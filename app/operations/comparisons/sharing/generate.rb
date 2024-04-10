# frozen_string_literal: true

module Comparisons
  module Sharing
    # @see Comparisons::Sharing::Generator
    class Generate < ::Support::SimpleServiceOperation
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      service_klass Comparisons::Sharing::Generator
    end
  end
end
