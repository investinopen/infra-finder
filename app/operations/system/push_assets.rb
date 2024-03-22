# frozen_string_literal: true

module System
  # @see System::AssetPusher
  class PushAssets < Support::SimpleServiceOperation
    include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

    service_klass System::AssetPusher
  end
end
