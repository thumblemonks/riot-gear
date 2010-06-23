require 'open-uri'

module SmokeMonster
  module Riot
    module AssertsJson

      def asserts_json(json_path)
        asserts("value from body as json:#{json_path}") do
          json_path(response, json_path)
        end
      end
    end # Context
  end # Riot
end # SmokeMonster

Riot::Context.instance_eval { include SmokeMonster::Riot::AssertsJson }
