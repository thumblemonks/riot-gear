require 'httparty'

module Riot
  module Gear
    class RiotPartyMiddleware < ::Riot::ContextMiddleware
      register

      def call(context)
        setup_faux_class(context)
        setup_helpers(context)
        proxy_httparty_hookups(context)
        middleware.call(context)
      end

    private

      # Only cluttering anonymous classes with HTTParty stuff. Keeps each context safe from collision ... in
      # theory
      def setup_faux_class(context)
        context.setup(true) do
          Class.new do
            include HTTParty
            # debug_output $stderr
          end
        end

        context.helper(:response) { @smoke_response }
      end # setup_faux_class

      def action_methods
        %w[get post put delete head options]
      end

      def proxy_methods
        HTTParty::ClassMethods.instance_methods - action_methods - ["default_options"]
      end

      # Basically, we're just passing standard HTTParty setup methods onto situation via hookups. Except
      # for the important action methods.
      def proxy_httparty_hookups(context)
        proxy_methods.each do |httparty_method|
          (class << context; self; end).__send__(:define_method, httparty_method) do |*args|
            hookup do
              topic.__send__(httparty_method, *args)
            end
          end
        end # proxy_methods.each
      end # proxy_httparty_hookups

      def setup_helpers(context)
        helper_json_path(context)
        helper_cookie_value(context)
      end

      # Maps a JSON string to a Hash tree. For instance, give this hash:
      #
      #     json_object = {"a" => {"b" => "c" => {"d" => "foo"}}}
      #
      # You could retrieve the value of 'd' via JSON notation in any of the following ways:
      #
      #     json_path(json_object, "a.b.c.d")
      #     => "foo"
      #     json_path(json_object, "a['b'].c[d]")
      #     => "foo"
      #
      # You can even work with array indexes
      #
      #     json_object = {"a" => {"b" => "c" => ["foo", {"d" => "bar"}]}}
      #     json_path(json_object, "a[b].c[1].d")
      #     => "bar"
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
      def helper_cookie_value(context)
        context.helper(:cookie_values) do
          response.header["set-cookie"].split("\n").inject({}) do |jar, cookie_str|
            (name, value), *bits = cookie_str.split(/; ?/).map { |bit| bit.split('=') }
            jar.merge!(name => bits.inject({"value" => value}) { |h, (k,v)| h.merge!(k => v) })
          end
        end
      end

    end # Middleware
  end # Gear
end # Riot
