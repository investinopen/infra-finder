# frozen_string_literal: true

module SolutionProperties
  # Define and expose implementation enums and store models for {SolutionInterface}.
  module HasImplementations
    extend ActiveSupport::Concern

    include SolutionProperties::HasStructuredAttributes

    # A list of implementation model attribute names.
    # @return [<Symbol>]
    IMPLEMENTATION_MODEL_NAMES = [
      :bylaws,
      :code_license,
      :code_of_conduct,
      :code_repository,
      :community_engagement,
      :contribution_pathways,
      :equity_and_inclusion,
      :governance_records,
      :governance_structure,
      :open_api,
      :open_data,
      :pricing,
      :privacy_policy,
      :product_roadmap,
      :user_documentation,
      :web_accessibility,
    ].freeze

    included do
      pg_enum! :bylaws_implementation, as: :implementation_status, default: :unknown, prefix: :bylaws

      pg_enum! :code_license_implementation, as: :implementation_status, default: :unknown, prefix: :code_license

      pg_enum! :code_of_conduct_implementation, as: :implementation_status, default: :unknown, prefix: :code_of_conduct

      pg_enum! :code_repository_implementation, as: :implementation_status, default: :unknown, prefix: :code_repository

      pg_enum! :community_engagement_implementation, as: :implementation_status, default: :unknown, prefix: :community_engagement

      pg_enum! :contribution_pathways_implementation, as: :implementation_status, default: :unknown, prefix: :contribution_pathways

      pg_enum! :equity_and_inclusion_implementation, as: :implementation_status, default: :unknown, prefix: :equity_and_inclusion

      pg_enum! :governance_records_implementation, as: :implementation_status, default: :unknown, prefix: :governance_records

      pg_enum! :governance_structure_implementation, as: :implementation_status, default: :unknown, prefix: :governance_structure

      pg_enum! :open_api_implementation, as: :implementation_status, default: :unknown, prefix: :open_api

      pg_enum! :open_data_implementation, as: :implementation_status, default: :unknown, prefix: :open_data

      pg_enum! :pricing_implementation, as: :pricing_implementation_status, default: :unknown, prefix: :pricing

      pg_enum! :privacy_policy_implementation, as: :implementation_status, default: :unknown, prefix: :privacy_policy

      pg_enum! :product_roadmap_implementation, as: :implementation_status, default: :unknown, prefix: :product_roadmap

      pg_enum! :user_documentation_implementation, as: :implementation_status, default: :unknown, prefix: :user_documentation

      pg_enum! :web_accessibility_implementation, as: :implementation_status, default: :unknown, prefix: :web_accessibility

      attribute :bylaws, Implementations::Bylaws.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :code_license, Implementations::CodeLicense.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :code_of_conduct, Implementations::CodeOfConduct.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :code_repository, Implementations::CodeRepository.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :community_engagement, Implementations::CommunityEngagement.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :contribution_pathways, Implementations::ContributionPathways.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :equity_and_inclusion, Implementations::EquityAndInclusion.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :governance_records, Implementations::GovernanceRecords.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :governance_structure, Implementations::GovernanceStructure.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :open_api, Implementations::OpenAPI.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :open_data, Implementations::OpenData.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :pricing, Implementations::Pricing.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :privacy_policy, Implementations::PrivacyPolicy.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :product_roadmap, Implementations::ProductRoadmap.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :user_documentation, Implementations::UserDocumentation.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      attribute :web_accessibility, Implementations::WebAccessibility.to_type, default: proc { Dry::Core::Constants::EMPTY_HASH }

      delegate :available_with_url?, :has_url?, to: :bylaws, prefix: :bylaws

      delegate :available_with_url?, :has_url?, to: :code_license, prefix: :code_license

      delegate :available_with_url?, :has_url?, to: :code_of_conduct, prefix: :code_of_conduct

      delegate :available_with_url?, :has_url?, to: :code_repository, prefix: :code_repository

      delegate :available_with_url?, :has_url?, to: :community_engagement, prefix: :community_engagement

      delegate :available_with_url?, :has_url?, to: :contribution_pathways, prefix: :contribution_pathways

      delegate :available_with_url?, :has_url?, to: :equity_and_inclusion, prefix: :equity_and_inclusion

      delegate :available_with_url?, :has_url?, to: :governance_records, prefix: :governance_records

      delegate :available_with_url?, :has_url?, to: :governance_structure, prefix: :governance_structure

      delegate :available_with_url?, :has_url?, to: :open_api, prefix: :open_api

      delegate :available_with_url?, :has_url?, to: :open_data, prefix: :open_data

      delegate :available_with_url?, :has_url?, to: :pricing, prefix: :pricing

      delegate :available_with_url?, :has_url?, to: :privacy_policy, prefix: :privacy_policy

      delegate :available_with_url?, :has_url?, to: :product_roadmap, prefix: :product_roadmap

      delegate :available_with_url?, :has_url?, to: :user_documentation, prefix: :user_documentation

      delegate :available_with_url?, :has_url?, to: :web_accessibility, prefix: :web_accessibility

      accepts_nested_attributes_for *IMPLEMENTATION_MODEL_NAMES, reject_if: :all_blank, update_only: true

      validates *IMPLEMENTATION_MODEL_NAMES, store_model: { if: :apply_editor_validations? }
    end

    # @!attribute [rw] bylaws_structured
    # @return [String]
    def bylaws_structured = structured_data_read(:bylaws)

    # @param [String] json
    def bylaws_structured=(json)
      structured_data_write! :bylaws, json
    end

    # @!attribute [rw] code_license_structured
    # @return [String]
    def code_license_structured = structured_data_read(:code_license)

    # @param [String] json
    def code_license_structured=(json)
      structured_data_write! :code_license, json
    end

    # @!attribute [rw] code_of_conduct_structured
    # @return [String]
    def code_of_conduct_structured = structured_data_read(:code_of_conduct)

    # @param [String] json
    def code_of_conduct_structured=(json)
      structured_data_write! :code_of_conduct, json
    end

    # @!attribute [rw] code_repository_structured
    # @return [String]
    def code_repository_structured = structured_data_read(:code_repository)

    # @param [String] json
    def code_repository_structured=(json)
      structured_data_write! :code_repository, json
    end

    # @!attribute [rw] community_engagement_structured
    # @return [String]
    def community_engagement_structured = structured_data_read(:community_engagement)

    # @param [String] json
    def community_engagement_structured=(json)
      structured_data_write! :community_engagement, json
    end

    # @!attribute [rw] contribution_pathways_structured
    # @return [String]
    def contribution_pathways_structured = structured_data_read(:contribution_pathways)

    # @param [String] json
    def contribution_pathways_structured=(json)
      structured_data_write! :contribution_pathways, json
    end

    # @!attribute [rw] equity_and_inclusion_structured
    # @return [String]
    def equity_and_inclusion_structured = structured_data_read(:equity_and_inclusion)

    # @param [String] json
    def equity_and_inclusion_structured=(json)
      structured_data_write! :equity_and_inclusion, json
    end

    # @!attribute [rw] governance_records_structured
    # @return [String]
    def governance_records_structured = structured_data_read(:governance_records)

    # @param [String] json
    def governance_records_structured=(json)
      structured_data_write! :governance_records, json
    end

    # @!attribute [rw] governance_structure_structured
    # @return [String]
    def governance_structure_structured = structured_data_read(:governance_structure)

    # @param [String] json
    def governance_structure_structured=(json)
      structured_data_write! :governance_structure, json
    end

    # @!attribute [rw] open_api_structured
    # @return [String]
    def open_api_structured = structured_data_read(:open_api)

    # @param [String] json
    def open_api_structured=(json)
      structured_data_write! :open_api, json
    end

    # @!attribute [rw] open_data_structured
    # @return [String]
    def open_data_structured = structured_data_read(:open_data)

    # @param [String] json
    def open_data_structured=(json)
      structured_data_write! :open_data, json
    end

    # @!attribute [rw] pricing_structured
    # @return [String]
    def pricing_structured = structured_data_read(:pricing)

    # @param [String] json
    def pricing_structured=(json)
      structured_data_write! :pricing, json
    end

    # @!attribute [rw] privacy_policy_structured
    # @return [String]
    def privacy_policy_structured = structured_data_read(:privacy_policy)

    # @param [String] json
    def privacy_policy_structured=(json)
      structured_data_write! :privacy_policy, json
    end

    # @!attribute [rw] product_roadmap_structured
    # @return [String]
    def product_roadmap_structured = structured_data_read(:product_roadmap)

    # @param [String] json
    def product_roadmap_structured=(json)
      structured_data_write! :product_roadmap, json
    end

    # @!attribute [rw] user_documentation_structured
    # @return [String]
    def user_documentation_structured = structured_data_read(:user_documentation)

    # @param [String] json
    def user_documentation_structured=(json)
      structured_data_write! :user_documentation, json
    end

    # @!attribute [rw] web_accessibility_structured
    # @return [String]
    def web_accessibility_structured = structured_data_read(:web_accessibility)

    # @param [String] json
    def web_accessibility_structured=(json)
      structured_data_write! :web_accessibility, json
    end
  end
end
