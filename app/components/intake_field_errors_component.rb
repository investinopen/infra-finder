# frozen_string_literal: true

# @see SolutionIntakesController#update
# @see FormFieldWrapperComponent
class IntakeFieldErrorsComponent < ApplicationComponent
  ID = "intake-field-errors"

  CONTROLLER = "intake-field-errors-component--intake-field-errors-component"

  include AcceptsSolutionIntake

  # @api private
  # @return [Hash]
  def container_data
    { controller: CONTROLLER, field_errors: }
  end

  # @api private
  # @return [String] JSON
  def field_errors
    form_errors.field_data.to_json
  end
end
