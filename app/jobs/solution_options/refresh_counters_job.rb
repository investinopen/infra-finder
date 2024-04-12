# frozen_string_literal: true

module SolutionOptions
  class RefreshCountersJob < ApplicationJob
    include JobIteration::Iteration

    queue_as :maintenance

    OPTIONS = [
      ::BoardStructure,
      ::BusinessForm,
      ::CommunityGovernance,
      ::HostingStrategy,
      ::License,
      ::PrimaryFundingSource,
      ::ReadinessLevel,
      ::SolutionCategory,
      ::UserContribution,
    ].freeze

    # @param [String] cursor
    # @return [Enumerator]
    def build_enumerator(cursor:)
      enumerator_builder.array(OPTIONS, cursor:)
    end

    # @param [Class<SolutionOption>] klass
    def each_iteration(klass)
      klass.refresh_counters!
    end
  end
end
