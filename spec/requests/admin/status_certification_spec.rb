# frozen_string_literal: true

RSpec.describe "Admin StatusCertification Requests", type: :request, default_auth: true do
  describe StatusCertification do
    include_examples "a solution option admin section", StatusCertification
  end
end
