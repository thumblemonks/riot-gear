require 'teststrap'

context "[Context] A once block:" do
  once do
    @instance_var_x = "foo"
  end

  asserts("var x defined in same context as once block") { @instance_var_x }.equals("foo")

  context "inner-context A" do
    asserts("var x defined in out context") { @instance_var_x }.nil
    asserts("var y defined in once block from this context") { @instance_var_y }.equals("bar")

    # defining this below the asserts just for fun, to make sure it
    # is eval'ed before the asserts are run
    once do
      @instance_var_y = "bar"
    end
  end
end

