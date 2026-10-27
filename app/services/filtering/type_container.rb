# frozen_string_literal: true

module Filtering
  # A container for GraphQL types used by the filtering subsystem.
  #
  # Models and enums are registered here as resources gain filter scopes.
  TypeContainer = Support::DryGQL::TypeContainer.new.configure do |tc|
    tc.add! :date_match, Filtering::Inputs::DateMatch

    tc.add! :float_match, Filtering::Inputs::FloatMatch

    tc.add! :integer_match, Filtering::Inputs::IntegerMatch

    tc.add! :search_query, ::Searching::Query::Type

    tc.add! :time_match, Filtering::Inputs::TimeMatch

    tc.add_enum! ::Types::InvitationStateType
    tc.add_enum! ::Types::PublicationType
    tc.add_enum! ::Types::SolutionClaimStateType
    tc.add_enum! ::Types::SolutionDraftStateType
    tc.add_enum! ::Types::SolutionImportStateType
    tc.add_enum! ::Types::SolutionImportStrategyType
    tc.add_enum! ::Types::SolutionIntakeStateType
    tc.add_enum! ::Types::UserKindType

    tc.add_model! ::Provider
    tc.add_model! ::Solution
    tc.add_model! ::SolutionCategory
  end
end
