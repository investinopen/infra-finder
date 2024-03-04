# frozen_string_literal: true

class ActsAsTaggableOnMigration < ActiveRecord::Migration[6.0]
  def change
    create_table ActsAsTaggableOn.tags_table, id: :uuid do |t|
      t.citext :name, null: false

      t.bigint :taggings_count, null: false, default: 0

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :name, unique: true
    end

    create_table ActsAsTaggableOn.taggings_table, id: :uuid do |t|
      t.references :tag, type: :uuid, foreign_key: { on_delete: :cascade, to_table: ActsAsTaggableOn.tags_table }

      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, type: :uuid, polymorphic: true
      t.references :tagger, type: :uuid, polymorphic: true

      t.text :context, null: true

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.index :context

      t.index %i[taggable_id taggable_type context],
        name: "taggings_taggable_content_idx"

      t.index %i[tag_id taggable_id taggable_type context tagger_id tagger_type],
        unique: true,
        name: "taggings_idx"

      t.index %i[taggable_id taggable_type tagger_id context],
        name: "taggings_idy"
    end
  end
end
