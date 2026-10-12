# frozen_string_literal: true

RSpec.describe SolutionImportPolicy, type: :policy do
  include_context "a standard policy"

  let_it_be(:solution_import, refind: true) { FactoryBot.create :solution_import }

  context "with a solution import" do
    let(:record) { solution_import }

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
      it_behaves_like "a privileged permission"
    end

    describe_rule :update? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :destroy? do
      it_behaves_like "a privileged permission"
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

    let(:scope) { policy.apply_scope(SolutionImport.all, type: :active_record_relation) }

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

      it_behaves_like "a full access scope"
    end

    context "as another provider's editor" do
      let(:user) { other_editor }

      it_behaves_like "a full access scope"
    end

    context "as a regular user" do
      let(:user) { regular_user }

      it_behaves_like "a full access scope"
    end

    context "as an anonymous user" do
      let(:user) { nil }

      it_behaves_like "a full access scope"
    end
  end
end
