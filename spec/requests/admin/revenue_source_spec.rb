# frozen_string_literal: true

RSpec.describe "Admin RevenueSource Requests", type: :request, default_auth: true do
  describe RevenueSource do
    include_examples "a solution option admin section", RevenueSource
  end
end
