# frozen_string_literal: true

module Support
  module Patches
    module ArgumentWalking
      module BuildsPathSegments
        # @api private
        # @param [Object] object
        # @return [<VOGMutations::Arguments::PathSegment>]
        # @return [{ VOGMutations::Arguments::PathSegment => <VOGMutations::Arguments::PathSegment> }]
        def path_segments_for(object)
          case object
          when ::GraphQL::Schema::Argument
            object.to_path_segments
          when ::GraphQL::Schema::NonNull
            path_segments_for(object.of_type)
          when ::GraphQL::Schema::List
            object.to_path_segments
          else
            object.try(:to_path_segments) || []
          end.to_a
        end
      end

      module ArgumentEnhancement
        # Whether this argument is transient.
        #
        # Transient arguments can be used for validation and authorization, but will not
        # be passed to the mutation implementation's actual `call` method.
        # @return [Boolean]
        attr_reader :transient

        alias transient? transient

        # @return [VOGMutations::Arguments::Argument]
        def to_path_segment
          VOGMutations::Arguments::Argument.new(
            keyword: keyword || name.to_s.underscore.to_sym,
            name:,
            type:,
            argument: self,
            transient:
          )
        end

        # @return [<VOGMutations::Arguments::PathSegment>]
        # @return [{ VOGMutations::Arguments::PathSegment => <VOGMutations::Arguments::PathSegment> }]
        def to_path_segments
          segment = to_path_segment

          subsegments = path_segments_for(type)

          { segment => subsegments }
        end
      end

      module InputObjectEnhancement
        # @return [<VOGMutations::Arguments::PathSegment>]
        def to_path_segments
          arguments.values.map(&:to_path_segments)
        end
      end

      module ListEnhancement
        # @return [VOGMutations::Arguments::List]
        def to_path_segment
          ::VOGMutations::Arguments::List.new(actual: self)
        end

        # @return [{ VOGMutations::Arguments::PathSegment => <VOGMutations::Arguments::PathSegment> }]
        def to_path_segments
          segment = to_path_segment

          subsegments = path_segments_for(of_type)

          { segment => subsegments }
        end
      end

      module NonNullEnhancement
        # @return [<VOGMutations::Arguments::PathSegment>]
        def to_path_segments
          path_segments_for(of_type)
        end
      end
    end
  end
end

[GraphQL::Schema::Argument, GraphQL::Schema::InputObject, GraphQL::Schema::List, GraphQL::Schema::NonNull].each do |klass|
  klass.prepend Support::Patches::ArgumentWalking::BuildsPathSegments
end

GraphQL::Schema::Argument.prepend Support::Patches::ArgumentWalking::ArgumentEnhancement
GraphQL::Schema::InputObject.singleton_class.prepend Support::Patches::ArgumentWalking::InputObjectEnhancement
GraphQL::Schema::List.prepend Support::Patches::ArgumentWalking::ListEnhancement
GraphQL::Schema::NonNull.prepend Support::Patches::ArgumentWalking::NonNullEnhancement
