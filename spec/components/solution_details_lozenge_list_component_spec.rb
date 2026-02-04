# frozen_string_literal: true

RSpec.describe SolutionDetailsLozengeListComponent, type: :component do
  let(:item_1) { double(:item, name: "First Item") }
  let(:item_2) { double(:item, name: "Second Item") }
  let(:items) { [item_1, item_2] }
  let(:heading) { "Test Heading" }
  let(:text) { "<p>Some additional text</p>" }

  describe "rendering with items" do
    it "renders the heading when provided" do
      result = render_inline(described_class.new(items:, heading:))

      expect(result.css("h3").text).to eq(heading)
    end

    it "renders all items as list items" do
      result = render_inline(described_class.new(items:, heading:))

      list_items = result.css("ul li")
      expect(list_items.length).to eq(2)
      expect(list_items[0].text).to eq("First Item")
      expect(list_items[1].text).to eq("Second Item")
    end

    it "applies correct CSS classes to list items" do
      result = render_inline(described_class.new(items:, heading:))

      list_items = result.css("ul li")
      expect(list_items[0].attr("class")).to include("m-badge")
      expect(list_items[0].attr("class")).to include("m-badge--white")
    end

    it "renders without a heading when heading is nil" do
      result = render_inline(described_class.new(items:, heading: nil))

      expect(result.css("h3")).to be_empty
      expect(result.css("ul li").length).to eq(2)
    end
  end

  describe "rendering with text" do
    it "renders sanitized text when provided" do
      result = render_inline(described_class.new(items: nil, heading:, text:))

      expect(result.css(".t-rte").to_html).to include("Some additional text")
    end

    it "renders both items and text when both are provided" do
      result = render_inline(described_class.new(items:, heading:, text:))

      expect(result.css("ul li").length).to eq(2)
      expect(result.css(".t-rte").to_html).to include("Some additional text")
    end
  end

  describe "rendering conditions" do
    it "renders when only items are provided" do
      result = render_inline(described_class.new(items:, heading: nil, text: nil))

      expect(result.to_html).not_to be_empty
      expect(result.css("ul li").length).to eq(2)
    end

    it "renders when only text is provided" do
      result = render_inline(described_class.new(items: nil, heading:, text:))

      expect(result.to_html).not_to be_empty
      expect(result.css(".t-rte")).not_to be_empty
    end

    it "does not render when both items and text are empty" do
      result = render_inline(described_class.new(items: [], heading:, text: nil))

      expect(result.to_html.strip).to be_empty
    end

    it "does not render when items is nil and text is nil" do
      result = render_inline(described_class.new(items: nil, heading:, text: nil))

      expect(result.to_html.strip).to be_empty
    end
  end

  describe "data controller" do
    it "includes the correct data controller attribute" do
      result = render_inline(described_class.new(items:, heading:))

      expect(result.css("[data-controller]").attr("data-controller").value)
        .to eq("solution-details-lozenge-list-component--solution-details-lozenge-list-component")
    end
  end
end
