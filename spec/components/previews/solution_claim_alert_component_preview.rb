# frozen_string_literal: true

class SolutionClaimAlertComponentPreview < ViewComponent::Preview
  def default
    render(SolutionClaimAlertComponent.new(solution: Solution.unclaimed.first!))
  end
end
