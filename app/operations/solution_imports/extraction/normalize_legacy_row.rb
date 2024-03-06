# frozen_string_literal: true

module SolutionImports
  module Extraction
    class NormalizeLegacyRow < Dry::Transformer::Pipe
      include SolutionImports::Legacy::Headers

      import Dry::Transformer::HashTransformations

      PRUNE_NULL = ->(val) { val unless val == "NULL" }

      define! do
        symbolize_keys

        accept_keys LEGACY_HEADERS

        reject_keys SKIPPED_HEADERS

        map_values PRUNE_NULL
      end
    end
  end
end
