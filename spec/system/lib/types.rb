# frozen_string_literal: true

module Testing
  module Types
    include Dry.Types

    AnyUser = ::Users::Types::Authenticated

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
