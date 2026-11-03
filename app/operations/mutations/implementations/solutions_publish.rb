# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionsPublish
    class SolutionsPublish < VOGMutations::Implementation
      use_contract! :solutions_publish

      authorizes! :solutions, with: :publish_all?

      # Incomplete or invalid solutions are skipped and reported, which doesn't fail the mutation.
      #
      # @param [<Solution>] solutions
      # @return [void]
      def call(solutions:)
        skipped = []

        ::Solution.where(id: solutions.map(&:id)).publish_all! do |solution|
          skipped << { solution:, errors: errors_for(solution) }
        end

        attach! :skipped, skipped

        attach! :solutions, solutions.each(&:reload)
      end

      private

      # Paths come from the arguments that edit a solution, as in its other mutation errors.
      #
      # @param [Solution] solution
      # @return [<{ Symbol => Object }>]
      def errors_for(solution)
        compiler = ::Mutations::MutateSolution.argument_set.error_compiler

        compiled = solution.errors.map do |error|
          compiler.model_error(error) || compiler.global(error.full_message, code: "$model_error")
        end

        compiled.group_by(&:attribute_error_key).map do |(path, type), errors|
          { path:, type:, messages: errors.map(&:message).uniq }
        end
      end
    end
  end
end
