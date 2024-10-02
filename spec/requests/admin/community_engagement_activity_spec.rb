# frozen_string_literal: true

RSpec.describe "Admin CommunityEngagementActivity Requests", type: :request, default_auth: true do
  describe CommunityEngagementActivity do
    include_examples "a solution option admin section", CommunityEngagementActivity
  end
end
