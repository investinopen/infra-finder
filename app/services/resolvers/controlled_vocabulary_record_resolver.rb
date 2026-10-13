# frozen_string_literal: true

module Resolvers
  # A resolver for the records of the parent {ControlledVocabulary}.
  #
  # @see Types::ControlledVocabularyType#records
  class ControlledVocabularyRecordResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination

    applies_policy_scope!

    type ::Types::ControlledVocabularyRecordType.connection_type, null: false

    resolves_model! ::License

    orders_with! ::Types::ControlledVocabularyRecordOrderType, default: "DEFAULT"

    option :name_search, type: ::Types::SearchQueryInputType, description: "Perform a full-text search on record names." do |scope, value|
      scope.search_name(value) if value.present?
    end

    option :visibility, type: ::Types::VisibilityType, description: "Filter by visibility." do |scope, value|
      scope.where(visibility: value) if value.present?
    end

    option :provides, type: ::Types::ControlledVocabularyProvisionType, description: "Filter by special behavior." do |scope, value|
      scope.with_providing(value) if value.present?
    end

    option :used, type: GraphQL::Types::Boolean, description: "Filter to records used (true) or unused (false) by any solution or draft." do |scope, value|
      case value
      when true then scope.used
      when false then scope.unused
      end
    end

    # The model for the parent vocabulary, rather than a fixed class.
    #
    # @return [Class<ControlledVocabularyRecord>]
    def model_klass
      object.try(:model_klass) || super
    end

    # @return [ActiveRecord::Relation<ControlledVocabularyRecord>]
    def resolve_default_scope
      model_klass.all
    end
  end
end
