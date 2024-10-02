# frozen_string_literal: true

RSpec.describe "Admin ReadinessLevel Requests", type: :request, default_auth: true do
  describe ReadinessLevel do
    include_examples "a solution option admin section", ReadinessLevel
  end
end
