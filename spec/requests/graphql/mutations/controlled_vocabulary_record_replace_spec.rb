# frozen_string_literal: true

RSpec.describe Mutations::ControlledVocabularyRecordReplace, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ControlledVocabularyRecordReplace($input: ControlledVocabularyRecordReplaceInput!) {
    controlledVocabularyRecordReplace(input: $input) {
      replacement {
        id
        solutionsCount
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:old_license, refind: true) { FactoryBot.create :license }

  let_it_be(:new_license, refind: true) { FactoryBot.create :license }

  let_it_be(:solution, refind: true) { FactoryBot.create(:solution).tap { _1.update!(licenses: [old_license]) } }

  let(:replacement) { new_license }

  let_mutation_input!(:controlled_vocabulary_record_id) { old_license.to_encoded_id }
  let_mutation_input!(:replacement_id) { replacement.to_encoded_id }

  let(:empty_mutation_shape) { gql.empty_mutation :controlled_vocabulary_record_replace }

  shared_examples_for "an unauthorized mutation" do
    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! empty_mutation_shape
      end
    end
  end

  shared_examples_for "an authorized mutation" do
    it "moves the solutions to the replacement and deletes the original" do
      expected_shape = gql.mutation(:controlled_vocabulary_record_replace) do |m|
        m.prop(:replacement) do |r|
          r[:id] = new_license.to_encoded_id
          r[:solutions_count] = 1
        end
      end

      expect_request! do |req|
        req.effect! change(License, :count).by(-1)
        req.effect! change { solution.reload.licenses.to_a }.from([old_license]).to([new_license])

        req.data! expected_shape
      end
    end

    context "with a record from another vocabulary" do
      let(:replacement) { FactoryBot.create :programming_language }

      it "fails" do
        expected_shape = gql.mutation(:controlled_vocabulary_record_replace, no_errors: false) do |m|
          m.attribute_errors do |ae|
            ae.error :replacement_id, :must_be_same_vocabulary
          end
        end

        expect_request! do |req|
          req.effect! keep_the_same(License, :count)

          req.data! expected_shape
        end
      end
    end

    context "with the same record" do
      let(:replacement) { old_license }

      it "fails" do
        expected_shape = gql.mutation(:controlled_vocabulary_record_replace, no_errors: false) do |m|
          m.attribute_errors do |ae|
            ae.error :replacement_id, :must_be_a_different_record
          end
        end

        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end
  end

  as_a_super_admin_user do
    include_examples "an authorized mutation"
  end

  as_an_admin_user do
    include_examples "an authorized mutation"
  end

  as_an_editor_user do
    include_examples "an unauthorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
