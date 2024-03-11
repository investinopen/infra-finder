# frozen_string_literal: true

class SolutionsComponentPreview < ViewComponent::Preview
  def all_existing_solutions
    # Make sure a solution exists. Seed if not.
    Solution.first!

    render(SolutionsComponent.new) do |component|
      component.with_solutions(Solution.all)
    end
  end

  def single_solution
    single_solution = Solution.first!

    render(SolutionsComponent.new) do |component|
      component.with_solutions([single_solution])
    end
  end

  def no_solutions
    render(SolutionsComponent.new)
  end
end
