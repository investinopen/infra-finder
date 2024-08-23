# frozen_string_literal: true

module ActiveAdmin
  # A policy for accessing pages in ActiveAdmin.
  class PagePolicy < ApplicationPolicy
    def show?
      case record.name
      when "Dashboard", "terms_and_conditions"
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
  end
end
