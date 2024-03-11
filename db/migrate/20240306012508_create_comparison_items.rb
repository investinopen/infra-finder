# frozen_string_literal: true

class CreateComparisonItems < ActiveRecord::Migration[7.1]
  def change
    create_table :comparison_items, id: :uuid do |t|
      t.references :comparison, null: false, foreign_key: { on_delete: :cascade }, type: :uuid, index: false
      t.references :solution, null: false, foreign_key: { on_delete: :cascade }, type: :uuid, index: false
      t.bigint :position

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[comparison_id solution_id], unique: true, name: "index_comparison_items_uniqueness"
      t.index %i[comparison_id position solution_id], name: "index_comparison_items_ordering"
    end
  end
end
