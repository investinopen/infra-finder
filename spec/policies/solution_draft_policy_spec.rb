# frozen_string_literal: true

RSpec.describe SolutionDraftPolicy, type: :policy do
  include_context "a standard policy"

  let_it_be(:other_solution, refind: true) { FactoryBot.create :solution, provider: other_provider }

  let_it_be(:pending_draft, refind: true) { solution.create_draft!(user: FactoryBot.create(:user)) }

  let_it_be(:in_review_draft, refind: true) { solution.create_draft!(user: FactoryBot.create(:user)).tap(&:request_review!) }

  let_it_be(:approved_draft, refind: true) do
    solution.create_draft!(user: FactoryBot.create(:user)).tap do |draft|
      draft.request_review!
      draft.transition_to!(:approved)
    end
  end

  let_it_be(:other_draft, refind: true) { other_solution.create_draft!(user: FactoryBot.create(:user)) }

  context "with a pending draft from the editor's provider" do
    let(:record) { pending_draft }

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
      it_behaves_like "an admin or record editor permission"
    end

    describe_rule :update? do
      it_behaves_like "an admin or record editor permission"
    end

    describe_rule :destroy? do
      it_behaves_like "an admin or record editor permission"
    end

    describe_rule :destroy_all? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :batch_action? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :approve? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :reject? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :request_review? do
      it_behaves_like "an admin or record editor permission"
    end

    describe_rule :request_revision? do
      it_behaves_like "a privileged permission"
    end
  end

  context "with an in-review draft from the editor's provider" do
    let(:record) { in_review_draft }

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
      it_behaves_like "an admin or record editor permission"
    end

    describe_rule :update? do
      it_behaves_like "an admin or record editor permission"
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

    describe_rule :approve? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :reject? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :request_review? do
      it_behaves_like "an admin or record editor permission"
    end

    describe_rule :request_revision? do
      it_behaves_like "a privileged permission"
    end
  end

  context "with an approved draft from the editor's provider" do
    let(:record) { approved_draft }

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
      it_behaves_like "a forbidden permission"
    end

    describe_rule :update? do
      it_behaves_like "a forbidden permission"
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

    describe_rule :approve? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :reject? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :request_review? do
      it_behaves_like "a forbidden permission"
    end

    describe_rule :request_revision? do
      it_behaves_like "a privileged permission"
    end
  end

  context "with a pending draft from another provider" do
    let(:record) { other_draft }

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
      it_behaves_like "an admin or record editor permission", editor: :other_editor, non_editor: :editor
    end

    describe_rule :update? do
      it_behaves_like "an admin or record editor permission", editor: :other_editor, non_editor: :editor
    end

    describe_rule :destroy? do
      it_behaves_like "an admin or record editor permission", editor: :other_editor, non_editor: :editor
    end

    describe_rule :destroy_all? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :batch_action? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :approve? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :reject? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :request_review? do
      it_behaves_like "an admin or record editor permission", editor: :other_editor, non_editor: :editor
    end

    describe_rule :request_revision? do
      it_behaves_like "a privileged permission"
    end
  end

  describe "relation scope" do
    let(:record) { nil }

    let(:scope) { policy.apply_scope(SolutionDraft.all, type: :active_record_relation) }

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
        expect(scope).to match_array(solution.solution_drafts)
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
