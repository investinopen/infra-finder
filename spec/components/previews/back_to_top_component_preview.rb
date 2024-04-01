# frozen_string_literal: true

class BackToTopComponentPreview < ViewComponent::Preview
  def default
    render(BackToTopComponent.new)
  end
end
