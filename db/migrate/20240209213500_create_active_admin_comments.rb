# frozen_string_literal: true

class CreateActiveAdminComments < ActiveRecord::Migration[7.1]
  def change
    create_table :active_admin_comments, id: :uuid do |t|
      t.string :namespace
      t.text   :body
      t.references :resource, type: :uuid, polymorphic: true
      t.references :author, type: :uuid, polymorphic: true

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :namespace
    end
  end
end
