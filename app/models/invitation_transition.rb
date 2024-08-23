# frozen_string_literal: true

# @see Invitation
# @see Invitations::StateMachine
class InvitationTransition < ApplicationRecord
  include StandardTransition

  set_up_transition! :invitation, inverse_of: :invitation_transitions
end
