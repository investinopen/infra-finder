# frozen_string_literal: true

module SolutionImports
  module Persistence
    # @abstract
    class BasePersister < SolutionImports::Subprocessor
      include Dry::Effects.State(:providers_count)
      include Dry::Effects.State(:solutions_count)

      # @param [SolutionImportable] importable
      # @return [void]
      def count_import_of!(importable)
        case importable
        in Provider
          self.providers_count += 1
        in Solution
          self.solutions_count += 1
        else
          # :nocov:
          # intentionally left blank
          # :nocov:
        end
      end

      # @param [SolutionImportable] importable
      # @return [void]
      def track_import_of!(importable)
        importable.add_imported_tag!

        count_import_of! importable

        Success()
      end
    end
  end
end
