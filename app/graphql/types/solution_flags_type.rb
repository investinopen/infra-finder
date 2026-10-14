# frozen_string_literal: true

module Types
  # @see Solutions::Flags
  class SolutionFlagsType < Types::BaseObject
    description <<~TEXT
    Characteristics derived from a `Solution`'s properties.
    TEXT

    field :oss, Boolean, null: false do
      description "Whether the solution is open source software."
    end

    field :open_access_content, Boolean, null: false do
      description "Whether the solution's content is open access."
    end

    field :free_to_use, Boolean, null: false do
      description "Whether the solution is free to use."
    end

    field :transparent_governance, Boolean, null: false do
      description "Whether the solution's governance is transparent."
    end

    field :nonprofit_operated, Boolean, null: false do
      description "Whether a nonprofit operates the solution."
    end
  end
end
