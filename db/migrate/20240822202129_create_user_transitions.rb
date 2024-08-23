# frozen_string_literal: true

class CreateUserTransitions < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      t.timestamp :accepted_terms_at

      t.index :accepted_terms_at
    end

    create_table :user_transitions, id: :uuid do |t|
      t.references :user, null: false, type: :uuid, foreign_key: { on_delete: :cascade }, index: false
      t.boolean :most_recent, null: false
      t.integer :sort_key, null: false
      t.string :to_state, null: false
      t.jsonb :metadata

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i(user_id sort_key), unique: true, name: "index_user_transitions_parent_sort"
      t.index %i(user_id most_recent), unique: true, where: "most_recent", name: "index_user_transitions_parent_most_recent"
    end

    reversible do |dir|
      dir.up do
        say_with_time "Auto-accepting terms for admins" do
          exec_update(<<~SQL)
          UPDATE users SET accepted_terms_at = created_at
          WHERE kind IN ('super_admin', 'admin')
          SQL
        end

        say_with_time "Creating transition history for admins" do
          exec_update(<<~SQL)
          WITH derived_transitions AS (
            SELECT id AS user_id, TRUE as most_recent, 10 AS sort_key, 'accepted_terms' AS to_state, jsonb_build_object('migrated', true) AS metadata, created_at, created_at AS updated_at
            FROM users
            WHERE kind IN ('super_admin', 'admin')
          )
          INSERT INTO user_transitions (user_id, most_recent, sort_key, to_state, metadata, created_at, updated_at)
          SELECT user_id, most_recent, sort_key, to_state, metadata, created_at, updated_at FROM derived_transitions
          ;
          SQL
        end
      end
    end
  end
end
