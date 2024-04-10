# frozen_string_literal: true

class CreateComparisonShareItems < ActiveRecord::Migration[7.1]
  def change
    create_table :comparison_share_items, id: :uuid do |t|
      t.references :comparison_share, null: false, foreign_key: { on_delete: :cascade }, type: :uuid, index: false
      t.references :solution, null: false, foreign_key: { on_delete: :cascade }, type: :uuid, index: false

      t.bigint :position

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[comparison_share_id solution_id], unique: true, name: "index_comparison_share_items_uniqueness"
      t.index %i[comparison_share_id position solution_id], name: "index_comparison_share_items_ordering"
    end
  end
end
