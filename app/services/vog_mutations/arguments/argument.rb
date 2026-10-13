# frozen_string_literal: true

module VOGMutations
  module Arguments
    # A struct representing a reference to a GraphQL argument.
    class Argument < PathSegment
      include Dry::Core::Equalizer.new(:keyword)

      attribute :keyword, Types::Coercible::Symbol
      attribute :name, Types::Coercible::String
      attribute? :type, Types::Any.optional
      attribute? :argument, Types.Instance(::GraphQL::Schema::Argument).optional

      def graphql_key = name

      def match_ruby?(value) = keyword == value

      def ruby_key = keyword.to_s
    end
  end
end
