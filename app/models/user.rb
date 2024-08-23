# frozen_string_literal: true

class User < ApplicationRecord
  include HasName
  include TimestampScopes
  include UsesStatesman

  devise :database_authenticatable,
    :recoverable, :rememberable, :validatable,
    :confirmable, :lockable, :timeoutable, :trackable

  has_state_machine!

  ransackable_minimum_allowance! :admin

  expose_ransackable_attributes!(
    "admin",
    "current_sign_in_at",
    "email",
    "kind",
    "sign_in_count",
    "super_admin",
    on: :admin
  )

  pg_enum! :kind, as: :user_kind, default: :default, allow_blank: false, suffix: :kind

  rolify after_add: :refresh_from_role!, after_remove: :refresh_from_role!

  scope :super_admins, -> { where(super_admin: true) }

  has_many :created_invitations, inverse_of: :admin, foreign_key: :admin_id, class_name: "Invitation", dependent: :nullify
  has_one :invitation, inverse_of: :user, dependent: :destroy
  has_many :provider_editor_assignments, inverse_of: :user, dependent: :destroy
  has_many :solution_drafts, inverse_of: :user, dependent: :nullify
  has_many :solution_editor_assignments, inverse_of: :user, dependent: :destroy
  has_many :solution_imports, inverse_of: :user, dependent: :nullify
  has_many :assigned_solutions, through: :provider_editor_assignments, source: :solutions

  before_validation :derive_kind!

  after_save :maybe_auto_accept_terms!
  after_save :maybe_accept_terms!

  validates :accept_terms_and_conditions, acceptance: { on: :accepting_terms }
  validates :name, presence: true

  # A pseudo-attribute that will transition the record on save.
  # @return [Boolean]
  attr_accessor :accept_terms_and_conditions

  alias editor? editor_kind?
  alias has_any_editor_access? editor_kind?

  def accepted_terms?
    accepted_terms_at?
  end

  alias has_accepted_terms? accepted_terms?

  def has_unaccepted_terms?
    !has_accepted_terms?
  end

  def has_any_admin_access?
    super_admin? || admin?
  end

  def has_any_admin_or_editor_access?
    has_any_admin_access? || has_any_editor_access?
  end

  def has_no_admin_access?
    !has_any_admin_access?
  end

  # @param [Solution] solution
  def has_pending_draft_for?(solution)
    pending_draft_scope_for(solution).exists?
  end

  def has_provider_editor_assignments?
    provider_editor_assignments.exists?
  end

  # @param [Solution] solution
  # @return [SolutionDraft, nil]
  def pending_draft_for(solution)
    pending_draft_scope_for(solution).first
  end

  # @param [Solution] solution
  # @return [ActiveRecord::Relation<SolutionDraft>]
  def pending_draft_scope_for(solution)
    solution_drafts.pending.where(solution:)
  end

  # @return [ExposesRansackable::Types::Allowance]
  def ransackable_allowance
    return :any if default_kind?

    ExposesRansackable::Types::Allowance[kind.to_sym]
  end

  private

  # @return [Users::Types::Kind]
  def derive_kind
    if super_admin?
      :super_admin
    elsif admin?
      :admin
    elsif has_provider_editor_assignments?
      :editor
    else
      :default
    end
  end

  # @return [void]
  def derive_kind!
    self.kind = derive_kind
  end

  # @see {#accept_terms_and_conditions}
  # @return [void]
  def maybe_accept_terms!
    return if in_state?(:accepted_terms) || accept_terms_and_conditions.blank?

    transition_to!(:accepted_terms)
  end

  # @return [void]
  def maybe_auto_accept_terms!
    return if in_state?(:accepted_terms) || has_no_admin_access?

    transition_to!(:accepted_terms)
  end

  # @param [Role] _role
  # @return [void]
  def refresh_from_role!(_role)
    derive_kind!

    update_columns(kind:) if kind_changed?
  end

  class << self
    # @param [Provider, Solution] resource
    # @return [ActiveRecord::Relation<User>]
    def assignable_to(resource)
      case resource
      when Provider
        assignable_to_provider(resource)
      when Solution
        assignable_to_solution(resource)
      else
        none
      end
    end

    # @param [Provider] provider
    # @return [ActiveRecord::Relation<User>]
    def assignable_to_provider(provider)
      where.not(kind: %w[admin super_admin]).
        where.not(id: provider.provider_editor_assignments.select(:user_id))
    end

    # @deprecated
    # @param [Solution] solution
    # @return [ActiveRecord::Relation<User>]
    def assignable_to_solution(solution)
      assignable_to_provider(solution.provider)
    end
  end
end
