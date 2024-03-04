# frozen_string_literal: true

RSpec.describe "Admin Solutions", type: :request, default_auth: true do
  let_it_be(:solution_draft) { solution.create_draft!(user: editor) }
  describe "GET /admin/solutions" do
    def make_the_request!
      expect do
        get admin_solution_solution_drafts_path(solution)
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

    it "is visible to editors" do
      sign_in editor

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(?/)
    end
  end

  describe "GET /admin/solutions/:id" do
    def make_the_request!
      expect do
        get admin_solution_path(solution)
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

      expect(response).to have_http_status(:ok)
    end

    it "is hidden from unassigned editors" do
      sign_in editor

      other_solution = FactoryBot.create :solution

      expect do
        get admin_solution_path(other_solution)
      end.to execute_safely

      expect(response).to have_http_status(:not_found)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /admin/solutions/:id/edit" do
    def make_the_request!
      expect do
        get edit_admin_solution_path(solution)
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

      expect(response).to redirect_to(?/)
    end

    it "is hidden from unassigned editors" do
      sign_in editor

      other_solution = FactoryBot.create :solution

      expect do
        get edit_admin_solution_path(other_solution)
      end.to execute_safely

      expect(response).to have_http_status(:not_found)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to have_http_status(:not_found)
    end
  end
end
