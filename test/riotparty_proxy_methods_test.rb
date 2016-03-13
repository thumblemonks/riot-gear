require 'teststrap'

context "A Riot Gear context" do
  # The magic to this whole thing is that if you modify RiotPartyMiddleware#proxy_httparty_hookups
  # to not either not setup hookups for these HTTParty method calls or simply not define HTTParty methods
  # on the context, these assertions will fail

  %w[
    base_uri headers cookies basic_auth digest_auth http_proxy format debug_output pem
    default_timeout default_params no_follow maintain_method_across_redirects
  ].each do |http_party_method|
    asserts_topic.responds_to(http_party_method)
  end

  base_uri "http://example.com"
  asserts("default options for base_uri") do
    topic.default_options[:base_uri]
  end.equals("http://example.com")

  headers({"Content-Type" => "gus/stuff"})
  asserts("default options headers") do
    topic.default_options[:headers]
  end.equals({"Content-Type" => "gus/stuff"})

  cookies({"foo" => "bar"})
  asserts("default cookies") { topic.default_cookies }.equals({"foo" => "bar"})

  basic_auth "user", "pass"
  asserts("default options for basic_auth") do
    topic.default_options[:basic_auth]
  end.equals({:username => "user", :password => "pass"})

  digest_auth "user", "pass"
  asserts("default options for digest_auth") do
    topic.default_options[:digest_auth]
  end.equals({:username => "user", :password => "pass"})

  http_proxy "http://foo.bar", 10101
  asserts("default options for http_proxyaddr") do
    topic.default_options[:http_proxyaddr]
  end.equals("http://foo.bar")

  asserts("default options for http_proxyport") do
    topic.default_options[:http_proxyport]
  end.equals(10101)

  format :json
  asserts("default options for format") do
    topic.default_options[:format]
  end.equals(:json)

  asserts("providing an invalid format") do
    topic.format :boogers
  end.raises(HTTParty::UnsupportedFormat, /':boogers' Must be one of:/)

  debug_output StringIO.new
  asserts("default options for debug_output") do
    topic.default_options[:debug_output]
  end.kind_of(StringIO)

  pem "I like cheese"
  asserts("default options for pem") do
    topic.default_options[:pem]
  end.equals("I like cheese")

  asserts("setting custom parser that does not support a provided format") do
    topic.default_options[:format] = :json
    topic.parser(
      Class.new do
        def supports_format?(fmt) false; end
        def supported_formats; [:nothing]; end
      end.new
    )
  end.raises(HTTParty::UnsupportedFormat, "':json' Must be one of: nothing")

  context "with a custom parser that supports a provided format" do
    HappyPartyParser = Class.new do
      def supports_format?(fmt) true; end
    end

    parser(HappyPartyParser.new)
    setup { topic.default_options[:parser] }
    asserts_topic.kind_of(HappyPartyParser)
  end # with a custom parser that supports a provided format

  default_timeout 100000
  asserts("default options for timeout") do
    topic.default_options[:timeout]
  end.equals(100000)

  default_params({"foo" => "bar"})
  asserts("default options for params") do
    topic.default_options[:default_params]
  end.equals({"foo" => "bar"})

  no_follow
  asserts("default options for no_follow") do
    topic.default_options[:no_follow]
  end.equals(false)

  maintain_method_across_redirects
  asserts("default options for maintain_method_across_redirects") do
    topic.default_options[:maintain_method_across_redirects]
  end.equals(true)
end # A Riot Gear context --- such as this very one :)
