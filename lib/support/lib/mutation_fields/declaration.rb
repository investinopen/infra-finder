# frozen_string_literal: true

module Support
  module MutationFields
    # A struct representing a mutation field declaration in a GraphQL type definition file.
    class Declaration < Support::FlexibleStruct
      include Comparable
      include Dry::Core::Equalizer(:name)

      attribute :name, Support::Types::String
      attribute :content, Support::Types::String
      attribute :index, Support::Types::Integer

      def <=>(other)
        name <=> other.name
      end

      def line
        "#{content.indent(4)}\n"
      end
    end
  end
end
