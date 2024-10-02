# frozen_string_literal: true

RSpec.describe "Admin License Requests", type: :request, default_auth: true do
  describe License do
    include_examples "a solution option admin section", License
  end
end
