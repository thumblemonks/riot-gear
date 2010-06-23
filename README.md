# Riot Gear

Real HTTP-based smoke testing with a real testing framework; [Riot](http://thumblemonks.github.com/riot) + [HTTParty]().

    require 'testsrap'

    context "Logging into Example.com as foo" do
      base_uri "http://example.com"
      post "/session/new", :body => {:username => "foo", :password => "password"}

      asserts_status.equals(200)
      asserts_header("Content-Type").equals("application/json;charset=utf-8")
    end # Logging into BrightTag as bgrande

Lots lots more to come soon.