# frozen_string_literal: true

RSpec.describe IntakeSaveDraftButtonComponent, type: :component do
  it "renders a submit button that targets the form and skips validation" do
    rendered = render_inline(described_class.new(form_id: "solution-intake-form"))

    button = rendered.at_css("button")

    expect(button["type"]).to eq("submit")
    expect(button["form"]).to eq("solution-intake-form")
    expect(button.key?("formnovalidate")).to be(true)
    expect(button["name"]).to eq("save_draft")
    expect(button.text.strip).to eq("Save progress")
  end

  it "defaults the form target to the intake form's id" do
    rendered = render_inline(described_class.new)

    expect(rendered.at_css("button")["form"]).to eq(IntakeFormComponent::FORM_ID)
  end
end
