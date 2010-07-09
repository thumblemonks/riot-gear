require 'open-uri'
require 'httparty'

module Riot
  module Gear
    module Http

      # Setup the scenario via a GET requst to the provided path. Feel free to include a query string
      def get(*args)
        hookup { @smoke_response = topic.get(*args) }
      end

      # Setup the scenario via a POST requst to the provided path. Feel free to include a :body option
      def post(*args)
        hookup { @smoke_response = topic.post(*args) }
      end

      def persist_cookie(cookie_name)
        hookup do
          if cookie_value = cookie_values[cookie_name]
            topic.cookies({cookie_name => cookie_value["value"]})
          end
        end
      end
    end # Http
  end # Gear
end # Riot

Riot::Context.instance_eval { include Riot::Gear::Http }
