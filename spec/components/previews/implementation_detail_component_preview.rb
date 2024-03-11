# frozen_string_literal: true

class ImplementationDetailComponentPreview < ViewComponent::Preview
  def default
    render(ImplementationDetailComponent.new)
  end
end
