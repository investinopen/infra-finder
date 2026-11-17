# frozen_string_literal: true

class RebuildSessionsTable < ActiveRecord::Migration[8.1]
  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        DROP TABLE IF EXISTS sessions;
        SQL
      end
    end

    create_table :session_records, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: { on_delete: :cascade }, null: true

      t.string :session_id, null: false

      t.inet :init_access_ip
      t.inet :last_access_ip

      t.jsonb :data, null: false, default: {}

      t.timestamp :last_user_request_at
      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :session_id, unique: true
      t.index :updated_at
    end
  end
end
