# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {Provider} with {::Types::ProviderOrderType}.
  module OrderedAsProvider
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::ProviderOrderType, default: "DEFAULT"
    end
  end
end
