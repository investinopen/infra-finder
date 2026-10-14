# frozen_string_literal: true

RSpec.describe SolutionRevisionPolicy, type: :policy do
  include_context "a standard policy"

  let_it_be(:other_solution, refind: true) { FactoryBot.create :solution, provider: other_provider }

  let_it_be(:revision, refind: true) { solution.initialize_revision! }

  let_it_be(:other_revision, refind: true) { other_solution.initialize_revision! }

  context "with a revision from the editor's provider" do
    let(:record) { revision }

    describe_rule :index? do
      it_behaves_like "an admin or editor permission"
    end

    describe_rule :show? do
      it_behaves_like "an admin or record editor permission"
    end

    describe_rule :new? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :create? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :edit? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :update? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :destroy? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :destroy_all? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :batch_action? do
      it_behaves_like "a super admin permission"
    end
  end

  context "with a revision from another provider" do
    let(:record) { other_revision }

    describe_rule :index? do
      it_behaves_like "an admin or editor permission"
    end

    describe_rule :show? do
      it_behaves_like "an admin or record editor permission", editor: :other_editor, non_editor: :editor
    end

    describe_rule :new? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :create? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :edit? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :update? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :destroy? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :destroy_all? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :batch_action? do
      it_behaves_like "a super admin permission"
    end
  end

  describe "relation scope" do
    let(:record) { nil }

    let(:scope) { policy.apply_scope(SolutionRevision.all, type: :active_record_relation) }

    context "as a super admin" do
      let(:user) { super_admin }

      it_behaves_like "a full access scope"
    end

    context "as an admin" do
      let(:user) { admin }

      it_behaves_like "a full access scope"
    end

    context "as an editor" do
      let(:user) { editor }

      it "includes only their solutions' records" do
        expect(scope).to match_array([revision])
      end
    end

    context "as a regular user" do
      let(:user) { regular_user }

      it_behaves_like "a no access scope"
    end

    context "as an anonymous user" do
      let(:user) { nil }

      it_behaves_like "a no access scope"
    end
  end
end
