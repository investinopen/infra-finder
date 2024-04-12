# frozen_string_literal: true

class ComparisonItemComponent < ApplicationComponent
  with_collection_parameter :item

  # @return [ComparisonItem]
  attr_reader :item

  # @return [ActionView::PartialIteration]
  attr_reader :iteration

  delegate :comparison, :solution, to: :item

  # @param [ComparisonItem] item
  # @param [ActionView::PartialIteration] item_iteration a magic value populated
  #   by the parent component's `with_collection` call.
  def initialize(item:, item_iteration: ActionView::PartialIteration.new(1))
    @item = item
    @iteration = item_iteration
  end

  def link_to_remove_options
    {
      class: "m-solution-card__close print:hidden",
      data: {
        turbo_frame: "_top",
        turbo_method: :delete,
      }
    }
  end

  def link_to_detail_options
    {
      class: "m-button m-button--sm bg-brand-mint",
      data: { turbo_frame: "_top" }
    }
  end

  def render_location
    render SolutionLocationComponent.new(solution:)
  end
end
