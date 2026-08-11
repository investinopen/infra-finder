# frozen_string_literal: true

module SolutionIntakes
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    include Solutions::Types

    InputBool = Params::Bool.default(false).fallback(false)

    IntakeParams = SolutionProperties::Schemas::Intake::Params

    IntakeState = ApplicationRecord.dry_pg_enum(:solution_intake_state, symbolize: true, default: :pending)
  end
end
