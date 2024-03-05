# frozen_string_literal: true

class BoardStructure < ApplicationRecord
  include SeededOption
  include SolutionOption
  include TimestampScopes

  single!
end
