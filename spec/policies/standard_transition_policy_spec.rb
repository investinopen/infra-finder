# frozen_string_literal: true

RSpec.describe StandardTransitionPolicy, type: :policy do
  include_context "a standard policy"

  let_it_be(:transition, refind: true) { FactoryBot.create(:solution_intake).tap { _1.transition_to!(:in_review) }.solution_intake_transitions.last }

  context "with a transition" do
    let(:record) { transition }

    describe_rule :index? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :show? do
      it_behaves_like "a full-access permission"
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

  context "with a transition whose owner is admin-only" do
    let_it_be(:invitation_transition, refind: true) { FactoryBot.create(:invitation).invitation_transitions.last }

    let(:record) { invitation_transition }

    describe_rule :show? do
      it_behaves_like "a privileged permission"
    end
  end
end
