require 'open-uri'

module Riot
  module Gear
    module AssertsJson

      # Generates an assertion that based on the value returned from passing the JSON path to the json_path
      # helper. If a handler block is provided, that block will be called with the value and the response
      # from the block will be used as the actual in the assertion test.
      #
      #   context "testing a hash" do
      #     setup do
      #       {"a" => {"b" => {"c" => {"d" => "foo"}}}}
      #     end
      #
      #     asserts_json("a.b.c.d").equals("foo")
      #     asserts_json("a['b'].c['d']").equals("foo")
      #
      #     asserts_json("a.b") do |value|
      #       value["c"]
      #     end.equals({"d" => "foo"})
      #  end
      #
      # This is useful for testing actual JSON responses from some service that are converted to a hash by
      # HTTParty.
      #
      # @param [String] json_string a JSON looking path
      # @param [lambda] &handler an optional block for filtering the actual value
      # @return [Riot::Assertion] an assertion block that macros can be applied to
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
