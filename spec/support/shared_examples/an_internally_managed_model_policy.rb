# frozen_string_literal: true

RSpec.shared_examples_for "an internally-managed model policy" do
  include_context "policy testing"

  include_examples "default application policy examples"
end
