# frozen_string_literal: true

RSpec.describe "Admin Dashboard", type: :request, default_auth: true do
  let_it_be(:review_draft, refind: true) do
    solution.create_draft!(user: editor).tap do |draft|
      draft.transition_to! :in_review
    end
  end

  let_it_be(:pending_draft, refind: true) { solution.create_draft!(user: editor) }

  describe "GET /admin" do
    def make_the_request!
      expect do
        get admin_root_path
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

  describe "GET /admin/dashboard" do
    def make_the_request!
      expect do
        get admin_dashboard_path
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

    context "with a user that has not accepted any terms and conditions" do
      let_it_be(:non_editor, refind: true) do
        FactoryBot.create(:user, accept_terms_and_conditions: false)
      end

      it "redirects with the proper message" do
        sign_in non_editor

        make_the_request!

        expect(flash[:alert]).to eq I18n.t("admin.access.alerts.non_editor")

        expect(response).to redirect_to root_path
      end
    end
  end
end
