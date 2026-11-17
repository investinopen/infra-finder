# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ViewerUpdate
    # @see Mutations::Implementations::ViewerUpdate
    class ViewerUpdate < VOGMutations::Contract
      json do
        optional(:email).filled(:string)
        optional(:name).filled(:string)
        optional(:password).maybe(:string) { str? > filled? }
        optional(:password_confirmation).maybe(:string) { str? > filled? }
        optional(:current_password).maybe(:string) { str? > filled? }

        required(:privileged_data_change).value(:user_privileged_data_change)
      end

      rule(:password_confirmation) do
        key.failure(:must_match_password) if key?(:password) && values[:password].present? && values[:password] != values[:password_confirmation]
      end

      rule(:privileged_data_change) do
        base.failure(:current_password_required) unless value.allowed?
      end
    end
  end
end
