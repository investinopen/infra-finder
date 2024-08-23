# frozen_string_literal: true

RSpec.describe "Admin Provider Editor Assignments", type: :request, default_auth: true do
  let_it_be(:provider_editor_assignment) { provider.assign_editor!(editor) }

  describe "GET /admin/providers/:provider_id/provider_editor_assignments" do
    def make_the_request!
      expect do
        get admin_provider_provider_editor_assignments_path(provider)
      end.to execute_safely
    end

    it "is visible to super admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is visible to admins" do
      sign_in admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is hidden from editors" do
      sign_in editor

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end
  end

  describe "GET /admin/providers/:provider_id/provider_editor_assignments/:id" do
    def make_the_request!
      expect do
        get admin_provider_provider_editor_assignments_path(provider, provider_editor_assignment)
      end.to execute_safely
    end

    it "has no show action" do
      sign_in super_admin

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end
  end

  describe "GET /admin/providers/:provider_id/provider_editor_assignments/new" do
    def make_the_request!
      get new_admin_provider_provider_editor_assignment_path(provider)
    end

    it "is visible to super admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is visible to admins" do
      sign_in admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is hidden from editors" do
      sign_in editor

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end
  end
end
