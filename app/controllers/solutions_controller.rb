# frozen_string_literal: true

# @see Solution
class SolutionsController < ApplicationController
  def index
    @solutions = Pundit.policy_scope!(current_user, Solution.all)
  end

  def show
    @solution = Solution.find params[:id]
  end
end
