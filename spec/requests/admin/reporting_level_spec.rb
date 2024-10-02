# frozen_string_literal: true

RSpec.describe "Admin ReportingLevel Requests", type: :request, default_auth: true do
  describe ReportingLevel do
    include_examples "a solution option admin section", ReportingLevel
  end
end
