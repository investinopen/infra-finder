# frozen_string_literal: true

# @see Subscription
# @see Subscriptions::StateMachine
class SubscriptionTransition < ApplicationRecord
  include StandardTransition

  set_up_transition! :subscription, inverse_of: :subscription_transitions
end
