# frozen_string_literal: true

module Filtering
  # The base class for building filter scopes. It has a fluent DSL for defining filtering
  # arguments, and methods for applying those filters to an ActiveRecord scope.
  #
  # Filter scope implementations live in {Filtering::Scopes} and follow a convention of
  # being named in a plural of the model they filter, e.g. {Filtering::Scopes::Users}
  # serves as the filter scope for the `User` model. When inheriting from this class,
  # the model class that is wrapped is provided to {.[]} in order to automatically make
  # the necessary connections and definitions.
  #
  # @abstract
  class FilterScope < Support::QueryResolver::Base
    extend Dry::Initializer

    defines :required_scopes, type: Filtering::Types::ScopeNames

    required_scopes Dry::Core::Constants::EMPTY_ARRAY

    define_model_callbacks :ranking, only: %i[before after]

    include HasArguments

    defines :model_klass, type: Support::Models::Types::ModelClass

    model_klass ApplicationRecord

    defines :input_object_name, type: Filtering::Types::String

    input_object_name ""

    defines :input_object_default_value, type: Filtering::Types::Hash.fallback { {} }

    option :current_user, ::Users::Types::Current, default: ::Users::Types::DEFAULT_FROM_REQUEST

    # @return [EncodedSets::Collection]
    attr_reader :encoded_set

    def initialize(...)
      super

      @encoded_set = EncodedSets::Collection.new
      @filter_inputs = build_filter_inputs
    end

    # @see Filtering::Applicator#call
    # @param [ActiveRecord::Relation] top_level_scope
    # @return [ActiveRecord::Relation]
    def apply_to(top_level_scope) = applicator.(top_level_scope)

    # @return [ActiveRecord::Relation]
    def initialize_scope = self.class.model_klass.all

    # Finalize the scope by reselecting only the primary key and removing any ordering.
    #
    # @return [void]
    def finalize!
      augment_scope! do |sc|
        sc.reselect(sc.primary_key).reorder(nil)
      end
    end

    # @param [ActiveRecord::Relation] base
    # @return [ActiveRecord::Relation]
    def apply_ranking_to(base)
      @ranking_scope = base

      run_callbacks :ranking

      return @ranking_scope
    ensure
      @ranking_scope = nil
    end

    # @yieldparam [ActiveRecord::Relation] ranking_scope
    # @yieldreturn [ActiveRecord::Relation]
    # @return [void]
    def augment_ranking!
      # simplecov:disable
      new_scope = yield @ranking_scope

      @ranking_scope = new_scope unless new_scope.nil?
      # simplecov:enable
    end

    def has_any_admin_access? = current_user.try(:has_any_admin_access?)

    private

    # @!attribute [r] applicator
    # @return [Filtering::Applicator]
    def applicator
      @applicator ||= Filtering::Applicator.new(self)
    end

    # @return [void]
    def apply_all_tags!
      augment_scope! do |scope|
        external_tags&.call(scope, on: :external_tags)
      end

      augment_scope! do |scope|
        next unless internal_tags.present?
        next scope.none unless has_any_admin_access?

        internal_tags.call(scope, on: :internal_tags)
      end
    end

    # @return [Hash]
    def build_filter_inputs
      self.class.arguments.keys.to_h do |key|
        [key.to_sym, public_send(key)]
      end.compact
    end

    class << self
      # Create a subclass of {Filtering::FilterScope} for the given model class
      # to inherit from.
      #
      # @param [Class<ActiveRecord::Base>] klass the model class to wrap around
      # @return [Class<Filtering::FilterScope>]
      def [](klass)
        Class.new(self).tap do |filter_scope|
          filter_scope.model_klass klass

          filter_scope.input_object_name "#{klass.model_name.to_s.gsub("::", "")}FilterInput"
        end
      end

      # @!attribute [r] input_object
      # @return [Class<GraphQL::Schema::InputObject>]
      def input_object
        @input_object ||= input_object_type_name.safe_constantize
      end

      # Resolvers reference the input object by name so that graphql-ruby loads it lazily.
      # Loading it eagerly can create a load-order cycle through its `loads:` arguments.
      #
      # @return [String]
      def input_object_type_name = "::Types::Filtering::#{collapsed_model_name}FilterInputType"

      # @see Resolvers::AbstractResolver.filters_with!
      # @return [Hash] options for the `filters` resolver argument
      def options_for_resolver
        {
          type: input_object_type_name,
          default: input_object_default_value,
          argument_options: {
            replace_null_with_default: true,
          },
          description: <<~TEXT
          Filters that **must** match.
          TEXT
        }
      end

      # @see Resolvers::AbstractResolver.filters_with!
      # @return [Hash] options for the `orFilters` resolver argument
      def options_for_or_resolver
        {
          type: "[#{input_object_type_name}!]",
          default: [],
          argument_options: {
            replace_null_with_default: true,
          },
          description: <<~TEXT
          An array of filters, at least one of which must match. This is intended more for debugging and introspection in the API,
          though a UI could be built.

          **Note**: If `filters` is also specified, at least one set of filters in `orFilters` must match, along with `filters`.
          TEXT
        }
      end

      # The model class name with any namespacing collapsed,
      # e.g. `Snapshots::User` => `SnapshotsUser`.
      #
      # GraphQL types are flat, so namespaced models map to collapsed input type names.
      #
      # @return [String]
      def collapsed_model_name = model_klass.name.gsub("::", "")

      # @param [Symbol] scope_name
      # @return [void]
      def uses_scope!(scope_name)
        uses_scopes! scope_name
      end

      # @param [<Symbol>] scope_names
      # @return [void]
      def uses_scopes!(*scope_names)
        new_scopes = scope_names.flatten.compact_blank.map { _1.to_sym }

        # simplecov:disable
        return if new_scopes.blank?
        # simplecov:enable

        merged_scopes = (required_scopes | new_scopes).sort

        required_scopes merged_scopes.freeze
      end
    end
  end
end
