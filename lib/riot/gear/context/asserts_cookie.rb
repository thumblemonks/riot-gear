module Riot
  module Gear
    module AssertsCookie

      # Generates an assertion that retrieves the value of some cookie from the last response.
      #
      #   asserts_cookie("ui_session").matches(/stuff/)
      #
      # @param [String] cookie-name the name of the cookie
      # @return [Riot::Assertion] an assertion block that macros can be applied to
      def asserts_cookie(cookie_name)
        asserts("set-cookie #{cookie_name}") { cookie_values[cookie_name] }
      end

    end # AssertsHeader
  end # Gear
end # Riot

Riot::Context.instance_eval { include Riot::Gear::AssertsCookie }

