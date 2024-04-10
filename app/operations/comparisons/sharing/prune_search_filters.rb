# frozen_string_literal: true

module Comparisons
  module Sharing
    class PruneSearchFilters < Dry::Transformer::Pipe
      import Dry::Transformer::HashTransformations
      import Dry::Transformer::Recursion

      define! do
        deep_stringify_keys

        map_values ->(value) do
          case value
          when "true" then true
          when "false" then nil
          when Array then value.compact_blank.presence
          else
            value
          end
        end

        # Prune out any blank enumerables
        recursion -> { _1.compact_blank }

        # Sort by hash key for consistent shapes
        hash_recursion ->(h) { h.keys.sort.index_with { |k| h[k] } }
      end
    end
  end
end
