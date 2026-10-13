# frozen_string_literal: true

module Shared
  # The shared type registry used by {ApplicationContract}.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :filter_scope, ::Filtering::Types::Filters

    tc.add! :identifier, ::Support::GlobalTypes::Slug

    tc.add! :solution_kind, Solutions::Types::Kind
  end
end
