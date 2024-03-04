# frozen_string_literal: true

class CreateSnapshotsTables < ActiveRecord::Migration::Current
  def change
    create_table :snapshots, id: :uuid do |t|
      t.belongs_to :item, polymorphic: true, type: :uuid, null: false, index: true
      t.belongs_to :user, polymorphic: true, type: :uuid

      t.string :identifier, index: true
      t.index [:identifier, :item_id, :item_type], unique: true

      t.jsonb :metadata

      t.datetime :created_at, null: false
    end

    create_table :snapshot_items, id: :uuid do |t|
      t.belongs_to :snapshot, null: false, type: :uuid, index: true
      t.belongs_to :item, polymorphic: true, type: :uuid, null: false, index: true
      t.index [:snapshot_id, :item_id, :item_type], unique: true

      t.jsonb :object, null: false

      t.datetime :created_at, null: false
      t.text :child_group_name
    end
  end
end
