# frozen_string_literal: true

RSpec.describe IntakeFormComponent, type: :component do
  let_it_be(:solution_intake) { FactoryBot.create(:solution_intake) }

  it "renders the form" do
    rendered_component = render_inline(described_class.new(solution_intake:))

    expect(rendered_component).to satisfy("the form has the correct action and method") do |component|
      form = component.css("form")

      form.present? && form.attr("action").value == "/intake/#{solution_intake.slug}" && form.attr("method").value == "post"
    end
  end
end
