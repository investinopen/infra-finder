# frozen_string_literal: true

RSpec.describe Users::UploadAccessPolicy, type: :policy do
  include_context "a standard policy"

  let(:record) { Users::UploadAccess.new(user) }

  describe_rule :upload? do
    succeed "as a super admin" do
      let(:user) { super_admin }
    end

    succeed "as an admin" do
      let(:user) { admin }
    end

    succeed "as an editor" do
      let(:user) { editor }
    end

    failed "as a regular user" do
      let(:user) { regular_user }
    end

    failed "as an anonymous user" do
      let(:user) { nil }
    end

    failed "as a GraphQL anonymous user" do
      let(:user) { AnonymousUser.new }
    end
  end
end
