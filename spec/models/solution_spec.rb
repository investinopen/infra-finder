# frozen_string_literal: true

RSpec.describe Solution, type: :model do
  context "when dealing with editor assignments" do
    let_it_be(:solution, refind: true) { FactoryBot.create :solution }

    let_it_be(:user, refind: true) { FactoryBot.create :user }

    specify "an editor can be assigned" do
      expect do
        solution.assign_editor!(user)
      end.to change(ProviderEditorAssignment, :count).by(1)
        .and change { user.reload.kind }.from("default").to("editor")
    end

    context "when removing an editor" do
      let_it_be(:assignment, refind: true) { solution.assign_editor!(user) }

      before do
        user.reload
      end

      it "will revert the user when destroying the assignment" do
        expect do
          assignment.destroy!
        end.to change(ProviderEditorAssignment, :count).by(-1)
          .and change { user.reload.kind }.from("editor").to("default")
      end
    end
  end

  context "financial date range" do
    let_it_be(:solution, refind: true) { FactoryBot.create :solution }

    it "extracts dates for later consumption from the date range" do
      expect do
        solution.financial_date_range = "04-2024 to 12/2025"
        solution.save!
      end.to change(solution, :financial_date_range_started_on).from(nil).to(Date.new(2024, 4, 1))
        .and change(solution, :financial_date_range_ended_on).from(nil).to(Date.new(2025, 12, 1))
    end

    it "handles invalid dates without breaking" do
      expect do
        solution.financial_date_range = "13-2024 to 12/2025"
        solution.save!
      end.to keep_the_same(solution, :financial_date_range_started_on)
        .and keep_the_same(solution, :financial_date_range_ended_on)
    end
  end

  context "special controlled vocab validation" do
    let_it_be(:solution, refind: true) { FactoryBot.create :solution }

    it "validates #country_code" do
      expect do
        solution.country_code = "xyz"
      end.to change(solution, :valid?).from(true).to(false)
    end

    it "validates #currency" do
      expect do
        solution.currency = "a non existent currency"
      end.to change(solution, :valid?).from(true).to(false)
    end
  end

  context "publication" do
    let_it_be(:solution, refind: true) { FactoryBot.create :solution }

    it "changes the published_at timestamp when altering publication" do
      expect do
        solution.published!
      end.to change(solution, :published_at).from(nil).to(a_kind_of(Time))
        .and change(described_class.published, :count).by(1)
        .and change(described_class.unpublished, :count).by(-1)

      expect do
        solution.unpublished!
      end.to change(solution, :published_at).from(a_kind_of(Time)).to(nil)
        .and change(described_class.published, :count).by(-1)
        .and change(described_class.unpublished, :count).by(1)
    end

    context "when a published solution is unpublished" do
      let_it_be(:comparison, refind: true) { FactoryBot.create :comparison }

      let_it_be(:comparison_item, refind: true) { FactoryBot.create(:comparison_item, comparison:, solution:) }

      let_it_be(:comparison_share, refind: true) { comparison.comparison_share }

      before do
        solution.published!
      end

      it "purges any links to comparisons that include the solution" do
        expect do
          solution.unpublished!
        end.to change(ComparisonItem, :count).by(-1)
          .and change(ComparisonShareItem, :count).by(-1)
          .and change { comparison_share.comparison_share_items.count }.by(-1)
      end
    end
  end

  describe ".vocab_for" do
    it "works as expected" do
      expect(described_class.vocab_for("currency")).to be_present
    end
  end

  describe ".vocab_options_for" do
    it "works as expected" do
      expect(described_class.vocab_options_for("bylaws_implementation")).to be_present
    end
  end
end
