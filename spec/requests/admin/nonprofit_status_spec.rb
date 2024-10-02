# frozen_string_literal: true

RSpec.describe "Admin NonprofitStatus Requests", type: :request, default_auth: true do
  describe NonprofitStatus do
    include_examples "a solution option admin section", NonprofitStatus
  end
end
