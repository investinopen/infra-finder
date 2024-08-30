# frozen_string_literal: true

module SubscriptionOptions
  # Unsubscribe a record from a specific kind with a given token.
  class UnsubscribeWithToken < Support::SimpleServiceOperation
    service_klass SubscriptionOptions::TokenUnsubscriber
  end
end
