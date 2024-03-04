# frozen_string_literal: true

RSpec.shared_examples_for "a solution option model" do
  let_it_be(:factory_kind) { described_class.factory_bot_name }

  it "has the right policy class" do
    expect(described_class.policy_class).to eq SolutionOptionPolicy
  end
end
