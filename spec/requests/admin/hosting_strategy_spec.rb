# frozen_string_literal: true

RSpec.describe "Admin HostingStrategy Requests", type: :request, default_auth: true do
  describe HostingStrategy do
    include_examples "a solution option admin section", HostingStrategy
  end
end
