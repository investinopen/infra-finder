# frozen_string_literal: true

module Users
  # Email confirmation and resending confirmation instructions.
  class ConfirmationsController < Devise::ConfirmationsController
    include AccountPages

    rate_limit_create! to: 5, within: 1.hour
  end
end
