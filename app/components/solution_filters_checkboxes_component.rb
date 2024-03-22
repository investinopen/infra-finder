# frozen_string_literal: true

class SolutionFiltersCheckboxesComponent < ApplicationComponent
  # @return [Ransack::Helpers::FormBuilder] f
  attr_reader :f

  # @param [Ransack::Helpers::FormBuilder] f
  def initialize(f:)
    @f = f
  end

  # NOTE: Does not work when component is shared between two views
  # @param [Symbol] scope_name
  # @return [String]
  def implementation_checkbox(scope_name)
    f.label scope_name, class: "m-checkbox" do
      capture do
        concat f.check_box scope_name, {}, "true", "false"
        concat content_tag :span, t(".implementations.#{scope_name}", raise: true)
      end
    end
  end
end
