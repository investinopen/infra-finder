# frozen_string_literal: true

class DropAllowlistedJwts < ActiveRecord::Migration[8.1]
  def change
    drop_table :allowlisted_jwts, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.string :jti, null: false
      t.string :aud
      t.datetime :exp, null: false
      t.timestamps

      t.index :jti, unique: true
      t.index :exp
    end
  end
end
