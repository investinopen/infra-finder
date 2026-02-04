# frozen_string_literal: true

RSpec.describe SolutionDetailsSimpleCardListComponent, type: :component do
  let(:item_1) { double(:item, name: "First Item", :[] => nil, url: nil, description: nil) }
  let(:item_2) { double(:item, name: "Second Item", :[] => nil, url: nil, description: nil) }
  let(:items) { [item_1, item_2] }
  let(:heading) { "Test Heading" }
  let(:text) { "<p>Some additional text</p>" }

  describe "rendering with items" do
    it "renders the heading when provided" do
      result = render_inline(described_class.new(items:, heading:))

      expect(result.css("h4").text).to eq(heading)
    end

    it "renders all items as list items" do
      result = render_inline(described_class.new(items:, heading:))

      list_items = result.css("ul li")
      expect(list_items.length).to eq(2)
      expect(list_items[0].text).to include("First Item")
      expect(list_items[1].text).to include("Second Item")
    end

    it "applies correct CSS classes to the card" do
      result = render_inline(described_class.new(items:, heading:))

      expect(result.css(".m-card")).not_to be_empty
    end

    it "renders without a heading when heading is nil" do
      result = render_inline(described_class.new(items:, heading: nil))

      expect(result.css("h4")).to be_empty
      expect(result.css("ul li").length).to eq(2)
    end

    it "renders items with URLs as links" do
      item_with_url = double(:item, name: "Link Item", :[] => "http://example.com", url: "http://example.com", description: nil)
      result = render_inline(described_class.new(items: [item_with_url], heading:))

      expect(result.css("a[href='http://example.com']").text).to eq("Link Item")
    end

    it "renders items without URLs as spans" do
      result = render_inline(described_class.new(items:, heading:))

      expect(result.css("ul li span").first.text).to eq("First Item")
    end

    it "renders item descriptions when present" do
      item_with_desc = double(:item, name: "Item", :[] => proc { |key| key == "description" ? "A description" : nil }, url: nil, description: "A description")
      result = render_inline(described_class.new(items: [item_with_desc], heading:))

      expect(result.css(".text-neutral-70").text).to eq("A description")
    end

    it "filters out items with name 'Other'" do
      other_item = double(:item, name: "Other", :[] => nil, url: nil, description: nil)
      result = render_inline(described_class.new(items: [item_1, other_item, item_2], heading:))

      list_items = result.css("ul li")
      expect(list_items.length).to eq(2)
      expect(result.to_html).not_to include("Other")
    end
  end

  describe "rendering with text" do
    it "renders sanitized text when provided" do
      result = render_inline(described_class.new(items: nil, heading:, text:))

      expect(result.css(".text-xxs").to_html).to include("Some additional text")
    end

    it "renders both items and text when both are provided" do
      result = render_inline(described_class.new(items:, heading:, text:))

      expect(result.css("ul li").length).to eq(2)
      expect(result.css(".text-xxs").to_html).to include("Some additional text")
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
      expect(result.css(".text-xxs")).not_to be_empty
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
        .to eq("solution-details-simple-card-list-component--solution-details-simple-card-list-component")
    end
  end
end
