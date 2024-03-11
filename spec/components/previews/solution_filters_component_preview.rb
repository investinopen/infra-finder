# frozen_string_literal: true

class SolutionFiltersComponentPreview < ViewComponent::Preview
  def default
    render(SolutionFiltersComponent.new)
  end
end
