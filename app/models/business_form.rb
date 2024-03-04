# frozen_string_literal: true

class BusinessForm < ApplicationRecord
  include SeededOption
  include SolutionOption
  include TimestampScopes

  scalar!
end
