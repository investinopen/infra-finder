# frozen_string_literal: true

module Implementations
  # The type registry used by {Implementation}.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :enum_type, Implementations::Types::EnumType
    tc.add! :implementation_name, Implementations::Types::Name
  end
end
