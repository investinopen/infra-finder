# frozen_string_literal: true

RSpec.describe "GraphQL Introspection", type: :request, graphql: true do
  let(:query) { File.read(File.join(__dir__, "introspection.graphql")) }

  as_an_anonymous_user do
    it "can introspect without issue" do
      expect_request! do |req|
        req.effect! execute_safely
      end
    end
  end

  as_an_admin_user do
    it "can introspect without issue" do
      expect_request! do |req|
        req.effect! execute_safely
      end
    end
  end
end
