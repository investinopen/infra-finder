# frozen_string_literal: true

class SolutionMobileFiltersComponent < ApplicationComponent
  # @return [Ransack::Helpers::FormBuilder] f
  attr_reader :f

  # @param [Ransack::Helpers::FormBuilder] f
  def initialize(f:)
    @f = f
  end
end
