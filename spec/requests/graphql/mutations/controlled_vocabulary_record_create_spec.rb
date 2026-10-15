# frozen_string_literal: true

RSpec.describe Mutations::ControlledVocabularyRecordCreate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ControlledVocabularyRecordCreate($input: ControlledVocabularyRecordCreateInput!) {
    controlledVocabularyRecordCreate(input: $input) {
      controlledVocabularyRecord {
        __typename
        name
        term
        visibility
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let(:new_term) { "new-license" }

  let_mutation_input!(:kind) { "LICENSE" }
  let_mutation_input!(:name) { "New License" }
  let_mutation_input!(:term) { new_term }
  let_mutation_input!(:visibility) { "HIDDEN" }

  let(:empty_mutation_shape) { gql.empty_mutation :controlled_vocabulary_record_create }

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
    it "creates a record in the chosen vocabulary" do
      expected_shape = gql.mutation(:controlled_vocabulary_record_create) do |m|
        m.prop(:controlled_vocabulary_record) do |r|
          r[:__typename] = "License"
          r[:name] = "New License"
          r[:term] = new_term
          r[:visibility] = "HIDDEN"
        end
      end

      expect_request! do |req|
        req.effect! change(License, :count).by(1)

        req.data! expected_shape
      end
    end

    context "with a term already in use" do
      let(:new_term) { FactoryBot.create(:license).term }

      it "fails" do
        expected_shape = gql.mutation(:controlled_vocabulary_record_create, no_errors: false) do |m|
          m[:controlled_vocabulary_record] = be_blank

          m.attribute_errors do |ae|
            ae.error :term, :must_be_unique
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same(License, :count)

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
