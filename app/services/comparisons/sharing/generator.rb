# frozen_string_literal: true

module Comparisons
  module Sharing
    # @see Comparisons::Sharing::Generate
    class Generator < ::Support::HookBased::Actor
      include MonadicPersistence
      include Dry::Initializer[undefined: false].define -> do
        option :search_filters, Types::SearchFilters, default: proc { {}.freeze }
        option :solution_ids, Types::SolutionIDs, default: proc { [] }
        option :mark_as_shared, Types::Bool, default: proc { false }
      end

      standard_execution!

      # @return [ComparisonShare]
      attr_reader :comparison_share

      # @return [Comparisons::Sharing::Context]
      attr_reader :context

      # @return [String, nil] fingerprint
      attr_reader :fingerprint

      def call
        run_callbacks :execute do
          yield prepare!

          yield generate!
        end

        comparison_share.touch(:shared_at) if mark_as_shared

        Success comparison_share
      end

      wrapped_hook! def prepare
        @context = Comparisons::Sharing::Context.new(search_filters:, solution_ids:)

        return Failure[:nothing_to_share] if context.nothing_to_share?

        @fingerprint = context.fingerprint

        super
      end

      wrapped_hook! def generate
        @comparison_share = ComparisonShare.where(fingerprint:).first_or_initialize

        return Success(@comparison_share) if @comparison_share.persisted?

        @comparison_share.search_filters = context.search_filters

        yield monadic_save @comparison_share

        @comparison_share.solutions = Solution.find(context.solution_ids) if solution_ids.any?

        super
      end
    end
  end
end
