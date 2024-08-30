# frozen_string_literal: true

module ActiveAdmin
  # A policy for accessing pages in ActiveAdmin.
  class PagePolicy < ApplicationPolicy
    def show?
      case record.name
      when "Dashboard", "Notifications", "terms_and_conditions"
        admin_or_editor?
      else
        # :nocov:
        false
        # :nocov:
      end
    end

    def accept?
      case record.name
      when "terms_and_conditions"
        true
      else
        # :nocov:
        false
        # :nocov:
      end
    end

    def update_preferences?
      case record.name
      when "Notifications"
        admin_or_editor?
      else
        # :nocov:
        false
        # :nocov:
      end
    end
  end
end
