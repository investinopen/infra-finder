# frozen_string_literal: true

module HasSubscriptionOption
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  included do
    extend Dry::Core::ClassAttributes

    defines :subscription_identifier_method, type: SubscriptionOptions::Types::Symbol.optional
    defines :subscription_options, type: SubscriptionOptions::Definition::Map

    subscription_identifier_method nil

    subscription_options({}.freeze)

    has_many :subscriptions, as: :subscribable, dependent: :destroy

    delegate :subscription_option_for, to: :class

    before_validation :maybe_update_subscription_timestamps!

    after_save :sync_subscription_state!
  end

  def each_subscription_option
    # :nocov:
    return enum_for(__method__) unless block_given?
    # :nocov:

    subscription_options.values.each do |option|
      yield option
    end
  end

  def has_subscription_identifier?
    self.class.subscription_identifier_method.then { _1.present? && respond_to?(_1) }
  end

  def has_subscription_options?
    subscription_options.present?
  end

  monadic_operation! def subscribe_to(kind)
    subscription_instance_for(kind).bind(&:subscribe!)
  end

  # @return [Subscription]
  def subscription_for(kind)
    subscriptions.where(kind:).first_or_create!
  end

  # @return [{ Symbol => SubscriptionOptions::Definition }]
  def subscription_options
    self.class.subscription_options
  end

  def subscription_identifier
    # :nocov:
    raise "must set subscription_identifier on the class" unless has_subscription_identifier?
    # :nocov:

    public_send(self.class.subscription_identifier_method)
  end

  # @param [#to_sym] kind
  # @return [Dry::Monads::Success(SubscriptionOptions::Instance)]
  # @return [Dry::Monads::Failure(:unknown_subscription_option, #to_sym)]
  monadic_matcher! def subscription_instance_for(kind)
    call_operation("subscription_options.resolve_instance", self, kind)
  end

  # @api private
  # @return [void]
  def sync_subscription_state!(force: false)
    each_subscription_option do |option|
      next unless force || saved_change_to_attribute?(option.kind)

      subscription = subscription_for(option.kind)

      current = __send__(option.kind)

      next if subscription.in_state?(current)

      subscription.transition_to!(current)
    end

    return self
  end

  # @param [#to_sym]
  # @return [void]
  monadic_operation! def unsubscribe_from(kind)
    subscription_instance_for(kind).bind(&:unsubscribe!)
  end

  # @return [String, nil]
  def unsubscribe_token
    # :nocov:
    return unless persisted?
    # :nocov:

    to_sgid(for: :unsubscribe).to_s
  end

  # @see SubscriptionOptions::Definition#unsubscribe_url_for
  # @param [#to_sym] kind
  # @return [String]
  monadic_operation! def unsubscribe_url_for(kind)
    subscription_instance_for(kind).bind(&:unsubscribe_url)
  end

  private

  # @return [void]
  def maybe_update_subscription_timestamps!
    each_subscription_option do |option|
      next unless will_save_change_to_attribute? option.kind

      self[option.timestamp] = Time.current
    end
  end

  module ClassMethods
    # @param [String] token
    # @raise [ActiveRecord::RecordNotFound]
    # @raise [ActiveSupport::MessageVerifier::InvalidSignature]
    # @return [User]
    def find_for_unsubscribe_token(token)
      id = Rails.application.message_verifier(:unsubscribe).verify(token)

      find id
    end

    # @param [Symbol] method_name
    # @return [void]
    def subscription_identified_by!(method_name)
      subscription_identifier_method method_name
    end

    def subscription_option!(...)
      option = SubscriptionOptions::Definition.new(...)

      subscription_options(option.merge_into(**subscription_options))

      pg_enum! option.kind, **option.enum_options

      scope :"undecided_#{option.kind}", -> { undecided_subscription_for(option.kind) }
    end

    # @api private
    # @return [SubscriptionOptions::Definition]
    def subscription_option_for(kind)
      subscription_options.fetch(kind.to_sym)
    end

    # @return [ActiveRecord::Relation<HasSubscriptionOption>]
    def undecided_subscription_for(kind)
      option = subscription_option_for(kind)

      where(option.timestamp => nil)
    end
  end
end
