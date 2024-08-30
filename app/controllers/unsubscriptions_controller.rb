# frozen_string_literal: true

class UnsubscriptionsController < ApplicationController
  def show
    call_operation("subscription_options.unsubscribe_with_token", params[:id], params[:token]) do |m|
      m.success do |instance|
        notice = instance.unsubscribe_notice

        redirect_to solutions_url, notice:
      end

      m.failure do
        # We swallow all failures here.
        # URLs could be expired, users could be gone, etc.
        redirect_to solutions_url, alert: t(".invalid", raise: true)
      end
    end
  end
end
