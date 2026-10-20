# frozen_string_literal: true

module Users
  # Service object representing upload access for a user.
  #
  # @see Types::UploadAccessType
  # @see Users::UploadAccessPolicy
  class UploadAccess
    include Dry::Initializer[undefined: false].define -> do
      param :user, ::Users::Types::Current, default: ::Users::Types::DEFAULT

      option :session_id, ::Users::Types::String.optional, default: proc {}
    end

    delegate :policy_class, to: :class

    # @return [String, nil]
    def token
      user.upload_token(session_id:) if user.has_any_upload_access?
    end

    class << self
      # @see Users::UploadAccessPolicy
      # @return [Class] the policy class for this service object
      def policy_class = ::Users::UploadAccessPolicy
    end
  end
end
