# frozen_string_literal: true

# @note Locale-specific strings (like `subject` are in `config/locales/emails.en.yml`).
class InvitationsMailer < ApplicationMailer
  # @param [Invitation] invitation
  # @param [String] token
  # @return [void]
  def welcome(invitation, token)
    @invitation = invitation
    @provider = invitation.provider
    @user = invitation.user
    @token = token

    @reset_url = edit_user_password_url(@user, reset_password_token: @token)
    @instructions_url = LocationsConfig.instructions

    mail to: invitation.email
  end
end
