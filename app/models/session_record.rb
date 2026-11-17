# frozen_string_literal: true

# A session model suitable for use with activerecord-session_store.
#
# @see https://github.com/rails/activerecord-session_store
# @see SessionRecords::PruneJob
class SessionRecord < ApplicationRecord
  include TimestampScopes

  belongs_to :user, inverse_of: :session_records, optional: true

  scope :expired, -> { where(updated_at: ...SessionConfig.ttl.days.ago) }

  before_validation :extract_details!

  private

  # @return [String, nil]
  def extract_user_id_from_data = data.try(:dig, "warden.user.user.key", 0, 0)

  # @return [Time, nil]
  def extract_last_user_request_at
    raw_value = data.try(:dig, "warden.user.user.session", "last_request_at")

    Time.zone.at(raw_value) if raw_value
  end

  # @return [void]
  def extract_details!
    self.last_user_request_at = extract_last_user_request_at
    self.user_id = extract_user_id_from_data
  end

  class << self
    # @return [SessionRecord]
    def find_by_session_id(session_id) = find_by(session_id:)

    # @return [void]
    def prune!
      expired.in_batches.delete_all
    end
  end
end
