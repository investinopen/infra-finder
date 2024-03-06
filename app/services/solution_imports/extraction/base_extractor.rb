# frozen_string_literal: true

module SolutionImports
  module Extraction
    # @abstract
    class BaseExtractor < SolutionImports::Subprocessor
      def perform
        case strategy
        in "legacy"
          yield legacy_extract!

          super
        in "modern"
          # :nocov:
          Failure[:unsupported_strategy, strategy]
          # :nocov:
        end
      end

      wrapped_hook! :legacy_extract
    end
  end
end
