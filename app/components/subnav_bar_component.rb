# frozen_string_literal: true

class SubnavBarComponent < ApplicationComponent
  renders_one :share_bar

  # return [Boolean]
  attr_reader :back_to_solutions

  # @return [String, nil]
  attr_reader :class_name

  # @return [Boolean]
  attr_reader :show_back

  # @return [Boolean]
  attr_reader :show_welcome_notice

  # @param [Boolean] back_to_solutions
  # @param [Boolean] is_narrow
  # @param [Boolean] show_back
  def initialize(show_back: false, show_welcome_notice: false, is_narrow: false, back_to_solutions: false)
    @back_to_solutions = back_to_solutions
    @class_name = is_narrow ? "l-container--narrow" : ""
    @show_back = show_back
    @show_welcome_notice = show_welcome_notice
  end

  def link_to_back(&)
    options = {
      class: "m-button m-button--sm w-fit"
    }

    path = solutions_path

    link_to path, options do
      capture(&)
    end
  end

  def render_welcome_notice
    render WelcomeNoticeComponent.new()
  end
end
