# frozen_string_literal: true

module Solutions
  module Revisions
    class V2PropertySet
      include Support::EnhancedStoreModel
      include Solutions::Revisions::PropertySet
      include Dry::Core::Constants

      attribute :name, :string
      attribute :contact, :string
      attribute :first_name, :string
      attribute :last_name, :string
      attribute :email, :string
      attribute :service_summary, :string
      attribute :website, :string
      attribute :research_organization_registry_url, :string
      attribute :logo, ::Solutions::Revisions::Attachment.to_type
      attribute :country_code, :string
      attribute :solution_categories, :string_array, default: EMPTY_ARRAY
      attribute :mission, :string
      attribute :key_achievements, :string
      attribute :funding_needs, :string
      attribute :code_repository_implementation, :string
      attribute :open_data_implementation, :string
      attribute :user_documentation_implementation, :string
      attribute :governance_structure_implementation, :string
      attribute :governance_records_implementation, :string
      attribute :governance_summary, :string
      attribute :web_accessibility_implementation, :string
      attribute :pricing_implementation, :string
      attribute :equity_and_inclusion_implementation, :string
      attribute :community_engagement_implementation, :string
      attribute :community_engagement_activities, :string_array, default: EMPTY_ARRAY
      attribute :community_engagement_activity_other, :string
      attribute :contribution_pathways_implementation, :string
      attribute :user_contributions, :string_array, default: EMPTY_ARRAY
      attribute :user_contribution_other, :string
      attribute :code_of_conduct_implementation, :string
      attribute :privacy_policy_implementation, :string
      attribute :values_frameworks, :string_array, default: EMPTY_ARRAY
      attribute :community_governances, :string_array, default: EMPTY_ARRAY
      attribute :board_structures, :string_array, default: EMPTY_ARRAY
      attribute :board_structure_other, :string
      attribute :business_forms, :string_array, default: EMPTY_ARRAY
      attribute :business_form_other, :string
      attribute :nonprofit_status, :string
      attribute :shareholders, :boolean
      attribute :staffing_full_time, :string
      attribute :staffing_volunteer, :string
      attribute :founded_on, :date
      attribute :organizational_history, :string
      attribute :current_affiliations, ::Solutions::Institution.to_array_type, default: EMPTY_ARRAY
      attribute :current_affiliation_free_input, :string
      attribute :founding_institutions, ::Solutions::Institution.to_array_type, default: EMPTY_ARRAY
      attribute :founding_institution_free_input, :string
      attribute :primary_funding_sources, :string_array, default: EMPTY_ARRAY
      attribute :primary_funding_source_other, :string
      attribute :currency, :string
      attribute :financial_date_range, :string
      attribute :total_contributions, ::Solutions::Revisions::MoneyValue.to_type
      attribute :program_revenue, ::Solutions::Revisions::MoneyValue.to_type
      attribute :investment_income, ::Solutions::Revisions::MoneyValue.to_type
      attribute :other_revenue, ::Solutions::Revisions::MoneyValue.to_type
      attribute :annual_revenue, ::Solutions::Revisions::MoneyValue.to_type
      attribute :annual_expenses, ::Solutions::Revisions::MoneyValue.to_type
      attribute :total_assets, ::Solutions::Revisions::MoneyValue.to_type
      attribute :total_liabilities, ::Solutions::Revisions::MoneyValue.to_type
      attribute :financial_reporting_level, :string
      attribute :financial_reporting_level_other, :string
      attribute :financial_numbers_documented_url, :string
      attribute :top_granting_institutions, ::Solutions::Institution.to_array_type, default: EMPTY_ARRAY
      attribute :top_granting_institution_free_input, :string
      attribute :recent_grants, ::Solutions::Grant.to_array_type, default: EMPTY_ARRAY
      attribute :recent_grant_free_input, :string
      attribute :hosting_strategy, :string
      attribute :service_providers, ::Solutions::ServiceProvider.to_array_type, default: EMPTY_ARRAY
      attribute :service_provider_free_input, :string
      attribute :member_count, :big_integer
      attribute :readiness_level, :string
      attribute :maintenance_status, :string
      attribute :programming_languages, :string_array, default: EMPTY_ARRAY
      attribute :programming_language_other, :string
      attribute :integrations, :string_array, default: EMPTY_ARRAY
      attribute :integration_other, :string
      attribute :licenses, :string_array, default: EMPTY_ARRAY
      attribute :license_other, :string
      attribute :content_licenses, :string_array, default: EMPTY_ARRAY
      attribute :content_license_other, :string
      attribute :open_api_implementation, :string
      attribute :product_roadmap_implementation, :string
      attribute :metadata_standards, :string_array, default: EMPTY_ARRAY
      attribute :metadata_standard_other, :string
      attribute :persistent_identifier_standards, :string_array, default: EMPTY_ARRAY
      attribute :persistent_identifier_standard_other, :string
      attribute :authentication_standards, :string_array, default: EMPTY_ARRAY
      attribute :authentication_standard_other, :string
      attribute :board_members_url, :string
      attribute :security_standards, :string_array, default: EMPTY_ARRAY
      attribute :security_standard_other, :string
      attribute :scoss, :boolean
      attribute :board_level, :string
      attribute :board_level_other, :string
      attribute :code_license_implementation, :string
      attribute :membership_program_url, :string
      attribute :bylaws_implementation, :string
      attribute :preservation_standards, :string_array, default: EMPTY_ARRAY
      attribute :preservation_standard_other, :string
      attribute :metrics_standards, :string_array, default: EMPTY_ARRAY
      attribute :metrics_standard_other, :string
      attribute :financial_numbers_publishability, :string
      attribute :fiscal_host, :string
      attribute :domain_relevances, :string_array, default: EMPTY_ARRAY
      attribute :access_conditions, :string_array, default: EMPTY_ARRAY
      attribute :registries, ::Solutions::Registry.to_array_type, default: EMPTY_ARRAY
      attribute :registry_free_input, :string
      attribute :revenue_sources, :string_array, default: EMPTY_ARRAY
      attribute :bylaws, ::Implementations::Bylaws.to_type
      attribute :code_license, ::Implementations::CodeLicense.to_type
      attribute :code_of_conduct, ::Implementations::CodeOfConduct.to_type
      attribute :code_repository, ::Implementations::CodeRepository.to_type
      attribute :community_engagement, ::Implementations::CommunityEngagement.to_type
      attribute :contribution_pathways, ::Implementations::ContributionPathways.to_type
      attribute :equity_and_inclusion, ::Implementations::EquityAndInclusion.to_type
      attribute :governance_records, ::Implementations::GovernanceRecords.to_type
      attribute :governance_structure, ::Implementations::GovernanceStructure.to_type
      attribute :open_api, ::Implementations::OpenAPI.to_type
      attribute :open_data, ::Implementations::OpenData.to_type
      attribute :pricing, ::Implementations::Pricing.to_type
      attribute :privacy_policy, ::Implementations::PrivacyPolicy.to_type
      attribute :product_roadmap, ::Implementations::ProductRoadmap.to_type
      attribute :user_documentation, ::Implementations::UserDocumentation.to_type
      attribute :web_accessibility, ::Implementations::WebAccessibility.to_type
      attribute :web_accessibility_applicabilities, :string_array, default: EMPTY_ARRAY
    end
  end
end
