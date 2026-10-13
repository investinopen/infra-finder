# frozen_string_literal: true

RSpec.describe Middleware::ClientAddress do
  let(:app) { ->(env) { [200, {}, [ActionDispatch::Request.new(env).remote_ip]] } }

  let(:header) { "do-connecting-ip" }

  let(:middleware) { described_class.new(app, header:) }

  def remote_ip_for(headers)
    env = Rack::MockRequest.env_for("/", { "REMOTE_ADDR" => "10.0.0.1" }.merge(headers))

    ActionDispatch::RemoteIp.new(middleware).call(env).last.first
  end

  it "uses the configured header when present" do
    expect(remote_ip_for("HTTP_DO_CONNECTING_IP" => "203.0.113.7", "HTTP_X_FORWARDED_FOR" => "198.51.100.2")).to eq "203.0.113.7"
  end

  it "falls back to X-Forwarded-For" do
    expect(remote_ip_for("HTTP_X_FORWARDED_FOR" => "198.51.100.2")).to eq "198.51.100.2"
  end

  context "without a configured header" do
    let(:header) { "" }

    it "ignores the platform header" do
      expect(remote_ip_for("HTTP_DO_CONNECTING_IP" => "203.0.113.7")).to eq "10.0.0.1"
    end
  end
end
