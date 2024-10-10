# frozen_string_literal: true

module SubscriptionOptions
  class Instance < Support::FlexibleStruct
    extend Support::DoFor

    include Dry::Core::Memoizable
    include Dry::Monads[:result]

    attribute :record, Types.Instance(::HasSubscriptionOption)

    attribute :mode, Types::InstanceMode

    attribute? :option, SubscriptionOptions::Definition::Type.optional

    delegate :hidden?, to: :option, allow_nil: true

    def all?
      mode == :all
    end

    memoize def i18n_description
      default = option.kind.to_s.humanize(capitalize: false) unless all?

      I18n.t("subscription_options.description.#{kind}", raise: true, default:)
    end

    memoize def kind
      all? ? :all : option.kind
    end

    # @return [Dry::Monads::Success(SubscriptionOptions::Instance)]
    def subscribe!
      call_action(:subscribe)
    end

    # @return [Dry::Monads::Success(SubscriptionOptions::Instance)]
    def unsubscribe!
      call_action(:unsubscribe)
    end

    memoize def unsubscribe_notice
      description = i18n_description

      identifier = record.subscription_identifier

      I18n.t("subscription_options.notice.unsubscribe", identifier:, description:, raise: true)
    end

    # @param [HasSubscriptionOption] record
    # @return [String]
    def unsubscribe_url
      token = record.unsubscribe_token

      Success InfraFinder::Container["system.routes"].unsubscribe_url(kind.to_s, token:)
    end

    private

    # @param [:subscribe, :unsubscribe] action
    # @return [Dry::Monads::Success(SubscriptionOptions::Instance)]
    do_for! def call_action(action)
      if all?
        record.each_subscription_option do |option|
          yield call_action_for(option, action)
        end
      else
        yield call_action_for(option, action)
      end

      Success self
    end

    # @param [SubscriptionOptions::Definition] option
    # @param [:subscribe, :unsubscribe] action
    # @return [Dry::Monads::Success(SubscriptionOptions::Instance)]
    def call_action_for(option, action)
      method_name = option.method_for action

      record.__send__(method_name)

      Success self
    end
  end
end
