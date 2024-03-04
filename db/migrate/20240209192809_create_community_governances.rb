# frozen_string_literal: true

class CreateCommunityGovernances < ActiveRecord::Migration[7.1]
  def change
    create_table :community_governances, id: :uuid do |t|
      t.bigint :seed_identifier
      t.citext :name
      t.citext :slug
      t.text :description

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
