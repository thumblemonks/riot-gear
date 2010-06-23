require 'open-uri'

module Riot
  module Gear
    module AssertsJson

      def asserts_json(json_path)
        asserts("value from body as json:#{json_path}") do
          json_path(response, json_path)
        end
      end
    end # AssertsJson
  end # Gear
end # Riot

Riot::Context.instance_eval { include Riot::Gear::AssertsJson }
