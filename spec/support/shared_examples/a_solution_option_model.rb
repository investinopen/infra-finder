# frozen_string_literal: true

RSpec.shared_examples_for "a solution option model" do
  let_it_be(:factory_kind) { described_class.factory_bot_name }

  it "has the right policy class" do
    expect(described_class.policy_class).to eq SolutionOptionPolicy
  end

  describe "#replace_with" do
    let_it_be(:old_option, refind: true) { FactoryBot.create factory_kind }
    let_it_be(:new_option, refind: true) { FactoryBot.create factory_kind }

    let_it_be(:solution, refind: true) { FactoryBot.create :solution }

    before do
      old_option.solutions << solution

      solution.save!
    end

    it "replaces the solution and removes the old option" do
      expect do
        expect(old_option.replace_with(new_option)).to succeed
      end.to change { new_option.solutions.count }.by(1)
        .and change(described_class, :count).by(-1)
    end
  end
end
