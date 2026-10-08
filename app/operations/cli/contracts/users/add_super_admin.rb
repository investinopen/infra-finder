# frozen_string_literal: true

module CLI
  module Contracts
    module Users
      class AddSuperAdmin < ::ApplicationContract
        params do
          required(:email).filled(:string) { email? }
          required(:name).filled(:string)
        end

        rule(:email) do
          key.failure("is already taken") if User.exists?(email: value)
        end
      end
    end
  end
end
