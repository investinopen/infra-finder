# frozen_string_literal: true

class ImplementationFilterComponentPreview < ViewComponent::Preview
  def default
    render(ImplementationFilterComponent.new)
  end
end
