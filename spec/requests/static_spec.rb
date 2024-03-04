# frozen_string_literal: true

RSpec.describe StaticController, type: :request do
  describe ?/ do
    let_it_be(:solutions) { FactoryBot.create_list :solution, 3 }

    it "renders a successful response" do
      get root_url

      expect(response).to be_successful
    end
  end
end
