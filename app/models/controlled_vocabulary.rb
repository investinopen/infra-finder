# frozen_string_literal: true

class ControlledVocabulary < Support::FrozenRecordHelpers::AbstractRecord
  extend DefinesMonadicOperation

  include Dry::Core::Memoizable
  include ControlledVocabularies::HasStrategy

  schema!(types: ControlledVocabularies::TypeRegistry) do
    required(:name).filled(:vocab_name)
    required(:strategy).filled(:strategy)
    optional(:enum_name).maybe(:string)
    optional(:model_name).maybe(:string)
    required(:accepts_other).value(:bool)
    required(:mapping).value(:hash)
    required(:terms).value(:term_definitions)
  end

  default_attributes!(accepts_other: false, mapping: {}, terms: [])

  self.primary_key = :name

  add_index :name, unique: true
  add_index :model_name

  scope :accepts_other, -> { where(accepts_other: true) }
  scope :sans_model_name, -> { uses_model.where(model_name: [nil, ""]) }
  scope :with_model_name, -> { uses_model.where.not(model_name: [nil, ""]) }

  monadic_operation! def fetch_options
    InfraFinder::Container["controlled_vocabularies.fetch_options"].(self)
  end

  monadic_operation! def find_term(term)
    InfraFinder::Container["controlled_vocabularies.find_term"].(self, term)
  end

  # @return [Class(ApplicationRecord)]
  def model_klass
    model_name.safe_constantize if uses_model? && model_name?
  end

  # @return [Symbol, nil]
  def table_name
    model_klass&.table_name&.to_sym
  end

  monadic_operation! def upsert_records
    InfraFinder::Container["controlled_vocabularies.upsert_records"].(self)
  end

  # @return [<String>]
  memoize def used_by_properties
    SolutionProperty.by_vocab_name(name).pluck(:name)
  end

  # @return [ActiveSupport::HashWithIndifferentAccess]
  memoize def enum_lookup_map
    return nil unless uses?("enum")

    mapping.keys.index_with { _1 }.merge(mapping.invert).with_indifferent_access
  end

  def term_values_list
    return unless uses_model?

    values = terms.map(&:for_values_list)

    Arel::Nodes::ValuesList.new(values)
  end

  class << self
    include Dry::Core::Memoizable

    # @return [<String>]
    memoize def accepts_other_names
      ControlledVocabulary.accepts_other.pluck(:name)
    end

    # @return [<(String, String, Hash)>]
    def active_country_options
      active_country_codes = Solution.active_country_codes

      country_options.select { |(_, code, _)| code.in?(active_country_codes) }
    end

    # @return [<(String, String, Hash)>]
    def country_options
      uses_countries.first!.fetch_options!
    end

    # @return [<(String, String, Hash)>]
    def currency_options
      uses_currencies.first!.fetch_options!
    end

    def model_klasses
      with_model_name.pluck(:model_klass)
    end

    def upsert_everything!
      with_model_name.each(&:upsert_records!)
    end
  end
end
