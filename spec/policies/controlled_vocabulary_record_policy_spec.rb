# frozen_string_literal: true

RSpec.describe ControlledVocabularyRecordPolicy, type: :policy do
  include_context "a standard policy"

  let_it_be(:license, refind: true) { FactoryBot.create :license }

  context "with a controlled vocabulary record" do
    let(:record) { license }

    describe_rule :index? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :show? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :read? do
      it_behaves_like "a full-access permission"
    end

    describe_rule :read_admin_details? do
      it_behaves_like "a privileged permission"
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

    describe_rule :mark_hidden? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :mark_visible? do
      it_behaves_like "a super admin permission"
    end

    describe_rule :replace? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :replace_option? do
      it_behaves_like "a privileged permission"
    end
  end

  describe "api relation scope" do
    let(:record) { nil }

    let(:scope) { policy.apply_scope(License.all, type: :active_record_relation, name: :api) }

    context "as an editor" do
      let(:user) { editor }

      it_behaves_like "a full access scope"
    end

    context "as an anonymous user" do
      let(:user) { nil }

      it_behaves_like "a full access scope"
    end
  end
end
