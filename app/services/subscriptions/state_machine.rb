# frozen_string_literal: true

module Subscriptions
  class StateMachine
    include Statesman::Machine

    state :unsubscribed, initial: true
    state :subscribed

    transition from: :unsubscribed, to: :subscribed
    transition from: :subscribed, to: :unsubscribed

    after_transition do |record, _|
      record.touch(:updated_at)
    end
  end
end
