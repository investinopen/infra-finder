# frozen_string_literal: true

class SolutionComponentPreview < ViewComponent::Preview
  def default
    render(SolutionComponent.new)
  end
end
