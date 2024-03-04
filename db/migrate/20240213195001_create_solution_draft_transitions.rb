# frozen_string_literal: true

class CreateSolutionDraftTransitions < ActiveRecord::Migration[7.1]
  def change
    create_table :solution_draft_transitions, id: :uuid do |t|
      t.references :solution_draft, null: false, type: :uuid, foreign_key: { on_delete: :cascade }, index: false
      t.boolean :most_recent, null: false
      t.integer :sort_key, null: false
      t.string :to_state, null: false
      t.jsonb :metadata

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i(solution_draft_id sort_key), unique: true, name: "index_solution_draft_transitions_parent_sort"
      t.index %i(solution_draft_id most_recent), unique: true, where: "most_recent", name: "index_solution_draft_transitions_parent_most_recent"
    end
  end
end
