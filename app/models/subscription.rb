# frozen_string_literal: true

class Subscription < ApplicationRecord
  include TimestampScopes
  include UsesStatesman

  pg_enum! :kind, as: :subscription_kind, allow_blank: false

  has_state_machine!

  belongs_to :subscribable, polymorphic: true, inverse_of: :subscriptions

  validates :kind, presence: true, uniqueness: { scope: :subscribable }
end
