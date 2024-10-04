# frozen_string_literal: true

# The component for rendering solution implementation statements
# within the solution show / detail component.
class ImplementationStatementComponent < ApplicationComponent
  include AcceptsImplementation

  def render?
    # super && implementation.statement?
    false
  end
end
