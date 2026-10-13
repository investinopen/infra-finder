# frozen_string_literal: true

module VOGMutations
  module Arguments
    # A definition for a shared argument.
    #
    # @see Mutations::BaseArgumentSet
    class Shared < Support::FlexibleStruct
      include Dry::Core::Equalizer.new(:name)

      attribute :name, Types::ArgKey
      attribute :type, Types::Any
      attribute :options, Types::Hash
      attribute :block, Types::Callable.optional

      # @param [Class(Mutations::BaseMutation)] mutation_class
      # @return [void]
      def apply_to!(mutation_class)
        return if mutation_class.arguments.key?(name.to_s.camelize(:lower))

        mutation_class.argument(name, type, **options, &block)
      end
    end
  end
end
