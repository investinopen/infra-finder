# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::MutateUser
    class MutateUser < VOGMutations::Contract
      json do
        optional(:email).filled(:string)
        optional(:name).filled(:string)
        optional(:admin).filled(:bool)
        optional(:super_admin).filled(:bool)
        optional(:password).filled(:string)
        optional(:password_confirmation).filled(:string)
        optional(:comment_notifications).filled(:string)
        optional(:solution_notifications).filled(:string)
      end

      rule(:password_confirmation, :password) do
        key.failure(:must_match_password) if key?(:password) && values[:password] != values[:password_confirmation]
      end
    end
  end
end
