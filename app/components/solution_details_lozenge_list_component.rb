# frozen_string_literal: true

class SolutionDetailsLozengeListComponent < ApplicationComponent
  include AcceptsSolution

  # @return [String, nil]
  attr_reader :heading

  # @return [Array, nil]
  attr_reader :items

  # @return [String, nil]
  attr_reader :text

  # @param [Array, nil] items
  # @param [String, nil] heading
  # @param [String, nil] text
  def initialize(items:, heading:, text: nil)
    @items = items
    @heading = heading
    @text = text
  end
end
