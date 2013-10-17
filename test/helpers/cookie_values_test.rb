require 'teststrap'
require 'ostruct'

context "The cookie_values helper" do
  hookup do
    cookies = [
      "foo=12345; path=/; expires=never-ever;",
      "goo=jam; path=/blue; expires=sometime-soon;",
    ]
    stub_request(:get, 'http://foo/tossed-cookies').
      to_return({
        :status => 200,
        :headers => { "Set-Cookie" => cookies.join("\n") },
        :body => ""
      })
  end

  get "http://foo/tossed-cookies"

  asserts("non-existent bar cookie") { cookie_values["bar"] }.nil

  asserts("existing foo cookie") do
    cookie_values["foo"]
  end.equals({"value" => "12345", "path" => "/", "expires" => "never-ever"})

  asserts("existing goo cookie") do
    cookie_values["goo"]
  end.equals({"value" => "jam", "path" => "/blue", "expires" => "sometime-soon"})
end # The cookie_values helper
