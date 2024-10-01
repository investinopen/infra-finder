# frozen_string_literal: true

class SolutionNavComponent < ApplicationComponent
  # @param [Boolean, null] show_community_link
  def initialize(show_community_link: true)
    @show_community_link = show_community_link
  end

  def show_community_link?
    @show_community_link
  end
end
