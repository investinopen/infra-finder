# frozen_string_literal: true

class ComparisonItemComponentPreview < ViewComponent::Preview
  def default
    render(ComparisonItemComponent.new)
  end
end
