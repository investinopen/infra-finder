# frozen_string_literal: true

RSpec.describe SolutionEditorAssignmentPolicy, type: :policy do
  include_context "a standard policy"

  let_it_be(:assignment, refind: true) { FactoryBot.create :solution_editor_assignment, solution:, user: regular_user }

  context "with a solution editor assignment" do
    let(:record) { assignment }

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
end
