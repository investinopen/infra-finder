# frozen_string_literal: true

# Generic policy for all service options.
#
# @see SolutionOption
class SolutionOptionPolicy < ApplicationPolicy
  requires_admin_for_show!

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
