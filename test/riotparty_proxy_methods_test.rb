require 'teststrap'

context "A Riot Gear context" do
  # The magic to this whole thing is that if you modify RiotPartyMiddleware#proxy_httparty_hookups
  # to not either not setup hookups for these HTTParty method calls or simply not define HTTParty methods
  # on the context, these assertions will fail

  %w[
    headers maintain_method_across_redirects basic_auth default_timeout parser no_follow default_options
    default_params http_proxy base_uri digest_auth format debug_output cookies pem
   ].each do |http_party_method|
     asserts_topic.responds_to(http_party_method)
   end

  base_uri "http://example.com"
  asserts(:base_uri).equals("http://example.com")
end # A Riot Gear context --- such as this very one :)
