# frozen_string_literal: true

module StoredMessages
  class Logger < ::Logger
    # @return [StoredMessages::LogDevice]
    attr_reader :device

    # @return [HasStoredMessages]
    attr_reader :record

    delegate :persist!, to: :device

    # @param [HasStoredMessages] record
    def initialize(record)
      @record = record
      @device = StoredMessages::LogDevice.new(record)

      super(device)

      self.formatter = StoredMessages::Formatter.new
    end

    # @param [<String>] tags
    # @return [void]
    def tagged(*tags)
      # :nocov:
      raise "Must be called with a block" unless block_given?
      # :nocov:

      formatter.tagged(*tags) do
        yield self
      end
    end
  end
end
