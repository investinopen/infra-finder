# frozen_string_literal: true

class CreateSolutionUserContributions < ActiveRecord::Migration[7.1]
  def change
    create_table :solution_user_contributions, id: :uuid do |t|
      t.references :solution, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :user_contribution, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[solution_id user_contribution_id], unique: true, name: "index_solution_user_contributions_uniqueness"
    end
  end
end
