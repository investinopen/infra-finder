# frozen_string_literal: true

module ControlledVocabularies
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Assoc = Types::Coercible::String.constrained(filled: true)

    ConnectionMode = Coercible::Symbol.enum(:single, :multiple)

    EnumMapping = Coercible::Hash.map(Coercible::String, Coercible::String)

    Provision = ApplicationRecord.dry_pg_enum(:controlled_vocabulary_provision)

    Provisions = Array.of(Provision)

    Strategy = Coercible::String.enum("countries", "currencies", "enum", "model")

    Record = Instance(::ControlledVocabularyRecord)

    RecordList = Array.of(Record)

    RecordSelection = RecordList.constrained(min_size: 1)

    RecordRelation = Support::Types::Relation.of(Inherits(::ControlledVocabularyRecord))

    RecordSet = RecordRelation | RecordSelection

    Tag = Coercible::String.constrained(filled: true, format: /[^,]+/)

    Tags = Array.of(Tag).default(Dry::Core::Constants::EMPTY_ARRAY)

    Term = Coercible::String

    Terms = Coercible::Array.of(Term).default(Dry::Core::Constants::EMPTY_ARRAY)

    Visibility = ApplicationRecord.dry_pg_enum(:visibility, default: "visible")

    VocabName = Coercible::String.enum(
      "acc_scope",
      "access",
      "board",
      "bus_form",
      "code_lcns",
      "comm_eng",
      "cont_lcns",
      "countries",
      "currencies",
      "fos",
      "gov_stat",
      "impl_scale",
      "impl_scale_pricing",
      "integrations",
      "maint",
      "nonprofit_status",
      "pr_fund",
      "prgrm_lng",
      "rev_src",
      "rprt_lvl",
      "saas",
      "soln_cat",
      "staffing",
      "standards_auth",
      "standards_metadata",
      "standards_metrics",
      "standards_pids",
      "standards_pres",
      "standards_sec",
      "tech_read",
      "user_paths",
      "values"
    )

    SourceKind = Coercible::Symbol.enum(
      :actual,
      :draft,
      :intake
    ).constructor do |value|
      case value
      in /\Asolutions?\z/i then :actual
      in /\Asolution_?drafts?\z/i then :draft
      in /\Asolution_?intakes?\z/i then :intake
      else
        value
      end
    end

    SourceTable = Coercible::Symbol.enum(
      :solutions,
      :solution_drafts,
      :solution_intakes
    ).constructor do |value|
      case value
      in /\Aactual\z/i then :solutions
      in /\Adraft\z/i then :solution_drafts
      in /\Aintake\z/i then :solution_intakes
      else
        value
      end
    end

    TargetTable = Coercible::Symbol.enum(
      :access_conditions,
      :accessibility_scopes,
      :authentication_standards,
      :board_structures,
      :business_forms,
      :community_engagement_activities,
      :community_governances,
      :content_licenses,
      :domain_relevances,
      :hosting_strategies,
      :integrations,
      :licenses,
      :maintenance_statuses,
      :metadata_standards,
      :metrics_standards,
      :nonprofit_statuses,
      :persistent_identifier_standards,
      :preservation_standards,
      :primary_funding_sources,
      :programming_languages,
      :readiness_levels,
      :reporting_levels,
      :revenue_sources,
      :security_standards,
      :solution_categories,
      :staffings,
      :user_contributions,
      :values_frameworks
    )
  end
end
