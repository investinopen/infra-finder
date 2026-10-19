# frozen_string_literal: true

module Types
  # An enum describing where a file attachment is stored.
  class AttachmentStorageType < Types::BaseEnum
    description <<~TEXT
    This describes where a given file attachment is stored (if at all).
    TEXT

    value "STORE", value: :store do
      description <<~TEXT
      STORE refers to permanent storage. An asset here has been fully processed and is ready for access.
      TEXT
    end

    value "CACHE", value: :cache do
      description <<~TEXT
      CACHE refers to temporary storage. When a file is first uploaded to the system, it lives in cache and needs to be processed.
      A user could potentially fetch something from an API while a file is still being processed in the background, and if so, none
      of its derivatives will be present yet.
      TEXT
    end

    value "REMOTE", value: :remote do
      description <<~TEXT
      Remote URL storage. Only used internally at present, but may sometimes appear during certain events.
      TEXT
    end
  end
end
