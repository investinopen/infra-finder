# frozen_string_literal: true

# A concern for models that act as options to certain properties on a {Solution}.
module SolutionOption
  extend ActiveSupport::Concern

  include Filterable
  include SluggedByName
  include TimestampScopes

  included do
    extend Dry::Core::ClassAttributes

    defines :option_mode, type: Solutions::Types::OptionMode
  end

  module ClassMethods
    # @return [void]
    def multiple!
      include SolutionOption::Multiple
    end

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
    def single!
      include SolutionOption::Single
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

  # Options that a {Solution} can select multiple of, through a join record.
  module Multiple
    extend ActiveSupport::Concern

    included do
      option_mode :multiple
    end
  end

  # Options that a {Solution} can select only one of, as foreign keys directly on the record.
  module Single
    extend ActiveSupport::Concern

    included do
      option_mode :single

      has_many :solutions, inverse_of: model_name.i18n_key, dependent: :restrict_with_error

      has_many :solution_drafts, inverse_of: model_name.i18n_key, dependent: :restrict_with_error
    end
  end
end
