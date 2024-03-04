# frozen_string_literal: true

class ReadinessLevel < ApplicationRecord
  include SeededOption
  include SolutionOption
  include TimestampScopes

  scalar!
end
