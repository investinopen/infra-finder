# frozen_string_literal: true

module VOGMutations
  module Arguments
    # An object used in testing for quickly building out {VOGMutations::Arguments::Path} instances.
    class PathBuilder
      include Dry::Initializer[undefined: false].define -> do
        param :initial_segments, VOGMutations::Arguments::PathSegment::List
      end

      # @return [<VOGMutations::Arguments::Path>]
      def call(&)
        @paths = []

        instance_eval(&)

        return @paths
      end

      # @param [Symbol] keyword
      def argument!(keyword, name: nil, **options, &)
        name = name.presence || keyword.to_s.camelize(:lower)

        options[:keyword] = keyword
        options[:name] = name

        segment = VOGMutations::Arguments::Argument.new(**options)

        add_path_for!(segment, &)
      end

      alias arg! argument!

      # @param [Boolean] transient
      def list!(transient: false, &)
        segment = VOGMutations::Arguments::List.new(transient:)

        add_path_for!(segment, &)
      end

      private

      def add_path_for!(segment, &)
        new_segments = initial_segments + [segment]

        if segment.kind_of?(VOGMutations::Arguments::Argument)
          path = VOGMutations::Arguments::Path.new(new_segments)

          @paths << path
        end

        return unless block_given?

        builder = self.class.new(new_segments)

        @paths.concat(builder.call(&))
      end
    end
  end
end
