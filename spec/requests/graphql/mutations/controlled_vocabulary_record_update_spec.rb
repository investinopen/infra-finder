# frozen_string_literal: true

RSpec.describe Mutations::ControlledVocabularyRecordUpdate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ControlledVocabularyRecordUpdate($input: ControlledVocabularyRecordUpdateInput!) {
    controlledVocabularyRecordUpdate(input: $input) {
      controlledVocabularyRecord {
        name
        term
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:license, refind: true) { FactoryBot.create :license, name: "Old Name" }

  let_mutation_input!(:controlled_vocabulary_record_id) { license.to_encoded_id }
  let_mutation_input!(:name) { "New Name" }

  let(:empty_mutation_shape) { gql.empty_mutation :controlled_vocabulary_record_update }

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
    it "updates only the given fields" do
      expected_shape = gql.mutation(:controlled_vocabulary_record_update) do |m|
        m.prop(:controlled_vocabulary_record) do |r|
          r[:name] = "New Name"
          r[:term] = license.term
        end
      end

      expect_request! do |req|
        req.effect! change { license.reload.name }.from("Old Name").to("New Name")

        req.data! expected_shape
      end
    end

    context "when making an always-hidden record visible" do
      let_mutation_input!(:visibility) { "VISIBLE" }

      before { license.update_columns(provides: License.auto_hidden_provisions.first, visibility: "hidden") }

      it "fails" do
        expected_shape = gql.mutation(:controlled_vocabulary_record_update, no_errors: false) do |m|
          m.attribute_errors do |ae|
            ae.error :visibility, :cannot_be_visible
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same { license.reload.name }

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
  end
end
