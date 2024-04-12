# frozen_string_literal: true

# Generic policy for all service options.
#
# @see SolutionOption
class SolutionOptionPolicy < ApplicationPolicy
  requires_admin_for_show!

  def replace?
    has_any_admin_access?
  end

  alias replace_option? replace?

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
