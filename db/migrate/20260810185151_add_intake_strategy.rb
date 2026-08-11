# frozen_string_literal: true

class AddIntakeStrategy < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL
    ALTER TYPE solution_import_strategy ADD VALUE IF NOT EXISTS 'intake' BEFORE 'v2';
    SQL
  end

  def down
    # Intentionally left blank.
  end
end
