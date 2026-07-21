# frozen_string_literal: true

class IntakeFormComponentPreview < ViewComponent::Preview
  def default
    render(IntakeFormComponent.new)
  end
end
