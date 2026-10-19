# frozen_string_literal: true

RSpec.describe CommentPolicy, type: :policy do
  include_context "a standard policy"

  let_it_be(:other_solution, refind: true) { FactoryBot.create :solution, provider: other_provider }

  let_it_be(:comment, refind: true) { Comment.create!(resource: solution, author: editor, body: "A comment") }

  let_it_be(:other_comment, refind: true) { Comment.create!(resource: other_solution, author: other_editor, body: "A comment") }

  context "with the editor's comment on their provider's solution" do
    let(:record) { comment }

    describe_rule :index? do
      it_behaves_like "an admin or editor permission"
    end

    describe_rule :show? do
      it_behaves_like "an admin or record editor permission"
    end

    describe_rule :new? do
      it_behaves_like "an admin or record editor permission"
    end

    describe_rule :create? do
      it_behaves_like "an admin or record editor permission"
    end

    describe_rule :edit? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :update? do
      it_behaves_like "a super admin permission"
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
  end

  context "with another editor's comment on another provider's solution" do
    let(:record) { other_comment }

    describe_rule :index? do
      it_behaves_like "an admin or editor permission"
    end

    describe_rule :show? do
      it_behaves_like "an admin or record editor permission", editor: :other_editor, non_editor: :editor
    end

    describe_rule :new? do
      it_behaves_like "an admin or record editor permission", editor: :other_editor, non_editor: :editor
    end

    describe_rule :create? do
      it_behaves_like "an admin or record editor permission", editor: :other_editor, non_editor: :editor
    end

    describe_rule :edit? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :update? do
      it_behaves_like "a super admin permission"
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
  end

  context "with a comment on a provider" do
    let(:record) { Comment.new(resource: provider) }

    describe_rule :create? do
      it_behaves_like "a privileged permission"
    end
  end

  describe "relation scope" do
    let(:record) { nil }

    let(:scope) { policy.apply_scope(Comment.all, type: :active_record_relation) }

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

      it "includes only the accessible records" do
        expect(scope).to contain_exactly(comment)
      end
    end

    context "as another provider's editor" do
      let(:user) { other_editor }

      it "includes only the accessible records" do
        expect(scope).to contain_exactly(other_comment)
      end
    end

    context "as a regular user" do
      let(:user) { regular_user }

      it "includes nothing" do
        expect(scope).to be_empty
      end
    end

    context "as an anonymous user" do
      let(:user) { nil }

      it "includes nothing" do
        expect(scope).to be_empty
      end
    end
  end
end
