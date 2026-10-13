# frozen_string_literal: true

RSpec.describe "Query.uploadAccess", type: :request, graphql: true do
  let(:query) { "query { uploadAccess { token canUpload { value } } }" }

  def decoded_token
    raw = graphql_response(:data, :uploadAccess, :token)

    Common::Container["uploads.decode_token"].(raw).value!
  end

  as_an_editor_user do
    it "issues an upload token for the viewer" do
      make_default_request!

      expect(decoded_token).to include("sub" => current_user.id, "aud" => "upload", "sid" => Warden::JWTAuth::TokenDecoder.new.call(token)["jti"])
      expect(graphql_response(:data, :uploadAccess, :canUpload, :value)).to be true
    end
  end

  as_an_anonymous_user do
    it "issues no token" do
      make_default_request!

      expect(graphql_response(:data, :uploadAccess, :token)).to be_nil
      expect(graphql_response(:data, :uploadAccess, :canUpload, :value)).to be false
    end
  end
end
