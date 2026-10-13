# frozen_string_literal: true

module Patches
  module GraphQLUseActiveSupportInflection
    # Leading underscores are preserved so that introspection fields
    # like `__typename` and `__schema` keep their names, matching
    # graphql-ruby's own implementation.
    def camelize(string)
      leading = string[/\A_+/]

      return string if leading == string

      camelized = ::ActiveSupport::Inflector.camelize(string.delete_prefix(leading.to_s), false)

      "#{leading}#{camelized}"
    end

    def underscore(string)
      ::ActiveSupport::Inflector.underscore(string)
    end

    def constantize(string)
      ::ActiveSupport::Inflector.constantize(string)
    end
  end
end

GraphQL::Schema::Member::BuildType.singleton_class.prepend(Patches::GraphQLUseActiveSupportInflection)
