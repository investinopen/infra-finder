# frozen_string_literal: true

class SolutionDetailsGrantCardComponent < ApplicationComponent
  include AcceptsSolution

  # @return [Solutions::Grant]
  attr_reader :grant

  # @param [Solutions::Grant] grant
  def initialize(grant:)
    @grant = grant
  end
end
