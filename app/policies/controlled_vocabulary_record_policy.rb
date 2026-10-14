# frozen_string_literal: true

# Generic policy for all service options.
#
# @see ControlledVocabularyRecord
class ControlledVocabularyRecordPolicy < ApplicationPolicy
  # Anyone may read every record, hidden ones included, because the solution
  # and public intake forms already offer them.
  #
  # @return [Boolean]
  def show? = true

  # Internal details (the description and draft counts) are for admins.
  #
  # @return [Boolean]
  def read_admin_details?
    has_any_admin_access?
  end

  def mark_hidden? = update?

  def mark_visible? = update?

  def replace?
    has_any_admin_access?
  end

  alias replace_option? replace?

  private

  # Every record is readable (see {#show?}).
  #
  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_scope_for_non_admin(relation) = relation.all
end
