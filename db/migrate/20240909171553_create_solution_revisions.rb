# frozen_string_literal: true

class CreateSolutionRevisions < ActiveRecord::Migration[7.1]
  LANG = "SQL"

  def change
    reversible do |dir|
      dir.up do
        execute <<~SQL
        CREATE FUNCTION public.is_solution_revision_snapshot(text, jsonb) RETURNS boolean AS $$
        SELECT
          $1 = 'Solution'
          AND
          $2 ? 'kind'
          AND
          $2 ? 'diffs'
          AND
          $2 ? 'revision'
        ;
        $$ LANGUAGE #{LANG} IMMUTABLE STRICT PARALLEL SAFE;
        SQL
      end

      dir.down do
        execute <<~SQL
        DROP FUNCTION public.is_solution_revision_snapshot(text, jsonb);
        SQL
      end
    end

    change_table :snapshots do |t|
      t.virtual :solution_revision_kind, type: :solution_revision_kind, as: %[public.parse_solution_revision_kind(metadata ->> 'kind')], null: false, stored: true
      t.virtual :solution_revision_snapshot, type: :boolean, as: %[public.is_solution_revision_snapshot(item_type, metadata)], null: false, stored: true

      t.index :solution_revision_kind
      t.index :solution_revision_snapshot
      t.index %i[item_id created_at], order: { created_at: :desc }, name: "index_snapshots_solution_revision_ordering", where: %[solution_revision_snapshot]
    end

    create_table :solution_revisions, id: :uuid do |t|
      t.references :solution, type: :uuid, null: false, foreign_key: { on_delete: :cascade }
      t.references :provider, type: :uuid, null: true, foreign_key: { on_delete: :nullify }
      t.references :solution_draft, type: :uuid, null: true, foreign_key: { on_delete: :nullify }
      t.references :snapshot, type: :uuid, null: true, foreign_key: { on_delete: :nullify }, index: { unique: true }
      t.references :user, type: :uuid, null: true, foreign_key: { on_delete: :nullify }

      t.enum :kind, enum_type: :solution_revision_kind, null: false, default: :other
      t.enum :data_version, enum_type: :solution_data_version, null: false, default: :unknown
      t.enum :provider_state, enum_type: :solution_revision_provider_state, null: false, default: :same

      t.citext :identifier, null: true

      t.jsonb :diffs, null: false, default: []
      t.jsonb :data, null: false, default: {}

      t.text :note, null: true
      t.text :reason, null: true

      t.virtual :diffs_count, type: :bigint, as: %[jsonb_array_length(diffs)], null: false, stored: true

      t.timestamps

      t.index %i[solution_id created_at], name: "index_solution_revisions_ordering", order: { created_at: :desc }

      t.check_constraint %[jsonb_typeof(diffs) = 'array'], name: :valid_diffs
      t.check_constraint %[jsonb_typeof(data) = 'object'], name: :valid_data
    end
  end
end
