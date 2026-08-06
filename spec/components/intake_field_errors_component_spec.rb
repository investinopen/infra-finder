# frozen_string_literal: true

RSpec.describe IntakeFieldErrorsComponent, type: :component do
  let(:solution_intake) { SolutionIntake.new }

  subject(:component) { described_class.new(solution_intake:) }

  it "renders a hidden element the draft stream can target" do
    rendered = render_inline(component)

    element = rendered.at_css("##{described_class::ID}")

    expect(element).to be_present
    expect(element["hidden"]).to be_present
    expect(element["data-controller"]).to eq(described_class::CONTROLLER)
  end

  it "is an empty payload when the intake is valid" do
    expect(component.field_errors).to eq("[]")
  end

  it "addresses each error by the name of the input that posts it" do
    solution_intake.errors.add(:website, "is not a valid URL")

    expect(JSON.parse(component.field_errors))
      .to eq([{ "name" => "solution_intake[website]", "message" => "is not a valid URL" }])
  end

  it "exposes the payload to the client" do
    solution_intake.errors.add(:website, "is not a valid URL")

    expect(render_inline(component).at_css("##{described_class::ID}")["data-field-errors"])
      .to eq(component.field_errors)
  end
end
