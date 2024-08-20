# frozen_string_literal: true

module Testing
  class SeedTestSolutions
    include Dry::Monads[:result, :do]

    include MonadicPersistence

    V2_DUMP = Rails.root.join("spec", "data", "imports", "v2-valid.csv")

    def call
      import = SolutionImport.new(
        strategy: :v2,
        source: V2_DUMP.open("rb+"),
        options: {
          auto_approve: true
        }
      )

      import.skip_process = true

      yield monadic_save import

      yield import.process

      Solution.unpublished.each(&:published!)

      Success import
    end
  end
end
