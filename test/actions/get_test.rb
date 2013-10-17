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

end # Sending a GET request with a base-uri
