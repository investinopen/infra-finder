# frozen_string_literal: true

module Solutions
  module Revisions
    class V2PropertySet
      include Support::EnhancedStoreModel
      include Solutions::Revisions::PropertySet

      attribute :logo, ::Solutions::Revisions::Attachment.to_type
      attribute :first_name, :string
      attribute :last_name, :string
      attribute :email, :string
      attribute :member_count, :big_integer
      attribute :research_organization_registry_url, :string
      attribute :board_members_url, :string
      attribute :financial_date_range, :string
      attribute :annual_expenses, ::Solutions::Revisions::MoneyValue.to_type
      attribute :annual_revenue, ::Solutions::Revisions::MoneyValue.to_type
      attribute :investment_income, ::Solutions::Revisions::MoneyValue.to_type
      attribute :other_revenue, ::Solutions::Revisions::MoneyValue.to_type
      attribute :program_revenue, ::Solutions::Revisions::MoneyValue.to_type
      attribute :total_contributions, ::Solutions::Revisions::MoneyValue.to_type
      attribute :total_liabilities, ::Solutions::Revisions::MoneyValue.to_type
      attribute :financial_numbers_publishability, :string
      attribute :financial_numbers_documented_url, :string
      attribute :name, :string
      attribute :website, :string
      attribute :contact, :string
      attribute :founded_on, :date
      attribute :service_summary, :string
      attribute :key_achievements, :string
      attribute :mission, :string
      attribute :scoss, :boolean
      attribute :membership_program_url, :string
      attribute :governance_summary, :string
      attribute :organizational_history, :string
      attribute :shareholders, :boolean
      attribute :funding_needs, :string
      attribute :total_assets, ::Solutions::Revisions::MoneyValue.to_type
      attribute :currency, :string
      attribute :country_code, :string
      attribute :board_structure_other, :string
      attribute :financial_reporting_level_other, :string
      attribute :license_other, :string
      attribute :programming_language_other, :string
      attribute :metadata_standard_other, :string
      attribute :persistent_identifier_standard_other, :string
      attribute :authentication_standard_other, :string
      attribute :security_standard_other, :string
      attribute :preservation_standard_other, :string
      attribute :metrics_standard_other, :string
      attribute :content_license_other, :string
      attribute :integration_other, :string
      attribute :user_contribution_other, :string
      attribute :community_engagement_activity_other, :string
      attribute :board_level_other, :string
      attribute :business_form_other, :string
      attribute :primary_funding_source_other, :string
      attribute :current_affiliation_free_input, :string
      attribute :founding_institution_free_input, :string
      attribute :recent_grant_free_input, :string
      attribute :top_granting_institution_free_input, :string
      attribute :service_provider_free_input, :string
      attribute :bylaws, ::Implementations::Bylaws.to_type
      attribute :bylaws_implementation, :string
      attribute :code_license, ::Implementations::CodeLicense.to_type
      attribute :code_license_implementation, :string
      attribute :code_of_conduct, ::Implementations::CodeOfConduct.to_type
      attribute :code_of_conduct_implementation, :string
      attribute :code_repository, ::Implementations::CodeRepository.to_type
      attribute :code_repository_implementation, :string
      attribute :community_engagement, ::Implementations::CommunityEngagement.to_type
      attribute :community_engagement_implementation, :string
      attribute :contribution_pathways, ::Implementations::ContributionPathways.to_type
      attribute :contribution_pathways_implementation, :string
      attribute :equity_and_inclusion, ::Implementations::EquityAndInclusion.to_type
      attribute :equity_and_inclusion_implementation, :string
      attribute :governance_records, ::Implementations::GovernanceRecords.to_type
      attribute :governance_records_implementation, :string
      attribute :governance_structure, ::Implementations::GovernanceStructure.to_type
      attribute :governance_structure_implementation, :string
      attribute :open_api, ::Implementations::OpenAPI.to_type
      attribute :open_api_implementation, :string
      attribute :open_data, ::Implementations::OpenData.to_type
      attribute :open_data_implementation, :string
      attribute :pricing, ::Implementations::Pricing.to_type
      attribute :pricing_implementation, :string
      attribute :privacy_policy, ::Implementations::PrivacyPolicy.to_type
      attribute :privacy_policy_implementation, :string
      attribute :product_roadmap, ::Implementations::ProductRoadmap.to_type
      attribute :product_roadmap_implementation, :string
      attribute :user_documentation, ::Implementations::UserDocumentation.to_type
      attribute :user_documentation_implementation, :string
      attribute :web_accessibility, ::Implementations::WebAccessibility.to_type
      attribute :web_accessibility_implementation, :string
      attribute :readiness_level, :string
      attribute :staffing_volunteer, :string
      attribute :financial_reporting_level, :string
      attribute :hosting_strategy, :string
      attribute :maintenance_status, :string
      attribute :board_level, :string
      attribute :nonprofit_status, :string
      attribute :staffing_full_time, :string
      attribute :board_structures, :string_array, default: [].freeze
      attribute :community_governances, :string_array, default: [].freeze
      attribute :web_accessibility_applicabilities, :string_array, default: [].freeze
      attribute :solution_categories, :string_array, default: [].freeze
      attribute :licenses, :string_array, default: [].freeze
      attribute :programming_languages, :string_array, default: [].freeze
      attribute :metadata_standards, :string_array, default: [].freeze
      attribute :persistent_identifier_standards, :string_array, default: [].freeze
      attribute :authentication_standards, :string_array, default: [].freeze
      attribute :security_standards, :string_array, default: [].freeze
      attribute :preservation_standards, :string_array, default: [].freeze
      attribute :metrics_standards, :string_array, default: [].freeze
      attribute :content_licenses, :string_array, default: [].freeze
      attribute :integrations, :string_array, default: [].freeze
      attribute :user_contributions, :string_array, default: [].freeze
      attribute :values_frameworks, :string_array, default: [].freeze
      attribute :community_engagement_activities, :string_array, default: [].freeze
      attribute :business_forms, :string_array, default: [].freeze
      attribute :primary_funding_sources, :string_array, default: [].freeze
    end
  end
end
