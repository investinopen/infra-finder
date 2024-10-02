# frozen_string_literal: true

RSpec.describe "Admin MetricsStandard Requests", type: :request, default_auth: true do
  describe MetricsStandard do
    include_examples "a solution option admin section", MetricsStandard
  end
end
