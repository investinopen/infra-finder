# frozen_string_literal: true

module Events
  module Named
    extend ActiveSupport::Concern

    included do
      extend Dry::Core::ClassAttributes

      defines :event_name, type: Events::Types::EventName

      event_name "unknown.event"
    end

    # @return [Events::Types::EventName]
    def event_name = self.class.event_name
  end
end
