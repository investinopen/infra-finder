# frozen_string_literal: true

module Types
  # @abstract For input objects that represent filtering options.
  # @see Filtering::FilterScope
  class FilterScopeInputObject < Types::BaseInputObject
    # @return [Filtering::FilterScope, nil]
    def prepare
      options = to_h.symbolize_keys.compact.presence

      # simplecov:disable
      return nil if options.nil?
      # simplecov:enable

      self.class.filter_scope.new(**options)
    end

    class << self
      # @return [Class(Filtering::FilterScope)]
      attr_reader :filter_scope

      # @param [Class(Filtering::FilterScope)] filter_scope
      # @return [void]
      def inherit_from!(filter_scope)
        @filter_scope = filter_scope
      end
    end
  end
end
