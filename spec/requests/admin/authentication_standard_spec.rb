# frozen_string_literal: true

RSpec.describe "Admin AuthenticationStandard Requests", type: :request, default_auth: true do
  describe AuthenticationStandard do
    include_examples "a solution option admin section", AuthenticationStandard
  end
end
