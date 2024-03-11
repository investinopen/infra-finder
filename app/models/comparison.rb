# frozen_string_literal: true

# A session-based model for tracking comparisons between various {Solution}s.
class Comparison < ApplicationRecord
  include TimestampScopes

  has_many :comparison_items, -> { in_default_order }, inverse_of: :comparison, dependent: :destroy

  has_many :solutions, through: :comparison_items

  validates :session_id, presence: true, uniqueness: true

  # @see Comparisons::Add
  # @return [Dry::Monads::Result]
  monadic_matcher! def add(solution)
    call_operation("comparisons.add", self, solution)
  end

  # @see Comparisons::Remove
  # @return [Dry::Monads::Result]
  monadic_matcher! def remove(solution)
    call_operation("comparisons.remove", self, solution)
  end
end
