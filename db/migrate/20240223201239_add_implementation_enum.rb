# frozen_string_literal: true

class AddImplementationEnum < ActiveRecord::Migration[7.1]
  def change
    create_enum :solution_implementation, %w[
      bylaws
      code_of_conduct
      code_repository
      community_engagement
      equity_and_inclusion
      governance_activities
      governance_structure
      open_api
      open_data
      product_roadmap
      pricing
      privacy_policy
      user_contribution_pathways
      user_documentation
      web_accessibility
    ]
  end
end
