# frozen_string_literal: true

Support::System.register_provider(:global_types) do
  start do
    ActiveModel::Type.register :any_array, ::Support::GlobalTypes::AnyArray
    ActiveModel::Type.register :any_json, ::Support::GlobalTypes::AnyJSON
    ActiveModel::Type.register :string_array, ::Support::GlobalTypes::StringArray
    ActiveModel::Type.register :integer_array, ::Support::GlobalTypes::IntegerArray

    ActiveModel::Type.register :indifferent_hash, ::Support::GlobalTypes::IndifferentHash
    ActiveModel::Type.register :property_hash, ::Support::GlobalTypes::PropertyHash

    ActiveRecord::Type.register :indifferent_hash, ::Support::GlobalTypes::IndifferentHash
    ActiveRecord::Type.register :property_hash, ::Support::GlobalTypes::PropertyHash
  end
end
