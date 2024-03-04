# frozen_string_literal: true

class CreateLicenses < ActiveRecord::Migration[7.1]
  def change
    create_table :licenses, id: :uuid do |t|
      t.bigint :seed_identifier
      t.citext :name, null: false
      t.citext :slug, null: false

      t.text :description
      t.text :url

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :seed_identifier, unique: true
      t.index :slug, unique: true
    end
  end
end
