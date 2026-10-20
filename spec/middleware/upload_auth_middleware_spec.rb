# frozen_string_literal: true

RSpec.describe Middleware::UploadAuthMiddleware do
  include Rack::Test::Methods

  let(:app) do
    Rack::Builder.app do
      # rubocop:disable RSpec/DescribedClass
      # described_class is not available in this context.
      use Middleware::UploadAuthMiddleware
      # rubocop:enable RSpec/DescribedClass

      run ->(_env) { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
    end
  end

  let_it_be(:authorized_user) { FactoryBot.create(:user, :with_admin) }
  let_it_be(:unauthorized_user) { FactoryBot.create(:user, :accepted_terms) }

  let(:token_helper) { VOGTesting::System["tokens.helper"] }

  let(:current_user) { nil }

  let(:auth_token) { token_helper.build_token(from_user: current_user) if current_user.present? }

  let(:upload_token) { nil }

  before do
    header "Authorization", "Bearer #{auth_token}" if auth_token.present?
    header "Upload-Token", upload_token if upload_token.present?
  end

  def upload_token_for(user)
    session_id = token_helper.build_access_token(from_user: user).session_id

    Common::Container["tokens.encode"].(sub: user.id, sid: session_id, aud: "upload", exp: 1.hour.from_now.to_i).value!
  end

  shared_examples_for "bypassing options requests" do
    it "bypasses options requests" do
      options ?/

      expect(last_response).to be_ok
    end
  end

  shared_examples_for "a forbidden request" do
    include_examples "bypassing options requests"

    it "is forbidden" do
      get ?/

      expect(last_response).to be_forbidden
    end
  end

  shared_examples_for "an allowed request" do
    include_examples "bypassing options requests"

    it "is allowed" do
      get ?/

      expect(last_response).to be_ok
    end
  end

  context "when an anonymous user makes a request" do
    it_behaves_like "a forbidden request"

    context "with an invalid upload token" do
      let(:upload_token) { "invalid data" }

      it_behaves_like "a forbidden request"
    end
  end

  context "when an authorized user makes a request" do
    let(:current_user) { authorized_user }

    it_behaves_like "an allowed request"

    context "with an upload token" do
      let(:auth_token) { nil }
      let(:upload_token) { upload_token_for(current_user) }

      it_behaves_like "an allowed request"
    end
  end

  context "when an unauthorized user makes a request" do
    let(:current_user) { unauthorized_user }

    it_behaves_like "a forbidden request"

    context "with an upload token" do
      let(:auth_token) { nil }
      let(:upload_token) { upload_token_for(current_user) }

      it_behaves_like "a forbidden request"
    end
  end
end
