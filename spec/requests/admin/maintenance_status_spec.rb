# frozen_string_literal: true

RSpec.describe "Admin MaintenanceStatus Requests", type: :request, default_auth: true do
  describe MaintenanceStatus do
    include_examples "a solution option admin section", MaintenanceStatus
  end
end