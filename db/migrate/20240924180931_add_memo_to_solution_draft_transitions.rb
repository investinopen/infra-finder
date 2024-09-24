# frozen_string_literal: true

class AddMemoToSolutionDraftTransitions < ActiveRecord::Migration[7.1]
  def change
    change_table :solution_draft_transitions do |t|
      t.virtual :memo, type: :text, stored: true, null: true, as: %[metadata ->> 'memo']
    end
  end
end
