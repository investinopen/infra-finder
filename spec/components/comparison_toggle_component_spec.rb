# frozen_string_literal: true

RSpec.describe ComparisonToggleComponent, type: :component do
  let_it_be(:comparison, refind: true) { FactoryBot.create :comparison }
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  context "when comparing" do
    before do
      comparison.add! solution
    end

    it "renders a link to remove the comparison" do
      expect(render_inline(described_class.new(comparison:, solution:)).css(%{[data-turbo-method="delete"]}).to_html).to be_present
    end
  end

  context "when not comparing" do
    it "renders a link to start comparing" do
      expect(render_inline(described_class.new(comparison:, solution:)).css(%{[data-turbo-method="post"]}).to_html).to be_present
    end
  end
end
