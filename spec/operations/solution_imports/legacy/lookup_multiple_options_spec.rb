# frozen_string_literal: true

RSpec.describe SolutionImports::Legacy::LookupMultipleOptions, type: :operation do
  before_all do
    InfraFinder::Container["seeding.seed_all_options"].().value!
  end

  it "finds the correct easily-confused options", :aggregate_failures do
    expect_calling_with(SolutionCategory, "Authoring tool").to succeed.with(contain_exactly(have_attributes(seed_identifier: 3)))
    expect_calling_with(SolutionCategory, "Peer review systems").to succeed.with(contain_exactly(have_attributes(seed_identifier: 30)))
    expect_calling_with(UserContribution, "\BFunds").to succeed.with(contain_exactly(have_attributes(seed_identifier: 5)))
    expect_calling_with(UserContribution, "User Research Design Sprints").to succeed.with(contain_exactly(have_attributes(seed_identifier: 22)))
  end
end
