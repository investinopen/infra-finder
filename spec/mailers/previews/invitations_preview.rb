# frozen_string_literal: true

class InvitationsPreview < ActionMailer::Preview
  def welcome
    invitation = Invitation.latest

    raise "requires an invitation to have been created" unless invitation.present?

    InvitationsMailer.welcome(invitation, Devise.friendly_token)
  end
end
