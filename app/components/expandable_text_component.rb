# frozen_string_literal: true

class ExpandableTextComponent < ApplicationComponent
  # @return [String]
  attr_reader :text

  # @return [Number, nil]
  attr_reader :truncate

  def initialize(text:, truncate: nil)
    @text = text
    @truncate = truncate
  end
end
