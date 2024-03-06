# frozen_string_literal: true

# @see SolutionImport
# @see SolutionImports::StateMachine
class SolutionImportTransition < ApplicationRecord
  include StandardTransition

  set_up_transition! :solution_import, inverse_of: :solution_import_transitions
end
