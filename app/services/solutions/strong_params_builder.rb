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

    after_build :maybe_add_organization!

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

    def maybe_add_organization!
      @params << :organization_id if actual?
    end

    def initialize_common_strong_params
      [].tap do |params|
        params.concat SolutionInterface::STANDARD_ATTRIBUTES
        params.concat SolutionInterface::ATTACHMENTS
        params.concat SolutionInterface::TAG_LISTS
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

      Solution.each_implementation do |implementation|
        enums << implementation.enum

        impls[implementation.name] = implementation.type.strong_params
      end

      [*enums, impls]
    end

    def store_model_list_attributes
      SolutionInterface::STORE_MODEL_LISTS.index_with do |key|
        store_model_list_attributes_for(key)
      end.transform_keys { :"#{_1}_attributes" }
    end

    def store_model_list_attributes_for(key)
      store_model_list_type_for(key).attribute_names.map(&:to_sym)
    end

    # @return [Class]
    def store_model_list_type_for(key)
      case key
      in :comparable_products
        Solutions::ComparableProduct
      in :current_affiliations
        Solutions::Institution
      in :founding_institutions
        Solutions::Institution
      in :service_providers
        Solutions::ServiceProvider
      end
    end

    def shared_multiple_association_keys
      SolutionInterface::SHARED_MULTIPLE_ASSOCIATIONS.each_with_object({}) do |option, h|
        h[:"#{option.to_s.singularize}_ids"] = []
      end
    end

    def shared_option_association_keys
      SolutionInterface::SHARED_OPTION_ASSOCIATIONS.map { :"#{_1}_id" }
    end
  end
end
