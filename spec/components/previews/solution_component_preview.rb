# frozen_string_literal: true

class SolutionComponentPreview < ViewComponent::Preview
  def comparing(solution_id: Solution.first!.id)
    solution = Solution.find solution_id

    comparison = Comparison.create!(ip: "127.0.0.1", session_id: SecureRandom.hex(16))

    comparison.add! solution

    render SolutionComponent.new(solution:, comparison:)
  end

  def not_comparing(solution_id: Solution.first!.id)
    solution = Solution.find solution_id

    render SolutionComponent.new(solution:, comparison: nil)
  end
end
