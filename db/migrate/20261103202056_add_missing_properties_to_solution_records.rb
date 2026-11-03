# frozen_string_literal: true

class AddMissingPropertiesToSolutionRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :solutions, :missing_properties, :text, array: true
    add_column :solution_drafts, :missing_properties, :text, array: true
    add_column :solution_intakes, :missing_properties, :text, array: true
  end
end
