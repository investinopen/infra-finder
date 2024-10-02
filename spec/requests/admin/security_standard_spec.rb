# frozen_string_literal: true

RSpec.describe "Admin SecurityStandard Requests", type: :request, default_auth: true do
  describe SecurityStandard do
    include_examples "a solution option admin section", SecurityStandard
  end
end
