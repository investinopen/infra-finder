# frozen_string_literal: true

class SolutionFiltersCheckboxesComponent < ApplicationComponent
  # @return [String, nil]
  attr_reader :current_heading

  # @return [Symbol, nil]
  attr_reader :current_section

  # @return [Ransack::Helpers::FormBuilder] f
  attr_reader :f

  # @param [Ransack::Helpers::FormBuilder] f
  def initialize(f:)
    @f = f

    @current_section = nil
    @current_heading = nil
  end

  # @param [#to_sym] section
  def accordion(section, select_all: true, heading_key: ".headings.#{section}", &)
    @current_section = section.to_sym
    @current_heading = t(heading_key, raise: true)

    detail_options = {
      class: "solution-filters-details",
      "data-solution-filters-checkboxes-component--solution-filters-checkboxes-component-target" => "accordion",
    }

    content_tag(:details, detail_options) do
      concat content_tag(:summary, current_heading, class: "text-h5")

      concat capture(&)

      if select_all
        concat render(SolutionFiltersSelectAllComponent.new)
      end
    end
  ensure
    @current_section = nil
    @current_heading = nil
  end

  def boolean_scope(name, label_key: ".scopes.#{name}", event_name: current_heading, event_value_key: label_key)
    checkbox_options = {
      "data-event-name" => event_name,
      "data-event-value" => t(event_value_key, raise: true),
    }

    content_tag(:label, class: "m-checkbox") do
      capture do
        concat f.check_box name, checkbox_options, "true", ""
        concat content_tag(:span, t(label_key, raise: true))
      end
    end
  end
end
