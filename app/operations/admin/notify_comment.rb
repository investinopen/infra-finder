# frozen_string_literal: true

module Admin
  class NotifyComment < Support::SimpleServiceOperation
    service_klass Admin::CommentNotifier
  end
end
