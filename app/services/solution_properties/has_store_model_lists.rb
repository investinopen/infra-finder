# frozen_string_literal: true

module SolutionProperties
  # A concern consumed by {SolutionInterface} which describes the
  # various complex store models backing certain properties.
  #
  # @see SolutionProperty.store_model_lists
  module HasStoreModelLists
    extend ActiveSupport::Concern

    include SolutionProperties::HasStructuredAttributes

    # A list of structured model attribute names.
    # @return [<Symbol>]
    STRUCTURED_MODEL_NAMES = [
      :current_affiliations,
      :founding_institutions,
      :recent_grants,
      :registries,
      :service_providers,
      :top_granting_institutions,
    ].freeze

    included do
      attribute :current_affiliations, ::Structured::Institution.to_array_type, default: proc { Dry::Core::Constants::EMPTY_ARRAY }

      attribute :founding_institutions, ::Structured::Institution.to_array_type, default: proc { Dry::Core::Constants::EMPTY_ARRAY }

      attribute :recent_grants, ::Structured::Grant.to_array_type, default: proc { Dry::Core::Constants::EMPTY_ARRAY }

      attribute :registries, ::Structured::Registry.to_array_type, default: proc { Dry::Core::Constants::EMPTY_ARRAY }

      attribute :service_providers, ::Structured::ServiceProvider.to_array_type, default: proc { Dry::Core::Constants::EMPTY_ARRAY }

      attribute :top_granting_institutions, ::Structured::Institution.to_array_type, default: proc { Dry::Core::Constants::EMPTY_ARRAY }

      accepts_nested_attributes_for *STRUCTURED_MODEL_NAMES, reject_if: :all_blank

      validates *STRUCTURED_MODEL_NAMES, store_model: { if: :apply_editor_validations? }
    end

    # @!attribute [rw] current_affiliations_structured
    # @return [String]
    def current_affiliations_structured = structured_data_read(:current_affiliations)

    def current_affiliations_structured=(json)
      structured_data_write! :current_affiliations, json
    end

    # @!attribute [rw] founding_institutions_structured
    # @return [String]
    def founding_institutions_structured = structured_data_read(:founding_institutions)

    def founding_institutions_structured=(json)
      structured_data_write! :founding_institutions, json
    end

    # @!attribute [rw] recent_grants_structured
    # @return [String]
    def recent_grants_structured = structured_data_read(:recent_grants)

    def recent_grants_structured=(json)
      structured_data_write! :recent_grants, json
    end

    # @!attribute [rw] registries_structured
    # @return [String]
    def registries_structured = structured_data_read(:registries)

    def registries_structured=(json)
      structured_data_write! :registries, json
    end

    # @!attribute [rw] service_providers_structured
    # @return [String]
    def service_providers_structured = structured_data_read(:service_providers)

    def service_providers_structured=(json)
      structured_data_write! :service_providers, json
    end

    # @!attribute [rw] top_granting_institutions_structured
    # @return [String]
    def top_granting_institutions_structured = structured_data_read(:top_granting_institutions)

    def top_granting_institutions_structured=(json)
      structured_data_write! :top_granting_institutions, json
    end
  end
end
