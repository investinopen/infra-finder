# frozen_string_literal: true

module Utility
  # A service object for calling an arbitrary method chain.
  class ChainMethod
    # @example
    #   Utility::ChainMethod.new.(foo, "bar.baz.quux")
    #
    # @param [Object] origin
    # @param [String, Symbol] chain
    # @raise [NoMethodError]
    # @return [Object]
    def call(origin, chain)
      methods = chain.to_s.split ?.

      result, _ = methods.reduce([origin, []]) do |(receiver, done), method|
        if receiver.respond_to?(method)
          [receiver.public_send(method), [*done, method]]
        else
          raise NoMethodError, "Expected #{receiver.inspect} to respond to #{method}, from #{origin.class.name}##{done.join(?.)}"
        end
      end

      result
    end
  end
end
