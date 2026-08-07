# frozen_string_literal: true

module SolutionProperties
  # @see SolutionProperties::BuildStrongParams
  class StrongParamsBuilder < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :solution_kind, Types::SolutionKind

      option :current_user, Types::User.optional, optional: true

      option :_user_kind, ::Users::Types::Kind, as: :user_kind, default: proc { Users::Types::Kind[current_user&.kind] }
    end

    ALLOWED_USER_KINDS = {
      actual: %i[super_admin admin],
      draft: %i[super_admin admin editor],
      intake: %i[super_admin admin editor user anonymous],
    }.freeze

    ADMINS = %i[super_admin admin].freeze

    # @return [<Users::Types::Kind>]
    attr_reader :allowed_user_kinds

    # @return [<Symbol, Hash>]
    attr_reader :params

    # @return [Utility::StrongParamSet]
    attr_reader :param_set

    standard_execution!

    # @return [<Symbol, Hash>]
    def call
      run_callbacks :execute do
        yield prepare!

        yield check!

        yield add_simple!

        yield add_associations!

        yield add_implementations!

        yield add_store_model_lists!
      end

      @params.concat(param_set)

      Success params
    end

    wrapped_hook! def prepare
      @allowed_user_kinds = ALLOWED_USER_KINDS.fetch(solution_kind)

      @param_set = Utility::StrongParamSet.new

      @params = []

      super
    end

    wrapped_hook! def check
      return Failure[:no_strong_params_allowed] unless user_kind.in?(allowed_user_kinds)

      super
    end

    wrapped_hook! def add_simple
      @param_set.concat(SolutionProperty.standard_values)
      @param_set.concat(SolutionProperty.free_input_names)

      SolutionProperty.attachment_values.each do |key|
        @param_set << key

        if intake?
          @param_set << :"#{key}_remote_url"
        end
      end

      if actual?
        @param_set << :provider_id << :publication
      end

      if intake? && any_admin?
        @param_set << :provider_id
      elsif intake? && anonymous?
        @param_set.delete(:founded_on)

        @param_set << :launch_year
      end

      super
    end

    wrapped_hook! def add_associations
      SolutionProperty.has_one_associations.each do |option|
        @param_set << :"#{option}_id"
      end

      SolutionProperty.has_many_associations.each do |option|
        @param_set.array! :"#{option.to_s.singularize}_ids"
      end

      super
    end

    wrapped_hook! def add_implementations
      Implementation.each do |impl|
        @param_set << impl.enum

        params = impl.type.strong_params

        @param_set[impl.name] = params
        @param_set[impl.nested_attributes] = params
      end

      super
    end

    wrapped_hook! def add_store_model_lists
      SolutionProperty.store_model_lists.each do |list|
        @param_set[:"#{list.name}_attributes"] = store_model_list_attributes_for(list.name)
      end

      super
    end

    private

    # @!group Predicates

    def actual? = solution_kind == :actual

    def anonymous? = user_kind == :anonymous

    def any_admin? = user_kind.in?(ADMINS)

    def draft? = solution_kind == :draft

    def intake? = solution_kind == :intake

    # @!endgroup Predicates

    def store_model_list_attributes_for(key)
      store_model_list_type_for(key).attribute_names.map(&:to_sym)
    end

    # @param [#to_s] key
    # @return [Class]
    def store_model_list_type_for(key)
      Solution.store_model_attribute_types.fetch(key.to_s).model_klass
    end
  end
end
