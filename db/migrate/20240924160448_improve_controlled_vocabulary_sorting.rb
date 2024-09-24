# frozen_string_literal: true

class ImproveControlledVocabularySorting < ActiveRecord::Migration[7.1]
  TABLES = %w[
    accessibility_scopes
    authentication_standards
    board_structures
    business_forms
    community_engagement_activities
    community_governances
    content_licenses
    hosting_strategies
    integrations
    licenses
    maintenance_statuses
    metadata_standards
    metrics_standards
    nonprofit_statuses
    persistent_identifier_standards
    preservation_standards
    primary_funding_sources
    programming_languages
    readiness_levels
    reporting_levels
    security_standards
    solution_categories
    staffings
    user_contributions
    values_frameworks
  ].freeze

  def change
    add_numeric_collation!

    TABLES.each do |table|
      collate_text_columns! table
    end
  end

  private

  def add_numeric_collation!
    reversible do |dir|
      dir.up do
        execute(<<~SQL.strip_heredoc.strip)
        CREATE COLLATION custom_numeric (provider = icu, locale = 'en-u-kn-true');

        COMMENT ON COLLATION "custom_numeric" IS 'A custom collation that supports lexically ordering by integral values found within the string, so that 1, 2, 10 orders correctly.';
        SQL
      end

      dir.down do
        execute(<<~SQL.strip_heredoc.strip)
        DROP COLLATION "custom_numeric";
        SQL
      end
    end
  end

  def collate_text_columns!(table)
    set_column_collation! table, :name
    set_column_collation! table, :term
  end

  def set_column_collation!(table, column)
    quoted_table = connection.quote_table_name table
    quoted_column = connection.quote_column_name column

    ident = "#{quoted_table}.#{quoted_column}"
    reversible do |dir|
      dir.up do
        say_with_time "Setting custom_numeric collation for #{ident}" do
          execute(<<~SQL.strip_heredoc.strip)
          ALTER TABLE #{quoted_table} ALTER COLUMN #{quoted_column} SET DATA TYPE citext COLLATE "custom_numeric";
          SQL
        end
      end

      dir.down do
        say_with_time "Setting default collation for #{ident}" do
          execute(<<~SQL.strip_heredoc.strip)
          ALTER TABLE #{quoted_table} ALTER COLUMN #{quoted_column} SET DATA TYPE citext;
          SQL
        end
      end
    end
  end
end
