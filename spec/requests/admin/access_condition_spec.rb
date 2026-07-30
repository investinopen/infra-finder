# frozen_string_literal: true

RSpec.describe "Admin AccessCondition Requests", type: :request, default_auth: true do
  describe AccessCondition do
    include_examples "a solution option admin section", AccessCondition
  end
end
