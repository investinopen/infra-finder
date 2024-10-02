# frozen_string_literal: true

RSpec.describe "Admin AccessibilityScope Requests", type: :request, default_auth: true do
  describe AccessibilityScope do
    include_examples "a solution option admin section", AccessibilityScope
  end
end
