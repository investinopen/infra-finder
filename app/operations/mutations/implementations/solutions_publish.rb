# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::SolutionsPublish
    class SolutionsPublish < VOGMutations::Implementation
      use_contract! :solutions_publish

      authorizes! :solutions, with: :publish_all?

      # Incomplete solutions are skipped, with an error for each one.
      #
      # @param [<Solution>] solutions
      # @return [void]
      def call(solutions:)
        ::Solution.where(id: solutions.map(&:id)).publish_all! do |solution|
          add_global_error! "Could not publish #{solution.name}: #{solution.errors.full_messages.to_sentence}", type: "$model_error"
        end

        graphql_response.preserve! :solutions

        attach! :solutions, solutions.each(&:reload)
      end
    end
  end
end
