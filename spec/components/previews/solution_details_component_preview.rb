# frozen_string_literal: true

class SolutionDetailsComponentPreview < ViewComponent::Preview
  def default
    render(SolutionDetailsComponent.new)
  end
end
