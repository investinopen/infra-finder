# frozen_string_literal: true

module Comparisons
  module Sharing
    class Context < Support::HookBased::Actor
      include Dry::Core::Memoizable
      include Support::Typing
      include Dry::Initializer[undefined: false].define -> do
        option :search_filters, Types::SearchFilters, default: proc { {}.freeze }, as: :raw_search_filters
        option :solution_ids, Types::SolutionIDs, default: proc { [] }, as: :raw_solution_ids
      end

      include InfraFinder::Deps[
        prune_search_filters: "comparisons.sharing.prune_search_filters",
      ]

      # @return [Hash]
      attr_reader :search_filters

      # @return [<String>]
      attr_reader :solution_ids

      def initialize(...)
        super

        @search_filters = prune_search_filters.(raw_search_filters)
        @solution_ids = raw_solution_ids.take(4)
      end

      def nothing_to_share?
        solution_ids.blank? && search_filters.blank?
      end

      # @!attribute [r] fingerprint
      # @return [String, nil]
      memoize def fingerprint
        return nil if nothing_to_share?

        digest = Digest::SHA256.new

        digestable_values.each do |value|
          digest.update value
        end

        digest.hexdigest
      end

      private

      # @return [Enumerator<String>]
      def digestable_values
        filter_size = search_filters.size * 2

        id_size = solution_ids.size

        size = 2 + id_size + filter_size

        Enumerator.new size do |y|
          y << "solution_ids"

          solution_ids.each do |id|
            y << id
          end

          y << "search_filters"

          search_filters.each do |key, value|
            y << key
            y << value.to_json
          end
        end
      end
    end
  end
end
