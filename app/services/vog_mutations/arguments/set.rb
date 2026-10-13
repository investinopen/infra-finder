# frozen_string_literal: true

module VOGMutations
  module Arguments
    # A set of {VOGMutations::Arguments::Path} objects for a given mutation.
    #
    # It is used for generating proper errors, detecting top-level transient
    # arguments, etc.
    class Set
      include Support::Typing
      include Dry::Initializer[undefined: false].define -> do
        param :paths, VOGMutations::Arguments::Path::List, default: proc { Dry::Core::Constants::EMPTY_ARRAY }
      end

      alias argument_paths paths

      # An object used for compiling errors based on this argument set.
      #
      # @return [VOGMutations::ErrorCompiler]
      attr_reader :error_compiler

      # A list of top-level arguments that are marked as transient,
      # and thus won't be passed along to the mutation's resolver.
      #
      # @return [<Symbol>]
      attr_reader :transient_arguments

      # Set up the argument set's {#error_compiler} and
      # {#transient_arguments}.
      def initialize(...)
        super

        @error_compiler = VOGMutations::ErrorCompiler.new(argument_set: self)

        @transient_arguments = paths.select(&:transient?).map(&:transient_argument)
      end

      # Take a raw path and normalize it, based on known attribute paths.
      #
      # It allows us to work with normalized Ruby paths while in Ruby, but
      # ensures that the GraphQL-style paths are what get reported in errors.
      #
      # The main use case is handling auto-loading attributes, since in GraphQL
      # those will be something like `userId`, but in ruby they will be `:user`.
      #
      # @api private
      # @param [String, <Symbol, Integer>] raw_path
      # @return [<String, Integer>]
      def normalize_attribute_path(raw_path)
        path = Array(raw_path)

        matched_path = argument_paths.detect { _1.match_ruby?(path) }

        return matched_path.graphqlize(path) if matched_path.present?

        path.map do |part|
          part.kind_of?(Symbol) ? part.to_s.camelize(:lower) : part
        end
      end

      class << self
        # @api private
        # Build a new {VOGMutations::Arguments::Set} using a block DSL.
        # @return [VOGMutations::Arguments::Set]
        def build!(&)
          builder = VOGMutations::Arguments::SetBuilder.new

          builder.(&)
        end
      end
    end
  end
end
