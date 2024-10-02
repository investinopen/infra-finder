# frozen_string_literal: true

RSpec.describe "Admin ProgrammingLanguage Requests", type: :request, default_auth: true do
  describe ProgrammingLanguage do
    include_examples "a solution option admin section", ProgrammingLanguage
  end
end
