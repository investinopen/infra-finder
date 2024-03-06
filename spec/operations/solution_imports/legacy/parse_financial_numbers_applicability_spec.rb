# frozen_string_literal: true

RSpec.describe SolutionImports::Legacy::ParseFinancialNumbersApplicability, type: :operation do
  it "resolves the correct input", :aggregate_failures do
    expect_calling_with(1).to succeed.with("not_applicable")
    expect_calling_with(2).to succeed.with("applicable")
    expect_calling_with("literally anything else").to succeed.with("unknown")
  end
end
