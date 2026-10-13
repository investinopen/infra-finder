# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {ProviderEditorAssignment} with {::Types::ProviderEditorAssignmentOrderType}.
  module OrderedAsProviderEditorAssignment
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::ProviderEditorAssignmentOrderType, default: "DEFAULT"
    end
  end
end
