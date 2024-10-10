# frozen_string_literal: true

module SubscriptionOptions
  class Definition
    include Dry::Core::Equalizer.new(:kind)
    include Dry::Core::Memoizable
    include Support::Typing

    map_type! key: Types::Column

    include Dry::Initializer[undefined: false].define -> do
      param :kind, Types::Kind

      option :hidden, Types::Bool, default: proc { false }

      option :timestamp, Types::Column, default: proc { :"#{kind}_updated_at" }

      option :suffix, Types::Column, default: proc { :"to_#{kind}" }
    end

    alias hidden? hidden

    def enum_options
      {
        as: :subscription,
        default: :unsubscribed,
        allow_blank: false,
        suffix:,
      }
    end

    # @api private
    # @param [{ Symbol => SubscriptionOptions::Definition }] existing
    # @return [{ Symbol => SubscriptionOptions::Definition }]
    def merge_into(**existing)
      self.class::Map[existing.merge(kind => self)].freeze
    end

    # @param [:subscribe, :unsubscribe] action
    # @return [Symbol]
    def method_for(action)
      case action
      in :subscribe
        subscribe_method
      in :unsubscribe
        unsubscribe_method
      end
    end

    memoize def subscribe_method
      :"subscribed_#{suffix}!"
    end

    memoize def unsubscribe_method
      :"unsubscribed_#{suffix}!"
    end
  end
end
