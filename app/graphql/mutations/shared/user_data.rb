# frozen_string_literal: true

module Mutations
  module Shared
    class UserData < VOGMutations::Arguments::SharedSet
      argument :email, String, required: false do
        description <<~TEXT
        The user's email address.
        TEXT
      end

      argument :name, String, required: false do
        description <<~TEXT
        The user's display name.
        TEXT
      end

      argument :password, String, required: false do
        description <<~TEXT
        A new password. Changing it signs the user out of the API everywhere.
        TEXT
      end

      argument :password_confirmation, String, required: false do
        description <<~TEXT
        Must match `password` when it is provided.
        TEXT
      end
    end
  end
end
