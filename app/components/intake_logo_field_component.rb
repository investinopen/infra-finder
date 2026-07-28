# frozen_string_literal: true

# @see IntakeFormComponent
class IntakeLogoFieldComponent < ApplicationComponent
  CONTROLLER = "intake-logo-field-component--intake-logo-field-component"

  # @return [ActionView::Helpers::FormBuilder]
  attr_reader :form

  # @param [ActionView::Helpers::FormBuilder] form
  def initialize(form:)
    @form = form
  end

  # @return [String]
  def controller_id
    CONTROLLER
  end

  # @return [String] the accepted file types
  def accept
    ImageUploader::ACCEPT
  end

  # @return [String, nil]
  def logo_url
    logo = form.object.logo

    logo.url if logo.present?
  rescue StandardError
    nil
  end
end
