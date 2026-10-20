# frozen_string_literal: true

module Users
  # Sign-in and sign-out.
  class SessionsController < Devise::SessionsController
    include AccountPages

    rate_limit_create! to: 10, within: 5.minutes
  end
end
