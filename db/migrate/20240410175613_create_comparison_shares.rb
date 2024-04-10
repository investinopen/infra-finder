# frozen_string_literal: true

class CreateComparisonShares < ActiveRecord::Migration[7.1]
  def change
    create_table :comparison_shares, id: :uuid do |t|
      t.bigint :comparison_share_items_count, null: false, default: 0
      t.bigint :share_count, null: false, default: 0
      t.enum :item_state, enum_type: :comparison_item_state, null: false, default: :empty
      t.timestamp :last_used_at
      t.timestamp :shared_at
      t.text :fingerprint, null: false
      t.jsonb :search_filters, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :fingerprint, unique: true
      t.index [:shared_at, :last_used_at, :fingerprint], name: "index_comparison_shares_prunability"
    end

    change_table :comparisons do |t|
      t.text :fingerprint

      t.index :fingerprint
    end
  end
end
