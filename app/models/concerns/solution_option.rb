# frozen_string_literal: true

# A concern for models that act as options to certain properties on a {Solution}.
module SolutionOption
  extend ActiveSupport::Concern

  include SluggedByName
  include TimestampScopes

  module ClassMethods
    def policy_class
      SolutionOptionPolicy
    end

    def ransackable_associations(auth_object = nil)
      []
    end

    def ransackable_attributes(auth_object = nil)
      [
        "id",
        "created_at", "updated_at",
        "name",
        "description",
        "visibility"
      ]
    end

    # @return [void]
    def scalar!
      has_many :solutions, inverse_of: model_name.i18n_key, dependent: :restrict_with_error

      has_many :solution_drafts, inverse_of: model_name.i18n_key, dependent: :restrict_with_error
    end

    # @api private
    # @abstract
    # @return [ActiveRecord::Relation<SolutionOption>]
    def order_for_select_options
      lazily_order(:name)
    end

    # @return [<(String, String)>]
    def to_select_options
      order_for_select_options.pluck(:name, :id)
    end
  end
end
