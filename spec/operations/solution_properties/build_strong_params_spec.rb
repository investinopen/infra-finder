# frozen_string_literal: true

RSpec.describe SolutionProperties::BuildStrongParams, type: :operation, default_auth: true do
  let(:solution_kind) { :actual }

  def expect_building_params_for(current_user)
    expect_calling_with(solution_kind, current_user:)
  end

  context "when building params for an actual solution" do
    it "works for super admins" do
      expect_building_params_for(super_admin).to succeed
    end

    it "works for admins" do
      expect_building_params_for(admin).to succeed
    end

    it "fails for editors" do
      expect_building_params_for(regular_user).to monad_fail.with_key(:no_strong_params_allowed)
    end

    it "fails for end-users" do
      expect_building_params_for(regular_user).to monad_fail.with_key(:no_strong_params_allowed)
    end

    it "fails for anonymous users" do
      expect_building_params_for(nil).to monad_fail.with_key(:no_strong_params_allowed)
    end
  end

  context "when building params for a solution draft" do
    let(:solution_kind) { :draft }

    it "works for super admins" do
      expect_building_params_for(super_admin).to succeed
    end

    it "works for admins" do
      expect_building_params_for(admin).to succeed
    end

    it "works for editors" do
      expect_building_params_for(editor).to succeed
    end

    it "fails for end-users" do
      expect_building_params_for(regular_user).to monad_fail.with_key(:no_strong_params_allowed)
    end

    it "fails for anonymous users" do
      expect_building_params_for(nil).to monad_fail.with_key(:no_strong_params_allowed)
    end
  end

  context "when building params for a solution intake" do
    let(:solution_kind) { :intake }

    it "works for super admins" do
      expect_building_params_for(super_admin).to succeed
    end

    it "works for admins" do
      expect_building_params_for(admin).to succeed
    end

    it "works for editors" do
      expect_building_params_for(editor).to succeed
    end

    it "works for end-users" do
      expect_building_params_for(regular_user).to succeed
    end

    it "works for anonymous users" do
      expect_building_params_for(nil).to succeed
    end
  end
end
