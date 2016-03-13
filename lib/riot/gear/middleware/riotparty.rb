require 'httparty'
# Here we prepare a {Riot::Context} to have HTTParty bound to it. Basically, this means that you can
# use HTTParty within a context the same way you would inside any class or you would normally use it in.
# Anything you can do with HTTParty, you can do within a context ... and then you can test it :)
#
# Great pains are made to ensure that the HTTParty setup bound to one context does not interfere setup
# bound to another context.
class Riot::Gear::RiotPartyMiddleware < ::Riot::ContextMiddleware
  register

  # Prepares the context for HTTParty support.
  #
  # @param [Riot::Context] context the context to prepare
  def call(context)
    setup_faux_class(context)
    setup_helpers(context)
    proxy_action_methods(context)
    proxy_httparty_hookups(context)
    middleware.call(context)
  end

private

  # Only cluttering anonymous classes with HTTParty stuff. Keeps each context safe from collision ... in
  # theory.
  #
  # @param [Riot::Context] context the context to create the setup for
  # @todo Fix this so that settings like +base_uri+ can be inherited
  def setup_faux_class(context)
    context.setup(true) do
      if topic
        topic
      else
        @saved_responses = []
        @named_responses = {}
        Class.new { include HTTParty }
      end
    end

    context.helper(:response) do |name=nil|
      name.nil? ? @saved_responses.last : @named_responses[name]
    end
  end # setup_faux_class

  # Returns the list of methods that do something; like make a network call.
  #
  # @return [Array<Symbol>]
  def actionable_methods; [:get, :post, :put, :patch, :delete, :head, :options]; end

  # Returns the list of methods that configure actionable HTTParty methods. The
  # {HTTParty.default_options} method is explicitly excluded from this list
  #
  # @return [Array<Symbol>]
  def proxiable_methods
    methods = HTTParty::ClassMethods.instance_methods.map { |m| m.to_s.to_sym }
    methods - actionable_methods - [:default_options]
  end

  # Bind the set of actionable methods to a given context.
  #
  # Basically, we're just passing standard HTTParty setup methods onto situation via hookups. These
  # hookups - so long as the topic hasn't changed yet - are bound to an anonymous class that has
  # HTTParty included to it. Meaning, this is how you call get, post, put, delete from within a
  # test.
  #
  # There are couple of different forms for these actions. As you would expect, there's:
  #
  #   get "/path", :query => {...}, ...
  #
  # But you can also record the response for use later in the test:
  #
  #   post(:new_thing) do
  #     { :path => "/things", :body => ... }
  #   end
  #
  #   get do # this response will be used for assertions since it's last
  #     { :path => "/things/#{response(:new_thing).id}/settings" }
  #   end
  #
  # @param [Riot::Context] context the context to add the helper to
  def proxy_action_methods(context)
    context_eigen = (class << context; self; end)
    actionable_methods.each do |method_name|

      context_eigen.__send__(:define_method, method_name) do |*args, &settings_block|
        anything do
          if settings_block
            name = args.first
            options = instance_eval(&settings_block)
            path = options.delete(:path) || "/"
          else
            name = nil
            path, options = *args
          end
          result = topic.__send__(method_name, path, options || {})
          @saved_responses += [result]
          @named_responses[name] = result unless name.nil?
        end
      end

    end # methods.each
  end

  # Bind the set of proxiable (non-action) methods to a given context.
  #
  # @param [Riot::Context] context the context to add the helper to
  def proxy_httparty_hookups(context)
    context_eigen = (class << context; self; end)
    proxiable_methods.each do |method_name|
      context_eigen.__send__(:define_method, method_name) do |*args|
        hookup { topic.__send__(method_name, *args) }
      end
    end # methods.each
  end

  #
  # Helpful helpers

  def setup_helpers(context)
    helper_json_path(context)
    helper_cookie_value(context)
  end

  # Maps a JSON string to a Hash tree. For instance, give this hash:
  #
  #     json_object = {"a" => {"b" => {"c" => {"d" => "foo"}}}}
  #
  # You could retrieve the value of 'd' via JSON notation in any of the following ways:
  #
  #     json_path(json_object, "a.b.c.d")
  #     => "foo"
  #     json_path(json_object, "a['b'].c['d']")
  #     => "foo"
  #
  # You can even work with array indexes
  #
  #     json_object = {"a" => {"b" => "c" => ["foo", {"d" => "bar"}]}}
  #     json_path(json_object, "a[b].c[1].d")
  #     => "bar"
  #
  # @param [Riot::Context] context the context to add the helper to
  def helper_json_path(context)
    context.helper(:json_path) do |dictionary, path|
      return nil if path.to_s.empty?
      path.scan(/[^\[\].'"]+/).inject(dictionary) do |dict,key|
        dict[key =~ /^\d+$/ ? key.to_i : key.strip]
      end
    end
  end

  # Splits up the cookies found in the Set-Cookie header. I'm sure I could use HTTParty for this somehow,
  # but this seemed just as straightforward. You will get back a hash of the
  # {cookie-name => cookie-bits} pairs
  #
  #     {
  #       "session_cookie" => {"value => "fooberries", "path" => "/", ...},
  #       "stupid_marketing_tricks" => {"value" => "personal-information", ...},
  #       ...
  #     }
  #
  # @param [Riot::Context] context the context to add the helper to
  def helper_cookie_value(context)
    context.helper(:cookie_values) do
      response.header["set-cookie"].split("\n").inject({}) do |jar, cookie_str|
        (name, value), *bits = cookie_str.split(/; ?/).map { |bit| bit.split('=') }
        jar.merge!(name => bits.inject({"value" => value}) { |h, (k,v)| h.merge!(k => v) })
      end
    end
  end

end # Riot::Gear::RiotPartyMiddleware

