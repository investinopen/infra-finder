# frozen_string_literal: true

module Support
  module Schemas
    class TypeContainer < Dry::Schema::TypeContainer
      include HandlesModelName

      NAMESPACES = %w[params json].freeze

      def initialize(...)
        super

        add! :bigdecimal, Support::Types::BigDecimal

        add! :safe_string, Types::SafeString

        add_model! "User"
      end

      def configure
        yield self

        return self
      end

      def add!(name, type)
        register(name, type)

        case name
        when String, Symbol
          NAMESPACES.each do |ns|
            register "#{ns}.#{name}", type
          end
        end
      end

      def add_model!(klass, model_name: model_name_from(klass), single_key: model_name.singular, plural_key: model_name.plural)
        single_type = ::Support::Types::ModelInstanceNamed[klass]

        plural_type = Types::Array.of(single_type)

        add! single_key, single_type
        add! plural_key, plural_type

        return self
      end
    end
  end
end
