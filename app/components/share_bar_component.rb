# frozen_string_literal: true

class ShareBarComponent < ApplicationComponent
  # @return [Boolean, nil]
  attr_reader :show_back

  # @return [String, nil]
  attr_reader :class_name

  # return [String, nil]
  attr_reader :back_to_solutions

  # @param [Boolean] show_back
  # @param [Boolean] is_narrow
  def initialize(show_back: false, is_narrow: false, back_to_solutions: false)
    @show_back = show_back
    @class_name = is_narrow ? "l-container--narrow" : ""
    @back_to_solutions = back_to_solutions
  end

  def link_to_back(&)
    options = {
      class: "m-button m-button--sm"
    }

    if @back_to_solutions
      link_to solutions_path, options do
        capture(&)
      end
    else
      link_to :back, options do
        capture(&)
      end
    end
  end
end
