# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations, id: :uuid do |t|
      t.citext :identifier, null: false, default: proc { "gen_random_uuid()::text" }
      t.citext :name, null: false
      t.citext :slug, null: false
      t.text :url

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :slug, unique: true
      t.index :identifier, unique: true
    end
  end
end
