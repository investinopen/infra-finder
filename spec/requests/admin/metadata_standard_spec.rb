# frozen_string_literal: true

RSpec.describe "Admin MetadataStandard Requests", type: :request, default_auth: true do
  describe MetadataStandard do
    include_examples "a solution option admin section", MetadataStandard
  end
end
