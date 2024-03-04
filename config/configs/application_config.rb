# frozen_string_literal: true

# Base class for application config classes
#
# @abstract
class ApplicationConfig < Anyway::Config
  include Dry::Core::Memoizable

  class << self
    # Make it possible to access a singleton config instance
    # via class methods (i.e., without explictly calling `instance`)
    delegate_missing_to :instance

    private

    # Returns a singleton config instance
    def instance
      if Rails.env.test?
        new
      else
        # :nocov:
        @instance ||= new
        # :nocov:
      end
    end
  end
end
