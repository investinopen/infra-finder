# frozen_string_literal: true

module VOGMutations
  module Arguments
    # An object used in testing for quickly building out {VOGMutations::Arguments::Set} instances.
    class SetBuilder
      def call(&)
        path_builder = VOGMutations::Arguments::PathBuilder.new([])

        paths = path_builder.(&)

        return VOGMutations::Arguments::Set.new(paths)
      end
    end
  end
end
