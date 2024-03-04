# frozen_string_literal: true

RSpec.describe SolutionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/solutions").to route_to("solutions#index")
    end

    it "routes to #show" do
      expect(get: "/solutions/1").to route_to("solutions#show", id: "1")
    end
  end
end
