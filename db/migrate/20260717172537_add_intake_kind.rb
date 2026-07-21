# frozen_string_literal: true

class AddIntakeKind < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL
    ALTER TYPE solution_kind ADD VALUE IF NOT EXISTS 'intake';
    SQL
  end

  def down
    # Intentionally left blank.
  end
end
