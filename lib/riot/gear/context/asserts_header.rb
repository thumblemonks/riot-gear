require 'open-uri'

module Riot
  module Gear
    module AssertsHeader

      def asserts_header(header_key)
        asserts("header variable #{header_key}") { response.headers[header_key] }
      end

    end # AssertsHeader
  end # Gear
end # Riot

Riot::Context.instance_eval { include Riot::Gear::AssertsHeader }
