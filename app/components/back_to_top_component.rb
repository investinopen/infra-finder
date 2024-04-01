# frozen_string_literal: true

class BackToTopComponent < ApplicationComponent
  # @return [String, nil]
  attr_reader :class_name

  # @param [Boolean] is_narrow
  def initialize(is_narrow: false)
    @class_name = is_narrow ? "max-w-narrow" : "max-w-base"
  end
end
