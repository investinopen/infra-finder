# frozen_string_literal: true

module Users
  # Unlocking an account and resending unlock instructions.
  class UnlocksController < Devise::UnlocksController
    include AccountPages

    rate_limit_create! to: 5, within: 1.hour
  end
end
