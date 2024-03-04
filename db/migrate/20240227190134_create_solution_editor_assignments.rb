# frozen_string_literal: true

class CreateSolutionEditorAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :solution_editor_assignments, id: :uuid do |t|
      t.references :solution, null: false, foreign_key: { on_delete: :restrict }, type: :uuid
      t.references :user, null: false, foreign_key: { on_delete: :restrict }, type: :uuid

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[solution_id user_id], unique: true, name: "index_solution_editor_assignments_uniqueness"
    end
  end
end
