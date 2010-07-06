require 'teststrap'

context "Two distinct gear contexts" do
  helper(:gear_up) do
    situation = Riot::Situation.new
    Riot::Context.new("A") {}.local_run(Riot::SilentReporter.new, situation)
    situation
  end

  setup { gear_up.topic }
  asserts_topic.kind_of(Class)
  asserts("equivalence of the topic for similar contexts") { topic == gear_up.topic }.not!
end # Setting up a gear context

context "Gear context and its inner context" do
  helper(:local_run) do |ctx|
    situation = Riot::Situation.new
    ctx.local_run(Riot::SilentReporter.new, situation)
    situation
  end

  setup { Riot::Context.new("A") {} }

  asserts("equivalence of the topic for similar contexts") do
    parent_topic = local_run(topic).topic
    child_topic = local_run(topic.context("B") {}).topic

    parent_topic == child_topic
  end.not!
end # Setting up a gear context
