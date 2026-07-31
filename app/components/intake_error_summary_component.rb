# frozen_string_literal: true

# @see SolutionIntakesController#update
class IntakeErrorSummaryComponent < ApplicationComponent
  CONTROLLER = "intake-error-summary-component--intake-error-summary-component"

  OBJECT_NAME = "solution_intake"

  Entry = Struct.new(:message, :field_name, keyword_init: true)

  # @return [SolutionIntake]
  attr_reader :solution_intake

  # @param [SolutionIntake] solution_intake
  def initialize(solution_intake:)
    @solution_intake = solution_intake
  end

  def render?
    solution_intake.errors.any?
  end

  # @return [<Entry>]
  def entries
    solution_intake.errors.flat_map { expand(_1) }
  end

  private

  # Store models report `"is invalid"` on the parent, so their own errors have to be
  # read off the nested record to say anything useful.
  def expand(error)
    value = read(solution_intake, error.attribute)

    if rows?(value)
      row_entries(error.attribute, value)
    elsif value.respond_to?(:errors)
      nested_entries(error.attribute, value)
    else
      [Entry.new(message: error.full_message, field_name: "#{OBJECT_NAME}[#{error.attribute}]")]
    end
  end

  def row_entries(attr, rows)
    rows.each_with_index.flat_map do |row, index|
      row.errors.map do |error|
        Entry.new(
          message: "#{label_for(attr)}, row #{index + 1}: #{error.full_message}",
          field_name: "#{OBJECT_NAME}[#{attr}_attributes][#{index}][#{error.attribute}]"
        )
      end
    end
  end

  def nested_entries(attr, model)
    field_name = nested_field_name(attr, model)

    leaf_messages(model).map do |message|
      Entry.new(message: "#{label_for(attr)}: #{message}", field_name:)
    end
  end

  def leaf_messages(model)
    model.errors.flat_map do |error|
      nested = read(model, error.attribute)

      if rows?(nested)
        nested.flat_map { _1.errors.full_messages }.presence || [error.full_message]
      elsif nested.respond_to?(:errors) && nested.errors.any?
        nested.errors.full_messages
      else
        [error.full_message]
      end
    end
  end

  # Mirrors the names emitted by {IntakeFormComponent#implementation_url_field}.
  def nested_field_name(attr, model)
    if model.respond_to?(:links)
      "#{OBJECT_NAME}[#{attr}_attributes][links][][url]"
    elsif model.respond_to?(:link)
      "#{OBJECT_NAME}[#{attr}_attributes][link][url]"
    else
      "#{OBJECT_NAME}[#{attr}]"
    end
  end

  def rows?(value)
    value.is_a?(Array) && value.any? { _1.respond_to?(:errors) }
  end

  def read(object, attr)
    object.public_send(attr) if object.respond_to?(attr)
  end

  def label_for(attr)
    SolutionIntake.human_attribute_name(attr)
  end
end
