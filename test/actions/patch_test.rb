require 'teststrap'

context "Sending a PATCH request with a base uri" do

  context "without params" do
    hookup do
      stub_request(:patch, 'http://test.local/foo')
        .with(:body => {"foo" => "bar"}.to_json)
        .to_return(:body => "Foo", :status => 200)
    end

    base_uri "http://test.local"
    patch "/foo", :body => {"foo" => "bar"}.to_json

    asserts("status code") { response.code }.equals(200)
    asserts("response body") { response.body }.equals("Foo")
  end # without params

  context "with params" do
    hookup do
      stub_request(:patch, 'http://test.local/foo?bar=baz').
        with(:body => {"goo" => "car"}.to_json).
        to_return(:body => "", :status => 203)
    end

    context "through default_params" do
      base_uri "http://test.local"
      default_params({"bar" => "baz"})
      patch "/foo", :body => {"goo" => "car"}.to_json

      asserts("status code") { response.code }.equals(203)
    end # through default_params

    context "through query string" do
      base_uri "http://test.local"
      patch "/foo?bar=baz", :body => {"goo" => "car"}.to_json

      asserts("status code") { response.code }.equals(203)
    end # through query string
  end # with params

  context "while processing options from a block" do
    hookup do
      stub_request(:patch, 'http://test.local/foo/bar').
        with(:body => {"s" => "things"}.to_json).
        to_return(:body => "", :status => 299)
    end

    base_uri "http://test.local"

    patch do
      { :path => "/foo/bar", :body => {"s" => "things"}.to_json }
    end

    asserts("status code") { response.code }.equals(299)
  end # while processing options from a block

end # Sending a PUT request with a base uri