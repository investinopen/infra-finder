# frozen_string_literal: true

class WelcomeNoticeComponentPreview < ViewComponent::Preview
  def default
    render(WelcomeNoticeComponent.new)
  end
end
