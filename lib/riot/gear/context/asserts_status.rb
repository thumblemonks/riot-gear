require 'open-uri'

module SmokeMonster
  module Riot
    module AssertsStatus

      def asserts_status
        asserts("status code") { response.code }
      end

    end # Context
  end # Riot
end # SmokeMonster

Riot::Context.instance_eval { include SmokeMonster::Riot::AssertsStatus }
