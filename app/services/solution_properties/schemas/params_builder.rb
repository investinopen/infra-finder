# frozen_string_literal: true

module SolutionProperties
  module Schemas
    class ParamsBuilder < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        option :solution_kind, Solutions::Types::Kind
      end

      ENUMS = {
        implementation_status: "unknown",
        pricing_implementation_status: "unknown",
        publication: "unpublished",
      }.to_h do |name, default|
        [name, ApplicationRecord.dry_pg_enum(name, default:)]
      end.with_indifferent_access

      # @return [Dry::Types::Type]
      attr_reader :dry_type

      # @return [Hash]
      attr_reader :schema

      standard_execution!

      # @return [Dry::Types::Type]
      def call
        run_callbacks :execute do
          yield prepare!

          yield fetch_or_build!

          yield finalize!
        end

        Success dry_type
      end

      wrapped_hook! def prepare
        @key_mapping = {}.with_indifferent_access

        @schema = {}

        @dry_type = nil

        super
      end

      wrapped_hook! def fetch_or_build
        yield build!

        yield build_associations!

        yield build_implementations!

        yield build_store_model_lists!

        super
      end

      wrapped_hook! def build
        if actual?
          add_to_schema! :provider_id, type: Types::OptionalID
          add_to_schema! :publication, type: ENUMS.fetch(:publication)
        end

        if intake?
          add_to_schema! :launch_year
        end

        add_to_schema!(SolutionProperty.standard_values)

        add_to_schema!(SolutionProperty.attachment_values)

        SolutionProperty.attachment_values.each do |field|
          add_to_schema!(:"#{field}_remote_url", type: Types::OptionalString)
        end

        add_to_schema!(SolutionProperty.free_input_names, type: Types::OptionalString)

        super
      end

      wrapped_hook! def build_associations
        add_to_schema!(SolutionProperty.has_one_associations, type: Types::OptionalID) do |field|
          :"#{field}_id?"
        end

        add_to_schema!(SolutionProperty.has_many_associations, type: Types::OptionalIDs) do |field|
          :"#{field.to_s.singularize}_ids?"
        end

        super
      end

      wrapped_hook! def build_implementations
        Implementation.each do |implementation|
          @key_mapping[implementation.nested_attributes] = implementation.name.to_sym

          enum_type = ENUMS.fetch(implementation.enum_type)

          add_to_schema!(implementation.enum, type: enum_type)

          add_to_schema!(implementation.name, type: implementation.type.dry_type)
        end

        super
      end

      wrapped_hook! def build_store_model_lists
        SolutionProperty.store_model_lists.each do |prop|
          remapped = :"#{prop.name.to_s.singularize}_attributes"

          @key_mapping[remapped] = prop.name.to_sym

          model_type = prop.store_model_type_name.constantize

          type = InfraFinder::Container["solution_properties.schemas.simple_list_type_for"].(model_type)

          add_to_schema!(prop.name, type:)
        end

        super
      end

      wrapped_hook! def finalize
        @dry_type = Solutions::Types::Coercible::Hash.schema(**@schema).with_key_transform do |key|
          transformed = @key_mapping.fetch(key, key).to_sym

          transformed
        end

        super
      end

      private

      # @!group Solution Predicates

      def actual? = solution_kind == :actual

      def draft? = solution_kind == :draft

      def intake? = solution_kind == :intake

      # @!endgroup

      # @param [<Symbol>] keys
      # @param [Dry::Types::Type] type
      # @yield [Symbol] key
      # @yieldreturn [Symbol] schema_key
      # @return [void]
      def add_to_schema!(*keys, type: Solutions::Types::Any, &)
        keys.flatten.each do |key|
          schema_key = block_given? ? yield(key) : :"#{key}?"

          @schema[schema_key.to_sym] = type
        end
      end
    end
  end
end
