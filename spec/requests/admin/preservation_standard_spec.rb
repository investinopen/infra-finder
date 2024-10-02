# frozen_string_literal: true

RSpec.describe "Admin PreservationStandard Requests", type: :request, default_auth: true do
  describe PreservationStandard do
    include_examples "a solution option admin section", PreservationStandard
  end
end
