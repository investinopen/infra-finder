# frozen_string_literal: true

RSpec.describe "Admin Solution Drafts", type: :request, default_auth: true do
  let_it_be(:solution_draft) { solution.create_draft!(user: editor) }

  describe "GET /admin/solutions/:solution_id/solution_drafts" do
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

      expect(response).to redirect_to(unauthorized_path)
    end
  end

  describe "GET /admin/solutions/:solution_id/solution_drafts/:id" do
    before do
      solution_draft.update!(founded_on: Date.new(2024, 2, 14))
      solution_draft.request_review!
    end

    def make_the_request!
      expect do
        get admin_solution_solution_draft_path(solution, solution_draft)
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

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end

    context "when the draft is approved" do
      before do
        solution_draft.approve!
      end

      it "affects the display slightly" do
        sign_in super_admin

        make_the_request!

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /admin/solutions/:solution_id/solution_drafts/:id/edit" do
    def make_the_request!
      expect do
        get edit_admin_solution_solution_draft_path(solution, solution_draft)
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

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end
  end

  shared_context "state transitions" do
    let(:initial_state) { "pending" }
    let(:desired_state) { "in_review" }
    let(:request_path) { raise "must specify" }

    let(:success_path) do
      admin_solution_solution_draft_path(solution, solution_draft)
    end

    let(:failure_path) do
      admin_solution_solution_drafts_path(solution)
    end

    def expect_request_to_work!
      expect do
        put request_path
      end.to change { solution_draft.current_state(force_reload: true) }.from(initial_state).to(desired_state)

      expect(response).to redirect_to(success_path)
    end

    def expect_request_to_fail!(unauthorized: true)
      expect do
        put request_path
      end.to keep_the_same { solution_draft.current_state(force_reload: true) }

      if unauthorized
        expect(response).to redirect_to(unauthorized_path)
      else
        expect(response).to redirect_to(failure_path)
      end
    end
  end

  describe "PUT /admin/solutions/:solution_id/solution_drafts/:id/request_review" do
    include_context "state transitions"

    let(:request_path) do
      request_review_admin_solution_solution_draft_path(solution, solution_draft)
    end

    it "is usable by super admins" do
      sign_in super_admin

      expect_request_to_work!
    end

    it "is usable by admins" do
      sign_in admin

      expect_request_to_work!
    end

    it "is usable by assigned editors" do
      sign_in editor

      expect_request_to_work!
    end

    it "is not usable by regular users" do
      sign_in regular_user

      expect_request_to_fail!(unauthorized: true)
    end

    context "when it is already in review" do
      before do
        solution_draft.request_review!
      end

      it "handles failures gracefully" do
        sign_in editor

        expect_request_to_fail!(unauthorized: false)
      end
    end
  end

  describe "PUT /admin/solutions/:solution_id/solution_drafts/:id/request_revision" do
    include_context "state transitions"

    let(:initial_state) { "in_review" }
    let(:desired_state) { "pending" }

    let(:request_path) do
      request_revision_admin_solution_solution_draft_path(solution, solution_draft)
    end

    before do
      solution_draft.request_review!
    end

    it "is usable by super admins" do
      sign_in super_admin

      expect_request_to_work!
    end

    it "is usable by admins" do
      sign_in admin

      expect_request_to_work!
    end

    it "is not usable by assigned editors" do
      sign_in editor

      expect_request_to_fail!(unauthorized: true)
    end

    it "is not usable by regular users" do
      sign_in regular_user

      expect_request_to_fail!(unauthorized: true)
    end

    context "when it is already back in pending" do
      before do
        solution_draft.request_revision!
      end

      it "handles failures gracefully" do
        sign_in super_admin

        expect_request_to_fail!(unauthorized: false)
      end
    end
  end

  describe "PUT /admin/solutions/:solution_id/solution_drafts/:id/approve" do
    include_context "state transitions"

    let(:initial_state) { "in_review" }
    let(:desired_state) { "approved" }

    let(:request_path) do
      approve_admin_solution_solution_draft_path(solution, solution_draft)
    end

    before do
      solution_draft.request_review!
    end

    it "is usable by super admins" do
      sign_in super_admin

      expect_request_to_work!
    end

    it "is usable by admins" do
      sign_in admin

      expect_request_to_work!
    end

    it "is not usable by assigned editors" do
      sign_in editor

      expect_request_to_fail!(unauthorized: true)
    end

    it "is not usable by regular users" do
      sign_in regular_user

      expect_request_to_fail!(unauthorized: true)
    end

    context "when it is already approved" do
      before do
        solution_draft.approve!
      end

      it "handles failures gracefully" do
        sign_in super_admin

        expect_request_to_fail!(unauthorized: false)
      end
    end
  end

  describe "PUT /admin/solutions/:solution_id/solution_drafts/:id/reject" do
    include_context "state transitions"

    let(:initial_state) { "in_review" }
    let(:desired_state) { "rejected" }

    let(:request_path) do
      reject_admin_solution_solution_draft_path(solution, solution_draft)
    end

    before do
      solution_draft.request_review!
    end

    it "is usable by super admins" do
      sign_in super_admin

      expect_request_to_work!
    end

    it "is usable by admins" do
      sign_in admin

      expect_request_to_work!
    end

    it "is not usable by assigned editors" do
      sign_in editor

      expect_request_to_fail!(unauthorized: true)
    end

    it "is not usable by regular users" do
      sign_in regular_user

      expect_request_to_fail!(unauthorized: true)
    end

    context "when it is already rejected" do
      before do
        solution_draft.reject!
      end

      it "handles failures gracefully" do
        sign_in super_admin

        expect_request_to_fail!(unauthorized: false)
      end
    end
  end
end
