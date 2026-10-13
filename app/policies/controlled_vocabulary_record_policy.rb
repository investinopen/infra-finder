# frozen_string_literal: true

# Generic policy for all service options.
#
# @see ControlledVocabularyRecord
class ControlledVocabularyRecordPolicy < ApplicationPolicy
  requires_admin_for_show!

  # Reading terms through the GraphQL API. Anyone may read every term, hidden
  # ones included, because the solution and public intake forms already offer
  # them. ActiveAdmin's show pages stay admin-only via {#show?}.
  #
  # @see Types::AbstractControlledVocabularyRecord
  # @return [Boolean]
  def read? = true

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

  # Every record is readable through the API (see {#read?}).
  #
  # @return [Boolean]
  def api_admin_only? = false
end
