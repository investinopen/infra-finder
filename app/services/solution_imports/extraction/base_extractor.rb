# frozen_string_literal: true

module SolutionImports
  module Extraction
    # @abstract
    class BaseExtractor < SolutionImports::Subprocessor
      def perform
        Failure[:unsupported_strategy, strategy]
      end

      wrapped_hook! :legacy_extract
    end
  end
end
