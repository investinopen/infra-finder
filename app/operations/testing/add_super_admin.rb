# frozen_string_literal: true

module Testing
  class AddSuperAdmin
    include Dry::Monads[:result, :do]

    include InfraFinder::Deps[
      create_user: "users.create",
    ]

    def call(email, name)
      user = yield create_user.(email, name, super_admin: true, skip_confirmation: true)

      warn "Created user with email: #{email.inspect}"
      warn "Password: #{user.password.inspect}"

      Success user
    end
  end
end
