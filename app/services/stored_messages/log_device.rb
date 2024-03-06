# frozen_string_literal: true

module StoredMessages
  # A custom IO-like device that is used by {StoredMessages::Logger}.
  #
  # @api private
  class LogDevice
    include Dry::Initializer[undefined: false].define -> do
      param :record, Types::Record
    end

    # @!group Custom Log Device Methods

    # @param [StoredMessages::Message] message
    # @return [void]
    def write(message)
      record.messages = [message, *record.messages]
    end

    # @return [void]
    def close; end

    # @!endgroup

    # @return [void]
    def persist!
      record.update_column(:messages, record.messages)
    end
  end
end
