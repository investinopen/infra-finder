# frozen_string_literal: true

RSpec.describe ProviderEditorAssignment, type: :model do
  context "when dealing with editor assignments" do
    let_it_be(:provider, refind: true) { FactoryBot.create :provider }

    let_it_be(:user, refind: true) { FactoryBot.create :user }

    specify "an editor can be assigned", :aggregate_failures do
      expect do
        provider.assign_editor!(user)
      end.to change(described_class, :count).by(1)
        .and change { user.reload.kind }.from("default").to("editor")

      expect(user).to be_editor
    end

    context "when assigning to admin-type users" do
      let_it_be(:super_admin, refind: true) { FactoryBot.create :user, :with_super_admin }

      let_it_be(:admin, refind: true) { FactoryBot.create :user, :with_admin }

      it "has no effect on the user role", :aggregate_failures do
        expect do
          provider.assign_editor!(super_admin)
          provider.assign_editor!(admin)
        end.to change(described_class, :count).by(2)
          .and keep_the_same { super_admin.reload.kind }
          .and keep_the_same { admin.reload.kind }

        expect(super_admin).to be_super_admin
        expect(admin).to be_admin
      end
    end

    context "when an assignment already exists" do
      let_it_be(:assignment, refind: true) { provider.assign_editor!(user) }

      it "is idempotent", :aggregate_failures do
        expect do
          provider.assign_editor!(user)
        end.to keep_the_same(described_class, :count)
          .and keep_the_same { user.reload.kind }

        expect(user).to be_editor
      end
    end

    context "when removing an editor" do
      let_it_be(:assignment, refind: true) { provider.assign_editor!(user) }

      before do
        user.reload
      end

      it "will revert the user when destroying the assignment", :aggregate_failures do
        expect do
          assignment.destroy!
        end.to change(described_class, :count).by(-1)
          .and change { user.reload.kind }.from("editor").to("default")

        expect(user).not_to be_editor
        expect(user).to be_default_kind
      end
    end
  end
end
