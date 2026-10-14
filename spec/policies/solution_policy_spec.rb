# frozen_string_literal: true

RSpec.describe SolutionPolicy, type: :policy do
  include_context "a standard policy"

  let_it_be(:other_solution, refind: true) { FactoryBot.create :solution, provider: other_provider }

  context "with a solution from the editor's provider" do
    let(:record) { solution }

    describe_rule :index? do
      it_behaves_like "an admin or editor permission"
    end

    describe_rule :show? do
      it_behaves_like "an admin or record editor permission"

      context "when published" do
        before { solution.published! }

        succeed "as another editor" do
          let(:user) { other_editor }
        end

        succeed "as an anonymous user" do
          let(:user) { nil }
        end
      end
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

    describe_rule :create_draft? do
      it_behaves_like "an admin or record editor permission"
    end

    describe_rule :show_hidden? do
      it_behaves_like "an admin or record editor permission"

      context "when published" do
        before { solution.published! }

        failed "as an anonymous user" do
          let(:user) { nil }
        end
      end
    end

    describe_rule :show_financials? do
      it_behaves_like "an admin or record editor permission"

      context "when approved for publishing" do
        before { solution.financial_numbers_approved_to_publish! }

        succeed "as an anonymous user" do
          let(:user) { nil }
        end
      end
    end

    describe_rule :fetch_public? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :publish_all? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :unpublish_all? do
      it_behaves_like "a privileged permission"
    end
  end

  context "with a solution from another provider" do
    let(:record) { other_solution }

    describe_rule :index? do
      it_behaves_like "an admin or editor permission"
    end

    describe_rule :show? do
      it_behaves_like "an admin or record editor permission", editor: :other_editor, non_editor: :editor
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

    describe_rule :create_draft? do
      it_behaves_like "an admin or record editor permission", editor: :other_editor, non_editor: :editor
    end

    describe_rule :fetch_public? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :publish_all? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :unpublish_all? do
      it_behaves_like "a privileged permission"
    end
  end

  describe "relation scope" do
    let(:record) { nil }

    let_it_be(:published_solution) { FactoryBot.create(:solution, provider: other_provider).tap(&:published!) }

    let(:scope) { policy.apply_scope(Solution.all, type: :active_record_relation) }

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

      it "includes published solutions and their own" do
        expect(scope).to contain_exactly(solution, published_solution)
      end
    end

    context "as a regular user" do
      let(:user) { regular_user }

      it "includes only published solutions" do
        expect(scope).to contain_exactly(published_solution)
      end
    end

    context "as an anonymous user" do
      let(:user) { nil }

      it "includes only published solutions" do
        expect(scope).to contain_exactly(published_solution)
      end
    end
  end
end
