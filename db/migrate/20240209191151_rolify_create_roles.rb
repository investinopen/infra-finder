# frozen_string_literal: true

class RolifyCreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table(:roles, id: :uuid) do |t|
      t.citext :name, null: false

      t.references :resource, polymorphic: true, index: false, type: :uuid, null: true

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[name resource_type resource_id]
    end

    create_table(:users_roles, :id => false) do |t|
      t.references :user, type: :uuid, foreign_key: { on_delete: :cascade }, null: false
      t.references :role, type: :uuid, foreign_key: { on_delete: :cascade }, null: false

      t.index %i[user_id role_id], unique: true
    end
  end
end
