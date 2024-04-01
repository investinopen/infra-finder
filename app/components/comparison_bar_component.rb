# frozen_string_literal: true

class ComparisonBarComponent < ApplicationComponent
  # @return [Comparison]
  attr_reader :comparison

  # @return [Integer]
  attr_reader :remaining_slot_count

  delegate :comparison_items_count, :items_addable?, :items_comparable?, :items_incomparable?, to: :comparison

  # @param [Comparison] comparison
  def initialize(comparison:)
    @comparison = comparison

    @remaining_slot_count = (ComparisonItem::MAX_ITEMS - comparison_items_count).clamp(0, ComparisonItem::MAX_ITEMS)
  end

  def bar_visible?
    comparison.comparison_items.any?
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

  def link_to_clear_comparison(&)
    options = {
      class: "m-button m-button--sm hidden sm:flex bg-white",
      data: {
        turbo_frame: "solutions-index",
        turbo_method: :delete,
      },
    }

    link_to comparison_path, options do
      capture(&)
    end
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

  def each_remaining_slot
    return unless items_addable?

    iteration = ActionView::PartialIteration.new(remaining_slot_count)

    remaining_slot_count.times do
      yield iteration
    ensure
      iteration.iterate!
    end
  end
end
