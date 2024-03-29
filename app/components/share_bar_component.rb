# frozen_string_literal: true

class ShareBarComponent < ApplicationComponent
  # @return [Boolean, nil]
  attr_reader :show_back

  # @return [String, nil]
  attr_reader :class_name

  # @param [Boolean] show_back
  # @param [Boolean] is_narrow
  def initialize(show_back: false, is_narrow: false)
    @show_back = show_back
    @class_name = is_narrow ? "l-container--narrow" : ""
  end
end
