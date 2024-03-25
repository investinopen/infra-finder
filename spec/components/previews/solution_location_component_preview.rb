# frozen_string_literal: true

class SolutionLocationComponentPreview < ViewComponent::Preview
  def default
    render(SolutionLocationComponent.new)
  end
end
