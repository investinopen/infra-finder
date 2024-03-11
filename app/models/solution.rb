# frozen_string_literal: true

# The primary content model for this application.
class Solution < ApplicationRecord
  include SolutionInterface
  include SluggedByName
  include TimestampScopes

  resourcify

  belongs_to :organization, inverse_of: :solutions

  has_many :comparison_items, inverse_of: :solution, dependent: :destroy
  has_many :solution_drafts, -> { in_recent_order }, inverse_of: :solution, dependent: :destroy
  has_many :solution_editor_assignments, inverse_of: :solution, dependent: :destroy

  define_common_attributes!

  scope :with_pending_drafts, -> { where(id: SolutionDraft.in_state(:pending).select(:solution_id)) }
  scope :with_reviewable_drafts, -> { where(id: SolutionDraft.in_state(:in_review).select(:solution_id)) }

  # @param [User] user
  # @return [SolutionEditorAssignment]
  def assign_editor!(user)
    solution_editor_assignments.where(user:).first_or_create!
  end

  # @see Solutions::CreateDraft
  monadic_matcher! def create_draft(...)
    call_operation("solutions.create_draft", self, ...)
  end

  class << self
    def ransackable_associations(auth_object = nil)
      [
        "board_structure",
        "business_form",
        "community_governance",
        "hosting_strategy",
        "licenses",
        "maintenance_status",
        "organization",
        "primary_funding_source",
        "readiness_level",
        "solution_drafts",
        "solution_licenses",
        "solution_category_links",
        "solution_user_contributions",
        "solution_categories",
        "user_contributions",
      ]
    end

    def ransackable_attributes(auth_object = nil)
      [
        "annual_expenses", "annual_revenue",
        "board_structure_id",
        "business_form_id",
        "bylaws", "bylaws_implementation",
        "code_of_conduct", "code_of_conduct_implementation",
        "code_repository", "code_repository_implementation",
        "community_engagement", "community_engagement_implementation",
        "community_governance_id",
        "comparable_products", "contact", "contact_method",
        "content_licensing",
        "current_affiliations",
        "current_staffing",
        "equity_and_inclusion",
        "equity_and_inclusion_implementation",
        "financial_information_scope",
        "financial_numbers_applicability",
        "financial_numbers_documented_link",
        "financial_numbers_publishability",
        "founded_on",
        "founding_institutions",
        "governance_activities", "governance_activities_implementation",
        "governance_structure", "governance_structure_implementation",
        "governance_summary",
        "hosting_strategy_id",
        "investment_income",
        "key_achievements",
        "location_of_incorporation",
        "maintenance_status_id",
        "member_count",
        "mission",
        "name",
        "open_api", "open_api_implementation",
        "open_data", "open_data_implementation",
        "organization_id",
        "organizational_history",
        "other_revenue",
        "pricing", "pricing_implementation",
        "primary_funding_source_id",
        "privacy_policy", "privacy_policy_implementation",
        "product_roadmap", "product_roadmap_implementation",
        "program_revenue",
        "readiness_level_id",
        "research_organization_registry_url",
        "service_providers",
        "special_certifications_or_statuses",
        "standards_employed",
        "total_assets",
        "total_contributions",
        "total_liabilities",
        "user_contribution_pathways", "user_contribution_pathways_implementation",
        "user_documentation", "user_documentation_implementation",
        "web_accessibility", "web_accessibility_implementation",
        "website", "what_other_tools", "what_registered", "what_technologies",
        "created_at", "updated_at",
      ]
    end

    def ransackable_scopes(auth_object = nil)
      [
        "with_pending_drafts",
        "with_reviewable_drafts",
      ]
    end
  end
end
