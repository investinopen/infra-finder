# frozen_string_literal: true

# The component for rendering multiselect fields within
# the solution show / detail component.
#
# @see SolutionDetailsComponent
class SolutionMultiselectionComponent < ApplicationComponent
  include AcceptsSolution

  # @return [Solution]
  attr_reader :solution

  # The name of the connection
  # @return [Symbol]
  attr_reader :name

  # @return [String]
  attr_reader :layout

  # @return [Number]
  attr_reader :column_count

  # @return [Array]
  attr_reader :selections

  # @return [String, nil]
  attr_reader :other_value

  alias connection_name name

  # @param [Solution] solution
  # @param [Symbol] name
  # @param [String, nil] layout
  # @param [Number, nil] column_count
  def initialize(solution:, name:, layout: "default", column_count: 3)
    @solution = solution
    @name = name
    @layout = layout
    @column_count = column_count

    solution.vocab_selected_and_other_for(name) => { selected:, has_other:, other_value:, mode:, conn: }

    @selections = Array(selected)
    @other_value = other_value
  end
end