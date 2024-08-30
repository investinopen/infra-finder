# frozen_string_literal: true

RSpec.describe "Admin Solution Drafts", type: :request, default_auth: true do
  let_it_be(:solution_draft, refind: true) { solution.create_draft!(user: editor) }

  let_it_be(:other_admin, refind: true) do
    FactoryBot.create :user, :with_super_admin, :subscribed_to_all
  end

  let_it_be(:other_editor, refind: true) do
    FactoryBot.create(:user, :subscribed_to_all).tap { solution.assign_editor!(_1) }
  end

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
    let(:request_path) { url_for([workflow_action, :admin, solution, solution_draft]) }
    let(:workflow_action) { raise "must specify" }

    let(:success_path) do
      admin_solution_solution_draft_path(solution, solution_draft)
    end

    let(:failure_path) do
      admin_solution_solution_drafts_path(solution)
    end

    let(:params) do
      {
        workflow_action => {
          memo: "some memo text",
        }
      }
    end

    def expect_request_to_work!
      expect do
        put(request_path, params:)
      end.to change { solution_draft.current_state(force_reload: true) }.from(initial_state).to(desired_state)
        .and have_enqueued_mail(WorkflowMailer, workflow_action).at_least(1).times

      expect(response).to redirect_to(success_path)
    end

    def expect_request_to_fail!(unauthorized: true)
      expect do
        put(request_path, params:)
      end.to keep_the_same { solution_draft.current_state(force_reload: true) }
        .and have_enqueued_mail(WorkflowMailer, workflow_action).exactly(0).times

      if unauthorized
        expect(response).to redirect_to(unauthorized_path)
      else
        expect(response).to redirect_to(failure_path)
      end
    end
  end

  describe "PUT /admin/solutions/:solution_id/solution_drafts/:id/request_review" do
    include_context "state transitions"

    let(:workflow_action) { :request_review }

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

    let(:workflow_action) { :request_revision }

    let(:initial_state) { "in_review" }
    let(:desired_state) { "pending" }

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

    let(:workflow_action) { :approve }

    let(:initial_state) { "in_review" }
    let(:desired_state) { "approved" }

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

    let(:workflow_action) { :reject }

    let(:initial_state) { "in_review" }
    let(:desired_state) { "rejected" }

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
