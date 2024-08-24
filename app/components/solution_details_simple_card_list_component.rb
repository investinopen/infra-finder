# frozen_string_literal: true

class SolutionDetailsSimpleCardListComponent < ApplicationComponent
  include AcceptsSolution

  # @return [String, nil]
  attr_reader :heading

  # @return [Array, nil]
  attr_reader :items

  # @return [String, nil]
  attr_reader :text

  # @param [String, nil] heading
  # @param [Array, nil] items
  # @param [String, nil] text
  def initialize(heading:, items: nil, text: nil)
    @heading = heading
    @items = items
    @text = text
  end
end
