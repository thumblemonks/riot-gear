require 'open-uri'

module SmokeMonster
  module Riot
    module AssertsHeader

      def asserts_header(header_key)
        asserts("header variable #{header_key}") { response.headers[header_key] }
      end

    end # Context
  end # Riot
end # SmokeMonster

Riot::Context.instance_eval { include SmokeMonster::Riot::AssertsHeader }
