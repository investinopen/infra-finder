# frozen_string_literal: true

class ShareBarComponentPreview < ViewComponent::Preview
  def default
    render(ShareBarComponent.new)
  end
end
