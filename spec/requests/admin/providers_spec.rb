# frozen_string_literal: true

RSpec.describe "Admin Providers", type: :request, default_auth: true do
  let_it_be(:provider) { FactoryBot.create :provider }

  describe "GET /admin/providers" do
    let_it_be(:extra_users) { FactoryBot.create_list :provider, 3 }

    def make_the_request!
      expect do
        get admin_providers_path
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

      expect(response).to redirect_to(unauthorized_path)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end
  end

  describe "GET /admin/providers/:id" do
    def make_the_request!
      expect do
        get admin_provider_path(provider)
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

      expect(response).to redirect_to(unauthorized_path)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end
  end

  describe "GET /admin/providers/:id/edit" do
    def make_the_request!
      expect do
        get edit_admin_provider_path(provider)
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

      expect(response).to redirect_to(unauthorized_path)
    end

    it "is hidden to assigned editors" do
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
