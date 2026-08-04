# frozen_string_literal: true

RSpec.describe IntakeFormComponent, type: :component do
  let_it_be(:solution_intake) { FactoryBot.create(:solution_intake) }

  it "renders a form that submits to the intake's update path" do
    rendered = render_inline(described_class.new(solution_intake:))

    form = rendered.at_css("form")

    expect(form["action"]).to eq("/intake/#{solution_intake.slug}")
    expect(form["method"]).to eq("post")
    expect(form["id"]).to eq(described_class::FORM_ID)
    expect(rendered.at_css("input[type='submit']")["value"]).to eq("Submit")
  end

  describe "#field_errors" do
    let(:solution_intake) { SolutionIntake.new }

    subject(:component) { described_class.new(solution_intake:) }

    it "is an empty payload when the intake is valid" do
      expect(component.field_errors).to eq("[]")
    end

    it "addresses each error by the name of the input that posts it" do
      solution_intake.errors.add(:name, :blank)

      expect(JSON.parse(component.field_errors))
        .to eq([{ "name" => "solution_intake[name]", "message" => "can't be blank" }])
    end

    it "is exposed to the client on the form element" do
      expect(component.form_data).to include(field_errors: component.field_errors)
    end
  end
end
