# frozen_string_literal: true

module Solutions
  class StrongParamsBuilder < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      option :current_user, Types::User.optional, optional: true
      option :draft, Types::Bool, default: proc { false }

      option :_user_kind, ::Users::Types::Kind, as: :user_kind, default: proc { Users::Types::Kind[current_user&.kind] }
    end

    ALLOWED_USER_KINDS = {
      actual: %i[super_admin admin],
      draft: %i[super_admin admin editor],
    }.freeze

    # @return [<Users::Types::Kind>]
    attr_reader :allowed_user_kinds

    # @return [String]
    attr_reader :cache_key

    # @return [<Symbol, Hash>]
    attr_reader :params

    # @return [Solutions::Types::Kind]
    attr_reader :solution_kind

    standard_execution!

    # @return [<Symbol, Hash>]
    def call
      run_callbacks :execute do
        yield prepare!

        yield fetch_or_build!
      end

      Success params
    end

    wrapped_hook! def prepare
      @solution_kind = Solutions::Types::Kind[draft ? :draft : :actual]

      @allowed_user_kinds = ALLOWED_USER_KINDS.fetch(solution_kind)

      @cache_key = yield build_cache_key

      super
    end

    wrapped_hook! def fetch_or_build
      @params = yield build!

      super
    end

    wrapped_hook! def build
      @params = initialize_common_strong_params
    end

    after_build :add_actuals!, if: :actual?

    private

    # @!group Solution Predicates

    def actual?
      solution_kind == :actual
    end

    def draft?
      solution_kind == :draft
    end

    # @!endgroup

    def build_cache_key
      return Failure[:no_strong_params_allowed] unless user_kind.in?(allowed_user_kinds)

      cache_key = ["solutions", "strong_params", solution_kind, user_kind].join(?/)

      Success cache_key
    end

    def add_actuals!
      @params << :provider_id << :publication
    end

    def initialize_common_strong_params
      [].tap do |params|
        params.concat SolutionProperty.standard_values
        params.concat SolutionProperty.attachment_values
        params.concat SolutionProperty.free_input_names
        params.concat shared_option_association_keys
        params.concat implementation_params
        params << store_model_list_attributes
        params << shared_multiple_association_keys
      end
    end

    # @return [Array]
    def implementation_params
      enums = []

      impls = {}

      Implementation.each do |implementation|
        enums << implementation.enum.to_sym

        impls[implementation.name.to_sym] = implementation.type.strong_params
        impls[implementation.nested_attributes] = implementation.type.strong_params
      end

      [*enums, impls]
    end

    def store_model_list_attributes
      SolutionProperty.store_model_lists.map(&:name).index_with do |key|
        store_model_list_attributes_for(key)
      end.transform_keys { :"#{_1}_attributes" }
    end

    def store_model_list_attributes_for(key)
      store_model_list_type_for(key).attribute_names.map(&:to_sym)
    end

    # @param [#to_s] key
    # @return [Class]
    def store_model_list_type_for(key)
      Solution.store_model_attribute_types.fetch(key.to_s).model_klass
    end

    def shared_multiple_association_keys
      SolutionProperty.has_many_associations.each_with_object({}) do |option, h|
        h[:"#{option.to_s.singularize}_ids"] = []
      end
    end

    def shared_option_association_keys
      SolutionProperty.has_one_associations.map { :"#{_1}_id" }
    end
  end
end
