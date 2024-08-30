# frozen_string_literal: true

class AddUserSubscriptionOptions < ActiveRecord::Migration[7.1]
  SUBSCRIPTION_KINDS = %i[
    comment_notifications
    solution_notifications
    reminder_notifications
  ].freeze

  def change
    create_enum :subscription, %w[subscribed unsubscribed]

    create_enum :subscription_kind, SUBSCRIPTION_KINDS

    change_table :users do |t|
      SUBSCRIPTION_KINDS.each do |kind|
        t.enum kind, enum_type: :subscription, null: false, default: "unsubscribed"
        t.timestamp :"#{kind}_updated_at"
      end
    end
  end
end
