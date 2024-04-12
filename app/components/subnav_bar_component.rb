# frozen_string_literal: true

class SubnavBarComponent < ApplicationComponent
  renders_one :share_bar

  # return [Boolean]
  attr_reader :back_to_solutions

  # @return [String, nil]
  attr_reader :class_name

  # @return [Boolean]
  attr_reader :show_back

  # @param [Boolean] back_to_solutions
  # @param [Boolean] is_narrow
  # @param [Boolean] show_back
  def initialize(show_back: false, is_narrow: false, back_to_solutions: false)
    @back_to_solutions = back_to_solutions
    @class_name = is_narrow ? "l-container--narrow" : ""
    @show_back = show_back
  end

  def link_to_back(&)
    options = {
      class: "m-button m-button--sm"
    }

    path = solutions_path

    link_to path, options do
      capture(&)
    end
  end
end
