# frozen_string_literal: true

RSpec.describe ComparisonBarComponent, type: :component do
  let_it_be(:comparison, refind: true) { FactoryBot.create :comparison }

  let_it_be(:max_solutions) { FactoryBot.create_list :solution, ComparisonItem::MAX_ITEMS }

  def the_rendered_component(**options)
    render_inline(described_class.new(**options, comparison:))
  end

  context "when no solutions have been compared" do
    it "renders nothing" do
      expect(the_rendered_component.css("aside").to_html).to be_blank
    end
  end

  context "when a single solution has been compared" do
    before do
      comparison.add! max_solutions.first
    end

    it "renders a heplful instruction" do
      expect(the_rendered_component.css("span").to_html).to include(
        described_class.t(".not_enough_selected")
      )
    end
  end

  context "when enough solutions have been added to be comparable" do
    before do
      comparison.add! max_solutions.first
      comparison.add! max_solutions.second
    end

    it "renders the items", :aggregate_failures do
      cmp = the_rendered_component

      expect(cmp.css(".m-comparison-bar-item")).to have(ComparisonItem::MAX_ITEMS).items

      expect(cmp.css("span").to_html).not_to include(
        described_class.t(".not_enough_selected")
      )
    end
  end

  context "when the max number of solutions have been added to the comparison" do
    before do
      max_solutions.each do |solution|
        comparison.add! solution
      end
    end

    it "renders just the items and no remaining slots", :aggregate_failures do
      cmp = the_rendered_component

      expect(cmp.css(".m-comparison-bar-item")).to have(ComparisonItem::MAX_ITEMS).items

      expect(cmp.css("span").to_html).not_to include(
        described_class.t(".not_enough_selected")
      )
    end
  end
end
