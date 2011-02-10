# Riot Gear

Real HTTP-based smoke testing with a real testing framework; [Riot](http://thumblemonks.github.com/riot) + [HTTParty](http://github.com/jnunemaker/httparty). The principle impetus for creating Riot Gear came from a desire to easily develop a suite of smoke tests for a few, JSON-based web services. On one hand you could use Riot Gear to develop in-depth integration tests hitting a local testing environment that are constantly run through your continuous integration system. On the other hand, you could use Riot Gear to implement real smoke tests that hit your production environment frequently and/or maybe after a release. From this you can derive that Riot Gear does not intend to replace Selenium (Se) or any of Se's "competitors". Nope ... Riot Gear just wants to make the real-world testing of web-enabled APIs easier.

How Riot Gear does this is by combining two things I enjoy; Riot for its lightweight, contextual, and flexible testing framework; and HTTParty for its simplistic and powerful approach to providing HTTP enabled APIs (so to speak). The resulting DSL essentially allows one to mix HTTParty behavior directly with Riot behavior; i.e. build up and make an HTTP request and then test its response.

Here's an example involving a hypothetical login and login failure:

    require 'riot/gear'

    context "Logging into Example.com as good.user" do
      base_uri "http://example.com"
      post "/session", :body => {"email" => "good.user@example.com", "password" => "p4$sw0R)"}

      asserts_status.equals(200)
      asserts_header("Content-Type").equals("application/json;charset=utf-8")
      asserts_json("user.name").equals("Slick Rick")
    end

    context "Failing to log into Example.com as good.user" do
      base_uri "http://example.com"
      post "/session", :body => {"email" => "good.user@example.com", "password" => "y0uF41l"}

      asserts_status.equals(403)
      asserts_header("Content-Type").equals("application/json;charset=utf-8")
      asserts_json("error.message").matches(/email or password is invalid/i)
    end

If you're familiar with Riot and/or HTTParty you'll recognize their nature immediately. To begin, there are two Riot `context` blocks. Each context (and any of the sub-contexts) are independent from each other; this is in keeping with the nature of Riot. Within each context there will be setup code and then validation code. Setup code will most likely be reflected as HTTParty calls - though you should feel free to use Riot's helpers, setups, and hookups; whereas validation code will always be Riot (until this statement is wrong).

Thus, in the two example contexts, the setup code involves telling HTTParty what the `base_uri` is that any HTTP requests for that context will be made to; followed by the actual HTTP request - a `post` to `/session` with login credentials. After the `post` is sent, the `HTTParty::Response` object is made available for validation as the Riot helper named `response`.

Riot Gear provides a few built-in assertions for validating common response information, which you see above: `asserts_status`, `asserts_header`, and `asserts_json`. Each of these generate normal Riot assertions that can have assertion macros applied to them (eg. `equals`, `kind_of`, `matches`, `nil`, `exists`, etc.). You could easily replace what `asserts_status` does in the example above with this:

    asserts("status code") do
      response.code
    end.equals(200)

## Priming a request

Perhaps you have to be authenticated with a system before making a call ...

*The last HTTP request to be made within a context is the one whose response will be used for validation ...*

### ... on another host

`at_host` is coming

## Macros (need a better name)

Coming

## License

Riot Gear is released under the MIT license. See {file:MIT-LICENSE}.
