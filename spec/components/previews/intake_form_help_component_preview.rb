# frozen_string_literal: true

class IntakeFormHelpComponentPreview < ViewComponent::Preview
  def default
    render(IntakeFormHelpComponent.new(for_title: "About"))
  end
end
