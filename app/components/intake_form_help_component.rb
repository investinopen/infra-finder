# frozen_string_literal: true

# @see IntakeFormSectionComponent
class IntakeFormHelpComponent < ApplicationComponent
  # @return [String, nil]
  attr_reader :for_title

  # @return [String]
  attr_reader :href

  # @param [String, nil] for_title
  # @param [String, nil] href
  def initialize(for_title: nil, href: nil)
    @for_title = for_title
    @href = href.presence || "#"
  end

  # @return [String] accessible name
  def summary_label
    for_title.present? ? "Help for #{for_title} section" : "Section help"
  end
end
