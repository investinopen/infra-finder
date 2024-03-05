# frozen_string_literal: true

RSpec.describe Solutions::BuildStrongParams, type: :operation, default_auth: true do
  let(:draft) { false }

  def expect_building_params_for(current_user)
    expect_calling_with(current_user:, draft:)
  end

  context "when building params for an actual solution" do
    it "works for super admins" do
      expect_building_params_for(super_admin).to succeed
    end

    it "works for admins" do
      expect_building_params_for(super_admin).to succeed
    end

    it "fails for editors" do
      expect_building_params_for(regular_user).to monad_fail.with_key(:no_strong_params_allowed)
    end

    it "fails for end-users" do
      expect_building_params_for(regular_user).to monad_fail.with_key(:no_strong_params_allowed)
    end
  end

  context "when building params for a solution draft" do
    let(:draft) { true }

    it "works for super admins" do
      expect_building_params_for(super_admin).to succeed
    end

    it "works for admins" do
      expect_building_params_for(super_admin).to succeed
    end

    it "works for editors" do
      expect_building_params_for(editor).to succeed
    end

    it "fails for end-users" do
      expect_building_params_for(regular_user).to monad_fail.with_key(:no_strong_params_allowed)
    end
  end
end
