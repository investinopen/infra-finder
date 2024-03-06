# frozen_string_literal: true

module Seeding
  class ImportLegacySolutions
    include Dry::Monads[:result, :do]
    include MonadicPersistence

    LEGACY_PATH = Rails.root.join("vendor", "legacy-solutions.csv")

    def call
      import = yield build_import

      yield import.process

      import.current_state(force_reload: true)

      Success import.reload
    end

    private

    def build_import
      import = SolutionImport.new(strategy: :legacy)

      import.source = LEGACY_PATH.open("r+")

      import.skip_process = true

      import.options.auto_approve = true

      monadic_save import
    end
  end
end
