# frozen_string_literal: true

RSpec.describe "Solution.logo", type: :request, graphql: true do
  let_it_be(:solution, refind: true) do
    FactoryBot.create(:solution).tap do |solution|
      solution.logo_attacher.attach Rails.root.join("spec", "data", "logo.svg").open("r"), metadata: { "alt" => "A logo" }
      solution.logo_attacher.create_derivatives
      solution.published!
    end
  end

  let(:query) do
    <<~GRAPHQL
    query($slug: Slug!) {
      solution(slug: $slug) {
        logo {
          storage
          alt
          purpose
          original { url }
          thumb {
            size
            png { format url width height maxWidth }
            webp { format url }
          }
        }
        logoMetadata { alt }
      }
    }
    GRAPHQL
  end

  before do
    make_graphql_request! query, token:, variables: { slug: solution.system_slug }, operation: nil
  end

  as_an_anonymous_user do
    it "exposes the image and its derivatives" do
      expect(graphql_response(:data, :solution)).to include(
        "logo" => include(
          "storage" => "STORE",
          "alt" => "A logo",
          "purpose" => "LOGO",
          "original" => { "url" => be_present },
          "thumb" => {
            "size" => "THUMB",
            "png" => { "format" => "PNG", "url" => be_present, "width" => 200, "height" => 150, "maxWidth" => 200 },
            "webp" => { "format" => "WEBP", "url" => be_present },
          }
        ),
        "logoMetadata" => { "alt" => "A logo" }
      )
    end
  end
end
