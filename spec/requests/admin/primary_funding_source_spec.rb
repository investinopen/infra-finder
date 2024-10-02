# frozen_string_literal: true

RSpec.describe "Admin PrimaryFundingSource Requests", type: :request, default_auth: true do
  describe PrimaryFundingSource do
    include_examples "a solution option admin section", PrimaryFundingSource
  end
end
