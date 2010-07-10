require 'open-uri'
require 'httparty'

module Riot
  module Gear
    module PersistCookie

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
