# frozen_string_literal: true

# The component for rendering multiselect other fields within
# the solution show / detail component, for when only the other
# field should be shown.
#
# @see SolutionDetailsComponent
class SolutionMultiselectionOtherComponent < ApplicationComponent
  include AcceptsSolution

  # @return [Solution]
  attr_reader :solution

  # The name of the connection
  # @return [Symbol]
  attr_reader :name

  # @return [String, nil]
  attr_reader :other_value

  alias connection_name name

  # @param [Solution] solution
  # @param [Symbol] name
  def initialize(solution:, name:, hide_other: false)
    @solution = solution
    @name = name

    solution.vocab_selected_and_other_for(name) => { selected:, has_other:, other_value:, mode:, conn: }

    @other_value = other_value
  end
end
