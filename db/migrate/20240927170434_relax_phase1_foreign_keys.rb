# frozen_string_literal: true

class RelaxPhase1ForeignKeys < ActiveRecord::Migration[7.1]
  FOREIGN_KEYS = [
    [:solutions, :community_governances, {:column=>"phase_1_community_governance_id", :name=>"fk_rails_25e1f3faa1", :on_delete=>:restrict}],
    [:solutions, :readiness_levels, {:column=>"phase_1_readiness_level_id", :name=>"fk_rails_522f0b764c", :on_delete=>:restrict}],
    [:solutions, :hosting_strategies, {:column=>"phase_1_hosting_strategy_id", :name=>"fk_rails_57bffcae2d", :on_delete=>:restrict}],
    [:solutions, :maintenance_statuses, {:column=>"phase_1_maintenance_status_id", :name=>"fk_rails_73c7b0a3ae", :on_delete=>:restrict}],
    [:solutions, :board_structures, {:column=>"phase_1_board_structure_id", :name=>"fk_rails_c3189e0953", :on_delete=>:restrict}],
    [:solutions, :business_forms, {:column=>"phase_1_business_form_id", :name=>"fk_rails_c35caf4647", :on_delete=>:restrict}],
    [:solutions, :primary_funding_sources, {:column=>"phase_1_primary_funding_source_id", :name=>"fk_rails_d7b00384c2", :on_delete=>:restrict}],
    [:solution_drafts, :community_governances, {:column=>"phase_1_community_governance_id", :name=>"fk_rails_496e0d601c", :on_delete=>:restrict}],
    [:solution_drafts, :primary_funding_sources, {:column=>"phase_1_primary_funding_source_id", :name=>"fk_rails_57b1e3753d", :on_delete=>:restrict}],
    [:solution_drafts, :readiness_levels, {:column=>"phase_1_readiness_level_id", :name=>"fk_rails_5b8c678d1e", :on_delete=>:restrict}],
    [:solution_drafts, :maintenance_statuses, {:column=>"phase_1_maintenance_status_id", :name=>"fk_rails_7e91bf84ef", :on_delete=>:restrict}],
    [:solution_drafts, :business_forms, {:column=>"phase_1_business_form_id", :name=>"fk_rails_a937b670c8", :on_delete=>:restrict}],
    [:solution_drafts, :hosting_strategies, {:column=>"phase_1_hosting_strategy_id", :name=>"fk_rails_bf7a540f25", :on_delete=>:restrict}],
    [:solution_drafts, :board_structures, {:column=>"phase_1_board_structure_id", :name=>"fk_rails_d15fd7352a", :on_delete=>:restrict}]
  ].freeze

  def change
    FOREIGN_KEYS.each do |(from_table, to_table, options)|
      remove_foreign_key from_table, to_table, **options
      add_foreign_key from_table, to_table, **options, on_delete: :nullify
    end
  end
end
