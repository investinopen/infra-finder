# frozen_string_literal: true

class ImplementationComponentPreview < ViewComponent::Preview
  def default
    render(ImplementationComponent.new)
  end
end
