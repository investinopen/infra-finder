# frozen_string_literal: true

RSpec.describe "Admin PersistentIdentifierStandard Requests", type: :request, default_auth: true do
  describe PersistentIdentifierStandard do
    include_examples "a solution option admin section", PersistentIdentifierStandard
  end
end
