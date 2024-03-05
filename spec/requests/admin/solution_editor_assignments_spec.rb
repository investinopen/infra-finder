# frozen_string_literal: true

RSpec.describe "Admin Solution Editor Assignments", type: :request, default_auth: true do
  let_it_be(:solution_editor_assignment) { solution.assign_editor!(editor) }

  describe "GET /admin/solutions/:solution_id/solution_editor_assignments" do
    def make_the_request!
      expect do
        get admin_solution_solution_editor_assignments_path(solution)
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

  describe "GET /admin/solutions/:solution_id/solution_editor_assignments/:id" do
    def make_the_request!
      expect do
        get admin_solution_solution_editor_assignments_path(solution, solution_editor_assignment)
      end.to execute_safely
    end

    it "has no show action" do
      sign_in super_admin

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end
  end

  describe "GET /admin/solutions/:solution_id/solution_editor_assignments/new" do
    def make_the_request!
      get new_admin_solution_solution_editor_assignment_path(solution)
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
