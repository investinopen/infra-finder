# frozen_string_literal: true

RSpec.describe "Admin Solutions", type: :request, default_auth: true do
  describe "GET /admin/solutions" do
    let_it_be(:extra_solutions) { FactoryBot.create_list :solution, 3 }

    def make_the_request!
      expect do
        get admin_solutions_path
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

      expect(response).to redirect_to(unauthorized_path)
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

    it "is visible to assigned editors" do
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

      expect(response).to redirect_to(unauthorized_path)
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

  describe "PUT /admin/solutions/:id/create_draft" do
    let(:request_path) { create_draft_admin_solution_path(solution) }

    let(:success_path) do
      admin_solution_solution_draft_path(solution, SolutionDraft.latest)
    end

    def expect_request_to_work!
      expect do
        put request_path
      end.to change(SolutionDraft, :count).by(1)

      expect(response).to redirect_to(success_path)
    end

    def expect_request_to_fail!
      expect do
        put request_path
      end.to keep_the_same(SolutionDraft, :count)
    end

    it "is usable by a super admin" do
      sign_in super_admin

      expect_request_to_work!
    end

    it "is usable by an admin" do
      sign_in admin

      expect_request_to_work!
    end

    it "is usable by an assigned editor" do
      sign_in editor

      expect_request_to_work!
    end

    it "is not usable by an unassigned editor" do
      other_solution = FactoryBot.create(:solution)

      # sanity check
      expect do
        other_solution.assign_editor!(regular_user)
      end.to change { regular_user.reload.kind }.from("default").to("editor")

      sign_in regular_user

      expect_request_to_fail!

      expect(response).to have_http_status(:not_found)
    end

    it "is not usable by a regular user" do
      sign_in regular_user

      expect_request_to_fail!

      expect(response).to have_http_status(:not_found)
    end

    context "when a pending draft already exists" do
      let_it_be(:solution_draft) { solution.create_draft!(user: editor) }

      it "redirects to their existing draft" do
        sign_in editor

        expect_request_to_fail!

        expect(response).to redirect_to(admin_solution_solution_draft_path(solution, solution_draft))
      end
    end
  end
end
