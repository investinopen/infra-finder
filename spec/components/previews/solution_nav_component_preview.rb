# frozen_string_literal: true

class SolutionNavComponentPreview < ViewComponent::Preview
  def default
    render(SolutionNavComponent.new)
  end
end
