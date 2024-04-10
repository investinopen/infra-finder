# frozen_string_literal: true

module SolutionImports
  module Legacy
    module Headers
      extend ActiveSupport::Concern

      LEGACY_HEADERS = [
        # Identifier
        :id,

        # Provider
        :provider_name,

        # Core
        :service_name,
        :year_when_service_was_founded,
        :location_of_incorporation,
        :number_of_members,
        :current_staffing,

        # Contact
        :contact_us,
        :website,
        :research_organization_registry_id,

        # Attachments
        :service_logo,

        # Finances
        :annual_expenses,
        :annual_revenue,
        :investment_income,
        :other_revenue,
        :program_revenue,
        :total_assets,
        :total_contributions,
        :total_liabilities,
        :financial_numbers_documented_link,
        :financial_information_level_id,
        :financial_numbers_approved_for_publication_id,
        :financial_numbers_documented_applicable_id,

        # Blurbs
        :content_licensing,
        :engagement_with_values_frameworks,
        :funding_needs,
        :governance_summary,
        :key_achievements,
        :mission,
        :organizational_history,
        :service_summary,
        :special_certifications_or_statuses,
        :standards_employed,
        :what_other_tools,
        :what_registered,
        :what_technologies,

        # Implementations

        # Implementations/bylaws
        :link_to_bylaws_displayed,
        :link_to_bylaws_hidden_one,
        :link_to_bylaws_hidden_two,

        # Implementations/code_license
        :code_license_displayed,
        :code_license_hidden_one,
        :code_license_hidden_two,

        # Implementations/code_of_conduct
        :code_of_conduct,
        :link_to_code_of_conduct_displayed,
        :link_to_code_of_conduct_hidden_one,
        :link_to_code_of_conduct_hidden_two,

        # Implementations/code_repository
        :open_code_repository_id,
        :link_to_code_repository_displayed,
        :link_to_code_repository_hidden_one,
        :link_to_code_repository_hidden_two,

        # Implementations/community_engagement
        :organizational_commitment_to_community_engagement_id,
        :describe_activities_that_evidence_commitment,

        # Implementations/equity_and_inclusion
        :commitment_to_equity_and_inclusion_id,
        :link_to_commitment_to_equity_and_inclusion_displayed,
        :link_to_commitment_to_equity_and_inclusion_hidden_one,
        :link_to_commitment_to_equity_and_inclusion_hidden_two,

        # Implementations/governance_activities
        :governance_activities_id,
        :link_to_governance_activities_displayed,
        :link_to_governance_activities_hidden_one,
        :link_to_governance_activities_hidden_two,

        # Implementations/governance_structure
        :governance_structure_and_processes_id,
        :link_to_governance_structure_and_processes_displayed,
        :link_to_governance_structure_and_processes_hidden_one,
        :link_to_governance_structure_and_processes_hidden_two,

        # Implementations/open_api
        :open_api_id,
        :link_to_open_apis_displayed,
        :link_to_open_apis_hidden_one,
        :link_to_open_apis_hidden_two,

        # Implementations/open_data
        :open_data_statement_id,
        :link_to_open_data_statement_displayed,
        :link_to_open_data_statement_hidden_one,
        :link_to_open_data_statement_hidden_two,

        # Implementations/pricing
        :transparent_pricing_and_cost_expectations_id,
        :link_to_pricing_displayed,
        :link_to_pricing_hidden_one,
        :link_to_pricing_hidden_two,

        # Implementations/privacy_policy
        :commitment_to_privacy,
        :link_to_privacy_policy_displayed,
        :link_to_privacy_policy_hidden_one,
        :link_to_privacy_policy_hidden_two,

        # Implementations/product_roadmap
        :open_product_roadmap_id,
        :link_to_product_roadmap_displayed,
        :link_to_product_roadmap_hidden_one,
        :link_to_product_roadmap_hidden_two,

        # Implementations/user_contribution_pathways
        :user_contribution_pathways_id,
        :link_to_community_contribution_guidelines_or_fora_displayed,
        :link_to_community_contribution_guidelines_or_fora_hidden_one,
        :link_to_community_contribution_guidelines_or_fora_hidden_two,

        # Implementations/user_documentation
        :technical_user_documentation_id,
        :link_to_technical_user_documentation_displayed,
        :link_to_technical_user_documentation_hidden_one,
        :link_to_technical_user_documentation_hidden_two,

        # Implementations/web_accessibility
        :web_accessibility_statement_id,
        :link_to_web_accessibility_statement,
        :this_web_accessibility_statement_applies_to_id,

        # Lists
        :current_affiliations,
        :founding_institutions,
        :what_comparable_products_exist,
        :link_to_service_desc_or_service_provider_registry,
        :list_of_grants_received_past_year,
        :top_granting_institutions,

        # Single-mode Options
        :board_structure_id,
        :business_form_id,
        :community_governance_id,
        # Hosting strategy
        :can_infra_hosted_by_service_prvdr_or_3rd_party_id,
        :maintenance_status_id,
        :primary_funding_source_id,
        # Readiness Level
        :technology_readiness_level_id,

        # Multiple-mode options
        :solution_category_names,
        :in_what_ways_names,
        :license_type_names,

        # Tags
        :key_technologies_names,

        # Unused
        :board_structure_name,
        :business_form_name,
        :can_infra_hosted_by_service_prvdr_or_3rd_party_name,
        :commitment_to_equity_and_inclusion_name,
        :community_governance_name,
        :financial_information_level_name,
        :financial_numbers_approved_for_publication_name,
        :financial_numbers_documented_applicable_name,
        :governance_activities_name,
        :governance_structure_and_processes_name,
        :i_approve_this_revision,
        :initials,
        :maintenance_status_name,
        :open_api_name,
        :open_code_repository_name,
        :open_data_statement_name,
        :open_product_roadmap_name,
        :organizational_commitment_to_community_engagement_name,
        :primary_funding_source_name,
        :technical_user_documentation_name,
        :technology_readiness_level_name,
        :this_web_accessibility_statement_applies_to_name,
        :transparent_pricing_and_cost_expectations_name,
        :user_contribution_pathways_name,
        :web_accessibility_statement_name,
      ].freeze

      SKIPPED_HEADERS = %i[
        board_structure_name
        business_form_name
        can_infra_hosted_by_service_prvdr_or_3rd_party_name
        commitment_to_equity_and_inclusion_name
        community_governance_name
        financial_information_level_name
        financial_numbers_approved_for_publication_name
        financial_numbers_documented_applicable_name
        governance_activities_name
        governance_structure_and_processes_name
        i_approve_this_revision
        initials
        maintenance_status_name
        open_api_name
        open_code_repository_name
        open_data_statement_name
        open_product_roadmap_name
        organizational_commitment_to_community_engagement_name
        primary_funding_source_name
        technical_user_documentation_name
        technology_readiness_level_name
        this_web_accessibility_statement_applies_to_name
        transparent_pricing_and_cost_expectations_name
        user_contribution_pathways_name
        web_accessibility_statement_name
      ].freeze

      REMAPPED_KEYS = {
        id: :identifier,
        service_name: :name,
        provider_name: :provider_identifier,
        year_when_service_was_founded: :founded_on,
        service_logo: :logo_remote_url,
        number_of_members: :member_count,

        contact_us: :contact,
        research_organization_registry_id: :research_organization_registry_url,

        # Finances
        financial_numbers_documented_applicable_id: :financial_numbers_applicability,
        financial_numbers_approved_for_publication_id: :financial_numbers_publishability,
        financial_information_level_id: :financial_information_scope,
        financial_numbers_documented_link: :financial_numbers_documented_url,

        # Lists
        list_of_grants_received_past_year: :recent_grants,
        what_comparable_products_exist: :comparable_products,

        # Tags
        key_technologies_names: :key_technology_list,

        # Blurbs
        what_registered: :registered_service_provider_description,
        what_other_tools: :integrations_and_compatibility,
        what_technologies: :technology_dependencies,

      }.freeze
    end
  end
end
