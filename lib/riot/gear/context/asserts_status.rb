require 'open-uri'

module Riot
  module Gear
    module AssertsStatus

      def asserts_status
        asserts("status code") { response.code }
      end

    end # AssertsStatus
  end # Gear
end # Riot

Riot::Context.instance_eval { include Riot::Gear::AssertsStatus }
