# frozen_string_literal: true

class SolutionSortComponentPreview < ViewComponent::Preview
  def last_updated
    solution_search = Solution.ransack(?s => "updated_at desc")

    render(SolutionSortComponent.new(solution_search:))
  end

  def name_asc
    solution_search = Solution.ransack(?s => "name asc")

    render(SolutionSortComponent.new(solution_search:))
  end

  def name_desc
    solution_search = Solution.ransack(?s => "name desc")

    render(SolutionSortComponent.new(solution_search:))
  end
end
