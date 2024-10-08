# frozen_string_literal: true

class AddControlledVocabularyProvision < ActiveRecord::Migration[7.1]
  TABLES = [
    :accessibility_scopes,
    :authentication_standards,
    :board_structures,
    :business_forms,
    :community_engagement_activities,
    :community_governances,
    :content_licenses,
    :hosting_strategies,
    :integrations,
    :licenses,
    :maintenance_statuses,
    :metadata_standards,
    :metrics_standards,
    :nonprofit_statuses,
    :persistent_identifier_standards,
    :preservation_standards,
    :primary_funding_sources,
    :programming_languages,
    :readiness_levels,
    :reporting_levels,
    :security_standards,
    :solution_categories,
    :staffings,
    :user_contributions,
    :values_frameworks
  ].freeze

  def change
    create_enum :controlled_vocabulary_provision, %w[other unknown not_applicable none active applies_to_website applies_to_solution]

    TABLES.each do |table|
      convert_to_provision_enum!(table)
    end

    reversible do |dir|
      dir.up do
        say_with_time "Hiding certain hosting strategies" do
          exec_update(<<~SQL.strip_heredoc.strip)
          UPDATE hosting_strategies SET visibility = 'hidden' WHERE provides IN ('none', 'not_applicable', 'unknown');
          SQL
        end
      end
    end
  end

  private

  def convert_to_provision_enum!(table)
    reversible do |dir|
      dir.up do
        execute <<~SQL.strip_heredoc.strip
        ALTER TABLE #{table} ALTER COLUMN provides SET DATA TYPE controlled_vocabulary_provision USING provides::controlled_vocabulary_provision;
        SQL
      end

      dir.down do
        execute <<~SQL.strip_heredoc.strip
        ALTER TABLE #{table} ALTER COLUMN provides SET DATA TYPE text USING provides::text;
        SQL
      end
    end
  end
end
