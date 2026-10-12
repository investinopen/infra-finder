# frozen_string_literal: true

RSpec.describe ActiveAdmin::PagePolicy, type: :policy do
  include_context "a standard policy"

  let(:namespace) { ActiveAdmin.application.namespaces[:admin] }

  context "with the dashboard page" do
    let(:record) { ActiveAdmin::Page.new(namespace, "Dashboard", {}) }

    describe_rule :index? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :show? do
      it_behaves_like "an admin or editor permission"
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

    describe_rule :accept? do
      it_behaves_like "a forbidden permission"
    end

    describe_rule :update_preferences? do
      it_behaves_like "a forbidden permission"
    end
  end

  context "with the notifications page" do
    let(:record) { ActiveAdmin::Page.new(namespace, "Notifications", {}) }

    describe_rule :index? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :show? do
      it_behaves_like "an admin or editor permission"
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

    describe_rule :accept? do
      it_behaves_like "a forbidden permission"
    end

    describe_rule :update_preferences? do
      it_behaves_like "an admin or editor permission"
    end
  end

  context "with the terms and conditions page" do
    let(:record) { ActiveAdmin::Page.new(namespace, "terms_and_conditions", {}) }

    describe_rule :index? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :show? do
      it_behaves_like "an admin or editor permission"
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

    describe_rule :accept? do
      it_behaves_like "a full-access permission"
    end

    describe_rule :update_preferences? do
      it_behaves_like "a forbidden permission"
    end
  end

  context "with any other page" do
    let(:record) { ActiveAdmin::Page.new(namespace, "Other", {}) }

    describe_rule :index? do
      it_behaves_like "a privileged permission"
    end

    describe_rule :show? do
      it_behaves_like "a forbidden permission"
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

    describe_rule :accept? do
      it_behaves_like "a forbidden permission"
    end

    describe_rule :update_preferences? do
      it_behaves_like "a forbidden permission"
    end
  end
end
