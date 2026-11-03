# frozen_string_literal: true

RSpec.describe Solutions::CheckMissingProperties, type: :operation do
  let_it_be(:solution, refind: true) { FactoryBot.create(:solution) }

  it "keeps an accurate list" do
    expect do
      expect_calling_with(solution).to succeed.with(false)
    end.to keep_the_same { solution.reload.missing_properties }
  end

  context "when the list is stale" do
    before do
      solution.update_columns(missing_properties: nil)
    end

    it "updates the list" do
      expect do
        expect_calling_with(solution).to succeed.with(true)
      end.to change { solution.reload.missing_properties }.from(nil).to(include("mission"))
    end
  end
end
