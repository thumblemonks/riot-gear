require 'open-uri'
require 'httparty'

module SmokeMonster
  module Riot
    module Http

      # Setup the scenario via a GET requst to the provided path. Feel free to include a query string
      def get(*args)
        hookup { @smoke_response = topic.get(*args) }
      end

      def persist_cookie(cookie_name)
        hookup do
          topic.cookies({cookie_name => cookie_values[cookie_name]})
        end
      end
    end # Context
  end # Riot
end # SmokeMonster

Riot::Context.instance_eval { include SmokeMonster::Riot::Http }
