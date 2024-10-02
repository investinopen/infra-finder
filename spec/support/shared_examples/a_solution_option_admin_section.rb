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

      expect(response).to redirect_to(unauthorized_path)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
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

      expect(response).to redirect_to(unauthorized_path)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end
  end

  describe "POST /admin/#{plural}" do
    let_it_be(:params) do
      attrs = {
        name: "Some Name",
        term: "Some Term",
        description: "A description"
      }

      {
        described_class.model_name.i18n_key => attrs,
      }
    end

    def make_the_request!
      expect do
        post url_for([:admin, described_class]), params:
      end
    end

    it "creates records for super admins" do
      sign_in super_admin

      make_the_request!.to change(described_class, :count).by(1)

      expect(response).to redirect_to url_for([:admin, described_class.latest])
    end

    it "does not create anything for regular admins" do
      sign_in admin

      make_the_request!.to keep_the_same(described_class, :count)

      expect(response).to redirect_to(unauthorized_path)
    end

    it "does not create anything for editors" do
      sign_in editor

      make_the_request!.to keep_the_same(described_class, :count)

      expect(response).to redirect_to(unauthorized_path)
    end

    it "does not create anything for unassigned users" do
      sign_in regular_user

      make_the_request!.to keep_the_same(described_class, :count)

      expect(response).to redirect_to(unauthorized_path)
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

  describe "GET /admin/#{plural}/:id/replace" do
    def make_the_request!
      expect do
        get url_for([:replace, :admin, single_record])
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

  describe "PUT /admin/#{plural}/:id/replace_option" do
    let_it_be(:other_record, refind: true) { FactoryBot.create factory_kind }

    let(:params) do
      {
        option_replacement: {
          new_option: other_record.id,
        }
      }
    end

    def make_the_request!
      expect do
        put(url_for([:replace_option, :admin, single_record]), params:)
      end
    end

    it "is usable by super admins" do
      sign_in super_admin

      make_the_request!.to change(model_klass, :count).by(-1)

      expect(response).to redirect_to [:admin, model_klass]
    end

    it "is usable by admins" do
      sign_in admin

      make_the_request!.to change(model_klass, :count).by(-1)

      expect(response).to redirect_to [:admin, model_klass]
    end

    it "is hidden to assigned editors" do
      sign_in editor

      make_the_request!.to keep_the_same(model_klass, :count)

      expect(response).to redirect_to(unauthorized_path)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!.to keep_the_same(model_klass, :count)

      expect(response).to redirect_to(unauthorized_path)
    end
  end
end
