# frozen_string_literal: true

module SolutionDrafts
  # An abstract service that prepares various workflow actions.
  #
  # @abstract
  # @see SolutionDrafts::StateMachine
  class WorkflowActor < BaseActor
    option :memo, Types::String.optional, optional: true

    option :user, Types::User.optional, optional: true

    defines :to_state, type: Types::Symbol
    defines :workflow_definition, type: Types.Instance(::WorkflowDefinition).optional

    to_state :unknown

    delegate :action, to: :workflow_definition, prefix: :workflow

    # @return [<User>]
    attr_reader :recipients

    alias initiator user

    def prepare
      @recipients = workflow_definition.recipients_for(draft, initiator:)

      super
    end

    def perform
      yield handle_transition!

      yield post_process!

      yield notify!

      super
    end

    wrapped_hook! def handle_transition
      metadata = build_transition_metadata

      yield monadic_transition(draft, to_state, **metadata)

      super
    end

    wrapped_hook! :post_process

    wrapped_hook! def notify
      return super unless initiator.present?

      base_params = {
        draft:,
        solution:,
        initiator:,
        memo:,
      }

      recipients.find_each do |recipient|
        params = base_params.merge(recipient:)

        after_commit do
          WorkflowMailer.with(params).__send__(workflow_action).deliver_later
        end
      end

      super
    end

    # @!attribute [r] to_state
    # @api private
    # @return [Symbol]
    def to_state
      self.class.to_state
    end

    # @!attribute [r] workflow_definition
    # @api private
    # @return [WorkflowDefinition]
    def workflow_definition
      self.class.workflow_definition
    end

    private

    # @return [{ Symbol => Object }]
    def build_transition_metadata
      { memo:, }
    end

    class << self
      # @param [Symbol] state
      # @return [void]
      def transitions_to!(state)
        to_state state

        workflow_definition WorkflowDefinition.find_by!(to_state:)
      end
    end
  end
end
