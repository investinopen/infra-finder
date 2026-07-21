# frozen_string_literal: true

class IntakeFormComponent < ApplicationComponent
  include Formtastic::Helpers::FormHelper

  STIMULUS_CONTROLLER = "intake-form-component--intake-form-component"

  # @return [SolutionIntake]
  attr_reader :solution_intake

  def initialize(solution_intake:)
    @solution_intake = solution_intake
  end

  # ActiveAdmin monkeypatches Formtastic's `input_wrapping` to check
  # `template.assigns[:has_many_block]`. Within a ViewComponent, `template`
  # is the component itself and `assigns` is never populated, so it returns
  # `nil` and the patch raises `NoMethodError`. Default to an empty hash.
  #
  # @return [{ String => Object }]
  def assigns
    super || {}
  end

  # @return [{ Symbol => Object }]
  def form_html_options
    {
      data: {
        controller: STIMULUS_CONTROLLER,
      },
    }
  end

  # @return [{ Symbol => Object }]
  def save_on_blur_options
    {
      data: {
        action: "blur->#{STIMULUS_CONTROLLER}#save",
      },
    }
  end
end
