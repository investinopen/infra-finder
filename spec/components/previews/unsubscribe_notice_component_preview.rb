# frozen_string_literal: true

class UnsubscribeNoticeComponentPreview < ViewComponent::Preview
  def all
    user = User.first!

    render(UnsubscribeNoticeComponent.new(user:, kind: __method__))
  end

  def comment_notifications
    user = User.first!

    render(UnsubscribeNoticeComponent.new(user:, kind: __method__))
  end

  def solution_notifications
    user = User.first!

    render(UnsubscribeNoticeComponent.new(user:, kind: __method__))
  end
end
