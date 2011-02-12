# Riot Gear

Riot Gear is a framework for HTTP-based smoke testing using a real testing framework; [Riot](http://thumblemonks.github.com/riot) + [HTTParty](http://github.com/jnunemaker/httparty). The principle impetus for creating Riot Gear came from a desire to easily develop a suite of smoke tests for a few, JSON-based web services. On one hand you could use Riot Gear to develop in-depth integration tests hitting a local testing environment that are constantly run through your continuous integration system. On the other hand, you could use Riot Gear to implement real smoke tests that hit your production environment frequently and/or maybe after a release. From this you can derive that Riot Gear does not intend to replace Selenium (Se) or any of Se's "competitors". Nope ... Riot Gear just wants to make the real-world testing of web-enabled APIs easier.

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

If you're familiar with Riot and/or HTTParty you'll recognize their natures immediately. To begin, there are two Riot `context` blocks. Each context (and any of the sub-contexts) are independent from each other; this is in keeping with the nature of Riot. Within each context there will be setup code and then validation code. Setup code will most likely be reflected as HTTParty calls - though you should feel free to use Riot's helpers, setups, and hookups; whereas validation code will always be Riot (until this statement is wrong).

Thus, in the two example contexts, the setup code involves telling HTTParty what the `base_uri` is that any HTTP requests for that context will be made to; followed by the actual HTTP request - a `post` to `/session` with login credentials. After the `post` is sent, the `HTTParty::Response` object is made available for validation as the Riot helper named `response`.

Riot Gear provides a few built-in assertions for validating common response information, which you see above: `asserts_status`, `asserts_header`, and `asserts_json`. Each of these generate normal Riot assertions that can have assertion macros applied to them (eg. `equals`, `kind_of`, `matches`, `nil`, `exists`, etc.). You could easily replace what `asserts_status` does in the example above with this:

    asserts("status code") do
      response.code
    end.equals(200)

## Priming a request

A common problem when testing services is that you need to perform a few activities before you can perform the one you want to test. For instance, you may need to login and create some resource before you can test an update to that resource. This is simple enough in Riot Gear since the last request made through `get`, `post`, `put`, `delete`, or `head` is the one whose response will be validated. For instance:

    require 'riot/gear'

    context "Updating a playlist" do
      base_uri "http://example.com"

      post "/session", :body => {"email" => "good.user@example.com", "password" => "p4$sw0R)"}
      persist_cookie("example_session")

      post "/user/playlists", :body => {"name" => "Dubsteppin to the oldies"}
      put "/user/playlists/dubsteppin-to-the-oldies", :body => {"name" => "Dubsteppin to the newbies"}

      asserts_status.equals(200)
      asserts_header("Content-Type").equals("application/json;charset=utf-8")
      asserts_json("data.message").equals("Playlist updated successfully")
    end

The `post` commands and the `put` will execute in the order they are defined. However, only the response from the `put` will be used for validation. It also would not matter where in the context you put the assertions because they always run last. For instance, this context is effectually the same as the one above:

    require 'riot/gear'

    context "Updating a playlist" do
      base_uri "http://example.com"

      post "/session", :body => {"email" => "good.user@example.com", "password" => "p4$sw0R)"}
      persist_cookie("example_session")

      asserts_json("data.message").equals("Playlist updated successfully")

      post "/user/playlists", :body => {"name" => "Dubsteppin to the oldies"}

      asserts_header("Content-Type").equals("application/json;charset=utf-8")

      put "/user/playlists/dubsteppin-to-the-oldies", :body => {"name" => "Dubsteppin to the newbies"}

      asserts_status.equals(200)
    end

*This fact is likely to change soon.*

## Coming soon

* Reusable macro-like blocks
* Priming a test against another host via `at_host`
* Sequential command processing

## License

Riot Gear is released under the MIT license. See {file:MIT-LICENSE}.
