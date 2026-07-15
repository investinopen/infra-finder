# frozen_string_literal: true

RSpec.describe IntakeFormSectionComponent, type: :component do
  it "renders the title as a legend and each field slot" do
    rendered = render_inline(described_class.new(title: "About your solution")) do |section|
      section.with_field { "<input name='name'>".html_safe }
      section.with_field { "<input name='url'>".html_safe }
    end

    expect(rendered.at_css("fieldset legend").text).to eq("About your solution")
    expect(rendered.at_css("fieldset")["id"]).to be_nil
    expect(rendered.css(".form-field-wrapper").length).to eq(2)
    expect(rendered.css("input[name='name']")).to be_present
    expect(rendered.css("input[name='url']")).to be_present
  end

  it "merges a per-field class onto the field wrapper" do
    rendered = render_inline(described_class.new(title: "Overview")) do |section|
      section.with_field(class_name: "col-span-2") { "<input name='name'>".html_safe }
    end

    wrapper = rendered.at_css(".form-field-wrapper")

    expect(wrapper["class"].split).to include("form-field-wrapper", "col-span-2")
    expect(wrapper.at_css("input[name='name']")).to be_present
  end

  it "sets the fieldset id from the anchor for nav scroll targets" do
    rendered = render_inline(described_class.new(title: "Overview", anchor: "overview"))

    expect(rendered.at_css("fieldset")["id"]).to eq("overview")
  end
end
