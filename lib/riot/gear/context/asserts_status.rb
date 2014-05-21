require 'open-uri'

module Riot
  module Gear
    module AssertsStatus

      # Generates an assertion that retrieves the status code from the last response. If a response
      # name is provided, that named response will be used instead. The status code will be an integer.
      #
      #   asserts_status.equals(200)
      #
      # @param [String,Symbol] response_name Name of response to check status code of
      # @return [Riot::Assertion] an assertion block that macros can be applied to
      def asserts_status(response_name=nil)
        asserts("status code") { response(response_name).code }
      end

    end # AssertsStatus
  end # Gear
end # Riot

Riot::Context.instance_eval { include Riot::Gear::AssertsStatus }
