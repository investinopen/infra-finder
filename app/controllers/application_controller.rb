# frozen_string_literal: true

# @abstract
class ApplicationController < ActionController::Base
  include Pundit::Authorization

  def access_denied(error = nil)
    redirect_to ?/
  end
end
