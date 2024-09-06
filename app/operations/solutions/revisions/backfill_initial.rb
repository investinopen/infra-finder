# frozen_string_literal: true

module Solutions
  module Revisions
    # Ensure solutions with missing initial revisions have them for comparison.
    class BackfillInitial
      include Dry::Monads[:result, :do]

      # @return [Dry::Monads::Success(void)]
      def call
        Solution.sans_initial_revision.find_each do |solution|
          yield solution.initialize_revision(reason: "Backfilling initial revision for existing solutions.")
        end

        Success()
      end
    end
  end
end
