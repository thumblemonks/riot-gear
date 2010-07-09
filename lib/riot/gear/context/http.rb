require 'open-uri'
require 'httparty'

module Riot
  module Gear
    module Http

      def get(*args)
        hookup { @smoke_response = topic.get(*args) }
      end

      def post(*args)
        hookup { @smoke_response = topic.post(*args) }
      end

      def put(*args)
        hookup { @smoke_response = topic.put(*args) }
      end

      def delete(*args)
        hookup { @smoke_response = topic.delete(*args) }
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
