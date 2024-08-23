# frozen_string_literal: true

class CreateProviderEditorAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :provider_editor_assignments, id: :uuid do |t|
      t.references :provider, null: false, foreign_key: { on_delete: :restrict }, type: :uuid
      t.references :user, null: false, foreign_key: { on_delete: :restrict }, type: :uuid

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index %i[provider_id user_id], unique: true, name: "index_provider_editor_assignments_uniqueness"
    end

    reversible do |dir|
      dir.up do
        say_with_time "Migrate existing solution editor assignments" do
          exec_update(<<~SQL.strip_heredoc.strip)
          WITH assignments AS (
            SELECT s.provider_id, sea.user_id, MIN(sea.created_at) AS created_at, MAX(sea.updated_at) AS updated_at
            FROM solution_editor_assignments sea
            INNER JOIN solutions s ON s.id = sea.solution_id
            GROUP BY s.provider_id, sea.user_id
          ), role_insertions AS (
            INSERT INTO roles (name, resource_type, resource_id, created_at, updated_at)
            SELECT DISTINCT ON (provider_id) 'editor' AS name, 'Provider' AS resource_type, provider_id AS resource_id, created_at, updated_at FROM assignments
            RETURNING id AS role_id, resource_id AS provider_id
          ), user_role_insertions AS (
            INSERT INTO users_roles (role_id, user_id)
            SELECT ri.role_id, a.user_id
            FROM assignments a
            INNER JOIN role_insertions ri USING (provider_id)
            ON CONFLICT DO NOTHING
          )
          INSERT INTO provider_editor_assignments (provider_id, user_id, created_at, updated_at)
          SELECT provider_id, user_id, created_at, updated_at FROM assignments
          ON CONFLICT DO NOTHING;
          SQL
        end
      end
    end
  end
end
