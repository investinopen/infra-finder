# frozen_string_literal: true

class AddUserToSolutionIntakeTransitions < ActiveRecord::Migration[7.1]
  def change
    change_table :solution_intake_transitions, bulk: true do |t|
      t.references :user, type: :uuid, null: true, foreign_key: { to_table: :users, on_delete: :nullify }
    end
  end
end
