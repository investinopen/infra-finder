# frozen_string_literal: true

RSpec.describe SolutionIntakePolicy, type: :policy do
  include_context "a standard policy"

  let_it_be(:pending_intake, refind: true) { FactoryBot.create :solution_intake }

  let_it_be(:in_review_intake, refind: true) { FactoryBot.create(:solution_intake).tap { _1.transition_to!(:in_review) } }

  let_it_be(:rejected_intake, refind: true) do
    FactoryBot.create(:solution_intake).tap do |intake|
      intake.transition_to!(:in_review)
      intake.transition_to!(:rejected)
    end
  end

  context "with a pending intake" do
    let(:record) { pending_intake }

    describe_rule :show_hidden? do
      it_behaves_like "a full-access permission"
    end

    describe_rule :show_financials? do
      it_behaves_like "a full-access permission"
    end

    describe_rule :index? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :show? do
      it_behaves_like "a full-access permission"
    end

    describe_rule :new? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :create? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :edit? do
      it_behaves_like "a full-access permission"
    end

    describe_rule :update? do
      it_behaves_like "a full-access permission"
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
      it_behaves_like "a forbidden permission"
    end

    describe_rule :approve_all? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :reject? do
      it_behaves_like "a forbidden permission"
    end

    describe_rule :reject_all? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :reset? do
      it_behaves_like "a forbidden permission"
    end

    describe_rule :submit? do
      it_behaves_like "a full-access permission"
    end
  end

  context "with an in-review intake" do
    let(:record) { in_review_intake }

    describe_rule :index? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :show? do
      it_behaves_like "a full-access permission"
    end

    describe_rule :new? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :create? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :edit? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :update? do
      it_behaves_like "a privileged permission"
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

    describe_rule :approve_all? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :reject? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :reject_all? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :reset? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :submit? do
      it_behaves_like "a forbidden permission"
    end
  end

  context "with a rejected intake" do
    let(:record) { rejected_intake }

    describe_rule :show_hidden? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :index? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :show? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :new? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :create? do
      it_behaves_like "a privileged permission"
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
      it_behaves_like "a forbidden permission"
    end

    describe_rule :approve_all? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :reject? do
      it_behaves_like "a forbidden permission"
    end

    describe_rule :reject_all? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :reset? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :submit? do
      it_behaves_like "a forbidden permission"
    end
  end

  describe "relation scope" do
    let(:record) { nil }

    let(:scope) { policy.apply_scope(SolutionIntake.all, type: :active_record_relation) }

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

      it_behaves_like "a no access scope"
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
