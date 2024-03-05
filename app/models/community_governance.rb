# frozen_string_literal: true

class CommunityGovernance < ApplicationRecord
  include SeededOption
  include SolutionOption
  include TimestampScopes

  single!
end
