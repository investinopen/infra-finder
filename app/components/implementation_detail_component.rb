# frozen_string_literal: true

# The component for rendering solution implementations in a more detailed
# fashion within the solution show / detail component.
#
# @see SolutionDetailsComponent
class ImplementationDetailComponent < ApplicationComponent
  include AcceptsImplementation

  def render?
    super && available_or_in_progress?
  end
end
