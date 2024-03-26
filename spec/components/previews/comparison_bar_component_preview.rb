# frozen_string_literal: true

class ComparisonBarComponentPreview < ViewComponent::Preview
  def one_solution
    comparison = Comparison.create!(ip: "127.0.0.1", session_id: SecureRandom.hex(16))

    comparison.add! Solution.first!

    render ComparisonBarComponent.new(comparison:)
  end

  def min_comparable
    comparison = Comparison.create!(ip: "127.0.0.1", session_id: SecureRandom.hex(16))

    comparison.add! Solution.first!
    comparison.add! Solution.second!

    render ComparisonBarComponent.new(comparison:)
  end

  def max_solutions
    comparison = Comparison.create!(ip: "127.0.0.1", session_id: SecureRandom.hex(16))

    solutions = Solution.take(ComparisonItem::MAX_ITEMS)

    solutions.each do |solution|
      comparison.add! solution
    end

    render ComparisonBarComponent.new(comparison:)
  end
end
