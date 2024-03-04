# frozen_string_literal: true

module SolutionDrafts
  # Fetch an array of {SolutionDrafts::ChangedField}s.
  #
  # @see SolutionDrafts::FetchChangedFields
  class ChangedFieldsFetcher < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :draft, Types::Draft
    end

    standard_execution!

    delegate :draft_overrides, :solution, to: :draft

    # @return [<SolutionDrafts::ChangedField>]
    attr_reader :changes

    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_reader :comparisons

    include InfraFinder::Deps[
      compare_attributes: "solutions.compare_attributes",
    ]

    # @return [Dry::Monads::Success<SolutionDrafts::ChangedField>]
    def call
      run_callbacks :execute do
        yield prepare!

        yield compare!

        yield prepare_changes!
      end

      Success changes
    end

    wrapped_hook! def prepare
      @changes = []

      super
    end

    wrapped_hook! def compare
      @comparisons = yield compare_attributes.(solution, draft)

      super
    end

    wrapped_hook! def prepare_changes
      draft_overrides.each do |field|
        source_value, target_value = comparisons.fetch(field, [])

        field_kind = Solution.field_kind_for field

        changes << SolutionDrafts::ChangedField.new(field:, field_kind:, source_value:, target_value:)
      end

      super
    end
  end
end
