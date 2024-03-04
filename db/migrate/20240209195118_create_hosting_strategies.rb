# frozen_string_literal: true

class CreateHostingStrategies < ActiveRecord::Migration[7.1]
  def change
    create_table :hosting_strategies, id: :uuid do |t|
      t.bigint :seed_identifier
      t.citext :name, null: false
      t.citext :slug, null: false
      t.text :description
      t.enum :visibility, enum_type: "visibility", null: false, default: "hidden"

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :seed_identifier, unique: true
      t.index :slug, unique: true
    end
  end
end
