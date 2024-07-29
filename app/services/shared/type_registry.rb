# frozen_string_literal: true

module Shared
  # The shared type registry used by {ApplicationContract}.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :solution_kind, Solutions::Types::Kind
  end
end
