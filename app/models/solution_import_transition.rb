# frozen_string_literal: true

# @see SolutionImport
# @see SolutionImports::StateMachine
class SolutionImportTransition < ApplicationRecord
  include Support::StatesmanHelpers::Transition
  include CommonTransition

  stateful_enum! :solution_import_state

  belongs_to :solution_import, inverse_of: :solution_import_transitions
  belongs_to :initiator, optional: true, polymorphic: true

  owner_association_name :solution_import
  transitions_association_name :solution_import_transitions
end
