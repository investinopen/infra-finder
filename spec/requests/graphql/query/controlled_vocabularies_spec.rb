# frozen_string_literal: true

RSpec.describe "Query.controlledVocabularies", type: :request, graphql: true do
  let(:query) do
    <<~GRAPHQL
    query {
      controlledVocabularies {
        kind
        label
        recordsCount
        extraFields {
          name
          type
          required
        }
      }
    }
    GRAPHQL
  end

  as_an_anonymous_user do
    it "lists every model-backed vocabulary" do
      make_default_request!

      vocabularies = graphql_response(:data, :controlledVocabularies)

      expect(vocabularies.pluck("kind")).to match_array(Types::ControlledVocabularyKindType.values.keys)
      expect(vocabularies).to include(
        a_hash_including("kind" => "LICENSE", "label" => "Licenses", "extraFields" => [{ "name" => "url", "type" => "STRING", "required" => false }]),
        a_hash_including("kind" => "STAFFING", "extraFields" => a_collection_including(a_hash_including("name" => "minValue", "type" => "INTEGER")))
      )
    end
  end
end
