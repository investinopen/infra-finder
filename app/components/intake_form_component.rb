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

  # Equivalent of {#vocab_options} for plain enums
  # @param [Symbol] attr
  # @return [<(String, String)>]
  def enum_options(attr)
    solution_intake.class.public_send(attr.to_s.pluralize).keys.map do |value|
      [I18n.t("pg_enums.#{attr}.#{value}"), value]
    end
  end

  # @param [ActionView::Helpers::FormBuilder] f
  # @param [Symbol] name the implementation attribute name
  # @return [ActiveSupport::SafeBuffer]
  def implementation_url_field(f, name, **options)
    store = f.object.public_send(name)

    if store.respond_to?(:links)
      field_name = "#{f.object_name}[#{name}_attributes][links][][url]"
      value = store.links.first&.url
    else
      field_name = "#{f.object_name}[#{name}_attributes][link][url]"
      value = store.link&.url
    end

    helpers.url_field_tag(field_name, value, id: implementation_url_field_id(f, name), **options)
  end

  # @param [ActionView::Helpers::FormBuilder] f
  # @param [Symbol] name
  # @return [String] the DOM id shared by {#implementation_url_field} and its label's `for`
  def implementation_url_field_id(f, name)
    "#{f.object_name}_#{name}_url"
  end

  # Sync form max-length to model
  # @param [Symbol] attr
  # @return [Integer, nil]
  def max_length(attr)
    solution_intake.class
      .validators_on(attr)
      .find { |v| v.is_a?(ActiveModel::Validations::LengthValidator) }
      &.options&.dig(:maximum)
  end
end
