# frozen_string_literal: true

module Comparisons
  module Filtering
    # We have some very bespoke logic for how the different filters are grouped together.
    #
    # Take a flat hash and recombine it into the correct structure so that Ransack will
    # AND/OR where necessary.
    #
    # @api private
    class RansackBuilder < Support::HookBased::Actor
      include Dry::Core::Memoizable
      include Dry::Initializer[undefined: false].define -> do
        option :scope, Types::SolutionRelation, default: proc { Solution.all }
        option :filters, Types::GroupedSearchFilters, default: proc { {} }
      end

      standard_execution!

      # @return [Hash]
      attr_reader :search_params

      # @return [Ransack::Search]
      attr_reader :search

      # @return [Dry::Monads::Success(Ransack::Search<Solution>)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield apply_or_conditions!

          yield apply_categories!

          yield finalize!
        end

        Success search
      end

      wrapped_hook! def prepare
        @search_params = has_filters_for?(:global) ? filters_for!(:global) : {}
      end

      wrapped_hook! def apply_or_conditions
        conds = [].tap do |inner|
          inner << ransack_grouping(:technical_attribute)
          inner << ransack_grouping(:community_engagement, m: "or")
          inner << ransack_grouping(:policy, m: "or")
        end.compact

        or_conditions = { g: conds, m: "or" } if conds.any?

        add_final_grouping!(or_conditions)

        super
      end

      wrapped_hook! def apply_categories
        add_final_grouping! ransack_grouping(:solution_category)

        super
      end

      wrapped_hook! def finalize
        @search = scope.ransack(@search_params)

        # apply default sort
        search.sorts = [Comparisons::SearchFilters::DEFAULT_SORT] if search.sorts.empty?

        super
      end

      before_finalize :add_combinator_to_final!, if: :search_params_has_groupings?

      private

      # @return [void]
      def add_combinator_to_final!
        search_params[:m] = "and"
      end

      # @param [Hash, nil] grouping
      # @return [void]
      def add_final_grouping!(grouping)
        return if grouping.blank?

        search_params[:g] ||= []

        search_params[:g] << grouping
      end

      def filters_for!(key)
        key = Comparisons::Types::SearchFilterGrouping[key]

        filters[key].presence
      end

      def search_params_has_groupings?
        search_params[:g].present?
      end

      def has_filters_for?(key)
        key = Comparisons::Types::SearchFilterGrouping[key]

        filters[key].present?
      end

      # @return [Hash]
      def ransack_grouping(key, m: "and")
        attrs = filters_for!(key)

        return attrs.merge(m:) if attrs.present?
      end
    end
  end
end
