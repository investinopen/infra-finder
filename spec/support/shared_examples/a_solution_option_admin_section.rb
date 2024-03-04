# frozen_string_literal: true

RSpec.shared_examples_for "a solution option admin section" do |klass|
  plural = klass.model_name.plural

  let_it_be(:model_klass) { klass }

  let_it_be(:factory_kind) { model_klass.factory_bot_name }

  let_it_be(:single_record, refind: true) { FactoryBot.create factory_kind }

  describe "GET /admin/#{plural}" do
    let_it_be(:extra_records) { FactoryBot.create_list factory_kind, 3 }

    def make_the_request!
      expect do
        get url_for([:admin, model_klass])
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

      expect(response).to redirect_to(?/)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(?/)
    end
  end

  describe "GET /admin/#{plural}/:id" do
    def make_the_request!
      expect do
        get url_for([:admin, single_record])
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

      expect(response).to redirect_to ?/
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to ?/
    end
  end

  describe "GET /admin/#{plural}/:id/edit" do
    def make_the_request!
      expect do
        get url_for([:edit, :admin, single_record])
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

      expect(response).to redirect_to ?/
    end

    it "is hidden to assigned editors" do
      sign_in editor

      make_the_request!

      expect(response).to redirect_to ?/
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to ?/
    end
  end
end
