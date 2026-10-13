# frozen_string_literal: true

module VOGMutations
  module Arguments
    # An object representing a list
    class List < PathSegment
      include Dry::Core::Equalizer.new(:identifier)

      attribute? :actual, Types.Instance(::GraphQL::Schema::List).optional

      def graphql_key = "<LIST>"

      def identifier = :list

      def match_ruby?(value) = value.kind_of?(Integer)

      def ruby_key = "$LIST$"
    end
  end
end
