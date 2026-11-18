# frozen_string_literal: true

module Support
  module Requests
    module ReadsCurrentUser
      extend ActiveSupport::Concern

      # @return [User, nil]
      def current_authenticated_user = current_user.then { _1 if _1.authenticated? }

      # @return [AnonymousUser, User]
      def current_user
        Support::Requests::Current.current_user
      end
    end
  end
end
