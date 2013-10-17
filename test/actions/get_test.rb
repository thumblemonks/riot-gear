require 'teststrap'

context "Sending a GET request with a base-uri" do

  context "without params" do
    hookup do
      stub_request(:get, 'http://test.local/foo').to_return(:body => "Foo", :status => 200)
    end

    base_uri "http://test.local"
    get "/foo"

    asserts("status code") { response.code }.equals(200)
    asserts("response body") { response.body }.equals("Foo")
  end # without params

  context "with params" do
    hookup { stub_request(:get, 'http://test.local/foo?bar=baz').to_return(:body => "", :status => 201) }

    context "through default_params" do
      base_uri "http://test.local"
      default_params({"bar" => "baz"})
      get "/foo"

      asserts("status code") { response.code }.equals(201)
    end # through default_params

    context "through query string" do
      base_uri "http://test.local"
      get "/foo?bar=baz"

      asserts("status code") { response.code }.equals(201)
    end # through query string
  end # with params

  context "while processing options from a block" do
    hookup do
      stub_request(:get, 'http://test.local/foo/bar?s=things').to_return(:body => "", :status => 299)
    end

    base_uri "http://test.local"

    get do 
      { :path => "/foo/bar", :query => {"s" => "things"} }
    end

    asserts("status code") { response.code }.equals(299)
  end # while processing options from a block

  context "when no path provided from block" do
    hookup do
      stub_request(:get, 'http://test.local/?s=things').to_return(:body => "", :status => 299)
    end

    base_uri "http://test.local"

    get do # should default path to just "/"
      { :query => {"s" => "things"} }
    end

    asserts("status code") { response.code }.equals(299)
  end # while processing options from a block

  context "allows response sharing" do
    hookup do
      stub_request(:get, 'http://test.local/things/1').
        to_return({
          :status => 200,
          :headers => { "Content-Type" => "application/json" },
          :body => {id: 1, name: "Shakes"}.to_json
        })
      stub_request(:get, 'http://test.local/things/2').
        to_return({
          :status => 200,
          :headers => { "Content-Type" => "application/json" },
          :body => {id: 2, name: "Stakes"}.to_json
        })
      stub_request(:get, 'http://test.local/search?s=Shakes,Stakes').
        to_return(:body => "some kind of response", :status => 200)
    end

    base_uri "http://test.local"

    get(:thing_1) do 
      { :path => "/things/1" }
    end

    get(:thing_2) do 
      { :path => "/things/2" }
    end

    get do 
      { :path => "/search",
        :query => { "s" => [ response(:thing_1)["name"], response(:thing_2)["name"] ].join(",") }
      }
    end

    asserts("status code") { response.code }.equals(200)
    asserts("body") { response.body }.equals("some kind of response")
  end # while processing options from a block

end # Sending a GET request with a base-uri
