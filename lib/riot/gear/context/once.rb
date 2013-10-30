class Riot::Gear::OnceRunnable < Riot::RunnableBlock
  def initialize(description, &definition)
    super("[once] #{description}", &definition)
    @ran = false
  end

  # Applies the provided +&definition+ to the +situation+. But, it only
  # does so once.
  #
  # @param [Riot::Situation] situation An instance of a {Riot::Situation}
  # @return [Array<Symbol>]
  def run(situation)
    if @ran
      [:once_ignored]
    else
      @ran = true
      situation.evaluate(&definition)
      [:once]
    end
  end
end

module Riot::Gear::OnceContextHelper
  # A setup helper that will only run once and only in the context it
  # was defined in. This will not be run in any of its sub-contexts
  # and it will run before any assertions ... the same as any other
  # setup block.
  #
  #   once "doing this one thing" do
  #     topic.post "/user/things", :query => {"name" => "x"}
  #   end
  #
  # @param [String] description A description of what the block is for
  # @param [lambda] &definition The block that will be executed once
  # @return [Riot::Gear::OnceRunnable]
  def once(description="", &definition)
    @setups << Riot::Gear::OnceRunnable.new(description, &definition)
  end
end

Riot::Context.instance_eval { include Riot::Gear::OnceContextHelper }

