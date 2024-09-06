# frozen_string_literal: true

module Solutions
  module Revisions
    # @api private
    # @see SolutionRevision
    class SnapshotMetadata
      include Support::EnhancedStoreModel

      actual_enum :kind, :direct, :draft, :import, :initial, :other, default: :other, _prefix: :because_of

      attribute :diffs, Solutions::Revisions::AnyDiff.to_array_type, default: []
      attribute :data, Solutions::Revisions::AnyData.to_type

      attribute :note, :string
      attribute :reason, :string

      attribute :solution_draft_id

      strip_attributes only: %i[note reason]
    end
  end
end
