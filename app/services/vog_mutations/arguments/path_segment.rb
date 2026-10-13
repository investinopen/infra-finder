# frozen_string_literal: true

module VOGMutations
  module Arguments
    # @abstract A segment within a {VOGMutations::Arguments::Path}.
    class PathSegment < Support::FlexibleStruct
      include Support::Typing

      attribute? :transient, Types::Bool.default(false)

      alias transient? transient

      # @abstract
      def match_ruby?(value) = false
    end
  end
end
