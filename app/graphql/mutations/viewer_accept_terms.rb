# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ViewerAcceptTerms
  class ViewerAcceptTerms < Mutations::BaseMutation
    description <<~TEXT
    Accept the terms and conditions. Until they do, editors can only query
    themselves and call this mutation.
    TEXT

    field :user, Types::UserType, null: true do
      description "The viewer, after accepting the terms."
    end

    argument :accept_terms_and_conditions, Boolean, required: true do
      description "Must be true."
    end

    performs_operation! "mutations.implementations.viewer_accept_terms"
  end
end
