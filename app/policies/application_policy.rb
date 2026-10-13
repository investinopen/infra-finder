# frozen_string_literal: true

# The base policy for authorizing actions in the application.
#
# @abstract
# @see https://actionpolicy.evilmartians.io/
#
# @!attribute [r] user
#   The user performing the action, if any.
#   @return [User, nil]
#
# @!attribute [r] record
#   The record the action is being performed on.
#   @return [ApplicationRecord, Class, Symbol]
class ApplicationPolicy < ActionPolicy::Base
  extend Dry::Core::ClassAttributes

  authorize :user, allow_nil: true

  defines :requires_admin_for_show, type: Support::GlobalTypes::Bool

  requires_admin_for_show false

  delegate :admin?, :has_any_admin_or_editor_access?, :has_any_admin_access?, :has_any_editor_access?, :has_role?, :super_admin?, to: :user, allow_nil: true

  alias admin_or_editor? has_any_admin_or_editor_access?

  alias_rule :edit?, to: :update?

  relation_scope do |relation|
    resolve_scope(relation)
  end

  # The scope GraphQL resolvers apply. Unlike ActiveAdmin, the API exposes
  # lists and lookups directly, so records only admins may show are hidden
  # from everyone else.
  #
  # @see Resolvers::AbstractResolver
  relation_scope(:api) do |relation|
    api_admin_only? && !has_any_admin_access? ? relation.none : resolve_api_scope(relation)
  end

  def index?
    has_any_admin_access?
  end

  def show?
    if requires_admin_for_show?
      has_any_admin_access?
    else
      record_exists_in_scope?
    end
  end

  # For the sake of mutations, assume arguments provided can always be read and worry
  # about authorizing within the context of the mutation.
  #
  # @see Support::GraphQLAPI::Enhancements::Authorized
  # @return [Boolean]
  def read_for_mutation? = true

  def create?
    super_admin?
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

  def batch_action?
    super_admin?
  end

  private

  def admin_or_editor_for_record?
    has_any_admin_access? || has_editor_access_for_record?
  end

  def has_editor_access_for_record?
    case record
    when Provider
      has_role?(:editor, record)
    when Solution, SolutionDraft
      has_role?(:editor, record.provider)
    when SolutionRevision
      has_role?(:editor, record.actual_provider)
    else
      # simplecov:disable
      false
      # simplecov:enable
    end
  end

  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_scope(relation)
    relation.all
  end

  # Whether the {:api} scope is admin-only. Defaults to {#requires_admin_for_show?}.
  #
  # @return [Boolean]
  def api_admin_only? = requires_admin_for_show?

  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_api_scope(relation)
    resolve_scope(relation)
  end

  def record_exists_in_scope?
    apply_scope(record.class.all, type: :active_record_relation).exists?(id: record.id)
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
end
