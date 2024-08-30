# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  DISPLAY_NAME_FORMAT = "%<model_name>s << %<identifier>s >>"

  default from: EmailConfig.origin

  layout "mailer"

  private

  # @param [ActiveRecord::Base] model
  # @return [String]
  def anchor_for(model)
    "#{model.model_name.singular}_#{model.id}"
  end

  def admin_show_url_for(resource, **options)
    case resource
    when SolutionDraft
      admin_solution_solution_draft_url(resource.solution, resource, **options)
    when Solution, Provider, User
      url_for([:admin, resource, **options])
    else
      # :nocov:
      raise "unsupported resource: #{resource}"
      # :nocov:
    end
  end

  def display_name_for(resource)
    model_name = display_model_name_for(resource)
    identifier = display_identifier_for(resource)

    DISPLAY_NAME_FORMAT % { model_name:, identifier:, }
  end

  def display_model_name_for(resource)
    case resource
    when SolutionDraft
      "Solution (Draft)"
    else
      resource.model_name.human
    end
  end

  # @param [ApplicationRecord] record
  # @return [String]
  def display_identifier_for(resource)
    case resource
    when SolutionDraft
      display_identifier_for(resource.solution)
    when HasName
      resource.name
    else
      # :nocov:
      resource.id
      # :nocov:
    end
  end
end
