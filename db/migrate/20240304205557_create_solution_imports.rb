# frozen_string_literal: true

class CreateSolutionImports < ActiveRecord::Migration[7.1]
  def change
    create_enum :solution_import_strategy, %w[legacy modern]

    create_table :solution_imports, id: :uuid do |t|
      t.references :user, null: true, foreign_key: { on_delete: :nullify }, type: :uuid

      t.enum :strategy, enum_type: :solution_import_strategy, null: false

      t.timestamp :started_at
      t.timestamp :success_at
      t.timestamp :failure_at

      t.bigint :identifier, null: false
      t.bigint :organizations_count, null: false, default: 0
      t.bigint :solutions_count, null: false, default: 0

      t.jsonb :source_data, null: false
      t.jsonb :options, null: false, default: {}
      t.jsonb :messages, null: false, default: []
      t.jsonb :metadata, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :identifier, unique: true
    end

    reversible do |dir|
      dir.up do
        say_with_time "Adding identifier sequence for solution imports" do
          execute <<~SQL
          CREATE SEQUENCE solution_imports_identifier_seq
            AS bigint
            INCREMENT BY 1
            START WITH 1
            NO CYCLE
            OWNED BY "solution_imports"."identifier"
          ;
          SQL
        end

        execute <<~SQL
        ALTER TABLE solution_imports
          ALTER COLUMN identifier SET DEFAULT nextval('solution_imports_identifier_seq')
        ;
        SQL
      end
    end
  end
end
