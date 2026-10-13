# frozen_string_literal: true

module Types
  # An interface for objects that expose {Types::SlugType}.
  #
  # @see HasEphemeralSystemSlug
  module SluggableType
    include BaseInterface

    description <<~TEXT
    Objects have an encoded slug for looking them up in the system and generating links without UUIDs
    TEXT

    field :slug, Types::SlugType, null: false do
      description "The encoded slug of the object."
    end

    # @return [String] The value to use for the slug field.
    def slug
      object.id
    end
  end
end
