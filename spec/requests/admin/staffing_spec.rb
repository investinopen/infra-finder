# frozen_string_literal: true

RSpec.describe "Admin Staffing Requests", type: :request, default_auth: true do
  describe Staffing do
    include_examples "a solution option admin section", Staffing
  end
end
