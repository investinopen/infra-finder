# frozen_string_literal: true

module Patches
  module FixConnectionPoolLoading
    # This is necessary because for some reason `ActivesSupport::Cache::RedisCacheStore`
    # does not properly handle kwargs to `ConnectionPool.new` in Rails 7.1.6
    def new(arg = nil, **kwargs, &)
      # :nocov:
      if arg.kind_of?(Hash) && kwargs.empty?
        return super(**arg, &)
      end

      super(**kwargs, &)
      # :nocov:
    end
  end
end

ConnectionPool.singleton_class.prepend(Patches::FixConnectionPoolLoading)
