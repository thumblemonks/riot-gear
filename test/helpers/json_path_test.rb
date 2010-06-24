require 'teststrap'

context "The json_path helper" do
  asserts("providing a nil path") { json_path({"a" => "foo"}, nil) }.nil
  asserts("providing a blank path") { json_path({"a" => "foo"}, "") }.nil
  asserts("providing a non-existent path") { json_path({"a" => "foo"}, "b") }.nil

  asserts("path of existing 'a'") { json_path({"a" => "foo"}, "a") }.equals("foo")
  asserts("path of non-existent 'a.b'") { json_path({"a" => "foo"}, "a.b") }.nil

  asserts("path of existing 'a.b'") { json_path({"a" => {"b" => "bar"}}, "a.b") }.equals("bar")
  asserts("path of existing 'a.b.c'") { json_path({"a" => {"b" => {"c" => "car"}}}, "a.b.c") }.equals("car")

  context "for hash based-lookups" do
    asserts("path of existing '[a]'") do
      json_path({"a" => {"b" => "bar"}}, '["a"]')
    end.equals({"b" => "bar"})

    asserts("path of existing 'a[\"b\"]'") do
      json_path({"a" => {"b" => "bar"}}, 'a["b"]')
    end.equals("bar")

    asserts("path of existing 'a['b']'") do
      json_path({"a" => {"b" => "bar"}}, "a['b']")
    end.equals("bar")

    asserts("path of existing 'a[b]'") do
      json_path({"a" => {"b" => "bar"}}, "a[b]")
    end.equals("bar")

    asserts("path of existing 'a[ b ]'") do
      json_path({"a" => {"b" => "bar"}}, "a[ b ]")
    end.equals("bar")

    asserts("path of existing 'a[b-ar]'") do
      json_path({"a" => {"b" => "bar"}}, "a[b-ar]")
    end.nil
  end # for hash based-lookups

  context "for index based-lookups" do
    asserts("path of existing '[0]'") do
      json_path(["foo", "bar"], '[0]')
    end.equals("foo")

    asserts("path of existing '[\"0\"]'") do
      json_path(["foo", "bar"], '["0"]')
    end.equals("foo")

    asserts("path of existing 'a[1]'") do
      json_path({"a" => ["foo", "bar"]}, 'a[1]')
    end.equals("bar")
  end # for index based-lookups

  context "for mix of dot, hash, index based-lookups" do
    asserts("path of existing '[a][1].c[0]'") do
      json_path({"a" => [ {"b" => "nil"}, {"c" => ["foo", "bar"]} ]}, '[a][1].c[0]')
    end.equals("foo")
  end # for mix of hash and index based-lookups
end # The json_path helper
