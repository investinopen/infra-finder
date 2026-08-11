# frozen_string_literal: true

class EnhanceSolutionImports < ActiveRecord::Migration[7.1]
  def change
    change_table :solution_imports, bulk: true do |t|
      t.bigint :intakes_count, null: false, default: 0
    end
  end
end
