# frozen_string_literal: true

RSpec.describe "Admin ContentLicense Requests", type: :request, default_auth: true do
  describe ContentLicense do
    include_examples "a solution option admin section", ContentLicense
  end
end
