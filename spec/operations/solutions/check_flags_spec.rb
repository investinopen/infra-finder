# frozen_string_literal: true

RSpec.describe Solutions::CheckFlags, type: :operation do
  let_it_be(:solution) { FactoryBot.create(:solution) }

  it "maintains the flag state" do
    expect do
      expect_calling_with(solution).to succeed.with(false)
    end.to keep_the_same { solution.flags.as_json }
  end

  context "when the flags are inaccurate" do
    before do
      allow(solution).to receive(:pricing_no_direct_costs?).and_return(true)
    end

    it "updates the flags" do
      expect do
        expect_calling_with(solution).to succeed.with(true)
      end.to change { solution.flags.free_to_use }.from(false).to(true)
    end
  end
end
