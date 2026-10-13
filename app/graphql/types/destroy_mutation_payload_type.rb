# frozen_string_literal: true

module Types
  # An interface for mutation payloads that destroy a model.
  module DestroyMutationPayloadType
    include Types::BaseInterface

    description <<~TEXT
    An interface for mutations that destroy a database-backed record.

    They report on the `destroyedId` to allow updating client caches.
    TEXT

    implements ::Types::StandardMutationPayloadType

    field :destroyed, Boolean, null: true do
      description <<~TEXT
      Whether or not the model was successfully destroyed.

      If false, check `globalErrors` or `attributeErrors` for more information.
      TEXT
    end

    field :destroyed_id, ID, null: true do
      description <<~TEXT
      The ID of the deleted model.
      TEXT
    end
  end
end
