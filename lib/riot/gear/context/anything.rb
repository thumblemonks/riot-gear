class Riot::Gear::AnythingRunnable < Riot::RunnableBlock
  def initialize(description, &definition)
    super("[anything] #{description}", &definition)
  end

  # @param [Riot::Situation] situation An instance of a {Riot::Situation}
  # @return [Array<Symbol>]
  def run(situation)
    situation.evaluate(&definition)
    [:anything]
  end
end

module Riot::Gear::AnythingContextHelper
  # @param [String] description A description of what the block is for
  # @param [lambda] &definition The block that will be executed ...
  # @return [Riot::Gear::AnythingRunnable]
  def anything(description="", &definition)
    @assertions << Riot::Gear::AnythingRunnable.new(description, &definition)
  end
end

Riot::Context.instance_eval { include Riot::Gear::AnythingContextHelper }

