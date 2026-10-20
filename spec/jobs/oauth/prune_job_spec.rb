# frozen_string_literal: true

RSpec.describe OAuth::PruneJob, type: :job do
  let_it_be(:user) { FactoryBot.create :user, :with_admin }

  let(:token_helper) { VOGTesting::System["tokens.helper"] }

  let!(:active_token) { token_helper.build_access_token(from_user: user) }
  let!(:revoked_token) { token_helper.build_access_token(from_user: user, revoked: true) }
  let!(:ended_token) { token_helper.build_access_token(from_user: user) }

  before do
    ended_token.update_column(:session_started_at, (OAuth::AccessToken::SESSION_LIFETIME + 1.day).ago)
  end

  it "prunes revoked tokens and token sessions past their lifetime" do
    expect do
      described_class.perform_now
    end.to change(OAuth::AccessToken, :count).by(-2)

    expect(OAuth::AccessToken.where(id: active_token.id)).to exist
  end
end
