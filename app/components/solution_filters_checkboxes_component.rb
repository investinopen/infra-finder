# frozen_string_literal: true

class SolutionFiltersCheckboxesComponent < ApplicationComponent
  # @return [Ransack::Helpers::FormBuilder] f
  attr_reader :f

  # @param [Ransack::Helpers::FormBuilder] f
  def initialize(f:)
    @f = f
  end
end
