# frozen_string_literal: true

module SubscriptionOptions
  # Unsubscribe a record from a specific kind with a given token.
  class TokenUnsubscriber < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :kind, Types::Selection

      param :token, Types::Token
    end

    standard_execution!

    # @return [SubscriptionOptions::Instance]
    attr_reader :instance

    # @return [HasSubscriptionOption]
    attr_reader :record

    # @return [Dry::Monads::Success(SubscriptionOptions::Instance)]
    def call
      run_callbacks :execute do
        yield find_record!

        yield find_instance!

        yield unsubscribe!
      end

      Success instance
    end

    wrapped_hook! def find_record
      @record = GlobalID::Locator.locate_signed(token, for: :unsubscribe, only: HasSubscriptionOption)

      return Failure[:record_not_found] if record.blank?

      super
    end

    wrapped_hook! def find_instance
      @instance = yield record.subscription_instance_for(kind)

      super
    end

    wrapped_hook! def unsubscribe
      yield instance.unsubscribe!

      super
    end
  end
end
