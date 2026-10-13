# frozen_string_literal: true

RSpec.describe UserPolicy, type: :policy do
  include_context "a standard policy"

  context "with the editor's account" do
    let(:record) { editor }

    describe_rule :index? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :show? do
      it_behaves_like "an admin or self permission", self_user: :editor
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

    describe_rule :send_reset_password_instructions? do
      it_behaves_like "an admin or self permission", self_user: :editor
    end

    describe_rule :manage_own_session? do
      succeed "as the editor" do
        let(:user) { editor }
      end

      failed "as a super admin" do
        let(:user) { super_admin }
      end

      failed "as another provider's editor" do
        let(:user) { other_editor }
      end

      failed "as an anonymous user" do
        let(:user) { nil }
      end

      failed "as a GraphQL anonymous user" do
        let(:user) { AnonymousUser.new }
      end
    end
  end

  context "with a GraphQL anonymous user as the record" do
    let(:record) { AnonymousUser.new }

    describe_rule :manage_own_session? do
      failed "as the same anonymous user" do
        let(:user) { record }
      end
    end
  end

  context "with the regular user's account" do
    let(:record) { regular_user }

    describe_rule :index? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :show? do
      it_behaves_like "an admin or self permission", self_user: :regular_user
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

    describe_rule :send_reset_password_instructions? do
      it_behaves_like "an admin or self permission", self_user: :regular_user
    end
  end

  describe "relation scope" do
    let(:record) { nil }

    let(:scope) { policy.apply_scope(User.all, type: :active_record_relation) }

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

  describe "api relation scope" do
    let(:record) { nil }

    let(:scope) { policy.apply_scope(User.all, type: :active_record_relation, name: :api) }

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

      it "includes only themselves" do
        expect(scope).to contain_exactly(editor)
      end
    end

    context "as a regular user" do
      let(:user) { regular_user }

      it "includes only themselves" do
        expect(scope).to contain_exactly(regular_user)
      end
    end

    context "as an anonymous user" do
      let(:user) { nil }

      it_behaves_like "a no access scope"
    end
  end
end
