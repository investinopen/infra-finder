# frozen_string_literal: true

class ComparisonComponentPreview < ViewComponent::Preview
  def default
    render(ComparisonComponent.new)
  end
end
