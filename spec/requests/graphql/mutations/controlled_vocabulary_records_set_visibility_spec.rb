# frozen_string_literal: true

RSpec.describe Mutations::ControlledVocabularyRecordsSetVisibility, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ControlledVocabularyRecordsSetVisibility($input: ControlledVocabularyRecordsSetVisibilityInput!) {
    controlledVocabularyRecordsSetVisibility(input: $input) {
      controlledVocabularyRecords {
        id
        visibility
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:license, refind: true) { FactoryBot.create :license, visibility: "visible" }

  let_it_be(:language, refind: true) { FactoryBot.create :programming_language, visibility: "visible" }

  let_mutation_input!(:controlled_vocabulary_record_ids) { [license.to_encoded_id, language.to_encoded_id] }
  let_mutation_input!(:visibility) { "HIDDEN" }

  let(:empty_mutation_shape) { gql.empty_mutation :controlled_vocabulary_records_set_visibility }

  shared_examples_for "an unauthorized mutation" do
    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! empty_mutation_shape
      end
    end
  end

  as_a_super_admin_user do
    it "updates every record, across vocabularies" do
      expect_request! do |req|
        req.effect! change { license.reload.visibility }.from("visible").to("hidden")
        req.effect! change { language.reload.visibility }.from("visible").to("hidden")
      end

      expect(graphql_response(:data, :controlledVocabularyRecordsSetVisibility, :controlledVocabularyRecords).pluck("visibility")).to eq %w[HIDDEN HIDDEN]
    end

    context "when making an always-hidden record visible" do
      let_mutation_input!(:visibility) { "VISIBLE" }

      before { license.update_columns(provides: License.auto_hidden_provisions.first, visibility: "hidden") }

      it "fails" do
        expected_shape = gql.mutation(:controlled_vocabulary_records_set_visibility, no_errors: false) do |m|
          m.attribute_errors do |ae|
            ae.error :visibility, :cannot_be_visible
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same { license.reload.visibility }

          req.data! expected_shape
        end
      end
    end

    context "when one record is invalid" do
      before { language.update_column(:term, "bad|term") }

      it "reports it and changes nothing" do
        expected_shape = gql.mutation(:controlled_vocabulary_records_set_visibility, no_errors: false) do |m|
          m[:controlled_vocabulary_records] = be_blank

          m.global_errors do |ge|
            ge.error(/Term/, type: "$model_error")
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same { license.reload.visibility }

          req.data! expected_shape
        end
      end
    end
  end

  as_an_admin_user do
    include_examples "an unauthorized mutation"
  end

  as_an_editor_user do
    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"

    context "with no records" do
      let_mutation_input!(:controlled_vocabulary_record_ids) { [] }

      include_examples "an unauthorized mutation"
    end
  end
end
