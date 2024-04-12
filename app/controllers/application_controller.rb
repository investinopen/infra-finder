# frozen_string_literal: true

# @abstract
class ApplicationController < ActionController::Base
  include CallsCommonOperation
  include WorksWithComparisons

  protect_from_forgery with: :null_session

  include Pundit::Authorization

  def access_denied(error = nil)
    if user_signed_in? && current_user.has_any_admin_or_editor_access?
      redirect_back fallback_location: root_path
    else
      redirect_to root_path
    end
  end

  def uncacheable!
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
  end

  class << self
    # @param [<Symbol>] actions
    # @return [void]
    def uncacheable!(*actions)
      before_action :uncacheable!, only: actions
    end
  end
end
