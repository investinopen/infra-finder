# frozen_string_literal: true

module Resolvers
  module Enhancements
    # An enhancement to a resolver that returns the first matching item instead of a list.
    module FirstMatching
      extend ActiveSupport::Concern

      included do
        # simplecov:disable
        extension Resolvers::Enhancements::FirstMatching::Extension, resolver: self
        # simplecov:enable
      end

      # The GraphQL field extension that supports {FirstMatching}.
      #
      # @api private
      class Extension < GraphQL::Schema::FieldExtension
        # @param [ActiveRecord::Relation, #first] value
        def after_resolve(value:, **) = value.first
      end
    end
  end
end
