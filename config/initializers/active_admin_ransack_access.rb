# frozen_string_literal: true

module Patches
  # This change is in AA 4.0, currently in beta.
  module RansackAuthInAdmin
    def apply_filtering(chain)
      @search = chain.ransack(params[:q] || {}, auth_object: active_admin_authorization)
      @search.result
    end
  end
end

Rails.application.configure do
  config.to_prepare do
    ActiveAdmin::ResourceController.prepend Patches::RansackAuthInAdmin
  end
end
