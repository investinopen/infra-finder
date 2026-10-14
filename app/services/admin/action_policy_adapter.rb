# frozen_string_literal: true

module Admin
  # Authorizes ActiveAdmin through Action Policy. The admin area itself is
  # limited to admins and editors; within it, the policies decide.
  class ActionPolicyAdapter < ActiveAdmin::AuthorizationAdapter
    # @param [Symbol] action
    # @param [Object, Class, Symbol, nil] subject
    # @return [Boolean]
    def authorized?(action, subject = nil)
      return false unless user.try(:has_any_admin_or_editor_access?)

      policy_for(subject).apply(rule_for(action, subject))
    end

    # @param [ActiveRecord::Relation] collection
    # @param [Symbol] _action
    # @return [ActiveRecord::Relation]
    def scope_collection(collection, _action = ActiveAdmin::Auth::READ)
      policy_for(collection).apply_scope(collection, type: :active_record_relation)
    end

    private

    # @param [Symbol] action
    # @param [Object, Class, Symbol, nil] subject
    # @return [Symbol]
    def rule_for(action, subject)
      case action
      when ActiveAdmin::Auth::READ then subject.is_a?(Class) ? :index? : :show?
      when ActiveAdmin::Auth::DESTROY then subject.is_a?(Class) ? :destroy_all? : :destroy?
      else :"#{action}?"
      end
    end

    # @param [Object, Class, Symbol, nil] subject
    # @return [ApplicationPolicy]
    def policy_for(subject)
      policies[subject || resource] ||= begin
        target = policy_target(subject)

        ActionPolicy.lookup(target, default: ApplicationPolicy).new(target, user:)
      end
    end

    # A class is authorized through a new instance of it.
    #
    # @param [Object, Class, Symbol, nil] subject
    # @return [Object]
    def policy_target(subject)
      case subject
      when nil then resource
      when Class then subject.new
      else subject
      end
    end

    # @return [{ Object => ApplicationPolicy }]
    def policies
      @policies ||= {}
    end
  end
end
