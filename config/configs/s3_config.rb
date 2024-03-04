# frozen_string_literal: true

# Configuration for S3
class S3Config < ApplicationConfig
  attr_config :access_key_id, :secret_access_key, :endpoint, region: "us-east-1", force_path_style: false

  coerce_types force_path_style: :boolean

  def build_s3_client
    Aws::S3::Client.new(
      access_key_id:,
      secret_access_key:,
      endpoint:,
      force_path_style:,
      region:
    )
  end
end
