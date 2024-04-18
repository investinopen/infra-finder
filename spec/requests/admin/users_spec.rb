# frozen_string_literal: true

RSpec.describe "Admin Users", type: :request, default_auth: true do
  describe "GET /admin/users" do
    let_it_be(:extra_users) { FactoryBot.create_list :user, 3 }

    def make_the_request!
      expect do
        get admin_users_path
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

    context "when fetching CSV" do
      def make_the_request!
        expect do
          get admin_users_path(format: :csv)
        end.to execute_safely
      end

      it "is visible to super admins" do
        sign_in super_admin

        make_the_request!

        expect(response).to have_http_status(:ok)
      end

      it "is hidden to regular admins" do
        sign_in admin

        make_the_request!

        expect(response).to redirect_to(unauthorized_path)
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
  end

  describe "GET /admin/users/:id" do
    def make_the_request!
      expect do
        get admin_user_path(super_admin)
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

  describe "GET /admin/users/:id/edit" do
    def make_the_request!
      expect do
        get edit_admin_user_path(super_admin)
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
