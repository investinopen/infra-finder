# frozen_string_literal: true

class IntakeFormComponent < ApplicationComponent
  FORM_ID = "solution-intake-form"

  # @return [SolutionIntake]
  attr_reader :solution_intake

  # @api private
  # @return [String]
  attr_reader :form_id

  # @param [SolutionIntake] solution_intake
  # @param [String] form_id
  def initialize(solution_intake:, form_id: FORM_ID)
    @solution_intake = solution_intake
    @form_id = form_id
  end

  # @param [String] vocab_name
  # @return [<(String, String, Hash)>]
  def vocab_options(vocab_name)
    ControlledVocabulary.find(vocab_name).fetch_options!
  end

  # Look up the submitted value for a vocabulary option by its label,
  # e.g. for wiring a conditional field to a specific choice.
  # @param [String] vocab_name
  # @param [String] label
  # @return [String]
  def vocab_option_value(vocab_name, label)
    vocab_options(vocab_name).find { |(l, _)| l == label }&.second or
      raise ArgumentError, "no option labeled #{label.inspect} in vocabulary #{vocab_name.inspect}"
  end

  # @param [String] vocab_name
  # @param [<String>] labels
  # @return [<String>]
  def vocab_option_values(vocab_name, *labels)
    labels.map { vocab_option_value(vocab_name, _1) }
  end
end
