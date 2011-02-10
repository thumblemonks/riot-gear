require 'open-uri'
require 'httparty'

module Riot
  module Gear
    module PersistCookie

      # Graft a cookie (name and value) from the last response onto the next and subsequent requests. Only
      # applies to multiple requests within a {Riot::Context}. For instance, if you log into your service,
      # you will probably want to pass along whatever the session cookie was to the next request in the test.
      #
      #   context "Get new messages" do
      #     base_uri "http://example.com"
      #     post "/session?email=foo@bar.baz&password=beepboopbop"
      #
      #     persist_cookie("example_session")
      #
      #     get "/user/messages.json"
      #     asserts_status.equals(200)
      #     asserts_json("messages").length(8)
      #   end
      #
      # @param [String] cookie_name the name of a cookie to persist
      # @return [Riot::Assertion] an assertion block that macros can be applied to
      def persist_cookie(cookie_name)
        hookup do
          if cookie_value = cookie_values[cookie_name]
            topic.cookies({cookie_name => cookie_value["value"]})
          end
        end
      end # persist_cookie

    end # PersistCookie
  end # Gear
end # Riot

Riot::Context.instance_eval { include Riot::Gear::PersistCookie }
