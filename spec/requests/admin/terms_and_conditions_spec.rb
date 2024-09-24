# frozen_string_literal: true

RSpec.describe "Terms And Conditions", type: :request, default_auth: true do
  # We want our editor to _not_ have accepted terms yet.
  let_it_be(:editor, refind: true) do
    FactoryBot.create(:user, accept_terms_and_conditions: false) do |u|
      solution.assign_editor!(u)
    end
  end

  let_it_be(:non_editor, refind: true) do
    FactoryBot.create(:user, accept_terms_and_conditions: false)
  end

  describe "GET /admin/terms_and_conditions" do
    def make_the_request!
      expect do
        get admin_terms_and_conditions_url
      end.to execute_safely
    end

    it "renders a form with a user with no terms and conditions accepted" do
      sign_in editor

      make_the_request!

      expect(response).to have_http_status :ok
    end

    it "redirects when a user has already accepted terms and conditions" do
      sign_in super_admin

      make_the_request!

      expect(response).to redirect_to admin_dashboard_path
    end

    it "redirects a non-editor away no matter what" do
      sign_in non_editor

      make_the_request!

      expect(flash[:alert]).to eq I18n.t("admin.access.alerts.non_editor")

      expect(response).to redirect_to root_path
    end
  end

  describe "POST /admin/terms_and_conditions/accept" do
    def make_the_request!(accept: false)
      params = {
        user: {
          accept_terms_and_conditions: accept ? ?1 : ?0
        },
      }

      post(admin_terms_and_conditions_accept_url, params:)
    end

    it "will accept terms and conditions and transition the user" do
      sign_in editor

      expect do
        make_the_request!(accept: true)
      end.to execute_safely
        .and change { editor.current_state(force_reload: true) }.from("pending").to("accepted_terms")
        .and change { editor.reload.accepted_terms_at }

      expect(response).to redirect_to(admin_dashboard_path)
    end

    it "renders an error when terms are not actually accepted" do
      sign_in editor

      expect do
        make_the_request!(accept: false)
      end.to execute_safely
        .and keep_the_same { editor.current_state(force_reload: true) }
        .and keep_the_same { editor.reload.accepted_terms_at }

      expect(response).to have_http_status(:ok)
    end

    it "redirects a non-editor away no matter what" do
      sign_in non_editor

      make_the_request!

      expect(flash[:alert]).to eq I18n.t("admin.access.alerts.non_editor")

      expect(response).to redirect_to root_path
    end
  end
end
