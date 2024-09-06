# frozen_string_literal: true

module Solutions
  module Revisions
    class Initializer < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :solution, Types::Actual

        option :user, Types.Instance(::User).optional, default: proc { RequestStore.store[:current_user] }
        option :reason, Types::String.optional, default: proc { "Initial revision" }
      end

      standard_execution!

      # @return [SolutionRevision, nil]
      attr_reader :revision

      delegate :solution_revisions, to: :solution
      delegate :initial_revision, to: :solution_revisions
      delegate :exists?, to: :initial_revision, prefix: true

      # @return [Dry::Monads::Success(SolutionRevision)]
      # @return [Dry::Monads::Success(nil)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield maybe_initialize!
        end

        Success revision
      end

      wrapped_hook! def prepare
        @revision = nil

        super
      end

      wrapped_hook! def maybe_initialize
        return super if initial_revision_exists?

        @revision = yield solution.create_revision(
          kind: "initial",
          user:,
          reason:
        )

        super
      end
    end
  end
end
