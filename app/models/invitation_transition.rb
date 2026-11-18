# frozen_string_literal: true

# @see Invitation
# @see Invitations::StateMachine
class InvitationTransition < ApplicationRecord
  include Support::StatesmanHelpers::Transition
  include CommonTransition

  stateful_enum! :invitation_state

  belongs_to :invitation, inverse_of: :invitation_transitions
  belongs_to :initiator, optional: true, polymorphic: true

  owner_association_name :invitation
  transitions_association_name :invitation_transitions
end
