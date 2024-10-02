# frozen_string_literal: true

RSpec.describe "Admin BoardStructure Requests", type: :request, default_auth: true do
  describe BoardStructure do
    include_examples "a solution option admin section", BoardStructure
  end
end
