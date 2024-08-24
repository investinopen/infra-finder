# frozen_string_literal: true

class SolutionStructuredListComponent < ApplicationComponent
  include AcceptsSolution

  # @return [Solution]
  attr_reader :solution

  # The name of the connection
  # @return [Symbol]
  attr_reader :name

  # @return [Array]
  attr_reader :items

  # @return [String, nil]
  attr_reader :free_text

  alias list_name name

  def initialize(solution:, name:, free_text: nil)
    @solution = solution
    @name = name
    @free_text = free_text

    @items = solution[name]
  end
end
