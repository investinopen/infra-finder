# frozen_string_literal: true

class CreateSolutionCategoryLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :solution_category_links, id: :uuid do |t|
      t.references :solution, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :solution_category, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[solution_id solution_category_id], unique: true, name: "index_solution_category_link_uniqueness"
    end
  end
end
