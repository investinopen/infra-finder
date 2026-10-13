# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::UserSignIn
    class UserSignIn < VOGMutations::Implementation
      include Users::AuthMutationHelpers
      include Common::Deps[
        issue_token: "users.tokens.issue",
      ]

      use_contract! :user_sign_in

      # @param [String] email
      # @param [String] password
      # @return [void]
      def call(email:, password:)
        throttle! :sign_in

        user = User.find_for_authentication(email:)

        password_matched = check_password(user, password)

        return refuse!(user, password_matched) unless password_matched && Users::Access.allowed?(user)

        user.update_tracked_fields!(TrackedRequest.new(graphql_context[:request_ip]))

        viewer_token = check_result!(issue_token.(user))

        act_as!(user)

        attach! :viewer_token, viewer_token
        attach! :user, user
      end

      private

      # Every attempt costs exactly one password hash, whether or not the
      # account exists, so response timing does not reveal registered emails.
      # Lockable counts a failed attempt for an existing account.
      #
      # @param [User, nil] user
      # @param [String] password
      # @return [Boolean]
      def check_password(user, password)
        if user.nil?
          Devise::Encryptor.digest(User, password)

          return false
        end

        matched = false

        user.valid_for_authentication? { matched = user.valid_password?(password) }

        matched
      end

      # Account state (locked, unconfirmed, no access) is only revealed after
      # a correct password, matching Devise.
      #
      # @param [User, nil] user
      # @param [Boolean] password_matched
      # @return [void]
      def refuse!(user, password_matched)
        key =
          if !password_matched
            :invalid
          elsif user.access_locked?
            :locked
          elsif !user.confirmed?
            :unconfirmed
          else
            :no_access
          end

        add_global_error! refusal_message(key), type: key.to_s
      end

      # @param [Symbol] key
      # @return [String]
      def refusal_message(key)
        case key
        when :no_access then I18n.t("server_messages.tokens.inactive")
        else
          I18n.t(key, scope: "devise.failure", authentication_keys: "email")
        end
      end

      # Devise's trackable only reads `remote_ip` from the request.
      TrackedRequest = Data.define(:remote_ip)
    end
  end
end
