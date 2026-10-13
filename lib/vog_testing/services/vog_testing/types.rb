# frozen_string_literal: true

module VOGTesting
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    AnyUser = Any

    Callable = Interface(:call)

    CamelizedErrorPath = Dry::Types["string"].constructor do |value|
      case value
      when Symbol then value.to_s.camelize(:lower)
      else
        value
      end
    end

    StringList = Array.of(String.constrained(rails_present: true))

    SymbolMap = Hash.map(Symbol, Any)
  end
end
