# frozen_string_literal: true

RSpec.describe Solutions::MissingPropertiesFinder, type: :service do
  it "lists the required properties without a value" do
    solution = FactoryBot.create :solution

    expect(described_class.new(solution).call.value!).to include("mission", "solution_categories")
  end

  it "lists nothing for a complete solution" do
    solution = FactoryBot.create :solution, **complete_solution_attributes(:actual)

    expect(described_class.new(solution).call.value!).to be_empty
  end

  it "includes an intake's additional required attributes" do
    intake = FactoryBot.create :solution_intake, :notifiable, **complete_solution_attributes(:intake), founded_on: nil, email: nil

    expect(described_class.new(intake).call.value!).to contain_exactly("founded_on", "email")
  end
end
