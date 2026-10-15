# frozen_string_literal: true

RSpec.describe Mutations::ControlledVocabularyRecordDestroy, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ControlledVocabularyRecordDestroy($input: ControlledVocabularyRecordDestroyInput!) {
    controlledVocabularyRecordDestroy(input: $input) {
      destroyed
      destroyedId
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:license, refind: true) { FactoryBot.create :license }

  let_mutation_input!(:controlled_vocabulary_record_id) { license.to_encoded_id }

  let(:empty_mutation_shape) { gql.empty_mutation :controlled_vocabulary_record_destroy }

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
    it "destroys the record" do
      expected_shape = gql.mutation(:controlled_vocabulary_record_destroy) do |m|
        m[:destroyed] = true
        m[:destroyed_id] = license.to_encoded_id
      end

      expect_request! do |req|
        req.effect! change(License, :count).by(-1)

        req.data! expected_shape
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
