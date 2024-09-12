# frozen_string_literal: true

module Comparisons
  class SearchFilters
    include Support::EnhancedStoreModel
    include Comparisons::Filtering::Groupings

    ACCEPTABLE_SORTS = [
      "updated_at desc",
      "name asc",
      "name desc",
    ].freeze

    DEFAULT_SORT = "updated_at desc"

    # Sorting
    global_filter! :s, :string

    global_filter! :name_or_provider_name_cont, :string

    global_filter! :country_code_eq, :string

    Solutions::Flags.scopes.each_value do |scope_name|
      flag_filter! scope_name, :boolean
    end

    solution_category_filter! :solution_categories_id_in, :string_array

    technical_attribute_filter! :maintenance_active, :boolean
    technical_attribute_filter! :open_api_available, :boolean
    technical_attribute_filter! :code_repository_available, :boolean
    technical_attribute_filter! :open_data_available, :boolean
    technical_attribute_filter! :product_roadmap_available, :boolean
    technical_attribute_filter! :user_documentation_available, :boolean

    community_engagement_filter! :code_of_conduct_available, :boolean
    community_engagement_filter! :community_engagement_available, :boolean
    community_engagement_filter! :contribution_pathways_available, :boolean

    policy_filter! :bylaws_available, :boolean
    policy_filter! :equity_and_inclusion_available, :boolean
    policy_filter! :privacy_policy_available, :boolean
    policy_filter! :web_accessibility_available, :boolean

    ControlledVocabularyConnection.actual_standards.each do |conn|
      standard_filter! conn.ransack_id_in, :string_array
    end

    strip_attributes

    # @param [String, nil] raw_sort
    # @return [void]
    def apply_sorts!(raw_sort)
      self[:s] = raw_sort.presence_in(ACCEPTABLE_SORTS) || DEFAULT_SORT
    end
  end
end
