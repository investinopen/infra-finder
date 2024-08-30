# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.references :subscribable, polymorphic: true, null: false, type: :uuid

      t.enum :kind, enum_type: :subscription_kind, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[subscribable_id subscribable_type kind], name: "index_subscriptions_uniqueness", unique: true
    end
  end
end
