# frozen_string_literal: true

module Types
  # @see ImageAttachments::Types::Purpose
  class ImagePurposeType < Types::BaseEnum
    description <<~TEXT
    Image attachments can fulfill different purposes. This can
    be used to distinguish them at the `ImageAttachment` level.
    TEXT

    value "LOGO", value: "logo" do
      description "A logo."
    end

    value "OTHER", value: "other" do
      description "A fallback for otherwise-unspecified images."
    end
  end
end
