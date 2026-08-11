# frozen_string_literal: true

module Support
  module Generators
    module Types
      include Dry.Types

      extend Support::EnhancedTypes

      TypeName = Coercible::String.constrained(filled: true)

      TypeMapping = Constructor(ActiveSupport::HashWithIndifferentAccess) do |value|
        value.to_h.with_indifferent_access
      end
    end
  end
end
