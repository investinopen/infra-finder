# frozen_string_literal: true

module Types
  # @see HasSubscriptionOption
  class SubscriptionType < Types::BaseEnum
    description <<~TEXT
    Whether a user receives a kind of email notification.
    TEXT

    value "SUBSCRIBED", value: "subscribed" do
      description "The user receives these notifications."
    end

    value "UNSUBSCRIBED", value: "unsubscribed" do
      description "The user does not receive these notifications."
    end
  end
end
