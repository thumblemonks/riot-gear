# Riot Gear

Real HTTP-based smoke testing with a real testing framework; [Riot](http://thumblemonks.github.com/riot) + [HTTParty]().

    require 'teststrap'

    context "Logging into Example.com as foo" do
      base_uri "http://example.com"
      get "/session/new?username=foo&password=password"

      asserts_status.equals(200)
      asserts_header("Content-Type").equals("application/json;charset=utf-8")

      # ... more stuff
    end

Lots lots more to come soon.