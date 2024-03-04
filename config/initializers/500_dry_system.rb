# frozen_string_literal: true

# A namespace for referring back to our dry-rails containers and auto_inject objects.
module Common
  Container = [].freeze
  Deps = [].freeze
end

Dry::Rails.container do
  use :bootsnap

  config.features = %i[application_contract safe_params controller_helpers]

  config.component_dirs.add "app/operations" do |dir|
    dir.memoize = !Rails.env.test?
  end

  register :filesystem, memoize: !Rails.env.test? do
    Dry::Files.new memory: Rails.env.test?
  end

  register :hashids, memoize: true do
    Hashids.new SecurityConfig.hash_salt
  end

  register :node_verifier, memoize: true do
    Support::System[:node_verifier]
  end

  namespace :s3 do
    register :bucket, memoize: false do
      name = resolve("bucket_name")

      client = resolve("client")

      Aws::S3::Bucket.new(name, client:)
    end

    register :bucket_name, memoize: false do
      UploadConfig.bucket
    end

    register :client, memoize: false do
      S3Config.build_s3_client
    end
  end

  register_provider :common_interface do
    start do
      ::Common.__send__ :remove_const, :Container
      ::Common.__send__ :remove_const, :Deps

      ::Common.const_set :Container, target

      ::Common.const_set :Deps, target.injector
    end
  end

  start :common_interface

  # :nocov
  if Rails.env.test?
    require "dry/system/stubs"

    enable_stubs!
  end
  # :nocov:
end
