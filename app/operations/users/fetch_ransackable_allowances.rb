# frozen_string_literal: true

module Users
  class FetchRansackableAllowances
    extend Dry::Core::Cache
    include Dry::Monads[:result]

    # @param [User] user
    # @return [Dry::Monads::Success<ExposesRansackable::Types::Allowance>]
    def call(user)
      allowances = fetch_or_store user.kind do
        %i[any].tap do |arr|
          arr << :super_admin if user.super_admin?
          arr << :admin if user.has_any_admin_access?
          arr << :editor if user.has_any_admin_or_editor_access?
        end
      end

      Success allowances
    end
  end
end
