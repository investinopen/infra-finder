# frozen_string_literal: true

class PrimaryFundingSource < ApplicationRecord
  include SeededOption
  include SolutionOption
  include TimestampScopes

  single!
end
