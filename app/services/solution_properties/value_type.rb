# frozen_string_literal: true

module SolutionProperties
  # Describes what a property's value is, so a client can render an input for
  # it without knowing ActiveAdmin's forms.
  #
  # @see SolutionProperty#value_type
  # @see Types::SolutionPropertyValueType
  module ValueType
    Scalar = Data.define(:scalar, :max_length)
    Enum = Data.define(:options)
    Vocabulary = Data.define(:vocab, :multiple, :other_property_key)
    Association = Data.define(:type_name, :multiple)
    StructuredList = Data.define(:fields, :free_input_key)
    StructuredField = Data.define(:name, :label, :scalar, :required)
    Implementation = Data.define(:link_mode, :status_property_key)

    # Scalar kinds by property kind.
    SCALARS = {
      attachment: "IMAGE",
      blurb: "TEXT",
      boolean: "BOOLEAN",
      contact: "CONTACT",
      date: "DATE",
      email: "EMAIL",
      integer: "INTEGER",
      money: "MONEY",
      other_option: "TEXT",
      store_model_input: "TEXT",
      string: "STRING",
      timestamp: "DATETIME",
      url: "URL",
    }.freeze

    class << self
      # @param [SolutionProperty] property
      # @return [Scalar, Enum, Vocabulary, Association, StructuredList, Implementation, nil]
      #   nil for `standard` properties, which are not stored values
      def for(property)
        return association_for(property) if property.association_name.present?

        case property.kind
        in :standard
          nil
        in :enum | :implementation_enum
          Enum.new(options: options_for(property))
        in :single_option | :multi_option if property.vocab&.uses_model?
          Vocabulary.new(vocab: property.vocab, multiple: property.kind == :multi_option, other_property_key: property.other_property&.name)
        in :single_option
          Enum.new(options: options_for(property))
        in :store_model_list
          structured_list_for(property)
        in :implementation
          Implementation.new(link_mode: property.implementation.link_mode.to_s.upcase, status_property_key: property.implementation.enum_property.name)
        else
          Scalar.new(scalar: property.scalar_kind&.upcase || SCALARS.fetch(property.kind), max_length: property.max_length)
        end
      end

      private

      # @param [SolutionProperty] property
      # @return [Association]
      def association_for(property)
        reflection = ::Solution.reflect_on_association(property.association_name.to_sym)

        Association.new(type_name: reflection.klass.graphql_node_type.graphql_name, multiple: reflection.collection?)
      end

      # @param [SolutionProperty] property
      # @return [<Hash>]
      def options_for(property)
        ::SolutionProperties::GraphQLOptions.new(property).call
      end

      # @param [SolutionProperty] property
      # @return [StructuredList]
      def structured_list_for(property)
        model = property.store_model_type_name.constantize

        required = model.validators.select { _1.kind == :presence }.flat_map(&:attributes).map(&:to_s)

        urls = model.validators.select { _1.kind == :url }.flat_map(&:attributes).map(&:to_s)

        fields = model.attribute_types.map do |name, type|
          scalar = urls.include?(name) ? "URL" : SCALARS.fetch(type.type, type.type.to_s.upcase)

          StructuredField.new(name: name.camelize(:lower), label: model.human_attribute_name(name), scalar:, required: required.include?(name))
        end

        StructuredList.new(fields:, free_input_key: property.free_input_name&.to_s)
      end
    end
  end
end
