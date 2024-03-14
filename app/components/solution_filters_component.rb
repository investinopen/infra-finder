# frozen_string_literal: true

class SolutionFiltersComponent < ApplicationComponent
  # @return [Ransack::Search]
  attr_reader :solution_search

  # @api private
  # @return [Hash]
  attr_reader :search_form_options

  # @param [Ransack::Search] solution_search
  def initialize(solution_search: Solution.all.ransack({}))
    @solution_search = solution_search
  end

  def before_render
    @search_form_options = build_search_form_options
  end

  private

  def build_search_form_options
    {
      url: solution_search_path,
      html: {
        class: "solution-filters bg-neutral-20 rounded-xl",
        data: {
          controller: "solution-filters-component--solution-filters-component",
          method: "post",
          "turbo-frame": "solutions-list",
          "turbo-method": "post",
        },
        method: :post,
      },
    }
  end
end
