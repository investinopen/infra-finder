# frozen_string_literal: true

class TagListComponentPreview < ViewComponent::Preview
  def key_technologies(solution_id: Solution.first!.id)
    solution = Solution.find solution_id

    render(TagListComponent.new(solution:, name: :key_technologies))
  end
end
