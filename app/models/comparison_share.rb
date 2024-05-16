# frozen_string_literal: true

# A more resilient version of {Comparison} that is designed to be shared.
class ComparisonShare < ApplicationRecord
  include AbstractComparison
  include TimestampScopes

  PRUNABLE_AGE = 2.years

  pg_enum! :item_state, as: :comparison_item_state, allow_blank: false, default: :empty, prefix: :items

  has_many :comparisons, inverse_of: :comparison_share, foreign_key: :fingerprint, primary_key: :fingerprint, dependent: :nullify

  has_many :comparison_share_items, -> { for_comparison }, inverse_of: :comparison_share, dependent: :destroy

  has_many :solutions, through: :comparison_share_items

  scope :prunable, -> { where(arel_prunable) }

  validates :fingerprint, presence: true, uniqueness: true

  # @return [void]
  def shared!
    touch :shared_at, :last_used_at unless shared_at?
  end

  def used!
    increment! :share_count

    update_columns(share_count:, last_used_at: Time.current)
  end

  class << self
    def arel_prunable
      last_used_at = arel_table[:last_used_at]

      too_old_since_used = last_used_at.lt(PRUNABLE_AGE.ago)
      too_old_since_created = arel_table[:created_at].lt(PRUNABLE_AGE.ago)

      arel_case do |stmt|
        stmt.when(arel_table[:shared_at].not_eq(nil)).then(arel_quote(false))
        stmt.when(last_used_at.not_eq(nil)).then(too_old_since_used)
        stmt.else(too_old_since_created)
      end
    end
  end
end
