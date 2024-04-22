# frozen_string_literal: true

class MakeCurrentStaffingNumeric < ActiveRecord::Migration[7.1]
  LEGACY_SOLUTIONS = Rails.root.join("vendor", "legacy-solutions.csv")

  TABLES = %i[solutions solution_drafts].freeze

  def up
    TABLES.each do |table|
      say_with_time "Restoring #{table}.current_staffing legacy database numeric type" do
        execute <<~SQL
        ALTER TABLE #{table} ALTER COLUMN current_staffing SET DATA TYPE numeric(19,2) USING current_staffing::numeric(19,2);
        SQL
      end
    end

    return unless LEGACY_SOLUTIONS.exist?

    tbl = CSV.table(LEGACY_SOLUTIONS)

    pairings = tbl.pluck(:id, :current_staffing).each_with_object([]) do |(id, value), pairs|
      next if value.blank? || value.kind_of?(Integer)

      pairs << [id.to_s, value.to_d]
    end

    say_with_time "backfilling Solution.current_staffing" do
      pairings.sum do |(identifier, current_staffing)|
        Solution.where(identifier:).update_all(current_staffing:)
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
