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

    expect(rendered.at_css(".field-description").text).to eq("Help text")
  end

  it "omits the description span when not given" do
    rendered = render_inline(described_class.new) { "<input>".html_safe }

    expect(rendered.at_css(".field-description")).to be_nil
  end

  it "renders a hidden error target for its controller to fill" do
    rendered = render_inline(described_class.new) { "<input>".html_safe }

    error = rendered.at_css(".field-content > .field-error")

    expect(error).to be_present
    expect(error.key?("hidden")).to be(true)
    expect(error["data-form-field-wrapper-component--form-field-wrapper-component-target"])
      .to eq("error")
  end

  it "places the error below the description row" do
    rendered = render_inline(described_class.new(description: "Help text")) do
      "<input>".html_safe
    end

    expect(rendered.css(".field-content > *").pluck("class"))
      .to eq([nil, "field-meta", "field-error"])
  end

  it "renders a hidden counter target in the description row" do
    rendered = render_inline(described_class.new(description: "Help text")) do
      "<textarea maxlength='1000'></textarea>".html_safe
    end

    counter = rendered.at_css(".field-counter")

    expect(counter).to be_present
    expect(counter.key?("hidden")).to be(true)
    expect(counter["data-form-field-wrapper-component--form-field-wrapper-component-target"])
      .to eq("counter")
  end

  describe "condition" do
    def wrapper_for(condition)
      rendered = render_inline(described_class.new(condition:, conditional: true)) do
        "<input>".html_safe
      end

      rendered.at_css(".conditional-field-wrapper")
    end

    it "exposes the trigger field and value to its controller" do
      wrapper = wrapper_for({ field: :business_form_ids, value: "abc123" })

      expect(wrapper["data-condition-field"]).to eq("business_form_ids")
      expect(wrapper["data-condition-value"]).to eq("abc123")
    end

    it "joins multiple accepted values with a space" do
      wrapper = wrapper_for({ field: :hosting_strategy_id, value: %w[abc123 def456] })

      expect(wrapper["data-condition-value"]).to eq("abc123 def456")
    end

    it "omits the value when the option could not be resolved" do
      wrapper = wrapper_for({ field: :business_form_ids, value: nil })

      expect(wrapper["data-condition-field"]).to eq("business_form_ids")
      expect(wrapper.key?("data-condition-value")).to be(false)
    end

    it "drops unresolved values from a multi-value condition" do
      wrapper = wrapper_for({ field: :hosting_strategy_id, value: [nil, "def456"] })

      expect(wrapper["data-condition-value"]).to eq("def456")
    end

    it "omits the value when every option in a multi-value condition is unresolved" do
      wrapper = wrapper_for({ field: :hosting_strategy_id, value: [nil, nil] })

      expect(wrapper.key?("data-condition-value")).to be(false)
    end
  end
end
