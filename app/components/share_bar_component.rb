# frozen_string_literal: true

class ShareBarComponent < ApplicationComponent
  # @return [Boolean, nil]
  attr_reader :show_back

  # @param [Boolean] show_back
  def initialize(show_back: false)
    @show_back = show_back
  end
end
