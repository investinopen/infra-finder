# frozen_string_literal: true

FactoryBot.define do
  factory :solution_intake do
    association(:provider)

    sequence(:name) { |n| "Solution From Intake #{n}" }

    trait :ready_to_approve do
      governance_summary { "A summary of the solution's governance" }
      launch_year { 2023 }
      mission { "A statement about the solution's mission" }
      organizational_history { "A history of the organization" }
      service_summary { "A summary of what the solution does" }
      website { "https://example.com" }

      board_structures do
        [BoardStructure.first!]
      end

      business_forms do
        [BusinessForm.first!]
      end

      community_governances do
        [CommunityGovernance.first!]
      end

      domain_relevances do
        [DomainRelevance.first!]
      end

      hosting_strategy do
        HostingStrategy.first!
      end

      maintenance_status do
        MaintenanceStatus.first!
      end

      primary_funding_sources do
        [PrimaryFundingSource.first!]
      end

      readiness_level do
        ReadinessLevel.first!
      end

      revenue_sources do
        [RevenueSource.first!]
      end

      solution_categories do
        [SolutionCategory.first!]
      end

      user_contributions do
        [UserContribution.first!]
      end
    end
  end
end
