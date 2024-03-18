# frozen_string_literal: true

class ComparisonBarComponent < ApplicationComponent
  # @return [Comparison]
  attr_reader :comparison

  # @param [Comparison] comparison
  def initialize(comparison:)
    @comparison = comparison
  end

  def before_render
    @nav_link_options = build_nav_link_options
  end

  # @param [String] label
  # @param [String] href
  # @param [Hash] options
  # @return [String] the generated link HTML
  def nav_link(label, href, **options)
    opts = @nav_link_options.merge(**options)

    active_link_to(label, href, **opts)
  end

  private

  def build_nav_link_options
    {
      class: "m-button m-button--sm bg-brand-mint",
      data: {
        turbo_frame: "_top",
      }
    }
  end

  def remaining_slots
    slots_length = @comparison.comparison_items.length < 4 ? 4 - @comparison.comparison_items.length : 1

    (1..slots_length).to_a
  end
end
