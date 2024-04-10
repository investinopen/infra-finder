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
end
