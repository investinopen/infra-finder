# frozen_string_literal: true

RSpec.describe "Query.solutionProperties", type: :request, graphql: true do
  let(:query) do
    <<~GRAPHQL
    query {
      solutionProperties {
        key
        fieldName
        required
        availableOn
        valueType {
          __typename
          ... on ScalarValue { scalar maxLength }
          ... on EnumValue { options { label value } }
          ... on VocabularyValue { multiple otherPropertyKey vocabulary { kind } }
          ... on AssociationValue { typeName multiple }
          ... on StructuredListValue { freeInputKey fields { name scalar required } }
          ... on ImplementationValue { linkMode statusPropertyKey }
        }
      }

      solutionPropertyTabs {
        name
        properties { key }
      }
    }
    GRAPHQL
  end

  def properties = graphql_response(:data, :solutionProperties)

  def property(key) = properties.find { _1["key"] == key }

  def value_type(key) = property(key)["valueType"]

  as_an_anonymous_user do
    it "describes every property that holds a value" do
      make_default_request!

      expect(properties.pluck("key")).to match_array(SolutionProperty.in_use.reject { _1.kind.in?(%i[standard implementation_property]) }.map(&:name))
    end

    it "describes each kind of value" do
      make_default_request!

      expect(value_type("name")).to eq("__typename" => "ScalarValue", "scalar" => "STRING", "maxLength" => 175)
      expect(value_type("founded_on")).to include("scalar" => "YEAR")
      expect(property("provider_name")).to include("fieldName" => "provider", "valueType" => { "__typename" => "AssociationValue", "typeName" => "Provider", "multiple" => false })
      expect(value_type("country_code")).to include("__typename" => "EnumValue", "options" => a_collection_including("label" => "Andorra", "value" => "AD"))
      expect(value_type("financial_numbers_publishability")["options"]).to include("label" => "Approved", "value" => "APPROVED")
      expect(value_type("board_structures")).to eq(
        "__typename" => "VocabularyValue", "multiple" => true, "otherPropertyKey" => "board_structure_other", "vocabulary" => { "kind" => "BOARD_STRUCTURE" }
      )
      expect(value_type("recent_grants")).to include(
        "__typename" => "StructuredListValue",
        "freeInputKey" => "recent_grant_free_input",
        "fields" => a_collection_including({ "name" => "startsOn", "scalar" => "DATE", "required" => false }, { "name" => "awardAnnouncementURL", "scalar" => "URL", "required" => false })
      )
      expect(value_type("current_affiliations")["fields"]).to include("name" => "name", "scalar" => "STRING", "required" => true)
      expect(value_type("code_repository")).to eq(
        "__typename" => "ImplementationValue", "linkMode" => "MANY", "statusPropertyKey" => "code_repository_implementation"
      )
      expect(property("code_repository_implementation")).to include(
        "fieldName" => "codeRepositoryImplementation",
        "valueType" => include("__typename" => "EnumValue", "options" => a_collection_including("label" => "Implemented/available", "value" => "AVAILABLE"))
      )
      expect(value_type("pricing_implementation")["options"]).to include("label" => a_kind_of(String), "value" => "NO_DIRECT_COSTS")
      expect(property("publication")).to include("availableOn" => ["ACTUAL"], "fieldName" => "publication")
    end

    it "lays out the form's tabs" do
      make_default_request!

      tabs = graphql_response(:data, :solutionPropertyTabs)

      expect(tabs.pluck("name")).to eq AdminTab.pluck(:name)
      expect(tabs.first["properties"].pluck("key")).to start_with("name")
    end

    it "names only fields that exist on SolutionInterface or the timestamps interface" do
      make_default_request!

      interface_fields = Types::SolutionInterfaceType.fields.keys + Types::HasDefaultTimestampsType.fields.keys

      shared = properties.select { _1["availableOn"].size == 3 && _1["fieldName"].present? }

      expect(shared.pluck("fieldName")).to all(be_in(interface_fields))
    end

    it "names fields that exist on the type for each solution kind" do
      make_default_request!

      types = { "ACTUAL" => Types::SolutionType, "DRAFT" => Types::SolutionDraftType, "INTAKE" => Types::SolutionIntakeType }

      properties.select { _1["fieldName"].present? }.each do |prop|
        prop["availableOn"].each do |kind|
          expect(types.fetch(kind).fields.keys).to include(prop["fieldName"]), "#{prop["key"]} is missing from #{kind}"
        end
      end
    end
  end
end
