# frozen_string_literal: true

module Users
  # The policy governing access to upload features.
  #
  # @see Users::UploadAccess
  # @see Types::UploadAccessType
  class UploadAccessPolicy < ApplicationPolicy
    # @return [Boolean]
    def upload?
      user.try(:has_any_upload_access?).present?
    end
  end
end
