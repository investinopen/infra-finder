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
end
