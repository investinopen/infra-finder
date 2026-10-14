# frozen_string_literal: true

module Types
  # @see StoredMessages::Message
  class StoredMessageType < Types::BaseObject
    description <<~TEXT
    A log message recorded while processing something, such as a `SolutionImport`.
    TEXT

    field :at, GraphQL::Types::ISO8601DateTime, null: false do
      description "When the message was recorded."
    end

    field :level, ::Types::StoredMessageLevelType, null: false do
      description "The message's severity."
    end

    field :message, String, null: true do
      description "The message."
    end

    field :step, String, null: true do
      description "The step of processing that recorded the message."
    end

    field :tags, [String, { null: false }], null: false do
      description "Tags for the message."
    end

    # @return [String]
    def level = object.level.to_s
  end
end
