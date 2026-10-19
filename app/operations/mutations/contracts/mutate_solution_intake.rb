# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::MutateSolutionIntake
    class MutateSolutionIntake < VOGMutations::Contract
      json do
        optional(:provider).maybe(:provider)
      end

      # Only admins assign an intake to a provider.
      rule(:provider) do
        key.failure(:must_be_set_by_an_admin) if key? && !current_user.has_any_admin_access?
      end
    end
  end
end
