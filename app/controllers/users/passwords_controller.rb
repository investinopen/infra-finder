# frozen_string_literal: true

module Users
  # Password reset requests and resets, including accepting an invitation.
  class PasswordsController < Devise::PasswordsController
    include AccountPages

    rate_limit_create! to: 5, within: 1.hour
  end
end
