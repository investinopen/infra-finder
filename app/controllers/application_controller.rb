# frozen_string_literal: true

# @abstract
class ApplicationController < ActionController::Base
  include CallsCommonOperation
  include WorksWithComparisons

  protect_from_forgery with: :null_session

  include Pundit::Authorization

  def access_denied(error = nil)
    redirect_back fallback_location: root_path
  end
end
