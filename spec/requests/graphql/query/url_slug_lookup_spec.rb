# frozen_string_literal: true

RSpec.describe "Looking up records by urlSlug", type: :request, graphql: true do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution, :published, name: "Manifold" }

  let_it_be(:unpublished, refind: true) { FactoryBot.create :solution, name: "Hidden Away" }

  let_it_be(:provider, refind: true) { FactoryBot.create :provider, name: "Cast Iron" }

  let_it_be(:license, refind: true) { FactoryBot.create :license, name: "Alpha License" }

  def lookup!(query, **variables)
    make_graphql_request! query, token:, variables:, operation: nil
  end

  as_an_anonymous_user do
    describe "Query.solution" do
      let(:query) do
        <<~GRAPHQL
        query($slug: Slug, $urlSlug: String) {
          solution(slug: $slug, urlSlug: $urlSlug) { name urlSlug }
        }
        GRAPHQL
      end

      it "finds a solution by its current slug" do
        lookup! query, url_slug: "manifold"

        expect(graphql_response(:data, :solution)).to eq("name" => "Manifold", "urlSlug" => "manifold")
      end

      it "finds a solution by a previous slug" do
        solution.update!(name: "Manifold Two", slug: nil)

        lookup! query, url_slug: "manifold"

        expect(graphql_response(:data, :solution)).to eq("name" => "Manifold Two", "urlSlug" => "manifold-two")
      end

      it "returns null for an unknown slug" do
        lookup! query, url_slug: "nope"

        expect(graphql_response(:data, :solution)).to be_nil
      end

      it "does not reveal an unpublished solution" do
        lookup! query, url_slug: unpublished.slug

        expect(graphql_response(:data, :solution)).to be_nil
      end

      it "still finds a solution by its encoded slug" do
        lookup! query, slug: solution.system_slug

        expect(graphql_response(:data, :solution, :name)).to eq "Manifold"
      end

      it "requires one of slug or urlSlug" do
        make_graphql_request! query, token:, variables: {}, operation: nil, no_top_level_errors: false

        expect(graphql_response(:errors)).to be_present
      end
    end

    describe "Query.provider" do
      let(:query) do
        <<~GRAPHQL
        query($urlSlug: String) {
          provider(urlSlug: $urlSlug) { name }
        }
        GRAPHQL
      end

      it "finds a provider by its slug" do
        lookup! query, url_slug: "cast-iron"

        expect(graphql_response(:data, :provider, :name)).to eq "Cast Iron"
      end
    end

    describe "ControlledVocabulary.record" do
      let(:query) do
        <<~GRAPHQL
        query($urlSlug: String!) {
          controlledVocabulary(kind: LICENSE) {
            record(urlSlug: $urlSlug) { name urlSlug }
          }
        }
        GRAPHQL
      end

      it "finds a record by its slug" do
        lookup! query, url_slug: license.slug

        expect(graphql_response(:data, :controlledVocabulary, :record, :name)).to eq "Alpha License"
      end

      it "returns null for an unknown slug" do
        lookup! query, url_slug: "nope"

        expect(graphql_response(:data, :controlledVocabulary, :record)).to be_nil
      end
    end
  end
end
