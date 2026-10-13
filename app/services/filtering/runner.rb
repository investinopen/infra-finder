# frozen_string_literal: true

module Filtering
  # A runner class that applies filtering scopes to ActiveRecord relations.
  #
  # @see Filtering::Run
  # @note Primarily used in testing.
  class Runner
    include Dry::Monads[:result]
    include Dry::Initializer[undefined: false].define -> do
      param :klass, Support::Models::Types::ModelClass

      option :base_scope, Support::Types::Relation, default: proc { klass.all }
      option :options, Types::Hash.map(Types::Coercible::Symbol, Types::Any)
      option :filter_klass, Types::FiltersClass, default: proc { "::Filtering::Scopes::#{klass.model_name.to_s.pluralize}".constantize }
      option :current_user, ::Users::Types::Current, default: ::Users::Types::DEFAULT_FROM_REQUEST
    end

    # @return [Filtering::FilterScope]
    attr_reader :filters

    # @return [ActiveRecord::Relation]
    def call
      @filters = filter_klass.new(**options, current_user:)

      result = filters.apply_to base_scope

      Success result
    end
  end
end
