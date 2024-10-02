# frozen_string_literal: true

RSpec.describe "Admin Integration Requests", type: :request, default_auth: true do
  describe Integration do
    include_examples "a solution option admin section", Integration
  end
end
