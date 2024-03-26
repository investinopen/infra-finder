# frozen_string_literal: true

RSpec.describe Comparisons::Add, type: :operation do
  let_it_be(:comparison, refind: true) { FactoryBot.create :comparison }

  let_it_be(:addable_solutions) { FactoryBot.create_list :solution, ComparisonItem::MAX_ITEMS }

  let_it_be(:breaking_solution) { FactoryBot.create :solution }

  it "adds solutions up to a point" do
    expect do
      addable_solutions.each do |solution|
        expect do
          expect_calling_with(comparison, solution).to succeed
        end.to change(ComparisonItem, :count).by(1)
          .and change { comparison.reload.comparison_items_count }.by(1)
      end
    end.to change { comparison.reload.item_state }.from("empty").to("maxed_out")

    expect(comparison).to be_items_maxed_out

    expect do
      expect_calling_with(comparison, breaking_solution).to monad_fail.with_key(:items_exceeded).with(a_kind_of(String))
    end.to keep_the_same(ComparisonItem, :count)
  end
end
