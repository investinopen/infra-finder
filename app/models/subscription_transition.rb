# frozen_string_literal: true

# @see Subscription
# @see Subscriptions::StateMachine
class SubscriptionTransition < ApplicationRecord
  include Support::StatesmanHelpers::Transition
  include CommonTransition

  stateful_enum! :subscription_state

  belongs_to :subscription, inverse_of: :subscription_transitions
  belongs_to :initiator, optional: true, polymorphic: true

  owner_association_name :subscription
  transitions_association_name :subscription_transitions
end
