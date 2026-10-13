# frozen_string_literal: true

# @!parse [ruby]
#   # A null object using [Naught](https://github.com/avdi/naught) to mimic {User}
#   # in cases when a GraphQL request is not authenticated. The GraphQL API relies
#   # on a non-nil value representing the user accessing a given object.
#   #
#   # @note Only the GraphQL API uses this. The HTML / ActiveAdmin side of the
#   #   application still represents anonymous visitors with `nil`.
#   class AnonymousUser < Naught
#     include AnonymousInterface
#     include GlobalID::Identification
#     extend AnonymousInterface::ClassMethods
#   end
AnonymousUser = Naught.build do |config|
  config.mimic User

  config.predicates_return false
end.tap do |klass|
  klass.prepend AnonymousInterface

  klass.extend AnonymousInterface::ClassMethods
end
