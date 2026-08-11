# frozen_string_literal: true

# This migration comes from noticed (originally 20231215190233)
class CreateNoticedTables < ActiveRecord::Migration[6.1]
  def change
    create_table :noticed_events, id: :uuid do |t|
      t.ltree :name, null: false

      t.text :type, null: false

      t.belongs_to :record, polymorphic: true, type: :uuid

      t.references :provider, type: :uuid, null: true, foreign_key: { to_table: :providers, on_delete: :nullify }
      t.references :solution, type: :uuid, null: true, foreign_key: { to_table: :solutions, on_delete: :nullify }
      t.references :solution_draft, type: :uuid, null: true, foreign_key: { to_table: :solution_drafts, on_delete: :nullify }
      t.references :solution_intake, type: :uuid, null: true, foreign_key: { to_table: :solution_intakes, on_delete: :nullify }
      t.references :user, type: :uuid, null: true, foreign_key: { to_table: :users, on_delete: :nullify }

      t.jsonb :params, null: false, default: {}

      t.bigint :notifications_count, default: 0, null: false

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    create_table :noticed_notifications, id: :uuid do |t|
      t.text :type, null: false

      t.belongs_to :event, null: false, type: :uuid, foreign_key: { to_table: :noticed_events, on_delete: :cascade }
      t.belongs_to :recipient, polymorphic: true, null: false, type: :uuid

      t.boolean :email_deliverable, null: false, default: false

      t.datetime :read_at
      t.datetime :seen_at

      t.jsonb :email_contact, null: false, default: {}

      t.jsonb :details, null: false, default: {}

      t.timestamps null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
