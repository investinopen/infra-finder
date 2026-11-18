# frozen_string_literal: true

# @see User
# @see Users::StateMachine
class UserTransition < ApplicationRecord
  include Support::StatesmanHelpers::Transition
  include CommonTransition

  stateful_enum! :user_state

  belongs_to :user, inverse_of: :user_transitions
  belongs_to :initiator, optional: true, polymorphic: true

  owner_association_name :user
  transitions_association_name :user_transitions
end
