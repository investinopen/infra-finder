# frozen_string_literal: true

module ApplicationHelper
  def enhanced_admin_form_for(*args, **options, &)
    options[:builder] = options[:form_builder] = Admin::EnhancedFormBuilder
    options[:html] ||= {}
    options[:html][:multipart] = true

    active_admin_form_for(*args, **options, &)
  end
end
