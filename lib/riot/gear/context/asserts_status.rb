require 'open-uri'

module Riot
  module Gear
    module AssertsStatus

      # Generates an assertion that retrieves the status code from the last response. The statuc code will
      # be an integer.
      #
      #   asserts_status.equals(200)
      #
      # @return [Riot::Assertion] an assertion block that macros can be applied to
      def asserts_status
        asserts("status code") { response.code }
      end

    end # AssertsStatus
  end # Gear
end # Riot

Riot::Context.instance_eval { include Riot::Gear::AssertsStatus }
