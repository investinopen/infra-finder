# frozen_string_literal: true

class CreateSolutionCategoryDraftLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :solution_category_draft_links, id: :uuid do |t|
      t.references :solution_draft, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :solution_category, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[solution_draft_id solution_category_id], unique: true, name: "index_solution_category_draft_links_uniqueness"
    end
  end
end
