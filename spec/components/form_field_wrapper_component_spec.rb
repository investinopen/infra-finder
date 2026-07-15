# frozen_string_literal: true

RSpec.describe FormFieldWrapperComponent, type: :component do
  it "wraps the given content and merges a class name" do
    rendered = render_inline(described_class.new(class_name: "wide")) do
      "<input name='name'>".html_safe
    end

    wrapper = rendered.at_css(".form-field-wrapper")

    expect(wrapper["class"].split).to include("form-field-wrapper", "wide")
    expect(wrapper.at_css("input[name='name']")).to be_present
  end

  it "adds the required modifier when required" do
    rendered = render_inline(described_class.new(required: true)) { "<input>".html_safe }

    expect(rendered.at_css(".form-field-wrapper")["class"].split)
      .to include("form-field-wrapper--required")
  end

  it "omits the required modifier by default" do
    rendered = render_inline(described_class.new) { "<input>".html_safe }

    expect(rendered.at_css(".form-field-wrapper")["class"]).not_to include("required")
  end

  it "renders the description below the field when given" do
    rendered = render_inline(described_class.new(description: "Help text")) do
      "<input>".html_safe
    end

    expect(rendered.at_css(".form-field-wrapper__description").text).to eq("Help text")
  end

  it "omits the description span when not given" do
    rendered = render_inline(described_class.new) { "<input>".html_safe }

    expect(rendered.at_css(".form-field-wrapper__description")).to be_nil
  end
end
