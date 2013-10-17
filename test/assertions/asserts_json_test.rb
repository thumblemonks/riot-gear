require 'teststrap'

context "The asserts_json macro" do

  helper(:response) do
    {
      "a" => {"b" => "foo"},
      "c" => [["foo", 1], ["bar", 2]]
    }
  end

  asserts_json("a.b").equals("foo")

  asserts_json("c") do |value|
    value.map { |string, number| number }
  end.equals([1,2])

end # The asserts_json macro
