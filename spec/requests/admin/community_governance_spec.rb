# frozen_string_literal: true

RSpec.describe "Admin CommunityGovernance Requests", type: :request, default_auth: true do
  describe CommunityGovernance do
    include_examples "a solution option admin section", CommunityGovernance
  end
end
