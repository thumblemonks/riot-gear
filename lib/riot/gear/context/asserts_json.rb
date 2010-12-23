require 'open-uri'

module Riot
  module Gear
    module AssertsJson

      # Returns the value of passing the JSON path to the json_path helper. If a handler block is provided,
      # that block will be called with the value and the response from the block will be used as the actual
      # in the assertion test.
      #
      #   asserts_json("http.status_code").equals(200)
      #
      #   asserts_json("http") do |value|
      #     value["status_code"]
      #   end.equals(200)
      def asserts_json(json_string, &handler)
        asserts("value from body as json:#{json_string}") do
          value = json_path(response, json_string)
          handler ? handler.call(value) : value
        end
      end

    end # AssertsJson
  end # Gear
end # Riot

Riot::Context.instance_eval { include Riot::Gear::AssertsJson }
