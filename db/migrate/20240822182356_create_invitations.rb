# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations, id: :uuid do |t|
      t.references :provider, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :admin, null: true, foreign_key: { on_delete: :nullify, to_table: :users }, type: :uuid
      t.references :user, null: true, index: { unique: true }, foreign_key: { on_delete: :cascade }, type: :uuid

      t.citext :email, null: false
      t.text :first_name, null: false
      t.text :last_name, null: false
      t.text :memo, null: true

      t.timestamp :notification_sent_at

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :email, unique: true
    end
  end
end
