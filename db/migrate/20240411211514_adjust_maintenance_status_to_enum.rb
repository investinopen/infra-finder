# frozen_string_literal: true

class AdjustMaintenanceStatusToEnum < ActiveRecord::Migration[7.1]
  TABLES = %i[solutions solution_drafts].freeze

  def change
    create_enum :maintenance_status, %w[active inactive unknown]

    TABLES.each do |table|
      change_table table do |t|
        t.enum :maintenance_status, enum_type: :maintenance_status, null: false, default: "unknown"

        t.index :maintenance_status
      end
    end

    reversible do |dir|
      dir.up do
        TABLES.each do |table|
          say_with_time "Correcting #{table}.maintenance_status" do
            exec_update(<<~SQL)
            UPDATE #{table} SET maintenance_status = 'active' WHERE maintenance_status_id IS NOT NULL;
            SQL
          end
        end
      end
    end
  end
end
