# frozen_string_literal: true

# A generic interface shared by all statesman transitions.
#
# @see CommonTransitionPolicy
module CommonTransition
  extend ActiveSupport::Concern

  include ::Support::Requests::ReadsCurrentUser
  include TimestampScopes

  included do
    extend Dry::Core::ClassAttributes

    defines :owner_name, :reflected_transitions, type: Support::Types::Symbol

    derive_owner_name!
    derive_reflected_transitions!

    scope :in_graphql_order, -> { order(sort_key: :desc) }

    before_create :maybe_capture_initiator!
  end

  # @!attribute [r] owner
  # @return [UsesStatesman]
  def owner = __send__ self.class.owner_name

  # @return [ActiveRecord::Relation<CommonTransition>]
  def sibling_transitions = owner.__send__ self.class.reflected_transitions

  private

  # @return [void]
  def maybe_capture_initiator!
    self.initiator = current_user if current_user.present? && current_user.authenticated?
  end

  module ClassMethods
    # @return [Class]
    def policy_class = CommonTransitionPolicy

    # Sets up the `from_state` and `to_state` enum columns for a transition model.
    # @param [Symbol, String] enum_type
    # @return [void]
    def stateful_enum!(enum_type)
      pg_enum! :from_state, as: enum_type, prefix: :from, allow_blank: true
      pg_enum! :to_state, as: enum_type, prefix: :to
    end

    private

    # @return [Symbol]
    def derive_owner_name = name.demodulize.sub(/Transition\z/, "").underscore.to_sym

    # @return [void]
    def derive_owner_name!
      owner_name derive_owner_name
    end

    # @return [Symbol]
    def derive_reflected_transitions = name.demodulize.tableize.to_sym

    # @return [void]
    def derive_reflected_transitions!
      reflected_transitions derive_reflected_transitions
    end
  end
end
