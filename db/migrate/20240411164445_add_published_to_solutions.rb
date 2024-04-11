# frozen_string_literal: true

class AddPublishedToSolutions < ActiveRecord::Migration[7.1]
  def change
    create_enum :publication, %w[published unpublished]

    change_table :solutions do |t|
      t.enum :publication, enum_type: :publication, null: false, default: :unpublished
      t.timestamp :published_at

      t.index :publication
    end

    reversible do |dir|
      dir.up do
        say_with_time "Setting all existing solutions to published" do
          exec_update <<~SQL
          UPDATE solutions SET publication = 'published', published_at = updated_at
          SQL
        end
      end
    end
  end
end
