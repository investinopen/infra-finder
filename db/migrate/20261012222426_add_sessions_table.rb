# frozen_string_literal: true

class AddSessionsTable < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions, if_not_exists: true do |t|
      t.string :session_id, null: false
      t.text :data
      t.timestamps

      t.index :session_id, unique: true
      t.index :updated_at
    end
  end
end
