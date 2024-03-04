# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable,
    :recoverable, :rememberable, :validatable,
    :confirmable, :lockable, :timeoutable, :trackable

  pg_enum! :kind, as: :user_kind, default: :default, allow_blank: false, suffix: :kind

  rolify after_add: :refresh_from_role!, after_remove: :refresh_from_role!

  scope :super_admins, -> { where(super_admin: true) }

  has_many :solution_drafts, inverse_of: :user, dependent: :nullify
  has_many :solution_editor_assignments, inverse_of: :user, dependent: :destroy
  has_many :assigned_solutions, through: :solution_editor_assignments, source: :solution

  before_validation :derive_kind!

  validates :name, presence: true

  alias editor? editor_kind?
  alias has_any_editor_access? editor_kind?

  def has_any_admin_access?
    super_admin? || admin?
  end

  def has_any_admin_or_editor_access?
    has_any_admin_access? || has_any_editor_access?
  end

  # @param [Solution] solution
  def has_pending_draft_for?(solution)
    pending_draft_scope_for(solution).exists?
  end

  def has_solution_editor_assignments?
    solution_editor_assignments.exists?
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

  private

  # @return [Users::Types::Kind]
  def derive_kind
    if super_admin?
      :super_admin
    elsif admin?
      :admin
    elsif has_solution_editor_assignments?
      :editor
    else
      :default
    end
  end

  # @return [void]
  def derive_kind!
    self.kind = derive_kind
  end

  # @param [Role] _role
  # @return [void]
  def refresh_from_role!(_role)
    derive_kind!

    update_columns(kind:) if kind_changed?
  end

  class << self
    # @param [Solution] solution
    # @return [ActiveRecord::Relation<User>]
    def assignable_to_solution(solution)
      where.not(kind: %w[admin super_admin]).
        where.not(id: solution.solution_editor_assignments.select(:user_id))
    end

    def ransackable_associations(auth_object = nil)
      []
    end

    def ransackable_attributes(auth_object = nil)
      [
        "id",
        "created_at",
        "current_sign_in_at",
        "email",
        "name",
        "kind",
        "sign_in_count",
        "super_admin",
        "updated_at",
      ]
    end
  end
end
