# frozen_string_literal: true

module Mutations
  # @abstract The base mutation class for all GraphQL mutations.
  #   It integrates with the {VOGMutations} framework to provide
  #   a standardized way to define and execute mutations with
  #   authorization, dry-rb validation, and error handling.
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    extend Dry::Core::ClassAttributes

    extend VOGMutations::Arguments::Manipulation

    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    # @!attribute [r] operation_name
    # @!scope class
    # Defines the name of the operation to be performed by this mutation.
    #
    # Set via {.performs_operation!}.
    # @see VOGMutations::Types::OperationName
    # @return [String]
    defines :operation_name, type: VOGMutations::Types::OperationName

    operation_name "vog_mutations.test_action"

    # The entry point for the mutation.
    #
    # @param [{ Symbol => Object }] args
    # @return [Hash, GraphQL::ExecutionError]
    def resolve(**args)
      perform_operation(operation_name, **args)
    end

    private

    # Perform the given operation with the provided arguments.
    #
    # This sets up the {VOGMutations::Executor} with the necessary context and
    # arguments, and then calls it to execute the operation.
    #
    # @api private
    # @param [String] name
    # @param [{ Symbol => Object }] args
    # @return [Hash, GraphQL::ExecutionError]
    def perform_operation(name, **args)
      operation = Common::Container[name]

      executor = VOGMutations::Executor.new(
        operation,
        argument_set:,
        context:,
        mutation: self,
        operation_name: name,
        provided_args: args.freeze,
      )

      executor.()
    end

    # @see .argument_set
    # @return [VOGMutations::Arguments::Set]
    def argument_set = self.class.argument_set

    # @see .operation_name
    # @return [String]
    def operation_name = self.class.operation_name

    class << self
      # @note We override this method to rebuild the {#argument_set}
      #   and {#argument_paths} whenever a new argument is added.
      # @return [void]
      def argument(...)
        super
      ensure
        @argument_paths = build_argument_paths
        @argument_set = build_argument_set
      end

      # @!attribute [r] argument_paths
      # The list of argument paths defined for this mutation.
      # @see Types::BaseArgument#walk_path_segments
      # @return [<VOGMutations::Arguments::Path>]
      def argument_paths
        @argument_paths ||= build_argument_paths
      end

      # @!attribute [r] argument_set
      # The set of arguments defined for this mutation.
      # @see Types::BaseArgument#walk_path_segments
      # @return [VOGMutations::Arguments::Set]
      def argument_set
        @argument_set ||= build_argument_set
      end

      # @param [String] name
      # @return [void]
      def performs_operation!(name, destroy: false)
        operation_name name

        standard_mutation!

        destroy_mutation! if destroy
      end

      # @return [void]
      def standard_mutation!
        payload_implements Types::StandardMutationPayloadType
      end

      # @return [void]
      def destroy_mutation!
        payload_implements Types::DestroyMutationPayloadType
      end

      private

      # @return [void]
      def payload_implements(*interfaces)
        interfaces.flatten.each { payload_type.implements _1 }
      end

      # @return [<VOGMutations::Arguments::Path>]
      def build_argument_paths
        Array(arguments.values.map { Array(_1.try(:walk_path_segments)) }.reduce(&:+))
      end

      # @return [VOGMutations::Arguments::Set]
      def build_argument_set
        VOGMutations::Arguments::Set.new(argument_paths)
      end
    end
  end
end
