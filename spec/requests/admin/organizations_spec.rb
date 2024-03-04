# frozen_string_literal: true

RSpec.describe "Admin Organizations", type: :request, default_auth: true do
  let_it_be(:organization) { FactoryBot.create :organization }

  describe "GET /admin/organizations" do
    let_it_be(:extra_users) { FactoryBot.create_list :organization, 3 }

    def make_the_request!
      expect do
        get admin_organizations_path
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

    it "is hidden to editors" do
      sign_in editor

      make_the_request!

      expect(response).to redirect_to(?/)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(?/)
    end
  end

  describe "GET /admin/organizations/:id" do
    def make_the_request!
      expect do
        get admin_organization_path(organization)
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

    it "is hidden to assigned editors" do
      sign_in editor

      make_the_request!

      expect(response).to redirect_to ?/
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to ?/
    end
  end

  describe "GET /admin/organizations/:id/edit" do
    def make_the_request!
      expect do
        get edit_admin_organization_path(organization)
      end.to execute_safely
    end

    it "is visible to super admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is hidden to admins" do
      sign_in admin

      make_the_request!

      expect(response).to redirect_to ?/
    end

    it "is hidden to assigned editors" do
      sign_in editor

      make_the_request!

      expect(response).to redirect_to ?/
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to ?/
    end
  end
end
