# frozen_string_literal: true

module Solutions
  module Revisions
    class Creator < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :solution, Types::Actual

        option :solution_draft, Types::Draft.optional, optional: true
        option :user, Types.Instance(::User).optional, default: proc { RequestStore.store[:current_user] }
        option :kind, Types::RevisionKind, default: proc { "other" }
        option :note, Types::String.optional, optional: true
        option :reason, Types::String.optional, optional: true
      end

      standard_execution!

      # Attributes to create a new {SolutionRevision}
      #
      # @return [Hash]
      attr_reader :attrs

      # @return [Solutions::Revisions::Data]
      attr_reader :data

      # @return [<Hash>]
      attr_reader :diffs

      # @return [ActiveSupport::HashWithIndifferentAccess]
      attr_reader :metadata

      # @return []
      attr_reader :revision

      # @return [ActiveSnapshot::Snapshot]
      attr_reader :snapshot

      # @return [Solutions::Revisions::Data, nil]
      attr_reader :previous_data

      # @return [SolutionRevision, nil]
      attr_reader :previous_revision

      attr_reader :provider_state

      delegate :provider, :snapshots, :solution_revisions, to: :solution

      delegate :id, to: :solution_draft, prefix: true, allow_nil: true

      delegate :data, to: :previous_revision, prefix: :previous, allow_nil: true
      delegate :properties, to: :previous_data, prefix: :previous, allow_nil: true
      delegate :properties, to: :data, prefix: :current, allow_nil: true

      # @return [Dry::Monads::Success(ActiveSupport::HashWithIndifferentAccess)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield extract_data!

          yield calculate_diffs!

          yield extract_metadata!

          yield create_snapshot!

          yield create_revision!
        end

        Success revision
      end

      wrapped_hook! def prepare
        @diffs = []

        @metadata = { kind:, note:, reason:, solution_draft_id:, }

        @attrs = metadata.dup.merge(provider:, user:)

        @data = nil

        @revision = nil

        @snapshot = nil

        @previous_revision = solution_revisions.latest

        super
      end

      wrapped_hook! def extract_data
        @data = yield solution.extract_revision_data

        @attrs[:data_version] = data.version

        super
      end

      wrapped_hook! def calculate_diffs
        @diffs = Solutions::Revisions::Diffs::BaseDiff.calculate(previous_properties, current_properties)

        super
      end

      wrapped_hook! def extract_metadata
        @attrs[:data] = @metadata[:data] = data
        @attrs[:diffs] = @metadata[:diffs] = diffs

        @attrs[:provider_state] = yield determine_provider_state

        super
      end

      wrapped_hook! def create_snapshot
        @snapshot = solution.create_snapshot!(
          user:,
          metadata:,
        )

        attrs[:snapshot] = snapshot

        super
      end

      wrapped_hook! def create_revision
        @revision = solution_revisions.create!(attrs)

        super
      end

      private

      # @return [Dry::Monads::Success(Solutions::Types::RevisionProviderState)]
      def determine_provider_state
        return Success("initial") if kind == "initial"

        data.has_different_provider_from?(previous_data) ? Success("diff") : Success("same")
      end
    end
  end
end
