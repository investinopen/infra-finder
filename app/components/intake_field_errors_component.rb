# frozen_string_literal: true

# A draft save answers with a stream that deliberately leaves the form in place, so
# server-side field errors have no re-rendered form to come back on. This element holds
# them instead, and is the only place they live: the stream replaces it, reconnecting
# tells the client a fresh set has arrived, and the field wrappers read it from here.
#
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
