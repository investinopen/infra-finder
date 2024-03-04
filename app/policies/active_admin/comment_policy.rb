# frozen_string_literal: true

module ActiveAdmin
  class CommentPolicy < ApplicationPolicy
    def index?
      super_admin?
    end

    def create?
      true
    end

    def destroy?
      record.author == user
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(author: user)
      end
    end
  end
end
