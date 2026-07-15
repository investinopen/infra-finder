# frozen_string_literal: true

# A button that saves the intake form without validation.
# Rendered into {BackToTopComponent}'s `action` slot.
#
# @see IntakeFormComponent
class IntakeSaveDraftButtonComponent < ApplicationComponent
  # @return [String]
  attr_reader :form_id

  # @param [String] form_id
  def initialize(form_id: IntakeFormComponent::FORM_ID)
    @form_id = form_id
  end
end
