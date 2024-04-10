# frozen_string_literal: true

class RenameOrganizations < ActiveRecord::Migration[7.1]
  def change
    rename_table :organizations, :providers

    rename_column :solutions, :organization_id, :provider_id
    rename_column :solution_imports, :organizations_count, :providers_count
  end
end
