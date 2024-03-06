# frozen_string_literal: true

# A concern that enables a model to have a custom logger that
# stores an array of JSON-encoded messages that can be displayed
# in the frontend, or eventually subscribed to.
module HasStoredMessages
  extend ActiveSupport::Concern

  included do
    attribute :messages, StoredMessages::Message.to_array_type, default: proc { [] }
  end

  # @return [StoredMessages::Logger]
  def message_logger
    StoredMessages::Logger.new(self)
  end
end
