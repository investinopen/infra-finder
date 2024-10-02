# frozen_string_literal: true

RSpec.describe "Admin ValuesFramework Requests", type: :request, default_auth: true do
  describe ValuesFramework do
    include_examples "a solution option admin section", ValuesFramework
  end
end
