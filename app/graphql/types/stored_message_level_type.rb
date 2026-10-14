# frozen_string_literal: true

module Types
  # @see StoredMessages::Message#level
  class StoredMessageLevelType < Types::BaseEnum
    description <<~TEXT
    The severity of a `StoredMessage`.
    TEXT

    value "DEBUG", value: "debug" do
      description "Debugging detail."
    end

    value "INFO", value: "info" do
      description "Information."
    end

    value "WARN", value: "warn" do
      description "A warning."
    end

    value "ERROR", value: "error" do
      description "An error."
    end

    value "FATAL", value: "fatal" do
      description "A fatal error."
    end

    value "UNKNOWN", value: "unknown" do
      description "An unknown severity."
    end
  end
end
