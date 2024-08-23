# frozen_string_literal: true

# @see User
# @see Users::StateMachine
class UserTransition < ApplicationRecord
  include StandardTransition

  set_up_transition! :user, inverse_of: :user_transitions
end
