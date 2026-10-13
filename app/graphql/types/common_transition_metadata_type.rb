# frozen_string_literal: true

module Types
  module CommonTransitionMetadataType
    include Types::BaseInterface

    description <<~TEXT
    An interface for metadata associated with a state transition. This can include information such as a note explaining the reason for the transition.
    TEXT

    field :note, String do
      description <<~TEXT
      A note explaining the reason for the transition. This is stored as part of the transition metadata.
      TEXT
    end
  end
end
