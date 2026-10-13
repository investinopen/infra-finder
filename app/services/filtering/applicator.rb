# frozen_string_literal: true

module Filtering
  # Applies a set of filters to a top-level ActiveRecord scope using the {Filtering} subsystem.
  class Applicator
    include Dry::Core::Equalizer.new(:filters)

    include Dry::Initializer[undefined: false].define -> do
      param :filters, Types::Filters
    end

    # @param [ActiveRecord::Relation] top_level_scope
    # @return [ActiveRecord::Relation]
    def call(top_level_scope)
      filtered = top_level_scope.where(primary_key_condition(top_level_scope))

      filters.apply_ranking_to filtered
    end

    # @api private
    # @return [ActiveRecord::Relation]
    def filtered_scope
      @filtered_scope ||= filters.call
    end

    private

    # Builds the primary key membership condition, supporting both single-column
    # and composite primary keys.
    #
    # @param [ActiveRecord::Relation] top_level_scope
    # @return [Hash, Arel::Nodes::In]
    def primary_key_condition(top_level_scope)
      keys = Array(top_level_scope.primary_key)

      return { keys.first => filtered_scope } if keys.one?

      columns = keys.map { |key| top_level_scope.arel_table[key] }

      Arel::Nodes::In.new(
        Arel::Nodes::Grouping.new(columns),
        filtered_scope.select(*keys).arel
      )
    end
  end
end
