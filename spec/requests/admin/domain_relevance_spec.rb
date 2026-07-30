# frozen_string_literal: true

RSpec.describe "Admin DomainRelevance Requests", type: :request, default_auth: true do
  describe DomainRelevance do
    include_examples "a solution option admin section", DomainRelevance
  end
end
