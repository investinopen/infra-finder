# frozen_string_literal: true

module ActiveAdmin
  # A policy for accessing pages in ActiveAdmin.
  class PagePolicy < ApplicationPolicy
    def show?
      case record.name
      when "Dashboard"
        admin_or_editor?
      else
        # :nocov:
        false
        # :nocov:
      end
    end
  end
end
