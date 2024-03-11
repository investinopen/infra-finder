# frozen_string_literal: true

# @see Solution
class SolutionsController < ApplicationController
  comparison_load_strategy :find_existing

  def index
    @solution_search = solution_scope.ransack(current_search_filters)
    @solutions = @solution_search.result(distinct: true).with_all_facets_loaded
  end

  def show
    @solution = Solution.find params[:id]
  end

  private

  def solution_scope
    Pundit.policy_scope!(current_user, Solution.all)
  end
end
