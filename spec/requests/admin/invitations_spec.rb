# frozen_string_literal: true

RSpec.describe "Invitations", type: :request, default_auth: true do
  describe "GET /admin/invitations" do
    def make_the_request!
      expect do
        get admin_invitations_url
      end.to execute_safely
    end

    it "is visible to super admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to have_http_status :ok
    end

    it "is visible to admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to have_http_status :ok
    end

    it "is hidden from editors" do
      sign_in editor

      make_the_request!

      expect(response).to redirect_to unauthorized_path
    end

    it "is hidden from regular users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to unauthorized_path
    end
  end

  describe "GET /admin/invitations/new" do
    def make_the_request!
      expect do
        get new_admin_invitation_url
      end.to execute_safely
    end

    it "is visible to super admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to have_http_status :ok
    end

    it "is visible to admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to have_http_status :ok
    end

    it "is hidden from editors" do
      sign_in editor

      make_the_request!

      expect(response).to redirect_to unauthorized_path
    end

    it "is hidden from regular users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to unauthorized_path
    end
  end

  describe "POST /admin/invitations" do
    def make_the_request!
      invitation = FactoryBot.attributes_for(:invitation).merge(provider_id: provider.id)

      params = {
        invitation:,
      }

      expect do
        post(admin_invitations_path, params:)
      end.to execute_safely
        .and change(Invitation, :count).by(1)
        .and change(User, :count).by(1)
        .and change(ProviderEditorAssignment, :count).by(1)
        .and have_enqueued_mail(InvitationsMailer, :welcome).once
    end

    it "works for super admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to redirect_to(admin_invitations_path)
    end

    it "works for admins" do
      sign_in admin

      make_the_request!

      expect(response).to redirect_to(admin_invitations_path)
    end
  end
end
