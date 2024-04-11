# frozen_string_literal: true

module SolutionImports
  module Extraction
    class TransformLegacyRow < Dry::Transformer::Pipe
      include SolutionImports::Legacy::Headers

      import Dry::Transformer::HashTransformations
      import SolutionImports::Legacy::Transformations

      define! do
        symbolize_keys

        year_to_date :year_when_service_was_founded

        normalize_maintenance_status

        normalize_multiple_options

        normalize_single_options

        parse_financial_numbers_applicability :financial_numbers_documented_applicable_id
        parse_financial_numbers_publishability :financial_numbers_approved_for_publication_id
        parse_financial_information_scope :financial_information_level_id

        rename_keys REMAPPED_KEYS

        compose_implementation(
          :bylaws,
          autostatus: true
        )

        compose_implementation(
          :code_license,
          autostatus: true,
          url_key_prefix: :code_license
        )

        compose_implementation(
          :code_of_conduct,
          # sic
          status_key: :code_of_conduct
        )

        compose_implementation(
          :code_repository,
          status_key: :open_code_repository_id
        )

        compose_implementation(
          :community_engagement,
          skip_urls: true,
          status_key: :organizational_commitment_to_community_engagement_id,
          statement_key: :describe_activities_that_evidence_commitment
        )

        compose_implementation(
          :equity_and_inclusion,
          status_key: :commitment_to_equity_and_inclusion_id,
          url_key_prefix: :link_to_commitment_to_equity_and_inclusion
        )

        compose_implementation(
          :governance_activities,
          status_key: :governance_activities_id
        )

        compose_implementation(
          :governance_structure,
          status_key: :governance_structure_and_processes_id,
          url_key_prefix: :link_to_governance_structure_and_processes
        )

        compose_implementation(
          :open_api,
          status_key: :open_api_id,
          url_key_prefix: :link_to_open_apis
        )

        compose_implementation(
          :open_data,
          status_key: :open_data_statement_id,
          url_key_prefix: :link_to_open_data_statement
        )

        compose_implementation(
          :pricing,
          status_key: :transparent_pricing_and_cost_expectations_id
        )

        compose_implementation(
          :privacy_policy,
          # sic
          status_key: :commitment_to_privacy
        )

        compose_implementation(
          :product_roadmap,
          status_key: :open_product_roadmap_id
        )

        compose_implementation(
          :user_contribution_pathways,
          status_key: :user_contribution_pathways_id,
          url_key_prefix: :link_to_community_contribution_guidelines_or_fora
        )

        compose_implementation(
          :user_documentation,
          status_key: :technical_user_documentation_id,
          url_key_prefix: :link_to_technical_user_documentation
        )

        compose_implementation(
          :web_accessibility,
          extra_keys: %i[
            this_web_accessibility_statement_applies_to_id
          ],
          url_keys: %i[
            link_to_web_accessibility_statement
          ]
        )

        parse_institutions_in :current_affiliations
        parse_institutions_in :founding_institutions
        parse_institutions_in :top_granting_institutions

        parse_comparable_products
        parse_service_providers
        parse_recent_grants
      end
    end
  end
end
