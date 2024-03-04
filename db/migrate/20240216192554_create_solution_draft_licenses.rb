# frozen_string_literal: true

class CreateSolutionDraftLicenses < ActiveRecord::Migration[7.1]
  def change
    create_table :solution_draft_licenses, id: :uuid do |t|
      t.references :solution_draft, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :license, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[solution_draft_id license_id], unique: true, name: "index_solution_draft_licenses_uniqueness"
    end
  end
end
