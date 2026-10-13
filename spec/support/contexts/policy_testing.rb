# frozen_string_literal: true

# Builds on the users from the "default auth" context, which is included for policy specs.
RSpec.shared_context "a standard policy" do
  let_it_be(:other_provider, refind: true) { FactoryBot.create :provider }

  let_it_be(:other_editor, refind: true) { FactoryBot.create(:user).tap { other_provider.assign_editor!(_1) } }

  let(:user) { regular_user }

  let(:context) { { user:, } }

  shared_examples_for "an admin allowed permission" do
    succeed "as a super admin" do
      let(:user) { super_admin }
    end

    succeed "as an admin" do
      let(:user) { admin }
    end
  end

  shared_examples_for "an admin forbidden permission" do
    failed "as a super admin" do
      let(:user) { super_admin }
    end

    failed "as an admin" do
      let(:user) { admin }
    end
  end

  shared_examples_for "a non-admin allowed permission" do
    succeed "as an editor" do
      let(:user) { editor }
    end

    succeed "as another provider's editor" do
      let(:user) { other_editor }
    end

    succeed "as a regular user" do
      let(:user) { regular_user }
    end

    succeed "as an anonymous user" do
      let(:user) { nil }
    end
  end

  shared_examples_for "a non-admin forbidden permission" do
    failed "as an editor" do
      let(:user) { editor }
    end

    failed "as another provider's editor" do
      let(:user) { other_editor }
    end

    failed "as a regular user" do
      let(:user) { regular_user }
    end

    failed "as an anonymous user" do
      let(:user) { nil }
    end
  end

  shared_examples_for "a forbidden permission" do
    include_examples "an admin forbidden permission"
    include_examples "a non-admin forbidden permission"
  end

  shared_examples_for "a super admin permission" do
    succeed "as a super admin" do
      let(:user) { super_admin }
    end

    failed "as an admin" do
      let(:user) { admin }
    end

    include_examples "a non-admin forbidden permission"
  end

  shared_examples_for "a privileged permission" do
    include_examples "an admin allowed permission"
    include_examples "a non-admin forbidden permission"
  end

  shared_examples_for "a full-access permission" do
    include_examples "an admin allowed permission"
    include_examples "a non-admin allowed permission"
  end

  shared_examples_for "an admin or editor permission" do
    include_examples "an admin allowed permission"

    succeed "as an editor" do
      let(:user) { editor }
    end

    succeed "as another provider's editor" do
      let(:user) { other_editor }
    end

    failed "as a regular user" do
      let(:user) { regular_user }
    end

    failed "as an anonymous user" do
      let(:user) { nil }
    end
  end

  shared_examples_for "an admin or record editor permission" do |editor: :editor, non_editor: :other_editor|
    include_examples "an admin allowed permission"

    succeed "as the record's editor" do
      let(:user) { public_send(editor) }
    end

    failed "as another editor" do
      let(:user) { public_send(non_editor) }
    end

    failed "as a regular user" do
      let(:user) { regular_user }
    end

    failed "as an anonymous user" do
      let(:user) { nil }
    end
  end

  shared_examples_for "an admin or self permission" do |self_user:|
    include_examples "an admin allowed permission"

    succeed "as the user themselves" do
      let(:user) { public_send(self_user) }
    end

    { editor: "an editor", other_editor: "another provider's editor", regular_user: "a regular user" }.except(self_user).each do |other, label|
      failed "as #{label}" do
        let(:user) { public_send(other) }
      end
    end

    failed "as an anonymous user" do
      let(:user) { nil }
    end
  end

  shared_examples_for "a full access scope" do
    it "includes every record" do
      expect(scope).to match_array(scope.klass.all)
    end
  end

  shared_examples_for "a no access scope" do
    it "includes no records" do
      expect(scope).to be_empty
    end
  end
end
