# frozen_string_literal: true

class ImplementationCheckboxComponentPreview < ViewComponent::Preview
  def default
    render(ImplementationCheckboxComponent.new)
  end
end
