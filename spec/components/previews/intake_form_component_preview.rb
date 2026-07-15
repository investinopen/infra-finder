# frozen_string_literal: true

class IntakeFormComponentPreview < ViewComponent::Preview
  def default
    render(IntakeFormComponent.new(solution_intake: FactoryBot.create(:solution_intake)))
  end
end
