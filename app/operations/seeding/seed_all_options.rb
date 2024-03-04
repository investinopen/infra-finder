# frozen_string_literal: true

module Seeding
  class SeedAllOptions
    include Dry::Monads[:result, :do]

    include InfraFinder::Deps[
      seed_options: "seeding.seed_options",
    ]

    def call
      yield seed_options.(BoardStructure)
      yield seed_options.(BusinessForm)
      yield seed_options.(CommunityGovernance)
      yield seed_options.(HostingStrategy)
      yield seed_options.(License)
      yield seed_options.(MaintenanceStatus)
      yield seed_options.(PrimaryFundingSource)
      yield seed_options.(ReadinessLevel)
      yield seed_options.(SolutionCategory)
      yield seed_options.(UserContribution)

      Success()
    end
  end
end
