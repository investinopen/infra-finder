# frozen_string_literal: true

RSpec.describe "Admin All Solution Options", type: :request, default_auth: true do
  describe BoardStructure do
    include_examples "a solution option admin section", BoardStructure
  end

  describe BusinessForm do
    include_examples "a solution option admin section", BusinessForm
  end

  describe CommunityGovernance do
    include_examples "a solution option admin section", CommunityGovernance
  end

  describe HostingStrategy do
    include_examples "a solution option admin section", HostingStrategy
  end

  describe License do
    include_examples "a solution option admin section", License
  end

  describe MaintenanceStatus do
    include_examples "a solution option admin section", MaintenanceStatus
  end

  describe PrimaryFundingSource do
    include_examples "a solution option admin section", PrimaryFundingSource
  end

  describe ReadinessLevel do
    include_examples "a solution option admin section", ReadinessLevel
  end

  describe SolutionCategory do
    include_examples "a solution option admin section", SolutionCategory
  end

  describe UserContribution do
    include_examples "a solution option admin section", UserContribution
  end
end
