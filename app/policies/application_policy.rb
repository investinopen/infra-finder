# frozen_string_literal: true

# @abstract
class ApplicationPolicy
  extend Dry::Core::ClassAttributes

  defines :requires_admin_for_show, type: Support::GlobalTypes::Bool

  requires_admin_for_show false

  # @return [ApplicationRecord]
  attr_reader :record

  # @return [User, nil]
  attr_reader :user

  delegate :admin?, :has_any_admin_or_editor_access?, :has_any_admin_access?, :has_any_editor_access?, :has_role?, :super_admin?, to: :user, allow_nil: true

  alias admin_or_editor? has_any_admin_or_editor_access?

  # @param [User, nil] user
  # @param [ApplicationRecord] record
  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    has_any_admin_access?
  end

  def show?
    if requires_admin_for_show?
      has_any_admin_access?
    else
      scope.exists?(id: record.id)
    end
  end

  def new?
    create?
  end

  def create?
    super_admin?
  end

  def edit?
    update?
  end

  def update?
    super_admin?
  end

  def destroy?
    super_admin?
  end

  def destroy_all?
    super_admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  private

  def admin_or_editor_for_record?
    has_any_admin_access? || has_editor_access_for_record?
  end

  def has_editor_access_for_record?
    case record
    when Solution
      has_role?(:editor, record)
    when SolutionDraft
      has_role?(:editor, record.solution)
    else
      # :nocov:
      false
      # :nocov:
    end
  end

  def requires_admin_for_show?
    self.class.requires_admin_for_show
  end

  class << self
    # @return [void]
    def requires_admin_for_show!
      requires_admin_for_show true
    end
  end

  # @abstract
  class Scope
    # @return [ActiveRecord::Relation]
    attr_reader :scope

    # @return [User, nil]
    attr_reader :user

    # @param [User, nil] user
    # @param [ActiveRecord::Relation] scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    # @return [ActiveRecord::Relation]
    def resolve
      scope
    end
  end
end
