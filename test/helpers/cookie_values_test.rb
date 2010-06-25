require 'teststrap'
require 'ostruct'

context "The cookie_values helper" do
  helper(:build_response) do |cookie_parts|
    OpenStruct.new( {:header => {"set-cookie" => cookie_parts.join("\n")}} )
  end

  hookup do
    @smoke_response = build_response([
      "foo=12345; path=/; expires=never-ever;",
      "goo=jam; path=/blue; expires=sometime-soon;",
    ])
  end

  asserts("non-existent bar cookie") { cookie_values["bar"] }.nil

  asserts("existing foo cookie") do
    cookie_values["foo"]
  end.equals({"value" => "12345", "path" => "/", "expires" => "never-ever"})

  asserts("existing goo cookie") do
    cookie_values["goo"]
  end.equals({"value" => "jam", "path" => "/blue", "expires" => "sometime-soon"})
end # The cookie_values helper
