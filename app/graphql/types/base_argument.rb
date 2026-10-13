# frozen_string_literal: true

module Types
  # @abstract The base argument class for GraphQL arguments.
  class BaseArgument < GraphQL::Schema::Argument
    # @abstract
    def initialize(*args, public_values: [], transient: false, replace_null_with_default: nil, **kwargs, &block)
      @transient = transient
      @public_values = Array(public_values).flatten

      replace_null_with_default = !kwargs[:default_value].nil? if replace_null_with_default.nil?

      super(*args, replace_null_with_default:, **kwargs, &block)
    end

    # Whether or not this argument is authorized for the given value and context.
    #
    # It will check public values if they are defined.
    #
    # @param [Object] obj
    # @param [Object] arg_value
    # @param [GraphQL::Query::Context] ctx
    def authorized?(obj, arg_value, ctx)
      super && maybe_check_public?(arg_value, ctx)
    end

    # Whether or not this argument has public values defined.
    def has_public_values?
      @public_values.present?
    end

    # @param [Object] arg_value
    # @param [GraphQL::Query::Context] ctx
    def maybe_check_public?(arg_value, ctx)
      # simplecov:disable
      return true unless should_check_public_values?(ctx)

      arg_value.in?(@public_values)
      # simplecov:enable
    end

    # Determine whether we should check public values for this argument.
    #
    # @param [GraphQL::Query::Context] ctx
    def should_check_public_values?(ctx)
      has_public_values? && !ctx[:current_user].try(:has_any_admin_access?)
    end

    # @api private
    # A method used for turning an argument (and any nested arguments) into an array
    # of {VOGMutations::Arguments::Path} objects, to be placed in a {VOGMutations::Arguments::Set}.
    #
    # @see Mutations::BaseMutation.argument_set
    # @return [<VOGMutations::Arguments::Path>]
    def walk_path_segments
      to_path_segments.each_with_object([]) do |part, paths|
        paths.concat(walk_paths_for(part))
      end
    end

    # @api private
    # @param [Object] input
    # @param [<VOGMutations::Arguments::PathSegment>] parent
    # @return [<VOGMutations::Arguments::Path>]
    def walk_paths_for(input, parent: [])
      paths = []

      case input
      in Hash
        input.each do |segment, subsegments|
          paths += walk_paths_for([segment, subsegments], parent:)
        end
      in VOGMutations::Arguments::Argument => segment, Array => subsegments
        segments = [*parent, segment]

        paths << path_for(segments)

        subsegments.each do |subsegment|
          paths += walk_paths_for(subsegment, parent: segments)
        end
      in VOGMutations::Arguments::List => segment, Array => subsegments
        list_parent = [*parent, segment]

        subsegments.each do |subsegment|
          paths += walk_paths_for(subsegment, parent: list_parent)
        end
      in VOGMutations::Arguments::Argument => segment
        # simplecov:disable
        segments = [*parent, segment]

        paths << path_for(segments)
        # simplecov:enable
      else
        # simplecov:disable
        raise "Unexpected segment type: #{input.class.name.inspect}"
        # simplecov:enable
      end

      return paths
    end

    # @api private
    # @param [<VOGMutations::Arguments::PathSegment>] segments
    # @return [VOGMutations::Arguments::Path]
    def path_for(*segments)
      segments.flatten!

      VOGMutations::Arguments::Path.new(segments)
    end
  end
end
