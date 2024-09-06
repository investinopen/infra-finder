# frozen_string_literal: true

class ImplementationStatementComponentPreview < ViewComponent::Preview
  def default
    render(ImplementationStatementComponent.new)
  end
end
