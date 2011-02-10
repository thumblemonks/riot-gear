require 'open-uri'

module Riot
  module Gear
    module AssertsHeader

      # Generates an assertion that retrieves the value of some header from the last response.
      #
      #   asserts_header("Content-Length").equals("125")
      #
      # @param [String] header_key the name of the header
      # @return [Riot::Assertion] an assertion block that macros can be applied to
      def asserts_header(header_key)
        asserts("header variable #{header_key}") { response.headers[header_key] }
      end

    end # AssertsHeader
  end # Gear
end # Riot

Riot::Context.instance_eval { include Riot::Gear::AssertsHeader }
