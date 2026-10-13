# frozen_string_literal: true

RSpec.describe Uploads::EncodeToken, type: :operation do
  let_it_be(:authorized_user) { FactoryBot.create(:user, :with_admin) }
  let_it_be(:unauthorized_user) { FactoryBot.create(:user, :accepted_terms) }

  it "encodes an upload token for an authorized user" do
    expect_calling_with(authorized_user, session_jti: SecureRandom.uuid).to succeed
  end

  it "fails to encode an upload token for an unauthorized user" do
    expect_calling_with(unauthorized_user, session_jti: SecureRandom.uuid).to monad_fail.with_key(:no_upload_access)
  end

  it "fails to encode an upload token without a session" do
    expect_calling_with(authorized_user, session_jti: nil).to monad_fail.with_key(:no_session)
  end
end
