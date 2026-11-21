# frozen_string_literal: true

class CreateControlledVocabularyEntries < ActiveRecord::Migration[8.1]
  def change
    create_enum :controlled_vocabulary_strategy, %w[countries currencies enum model]

    create_table :controlled_vocabulary_entries, id: :uuid do |t|
      t.enum :strategy, enum_type: :controlled_vocabulary_strategy, null: false

      t.citext :name, null: false

      t.citext :kind, null: false

      t.citext :label, null: false

      t.boolean :accepts_other, null: false, default: false

      t.bigint :records_count, null: false, default: 0

      t.jsonb :details, null: false, default: {}

      t.jsonb :extra_fields, null: false, default: []

      t.jsonb :mapping, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :kind, unique: true
      t.index :name, unique: true

      t.index :records_count
    end
  end
end
