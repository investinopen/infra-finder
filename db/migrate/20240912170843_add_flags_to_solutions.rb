# frozen_string_literal: true

class AddFlagsToSolutions < ActiveRecord::Migration[7.1]
  def change
    change_table :solutions do |t|
      t.jsonb :flags, null: false, default: {}

      t.index :flags, using: :gin
    end
  end
end
