require 'teststrap'

context "The denies_json macro" do

  helper(:response) do
    {
      "a" => {"b" => "foo"},
      "c" => [["foo", 1], ["bar", 2]]
    }
  end

  denies_json("a.b").equals("FOO")

  denies_json("c") do |value|
    value.map { |string, number| number }
  end.equals([0,1])

end # The denies_json macro
