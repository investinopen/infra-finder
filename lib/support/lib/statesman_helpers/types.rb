# frozen_string_literal: true

module Support
  module StatesmanHelpers
    module Types
      include Dry.Types

      extend Support::EnhancedTypes

      AssociationName = Coercible::Symbol

      MachineClass = Implements(::Statesman::Machine)

      Predicates = Value(:ALL) | Array.of(Coercible::Symbol)

      ModelClass = ::Support::Models::Types::ModelClass

      TransitionClass = ModelClass
    end
  end
end
