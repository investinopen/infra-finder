# frozen_string_literal: true

RSpec.describe Uploads::Authorize, type: :operation do
  let_it_be(:authorized_user, refind: true) { FactoryBot.create(:user, :with_admin) }
  let_it_be(:unauthorized_user, refind: true) { FactoryBot.create(:user, :accepted_terms) }

  let_it_be(:pending_terms_editor, refind: true) do
    FactoryBot.create(:user) do |user|
      FactoryBot.create(:provider).assign_editor!(user)
    end
  end

  let(:token_helper) { VOGTesting::System["tokens.helper"] }

  let(:current_user) { authorized_user }

  let(:authorization_token) { nil }
  let(:upload_token) { nil }

  let(:env) do
    {}.tap do |h|
      h["HTTP_AUTHORIZATION"] = "Bearer #{authorization_token}" if authorization_token.present?
      h["HTTP_UPLOAD_TOKEN"] = upload_token
    end
  end

  # The token session an upload token is issued under.
  def session_id_for(user)
    token_helper.build_access_token(from_user: user).session_id
  end

  specify "sanity check" do
    expect(authorized_user).to have_any_upload_access
    expect(unauthorized_user).not_to have_any_upload_access
    expect(pending_terms_editor).not_to have_any_upload_access
  end

  shared_examples_for "an authorized result" do
    it "is authorized" do
      expect_calling_with(env).to succeed.with(current_user)
    end
  end

  shared_examples_for "an unauthorized result" do
    it "is not authorized" do
      expect_calling_with(env).to monad_fail.with_key(:unauthorized)
    end
  end

  context "when authorizing from an API bearer token" do
    let(:authorization_token) { token_helper.build_token(from_user: current_user) }

    context "when the user has upload access" do
      include_examples "an authorized result"
    end

    context "when the user does not have upload access" do
      let(:current_user) { unauthorized_user }

      include_examples "an unauthorized result"
    end

    context "when the user has not accepted the terms" do
      let(:current_user) { pending_terms_editor }

      include_examples "an unauthorized result"
    end

    context "when the user is locked" do
      before { current_user.lock_access!(send_instructions: false) }

      include_examples "an unauthorized result"
    end

    context "when the bearer token has expired" do
      let(:authorization_token) { token_helper.build_token(from_user: current_user, expires_at: 1.minute.ago) }

      include_examples "an unauthorized result"
    end
  end

  context "when authenticating from an upload token header" do
    let(:session_id) { session_id_for(current_user) }

    # Issued before each example's `before` hooks run, as a client would hold it.
    let!(:upload_token) do
      Common::Container["tokens.encode"].(sub: current_user.id, sid: session_id, aud: "upload", exp: 1.hour.from_now.to_i).value!
    end

    context "when the user has upload access" do
      include_examples "an authorized result"
    end

    context "when the user does not have upload access" do
      let(:current_user) { unauthorized_user }

      include_examples "an unauthorized result"
    end

    context "when the session it was issued under has been revoked" do
      before { OAuth::AccessToken.in_session(session_id).update_all(revoked_at: Time.current) }

      include_examples "an unauthorized result"
    end

    context "when the session it was issued under has passed its lifetime" do
      before { OAuth::AccessToken.in_session(session_id).update_all(session_started_at: 31.days.ago) }

      include_examples "an unauthorized result"
    end

    context "when the user changed their password" do
      before { current_user.update!(password: "a different password", password_confirmation: "a different password") }

      include_examples "an unauthorized result"
    end

    context "when the user no longer exists" do
      let(:upload_token) do
        Common::Container["tokens.encode"].(sub: SecureRandom.uuid, sid: SecureRandom.uuid, aud: "upload", exp: 1.hour.from_now.to_i).value!
      end

      include_examples "an unauthorized result"
    end

    context "when the upload token has expired" do
      let(:upload_token) do
        Common::Container["tokens.encode"].(sub: current_user.id, sid: session_id, aud: "upload", exp: 1.minute.ago.to_i).value!
      end

      include_examples "an unauthorized result"
    end

    context "when the upload token is blank" do
      let(:upload_token) { "" }

      include_examples "an unauthorized result"
    end
  end
end
