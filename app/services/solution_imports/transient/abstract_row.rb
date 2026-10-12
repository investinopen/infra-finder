# frozen_string_literal: true

module SolutionImports
  module Transient
    # @abstract
    class AbstractRow < Support::FlexibleStruct
      include Support::Typing

      attribute :identifier, Types::Identifier

      # @abstract
      # @return [Hash]
      def attrs_to_create
        # simplecov:disable
        raise NotImplementedError, "Subclasses must implement `attrs_to_create`"
        # simplecov:enable
      end
    end
  end
end
