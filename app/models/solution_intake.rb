# frozen_string_literal: true

# A solution intake represents a {Solution} that can collect information before entering
# the system proper. It allows administrators to set up an intake, provide a URL to a maintainer,
# and easily track the progress of the intake, approving and publishing the intake if it meets
# acceptance criteria.
class SolutionIntake < ApplicationRecord
  extend FriendlyId

  include SolutionImportable
  include SolutionInterface
  include Notifiable
  include TimestampScopes
  include UsesStatesman

  resourcify

  pg_enum! :state, as: :solution_intake_state, default: :pending, allow_blank: false

  has_state_machine!

  belongs_to :editor, class_name: "User", inverse_of: :solution_intake_sources, optional: true
  belongs_to :solution, inverse_of: :solution_intake, optional: true
  belongs_to :provider, inverse_of: :solution_intakes, optional: true

  expose_ransackable_associations! :provider, :solution
  expose_ransackable_attributes! :provider_id, :solution_id, :name

  scope :missing_provider, -> { where(provider_id: nil) }

  before_validation :set_snowflake!, on: :create

  validates :solution_id, uniqueness: { if: :solution_id? }
  validates :snowflake, presence: true, uniqueness: true

  validates :launch_year, numericality: { only_integer: true, greater_than_or_equal_to: 1900, if: :apply_editor_validations? }

  validates :first_name, :last_name, :email, presence: true, if: :apply_editor_validations?

  friendly_id :snowflake

  delegate :name, to: :provider, prefix: true, allow_nil: true
  delegate :assign_editor!, to: :provider

  # @!group State Management

  # @param [{ Symbol => Object }] options
  # @option options [User, nil] :current_user The user performing the action, if any.
  # @option options [String, nil] :note A note to attach to the state transition, if any.
  # @option options ["admin", "form", "unspecified"] source The source of the state transition, if any.
  # @see SolutionIntakes::Approve
  # @see SolutionIntakes::Approver
  # @return [Dry::Monads::Success(SolutionIntake)]
  monadic_matcher! def approve(**options)
    call_operation("solution_intakes.approve", self, **options)
  end

  # @param [{ Symbol => Object }] options
  # @option options [User, nil] :current_user The user performing the action, if any.
  # @option options [String, nil] :note A note to attach to the state transition, if any.
  # @option options ["admin", "form", "unspecified"] source The source of the state transition, if any.
  # @see SolutionIntakes::Reject
  # @see SolutionIntakes::Rejector
  # @return [Dry::Monads::Success(SolutionIntake)]
  monadic_matcher! def reject(**options)
    call_operation("solution_intakes.reject", self, **options)
  end

  # @param [{ Symbol => Object }] options
  # @option options [User, nil] :current_user The user performing the action, if any.
  # @option options [String, nil] :note A note to attach to the state transition, if any.
  # @option options ["admin", "form", "unspecified"] source The source of the state transition, if any.
  # @see SolutionIntakes::Reset
  # @see SolutionIntakes::Resetter
  # @return [Dry::Monads::Success(SolutionIntake)]
  monadic_matcher! def reset(**options)
    call_operation("solution_intakes.reset", self, **options)
  end

  # @param [{ Symbol => Object }] options
  # @option options [User, nil] :current_user The user performing the action, if any.
  # @option options [String, nil] :note A note to attach to the state transition, if any.
  # @option options ["admin", "form", "unspecified"] source The source of the state transition, if any.
  # @see SolutionIntakes::Submit
  # @see SolutionIntakes::Submitter
  # @return [Dry::Monads::Success(SolutionIntake)]
  monadic_matcher! def submit(**options)
    call_operation("solution_intakes.submit", self, **options)
  end

  # @!endgroup State Management

  # @see SolutionIntakes::Assign
  # @see SolutionIntakes::Assigner
  # @return [Dry::Monads::Success(SolutionIntake)]
  monadic_operation! def assign
    call_operation("solution_intakes.assign", self)
  end

  # @see SolutionIntakes::TryInviting
  # @see SolutionIntakes::InvitationAttempter
  # @return [Dry::Monads::Success(SolutionIntake)]
  monadic_matcher! def try_inviting(**options)
    call_operation("solution_intakes.try_inviting", self, **options)
  end

  # @return [String]
  def contact_name
    "#{first_name} #{last_name}".strip
  end

  alias notifiable_contact_name contact_name

  # @api private
  # @param [Integer] flake
  # @return [String]
  def normalize_friendly_id(flake)
    InfraFinder::Container[:sqids].encode([flake])
  end

  # @!attribute [rw] launch_year
  # A proxy attribute that wraps around `founded_on`.
  # @return [Integer, nil]
  def launch_year
    founded_on&.year
  end

  # User form uses a plain number input for this value
  # @param [String, Integer, nil] value
  # @return [void]
  def launch_year=(value)
    self.founded_on = value.present? ? Date.new(value.to_i) : nil
  end

  # Whether the intake is mutable, meaning that the form is potentially usable
  # and it has not yet been approved nor rejected.
  def mutable?
    pending? || in_review?
  end

  # A guard predicate to make sure that the intake is valid for transitioning to `in_review`.
  def submittable?
    currently_applying = apply_editor_validations?

    self.apply_editor_validations = true

    valid?
  ensure
    self.apply_editor_validations = currently_applying
  end

  private

  # @return [void]
  def set_snowflake!
    self.snowflake ||= call_operation("snowflakes.generate")
  end
end
