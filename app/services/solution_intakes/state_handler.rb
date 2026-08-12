# frozen_string_literal: true

module SolutionIntakes
  # @abstract
  class StateHandler < Support::HookBased::Actor
    extend Dry::Core::ClassAttributes

    include Dry::Initializer[undefined: false].define -> do
      param :intake, Types::Intake

      option :current_user, Types::CurrentUser, optional: true

      option :note, Types::String.optional, optional: true

      option :source, Types::TransitionSource, default: proc { "unspecified" }
    end

    alias solution_intake intake

    alias user current_user

    defines :target_state, type: Types::IntakeState

    target_state :pending

    standard_execution!

    # @return [Solution]
    attr_reader :solution

    # @return [SolutionIntakes::TransitionMetadata]
    attr_reader :metadata

    # @return [Dry::Monads::Success(SolutionIntake)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield handle_transition!
      end

      Success intake
    end

    wrapped_hook! def prepare
      @solution = intake.solution

      @metadata = SolutionIntakes::TransitionMetadata.new(note:, source:)

      super
    end

    wrapped_hook! :pre_transition

    wrapped_hook! def handle_transition
      yield pre_transition!

      yield commit_transition!

      yield post_transition!

      super
    end

    around_handle_transition :within_transaction!

    wrapped_hook! def commit_transition
      meta_args = metadata.as_json.deep_symbolize_keys

      intake.transition_to!(target_state, **meta_args)

      intake.last_transition.update!(user:) if has_user?

      super
    end

    around_commit_transition :retry_conflicts!

    wrapped_hook! :post_transition

    # @return [:pending, :in_review, :approved, :rejected]
    def target_state = self.class.target_state

    private

    def has_user? = user.present?

    # @return [void]
    def retry_conflicts!
      Statesman::Machine.retry_conflicts(5) do
        ActiveRecord::Base.transaction(requires_new: true) do
          @solution = intake.reload_solution

          yield.tap do
            intake.reload
            intake.current_state(force_reload: true)

            @solution = intake.reload_solution
          end
        end
      end
    end

    # @return [void]
    def within_transaction!
      ActiveRecord::Base.transaction(requires_new: true) do
        yield
      end
    end

    class << self
      # @param [:pending, :in_review, :approved, :rejected] state
      # @return [void]
      def targets!(state)
        target_state state.to_sym
      end
    end
  end
end
