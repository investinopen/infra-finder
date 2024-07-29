# frozen_string_literal: true

module SolutionImports
  module Transient
    # A transient record to ensure an {Solution} exists.
    class SolutionRow < Support::FlexibleStruct
      attribute :identifier, Types::Identifier
      attribute :provider_identifier, Types::Identifier
      attribute :name, Types::PresentString

      # @!group Core Attributes

      attribute? :founded_on, Types::Date.optional
      attribute? :location_of_incorporation, Types::String.optional
      attribute? :member_count, Types::Integer.optional
      attribute? :current_staffing, Support::Types::BigDecimal
      attribute? :maintenance_status, Types::MaintenanceStatus

      # @!endgroup

      # @!group Contact

      attribute? :contact, Types::String.optional
      attribute? :website, Types::URL.optional
      attribute? :research_organization_registry_url, Types::URL.optional

      # @!endgroup

      # @!group Finances

      attribute? :annual_expenses, Types::Integer.optional
      attribute? :annual_revenue, Types::Integer.optional
      attribute? :investment_income, Types::Integer.optional
      attribute? :other_revenue, Types::Integer.optional
      attribute? :program_revenue, Types::Integer.optional
      attribute? :total_assets, Types::Integer.optional
      attribute? :total_contributions, Types::Integer.optional
      attribute? :total_liabilities, Types::Integer.optional

      attribute? :financial_numbers_applicability, Types::FinancialNumbersApplicability
      attribute? :financial_numbers_publishability, Types::FinancialNumbersPublishability
      attribute? :financial_information_scope, Types::FinancialInformationScope

      attribute? :financial_numbers_documented_url, Types::URL.optional

      # @!endgroup

      # SolutionInterface::BLURBS.each do |blurb|
      #   attribute? blurb, Types::Blurb
      # end

      Implementation.each do |impl|
        attribute impl.enum.to_sym, impl.enum_dry_type
        attribute impl.name.to_sym, impl.data_dry_type
      end

      # SolutionInterface::SINGLE_OPTIONS.each do |option|
      #  type = Types.ModelInstance(option.to_s.classify).optional

      #  attribute? option, type
      # end

      # SolutionInterface::MULTIPLE_OPTIONS.each do |option|
      #  inner_type = Types.ModelInstance(option.to_s.classify)

      #  type = Types::Coercible::Array.of(inner_type).default { [] }

      #  attribute? option, type
      # end

      # SolutionInterface::STORE_MODEL_LISTS.each do |sml|
      #   attribute sml, Types::StoreModelList
      # end

      # SolutionInterface::ATTACHMENTS.each do |att|
      #   attribute? :"#{att}_remote_url", Types::URL.optional
      # end

      DRAFT_ATTRS = SolutionProperty.to_clone_draft

      # The bare-minimum attributes to merely _create_ a {Solution}.
      #
      # The import process makes use of the draft process, to provide
      # an audit trail and cut down on the ways that solutions get modified.
      #
      # @return [Hash]
      def attrs_to_create
        { name:, }
      end

      # @return [Hash]
      def attrs_to_draft
        slice(*DRAFT_ATTRS)
      end
    end
  end
end
