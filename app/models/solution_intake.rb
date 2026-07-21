# frozen_string_literal: true

# A solution intake represents a {Solution} that can collect information before entering
# the system proper. It allows administrators to set up an intake, provide a URL to a maintainer,
# and easily track the progress of the intake, approving and publishing the intake if it meets
# acceptance criteria.
class SolutionIntake < ApplicationRecord
  extend FriendlyId

  include SolutionInterface
  include TimestampScopes
  include UsesStatesman

  resourcify

  pg_enum! :state, as: :solution_intake_state, default: :pending, allow_blank: false

  has_state_machine!

  belongs_to :solution, inverse_of: :solution_intake, optional: true
  belongs_to :provider, inverse_of: :solution_intakes

  expose_ransackable_associations! :provider, :solution
  expose_ransackable_attributes! :provider_id, :solution_id, :name

  before_validation :set_snowflake!, on: :create

  validates :solution_id, uniqueness: { if: :solution_id? }
  validates :snowflake, presence: true, uniqueness: true

  friendly_id :snowflake

  delegate :name, to: :provider, prefix: true
  delegate :assign_editor!, to: :provider

  # @return [Dry::Monads::Success(SolutionIntake)]
  monadic_operation! def approve
    call_operation("solution_intakes.approve", self)
  end

  # @return [Dry::Monads::Success(SolutionIntake)]
  monadic_operation! def assign
    call_operation("solution_intakes.assign", self)
  end

  # @api private
  # @param [Integer] flake
  # @return [String]
  def normalize_friendly_id(flake)
    InfraFinder::Container[:sqids].encode([flake])
  end

  private

  # @return [void]
  def set_snowflake!
    self.snowflake ||= call_operation("snowflakes.generate")
  end
end
