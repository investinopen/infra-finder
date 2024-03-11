# frozen_string_literal: true

class CreateComparisons < ActiveRecord::Migration[7.1]
  def change
    create_table :comparisons, id: :uuid do |t|
      t.inet :ip
      t.timestamp :last_seen_at

      t.text :session_id, null: false

      t.jsonb :search_filters, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :session_id, unique: true
      t.index :last_seen_at
    end
  end
end
