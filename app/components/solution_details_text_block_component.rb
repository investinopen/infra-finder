# frozen_string_literal: true

class SolutionDetailsTextBlockComponent < ApplicationComponent
  include AcceptsSolution

  # @return [String, nil]
  attr_reader :heading

  # @return [String, nil]
  attr_reader :text

  # @param [String, nil] text
  # @param [String, nil] heading
  def initialize(text:, heading:)
    @text = text
    @heading = heading
  end
end
