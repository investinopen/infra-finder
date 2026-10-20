# frozen_string_literal: true

module OAuth
  # The authorization endpoint. Signed-in users without admin or editor access
  # are sent back to the client with `access_denied`, so the client can
  # explain why, and keep their sign-in session.
  class AuthorizationsController < Doorkeeper::AuthorizationsController
    before_action :deny_without_access!

    private

    # @return [void]
    def deny_without_access!
      return if Users::Access.allowed?(current_resource_owner)

      return render_error unless pre_auth.authorizable?

      redirect_or_render(authorization.deny)
    end
  end
end
