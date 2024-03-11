# frozen_string_literal: true

class ComparisonToggleComponentPreview < ViewComponent::Preview
  def default
    render(ComparisonToggleComponent.new(solution: "solution", comparison: "comparison"))
  end
end
