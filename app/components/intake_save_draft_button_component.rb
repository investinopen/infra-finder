# frozen_string_literal: true

# @see IntakeFormComponent
class IntakeSaveDraftButtonComponent < ApplicationComponent
  CONTROLLER = "intake-save-draft-button-component--intake-save-draft-button-component"

  # Dispatched on `window` by {IntakeFormComponent}'s controller as a draft
  # save progresses
  SAVING_EVENT = "intake:saving"
  SAVED_EVENT = "intake:saved"
  SAVE_FAILED_EVENT = "intake:save-failed"

  # @api private
  # @return [Hash]
  def button_data
    {
      controller: CONTROLLER,
      action: [
        "#{CONTROLLER}#save",
        "#{SAVING_EVENT}@window->#{CONTROLLER}#saving",
        "#{SAVED_EVENT}@window->#{CONTROLLER}#saved",
        "#{SAVE_FAILED_EVENT}@window->#{CONTROLLER}#fail",
      ].join(" "),
      "#{CONTROLLER}-labels-value": labels,
    }
  end

  # @api private
  # @return [Hash]
  def labels
    {
      idle: t(".save_draft"),
      autosaving: t(".autosaving"),
      saving: t(".saving"),
      saved: t(".saved"),
    }
  end
end
