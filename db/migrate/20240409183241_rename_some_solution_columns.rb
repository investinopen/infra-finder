# frozen_string_literal: true

class RenameSomeSolutionColumns < ActiveRecord::Migration[7.1]
  TABLES = %i[solutions solution_drafts].freeze

  def change
    TABLES.each do |table|
      change_table table do |t|
        t.rename :what_registered, :registered_service_provider_description
        t.rename :what_other_tools, :integrations_and_compatibility
        t.rename :what_technologies, :technology_dependencies
      end
    end

    reversible do |dir|
      dir.up do
        TABLES.each do |table|
          say_with_time "web_accessibility.applies_to_project -> web_accessibility.applies_to_solution" do
            exec_update <<~SQL
            UPDATE #{table} SET web_accessibility = web_accessibility - 'applies_to_project' || jsonb_build_object('applies_to_solution', web_accessibility -> 'applies_to_project')
              WHERE web_accessibility ? 'applies_to_project'
            ;
            SQL
          end

          say_with_time "Correct current_staffing legacy database numeric type" do
            execute <<~SQL
            ALTER TABLE #{table} ALTER COLUMN current_staffing SET DATA TYPE bigint USING current_staffing::bigint;
            SQL
          end
        end
      end

      dir.down do
        TABLES.each do |table|
          say_with_time "Restoring current_staffing to legacy database numeric type" do
            execute <<~SQL
            ALTER TABLE #{table} ALTER COLUMN current_staffing SET DATA TYPE numeric USING current_staffing::numeric;
            SQL
          end
        end
      end
    end
  end
end
