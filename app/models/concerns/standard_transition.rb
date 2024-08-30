# frozen_string_literal: true

# A generic interface shared by all statesman transitions.
#
# @see StandardTransitionPolicy
module StandardTransition
  extend ActiveSupport::Concern

  include TimestampScopes

  included do
    extend Dry::Core::ClassAttributes

    defines :owner_name, :reflected_transitions, type: Support::Types::Symbol

    derive_owner_name!
    derive_reflected_transitions!

    after_destroy :update_most_recent!, if: :most_recent?
  end

  # @!attribute [r] owner
  # @return [UsesStatesman]
  def owner
    __send__ self.class.owner_name
  end

  # @return [ActiveRecord::Relation<StandardTransition>]
  def sibling_transitions
    owner.__send__ self.class.reflected_transitions
  end

  # @return [void]
  def update_most_recent!
    last_transition = sibling_transitions.reorder(sort_key: :desc).first

    return if last_transition.blank?

    last_transition.update_column(:most_recent, true)
  end

  module ClassMethods
    # @return [Class]
    def policy_class
      StandardTransitionPolicy
    end

    # @param [Symbol] owner
    # @param [Symbol] inverse_of
    # @param [{ Symbol => Object }] options options for the `belongs_to` association.
    #
    # @return [void]
    def set_up_transition!(owner, inverse_of:, **options)
      owner_name owner
      reflected_transitions inverse_of

      options[:inverse_of]

      belongs_to(owner, **options, inverse_of:)
    end

    private

    # @return [Symbol]
    def derive_owner_name
      name.demodulize.sub(/Transition\z/, "").underscore.to_sym
    end

    # @return [void]
    def derive_owner_name!
      owner_name derive_owner_name
    end

    # @return [Symbol]
    def derive_reflected_transitions
      name.demodulize.tableize.to_sym
    end

    # @return [void]
    def derive_reflected_transitions!
      reflected_transitions derive_reflected_transitions
    end
  end
end
