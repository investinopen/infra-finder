# frozen_string_literal: true

RSpec.describe "Admin UserContribution Requests", type: :request, default_auth: true do
  describe UserContribution do
    include_examples "a solution option admin section", UserContribution
  end
end
