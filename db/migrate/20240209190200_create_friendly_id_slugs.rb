# frozen_string_literal: true

class CreateFriendlyIdSlugs < ActiveRecord::Migration[7.1]
  def change
    create_table :friendly_id_slugs, id: :uuid do |t|
      t.citext :slug, null: false
      t.references :sluggable, null: false, type: :uuid, polymorphic: true
      t.citext :scope
      t.datetime :created_at
    end

    add_index :friendly_id_slugs, [:slug, :sluggable_type], length: { slug: 140, sluggable_type: 50 }
    add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope], length: { slug: 70, sluggable_type: 50, scope: 70 }, unique: true
  end
end
