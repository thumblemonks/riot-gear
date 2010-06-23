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

      def proxy_methods
        HTTParty::ClassMethods.instance_methods - %w[get post put delete head options]
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
      #     json_path(json_object, "a['b'].c['d']")
      #     => "foo"
      #
      # You can even work with array indexes.
      #     json_object = {"a" => {"b" => "c" => ["foo", {"d" => "bar"}]}}
      #     json_path(json_object, "a.b.c[1].d")
      #     => "bar"
      def helper_json_path(context)
        context.helper(:json_path) do |dictionary, path|
          path.scan(/\w+|\d+/).inject(dictionary) do |dict,key|
            dict[key =~ /^\d+$/ ? key.to_i : key]
          end
        end
      end

      def helper_cookie_value(context)
        context.helper(:cookie_values) do
          response.header["set-cookie"].split(';').inject({}) do |hash, key_val|
            key, val = key_val.strip.split('=')
            hash[key] = val
            hash
          end
        end
      end

    end # Middleware
  end # Gear
end # Riot
