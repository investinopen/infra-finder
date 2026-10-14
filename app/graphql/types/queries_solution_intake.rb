# frozen_string_literal: true

module Types
  # An interface for querying {SolutionIntake}.
  module QueriesSolutionIntake
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying `SolutionIntake` records.
    TEXT

    field :solution_intake, ::Types::SolutionIntakeType, null: true do
      description <<~TEXT
      Retrieve a single `SolutionIntake` by slug. Anyone with the slug may read a pending or in-review intake.
      TEXT

      argument :slug, Types::SlugType, required: true do
        description <<~TEXT
        The slug to look up.
        TEXT
      end
    end

    field :solution_intakes, resolver: ::Resolvers::SolutionIntakeResolver

    # @param [String] slug
    # @return [SolutionIntake, nil]
    def solution_intake(slug:)
      load_record_with(SolutionIntake, slug)
    end
  end
end
