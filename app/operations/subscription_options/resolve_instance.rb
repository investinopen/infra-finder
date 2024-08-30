# frozen_string_literal: true

module SubscriptionOptions
  class ResolveInstance
    include Dry::Monads[:result]

    # @param [HasSubscriptionOption] record
    # @param [#to_sym] kind
    # @return [Dry::Monads::Success(SubscriptionOptions::Instance)]
    # @return [Dry::Monads::Failure(:unknown_subscription_option, #to_sym)]
    def call(record, raw_kind)
      case raw_kind
      in SubscriptionOptions::Types::All
        resolve_all(record)
      in SubscriptionOptions::Types::Column => kind
        resolve_option(record, kind)
      else
        Failure[:unknown_subscription_option, raw_kind]
      end
    end

    private

    # @param [HasSubscriptionOption] record
    # @return [Dry::Monads::Success(SubscriptionOptions::Instance)]
    def resolve_all(record)
      resolve_instance(record, mode: :all)
    end

    # @param [HasSubscriptionOption] record
    # @return [Dry::Monads::Success(SubscriptionOptions::Instance)]
    # @return [Dry::Monads::Failure(:unknown_subscription_option, #to_sym)]
    def resolve_option(record, kind)
      option = record.subscription_option_for(kind)
    rescue KeyError
      Failure[:unknown_subscription_option, kind]
    else
      resolve_instance(record, mode: :option, option:)
    end

    # @param [HasSubscriptionOption] record
    # @param [:all, :option] mode
    # @param [SubscriptionOptions::Definition, nil] option
    # @return [Dry::Monads::Success(SubscriptionOptions::Instance)]
    def resolve_instance(record, mode:, option: nil)
      instance = SubscriptionOptions::Instance.new(record:, mode:, option:)

      Success instance
    end
  end
end
