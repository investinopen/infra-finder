# frozen_string_literal: true

module Support
  module GQL
    module Types
      extend Support::Typespace

      UNSET_TYPE = Object.new.freeze

      InterfaceType = Support::Types::Module.constrained(lt: ::GraphQL::Schema::Interface)

      ObjectType = Support::Types::Class.constrained(lt: ::GraphQL::Schema::Object)

      ExposableKind = Coercible::Symbol.enum(:interface, :object)

      ExposableType = InterfaceType | ObjectType

      ExposableTypeOrUnset = ExposableType | Types::Constant(UNSET_TYPE)

      ExposesType = Interface(:graphql_object_type)
    end
  end
end
