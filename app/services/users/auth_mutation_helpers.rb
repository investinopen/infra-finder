# frozen_string_literal: true

module Users
  # Shared steps for the authentication mutations.
  module AuthMutationHelpers
    # Count an attempt against {Users::Throttle} and halt the mutation once
    # the limit is exceeded.
    #
    # @param [Symbol] action a key in {Users::Throttle::LIMITS}
    # @raise [VOGMutations::Halting::Invalid] when throttled
    # @return [void]
    def throttle!(action)
      return unless Users::Throttle.exceeded?(action, graphql_context[:request_ip])

      add_global_error! I18n.t("server_messages.auth.throttled"), type: "throttled"

      throw_invalid
    end

    # Resolve the rest of this request's fields as the given user, who has
    # just signed in.
    #
    # @param [User] user
    # @return [void]
    def act_as!(user)
      graphql_context[:current_user] = user

      Support::Requests::Current.current_user = user
    end
  end
end
