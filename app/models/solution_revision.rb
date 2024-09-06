# frozen_string_literal: true

class SolutionRevision < ApplicationRecord
  include TimestampScopes

  belongs_to :solution, inverse_of: :solution_revisions

  belongs_to :provider, inverse_of: :solution_revisions, optional: true
  belongs_to :solution_draft, inverse_of: :solution_revisions, optional: true
  belongs_to :user, inverse_of: :solution_revisions, optional: true

  belongs_to_readonly :snapshot, class_name: "ActiveSnapshot::Snapshot", optional: true

  has_one :actual_provider, through: :solution, source: :provider

  pg_enum! :kind, as: :solution_revision_kind, allow_blank: false, default: :other, suffix: :revision
  pg_enum! :data_version, as: :solution_data_version, allow_blank: false, default: :unknown, suffix: :data
  pg_enum! :provider_state, as: :solution_revision_provider_state, allow_blank: false, default: :same, prefix: :provider

  attribute :diffs, Solutions::Revisions::AnyDiff.to_array_type, default: proc { [] }
  attribute :data, Solutions::Revisions::AnyData.to_type

  expose_ransackable_attributes! :provider_id, :solution_id, :solution_draft_id, :user_id, :identifier, :kind, :data_version, :created_at, on: :editor
  expose_ransackable_associations! :actual_provider, :provider, :solution, :solution_draft, :user, on: :editor

  strip_attributes only: %i[note reason]

  validates :note, :reason, length: { maximum: 500 }
end
