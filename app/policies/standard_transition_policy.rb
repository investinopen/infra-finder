# frozen_string_literal: true

# A generic policy for any Statesman transition.
#
# A transition is visible to whoever can see the record it belongs to.
#
# @see StandardTransition
class StandardTransitionPolicy < ApplicationPolicy
  # The owner check is memoized per request so a page of transitions for the
  # same owner loads and authorizes the owner once.
  #
  # @return [Boolean]
  def show?
    return false unless record.respond_to?(:owner)

    foreign_key = record.class.reflect_on_association(record.class.owner_name).foreign_key

    key = [self.class.name, record.class.name, record.public_send(foreign_key), user&.id]

    Policies::Current.fetch(key) { allowed_to?(:show?, record.owner) }
  end

  private

  # Transitions are only listed through their owner, which is authorized first.
  #
  # @param [ActiveRecord::Relation] relation
  # @return [ActiveRecord::Relation]
  def resolve_scope_for_non_admin(relation) = relation.all
end
