# frozen_string_literal: true

RSpec.describe SolutionDetailsComponent, type: :component do
  context "with a barebones solution" do
    let_it_be(:solution, refind: true) { FactoryBot.create :solution, :barebones }

    it "renders okay" do
      expect(
        render_inline(described_class.new(solution:)).css("h1").to_html
      ).to include solution.name
    end
  end
end
