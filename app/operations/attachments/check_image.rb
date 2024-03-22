# frozen_string_literal: true

module Attachments
  class CheckImage < Support::SimpleServiceOperation
    include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

    service_klass Attachments::ImageChecker
  end
end
