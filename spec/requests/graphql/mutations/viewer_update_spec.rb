# frozen_string_literal: true

RSpec.describe Mutations::ViewerUpdate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation ViewerUpdate($input: ViewerUpdateInput!) {
    viewerUpdate(input: $input) {
      user {
        id
        slug
        name
        email
        unconfirmedEmail
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let(:email) { nil }
  let(:name) { nil }

  let_mutation_input!(:password) { nil }
  let_mutation_input!(:password_confirmation) { nil }
  let_mutation_input!(:current_password) { nil }

  let(:changing_email) { email.present? && email != current_user.email }
  let(:changing_name) { name.present? && name != current_user.name }
  let(:changing_password) { password.present? }

  let(:correct_password) { "123456" }

  let(:valid_mutation_shape) do
    gql.mutation(:viewer_update) do |m|
      m.prop(:user) do |u|
        u[:id] = current_user.to_encoded_id
        u[:slug] = current_user.system_slug
        u[:email] = current_user.email

        if changing_email
          u[:unconfirmed_email] = email
        else
          u[:unconfirmed_email] = nil
        end

        if changing_name
          u[:name] = name
        else
          u[:name] = current_user.name
        end
      end
    end
  end

  let(:password_mismatch_shape) do
    gql.mutation(:viewer_update, no_errors: false) do |m|
      m[:user] = be_blank

      m.attribute_errors do |ae|
        ae.error :password_confirmation, :must_match_password
      end
    end
  end

  let(:password_required_shape) do
    gql.mutation(:viewer_update, no_global_errors: false) do |m|
      m[:user] = be_blank

      m.global_errors do |ge|
        ge.error(:current_password_required)
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :viewer_update
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "updates the viewer" do
      expect_request! do |req|
        req.effect! change { current_user.reload.updated_at }
        req.effect! keep_the_same { current_user.reload.email }

        if changing_email
          req.effect! change { current_user.reload.unconfirmed_email }
        end

        if changing_name
          req.effect! change { current_user.reload.name }
        else
          req.effect! keep_the_same { current_user.reload.name }
        end

        if changing_password
          req.effect! change { current_user.reload.valid_password?(password) }.from(false).to(true)

          req.effect! change { current_user.reload.encrypted_password }
        else
          req.effect! keep_the_same { current_user.reload.encrypted_password }
        end

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "a mutation that required current password but failed" do
    let(:expected_shape) { password_required_shape }

    it "requires the current password" do
      expect_request! do |req|
        req.effect! keep_the_same { current_user.reload.updated_at }

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "a privileged mutation" do
    context "when the password is provided and correct" do
      let_mutation_input!(:current_password) { correct_password }

      include_examples "a successful mutation"
    end

    context "when the password is provided but incorrect" do
      let_mutation_input!(:current_password) { "incorrect value!" }

      include_examples "a mutation that required current password but failed"
    end

    context "when the password is not provided" do
      let_mutation_input!(:current_password) { nil }

      include_examples "a mutation that required current password but failed"
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an authorized mutation" do
    specify "sanity check: password authenticates" do
      expect(current_user).to be_valid_password correct_password
    end

    context "when updating the name" do
      let_mutation_input!(:name) { "New Name" }

      include_examples "a successful mutation"
    end

    context "when updating the email" do
      let_mutation_input!(:email) { "new_email@example.com" }

      include_examples "a privileged mutation"
    end

    context "when updating the password" do
      let_mutation_input!(:password) { "new_password" }

      context "when the confirmation matches" do
        let_mutation_input!(:password_confirmation) { "new_password" }

        include_examples "a privileged mutation"
      end

      context "when the confirmation does not match" do
        let_mutation_input!(:password_confirmation) { "different_password" }

        let_mutation_input!(:current_password) { correct_password }

        let(:expected_shape) { password_mismatch_shape }

        it "fails with a password mismatch error" do
          expect_request! do |req|
            req.effect! execute_safely

            req.data! expected_shape
          end
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
    include_examples "an authorized mutation"
  end

  as_an_anonymous_user do
    include_examples "an unauthorized mutation"
  end
end
