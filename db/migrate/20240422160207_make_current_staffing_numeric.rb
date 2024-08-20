# frozen_string_literal: true

class MakeCurrentStaffingNumeric < ActiveRecord::Migration[7.1]
  TABLES = %i[solutions solution_drafts].freeze

  def up
    TABLES.each do |table|
      say_with_time "Restoring #{table}.current_staffing legacy database numeric type" do
        execute <<~SQL
        ALTER TABLE #{table} ALTER COLUMN current_staffing SET DATA TYPE numeric(19,2) USING current_staffing::numeric(19,2);
        SQL
      end
    end
  end

  def down
    TABLES.each do |table|
      execute <<~SQL
      ALTER TABLE #{table} ALTER COLUMN current_staffing SET DATA TYPE bigint USING current_staffing::bigint;
      SQL
    end
  end
end
