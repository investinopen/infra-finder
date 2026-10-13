# frozen_string_literal: true

module Filtering
  # A container for GraphQL argument types used by the filtering subsystem.
  #
  # Each {Filtering::FilterScope} has its own instance of this argument set.
  class Arguments
    include Dry::Container::Mixin

    # @param [#to_s] key
    # @param [#to_s, Class, (Class)] type_key
    # @return [Dry::Type]
    def add!(key, type_key, **options, &)
      type = Filtering::TypeContainer.resolve(type_key)

      configured_type = Filtering::ArgumentBuilder.new(type, **options).call(&)

      register key, configured_type

      return configured_type
    end
  end
end
