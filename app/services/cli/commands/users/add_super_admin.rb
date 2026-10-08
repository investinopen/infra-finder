# frozen_string_literal: true

module CLI
  module Commands
    module Users
      class AddSuperAdmin < ::CLI::Commands::AbstractCommand
        desc "Add a super admin"

        argument :email, required: true, type: :string, desc: "Email address of the super admin"

        argument :name, required: true, type: :string, desc: "Name of the super admin"

        option :print_password, type: :boolean, default: true, desc: "Print the password of the super admin"

        uses_contract!

        def perform!(email:, name:, print_password:, **)
          result = call_operation("users.create", email, name, super_admin: true, skip_confirmation: true)

          case result
          in Success(User => user)
            puts "Super Admin #{user.name.inspect} <#{user.email}> added successfully"

            if print_password
              puts "Password: #{user.password.inspect}"
            end
          in Failure(:invalid, _, errors)
            puts "Failed to add super admin: #{errors.join(', ')}"
          else
            puts "An unexpected error occurred while adding the super admin"
          end
        end
      end
    end
  end
end
