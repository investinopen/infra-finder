# frozen_string_literal: true

class CreateSolutionLicenses < ActiveRecord::Migration[7.1]
  def change
    create_table :solution_licenses, id: :uuid do |t|
      t.references :solution, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :license, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[solution_id license_id], unique: true, name: "index_solution_licenses_uniqueness"
    end
  end
end
