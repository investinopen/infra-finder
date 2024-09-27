# frozen_string_literal: true

class AddBespokeFilterPositionToControlledVocabularies < ActiveRecord::Migration[7.1]
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
    TABLES.each do |table_name|
      add_bespoke_filter_position_to! table_name
    end

    reversible do |dir|
      dir.up do
        exec_update(<<~SQL)
        INSERT INTO hosting_strategies (name, term, slug, enforced_slug, provides, visibility, bespoke_filter_position)
        VALUES
          ('Through solution provider only', 'Through solution provider only', 'provider-only', 'provider-only', NULL, 'visible', 1),
          ('Through third party vendor only', 'Through third party vendor only', 'third-party-only', 'third-party-only', NULL, 'visible', 2),
          ('Through solution provider or third party vendor', 'Through solution provider or third party vendor', 'provider-or-third-party', 'provider-or-third-party', NULL, 'visible', 3),
          ('Not applicable', 'Not applicable', 'not-applicable', 'not-applicable', 'not_applicable', 'visible', NULL),
          ('No services available', 'No services available', 'no-services-available', 'no-services-available', 'none', 'visible', NULL)
        ON CONFLICT (slug) DO UPDATE SET
          bespoke_filter_position = EXCLUDED.bespoke_filter_position,
          enforced_slug = EXCLUDED.enforced_slug,
          name = EXCLUDED.name,
          term = EXCLUDED.term,
          provides = EXCLUDED.provides,
          visibility = EXCLUDED.visibility
        ;
        SQL
      end
    end
  end

  private

  def add_bespoke_filter_position_to!(table_name)
    change_table table_name do |t|
      t.bigint :bespoke_filter_position

      t.index %i[bespoke_filter_position term], name: "index_#{table_name}_bespoke_filter_ordering", where: %[bespoke_filter_position IS NOT NULL]
    end
  end
end
