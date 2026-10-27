# frozen_string_literal: true

RSpec.describe Solutions::CheckEmptyPropertiesCount, type: :operation do
  let_it_be(:solution, refind: true) { FactoryBot.create(:solution) }

  it "keeps an accurate count" do
    expect do
      expect_calling_with(solution).to succeed.with(false)
    end.to keep_the_same { solution.reload.empty_properties_count }
  end

  context "when the count is stale" do
    before do
      solution.update_columns(empty_properties_count: nil)
    end

    it "updates the count" do
      expect do
        expect_calling_with(solution).to succeed.with(true)
      end.to change { solution.reload.empty_properties_count }.from(nil).to(a_kind_of(Integer))
    end
  end
end
