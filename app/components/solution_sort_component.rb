# frozen_string_literal: true

# @note When adding new sorts, be sure to update the {Comparisons::SearchFilters::ACCEPTABLE_SORTS}
#   constant with the new attr / dir pair. Otherwise the sort will not persist.
class SolutionSortComponent < ApplicationComponent
  DIR = Dry::Types["coercible.symbol"].enum(:asc, :desc).fallback(:asc)

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

  # @param [Symbol] attr
  # @param [:asc, :desc] dir
  # @param [{ Symbol => Object }] html_attributes
  # @return [ActiveSupport::SafeBuffer]
  def solution_sort_option(attr, dir: :asc, **html_attributes)
    dir = DIR[dir]

    label = t(".sorts.#{attr}.#{dir}", raise: true)

    html_attributes[:selected] = solution_option_selected?(attr, dir)

    html_attributes[:value] = "#{attr} #{dir}"

    tag_builder.content_tag_string(:option, label, html_attributes)
  end

  private

  def build_search_form_options
    {
      url: solution_sort_path,
      html: {
        autocomplete: "off",
        data: {
          controller: "solution-sort-component--solution-sort-component",
          method: "put",
          "turbo-frame": "solutions-list",
          "turbo-method": "put",
        },
        method: :post,
        onchange: "this.requestSubmit()",
      },
    }
  end

  # @param [#to_s] attr
  # @param [:asc, :desc] dir
  def solution_option_selected?(attr, dir)
    match = [[attr, dir].map(&:to_s)]

    solution_search.sorts.map { [_1.attr_name, _1.dir] } == match
  end
end
