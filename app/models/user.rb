# frozen_string_literal: true

class User < ApplicationRecord
  include Commentable
  include HasName
  include HasSubscriptionOption
  include Notifiable
  include TimestampScopes
  include UsesStatesman

  devise :database_authenticatable,
    :recoverable, :rememberable, :validatable,
    :confirmable, :lockable, :timeoutable, :trackable

  # A Rack env key that, when set, makes a sign-out keep the user's token
  # sessions (see the Warden hook in `config/initializers/devise.rb`).
  KEEP_TOKEN_SESSIONS = "infra_finder.keep_token_sessions"

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

  pg_enum! :kind, as: :user_kind, default: :unassigned, allow_blank: false, suffix: :kind

  subscription_identified_by! :email

  subscription_option! :comment_notifications

  subscription_option! :reminder_notifications, hidden: true

  subscription_option! :solution_notifications

  rolify after_add: :refresh_from_role!, after_remove: :refresh_from_role!

  define_simple_lookups! :email, :kind

  scope :in_default_order, -> { in_alphabetical_order }

  scope :any_admins, -> { where(kind: %w[admin super_admin]) }
  scope :admins, -> { admin_kind }
  scope :super_admins, -> { super_admin_kind }

  has_many :created_invitations, inverse_of: :admin, foreign_key: :admin_id, class_name: "Invitation", dependent: :nullify
  has_one :invitation, inverse_of: :user, dependent: :destroy
  has_many :oauth_access_grants, class_name: "OAuth::AccessGrant", foreign_key: :resource_owner_id, inverse_of: false, dependent: :delete_all
  has_many :oauth_access_tokens, class_name: "OAuth::AccessToken", foreign_key: :resource_owner_id, inverse_of: false, dependent: :delete_all
  has_many :provider_editor_assignments, inverse_of: :user, dependent: :destroy
  has_many :solution_drafts, inverse_of: :user, dependent: :nullify
  has_many :solution_editor_assignments, inverse_of: :user, dependent: :destroy
  has_many :solution_imports, inverse_of: :user, dependent: :nullify
  has_many :assigned_providers, through: :provider_editor_assignments, source: :provider
  has_many :assigned_solutions, through: :provider_editor_assignments, source: :solutions

  has_many_readonly :solution_revisions, inverse_of: :user

  has_many :solution_intake_sources, inverse_of: :editor, class_name: "SolutionIntake", foreign_key: :editor_id, dependent: :nullify
  has_many :solution_intake_transitions, inverse_of: :user, dependent: :nullify

  before_validation :derive_kind!

  after_update :revoke_token_sessions!, if: :saved_change_to_encrypted_password?

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

  # @see AnonymousInterface#anonymous?
  def anonymous? = false

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

  # Anyone who may use the GraphQL API, and has accepted the terms, may upload files.
  #
  # @see Users::Access
  # @see Users::UploadAccessPolicy
  def has_any_upload_access?
    Users::Access.allowed?(self) && has_any_admin_or_editor_access? && accepted_terms?
  end

  # @param [Solution] solution
  def has_pending_draft_for?(solution)
    pending_draft_scope_for(solution).exists?
  end

  def has_provider_editor_assignments?
    provider_editor_assignments.exists?
  end

  # Every sign-in is remembered, so a sign-in session outlives Devise's
  # `timeoutable` and lasts `Devise.remember_for`. This overrides the
  # `rememberable` accessor that the sign-in form would otherwise set.
  #
  # @return [true]
  def remember_me = true

  # Sign the user out of every token session, on every device. Happens on any
  # sign-out and on a password change.
  #
  # @return [void]
  def revoke_token_sessions!
    OAuth::AccessToken.revoke_all_for_user(self)
  end

  # @see Uploads::EncodeToken
  # @param [String] session_id the token session the upload token is issued under
  # @return [String, nil]
  def upload_token(session_id:)
    call_operation("uploads.encode_token", self, session_id:).value_or(nil)
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
    return :any if unassigned_kind?

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
      :unassigned
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

    # @param [ApplicationRecord] resource
    # @return [ActiveRecord::Relation<User>]
    def with_access_to(resource)
      case resource
      when Provider
        with_access_to_provider(resource)
      when Solution, SolutionDraft
        with_access_to(resource.provider)
      else
        # simplecov:disable
        none
        # simplecov:enable
      end
    end

    # @param [Provider] provider
    # @return [ActiveRecord::Relation<User>]
    def with_access_to_provider(provider)
      access_scope = unscoped.any_admins.or(unscoped.where(id: unscoped.with_role(:editor, provider)))

      where(id: access_scope)
    end
  end
end
