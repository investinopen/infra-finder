# frozen_string_literal: true

RSpec.describe "Admin SolutionCategory Requests", type: :request, default_auth: true do
  describe SolutionCategory do
    include_examples "a solution option admin section", SolutionCategory
  end
end
