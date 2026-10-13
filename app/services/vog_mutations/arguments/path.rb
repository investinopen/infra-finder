# frozen_string_literal: true

module VOGMutations
  module Arguments
    # An object representing a path to a specific argument
    class Path
      include Support::Typing
      include Dry::Core::Equalizer.new(:graphql_path, :ruby_path)

      include Dry::Initializer[undefined: false].define -> do
        param :segments, VOGMutations::Arguments::PathSegment::List
      end

      # The GraphQL-style path to this argument.
      #
      # @return [String]
      attr_reader :graphql_path

      # The Ruby-style path to this argument.
      #
      # @return [String]
      attr_reader :ruby_path

      # The number of segments in this path.
      #
      # @return [Integer]
      attr_reader :size

      # @return [Boolean]
      attr_reader :top_level

      alias top_level? top_level

      # @return [Boolean]
      attr_reader :transient

      alias transient? transient

      # @return [Symbol, nil]
      attr_reader :transient_argument

      def initialize(...)
        super

        @graphql_path = segments.map(&:graphql_key).join(?.)
        @ruby_path = segments.map(&:ruby_key).join(?.)
        @size = segments.size
        @top_level = segments.one?
        @transient = top_level? && segments.first.transient?

        @transient_argument = segments.first.keyword if transient?
      end

      # @param [<Object>] path
      # @return [<Object>]
      def graphqlize(path)
        # simplecov:disable
        return path unless match_ruby?(path)
        # simplecov:enable

        segments.each_with_index.map do |segment, index|
          case segment
          when VOGMutations::Arguments::Argument
            segment.name
          else
            path[index]
          end
        end
      end

      # @param [<Object>] path
      def match_ruby?(path)
        path.kind_of?(Array) && path.size == size && segments.zip(path).all? { |segment, value| segment.match_ruby?(value) }
      end
    end
  end
end
