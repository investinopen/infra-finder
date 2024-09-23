# frozen_string_literal: true

# A record representing each and every connection between a controlled vocabulary
# and either a {Solution} or a {SolutionDraft}.
class ControlledVocabularyConnection < Support::FrozenRecordHelpers::AbstractRecord
  include Dry::Core::Memoizable
  include ControlledVocabularies::HasStrategy

  STANDARD_VOCABS = %w[
    standards_auth
    standards_metadata
    standards_metrics
    standards_pids
    standards_pres
    standards_sec
  ].freeze

  schema!(types: ControlledVocabularies::TypeRegistry) do
    required(:key).filled(:string)
    required(:name).value(:assoc)
    required(:solution_kind).value(:source_kind)
    required(:connection_mode).value(:connection_mode)
    required(:strategy).value(:strategy)
    required(:vocab_name).value(:vocab_name)
  end

  self.primary_key = :key

  add_index :key, unique: true
  add_index :name
  add_index :vocab_name

  scope :for_kind, ->(kind) { where(solution_kind: ControlledVocabularies::Types::SourceKind[kind]) }

  scope :for_draft, -> { for_kind(:draft) }
  scope :for_actual, -> { for_kind(:actual) }

  scope :multiple, -> { where(connection_mode: :multiple) }
  scope :single, -> { where(connection_mode: :single) }

  scope :accepts_other, -> { where(vocab_name: ControlledVocabulary.accepts_other_names) }
  scope :standards, -> { where(vocab_name: STANDARD_VOCABS) }
  scope :actual_standards, -> { for_actual.standards }

  alias_attribute :assoc, :name

  delegate :accepts_other?, :fetch_options, :fetch_options!, to: :vocab
  delegate :input_attr, :other_property, to: :property
  delegate :attribute_name, to: :other_property, allow_nil: true, prefix: :other

  memoize def assoc_name
    assoc.to_s.pluralize(counter).to_sym
  end

  # @param [Class] klass
  # @return [void]
  def apply_to!(klass)
    klass.include ControlledVocabularies::ConnectionIntrospection.new(self)

    case strategy
    in "countries"
      apply_as_countries_to!(klass)
    in "currencies"
      apply_as_currencies_to!(klass)
    in "enum"
      apply_as_enum_to!(klass)
    in "model"
      apply_as_model_to!(klass)
    end
  end

  def counter
    single? ? 1 : 2
  end

  # @return [ControlledVocabularies::Linkage]
  memoize def linkage
    return nil unless strategy == "model"

    ControlledVocabularies::Linkage.for_link(vocab_name, solution_kind)
  end

  memoize def link_assoc_name
    "#{assoc}_connection".pluralize(counter).to_sym
  end

  def multiple?
    connection_mode == :multiple
  end

  def single?
    connection_mode == :single
  end

  alias single single?

  memoize def ransack_id_in
    :"#{assoc}_id_in"
  end

  memoize def property
    SolutionProperty.find name
  end

  memoize def vocab
    ControlledVocabulary.find(vocab_name)
  end

  private

  # @param [Class(ApplicationRecord)] klass
  # @return [void]
  def apply_as_countries_to!(klass)
    klass.validates assoc, country_code: true
  end

  # @param [Class(ApplicationRecord)] klass
  # @return [void]
  def apply_as_currencies_to!(klass)
    klass.validates assoc, currency: true
  end

  # @param [Class(ApplicationRecord)] klass
  # @return [void]
  def apply_as_enum_to!(klass)
    # intentionally left blank,
    # this is handled elsewhere
  end

  # @param [Class(ApplicationRecord)] klass
  # @return [void]
  def apply_as_model_to!(klass)
    apply_base_association_to!(klass)

    apply_connection_associations_to!(klass)

    apply_connection_scopes_to!(klass)
  end

  # @param [Class(ApplicationRecord)] klass
  # @return [void]
  def apply_base_association_to!(klass)
    klass.has_many linkage.link_table_name, inverse_of: linkage.source_reference, dependent: :destroy unless klass.reflect_on_association(linkage.link_table_name)
  end

  # @param [Class(ApplicationRecord)] klass
  # @return [void]
  def apply_connection_associations_to!(klass)
    if single?
      apply_single_connection_associations_to!(klass)
    else
      apply_multiple_connection_associations_to!(klass)
    end
  end

  # @param [Class(ApplicationRecord)] klass
  # @return [void]
  def apply_single_connection_associations_to!(klass)
    conditions = { assoc:, single:, }

    klass.has_one link_assoc_name, -> { where(conditions) }, class_name: linkage.link_model_name, dependent: :destroy, inverse_of: linkage.source_reference
    klass.has_one assoc_name, through: link_assoc_name, source: linkage.target_reference
  end

  # @param [Class(ApplicationRecord)] klass
  # @return [void]
  def apply_multiple_connection_associations_to!(klass)
    conditions = { assoc:, single:, }

    klass.has_many link_assoc_name, -> { where(conditions) }, class_name: linkage.link_model_name, dependent: :destroy, inverse_of: linkage.source_reference
    klass.has_many assoc_name, -> { lazily_order(:name) }, through: link_assoc_name, source: linkage.target_reference
  end

  # @param [Class(ApplicationRecord)] klass
  # @return [void]
  def apply_connection_scopes_to!(klass)
    target_model = linkage.target_model

    assoc_name = self.assoc_name

    klass.scope :"#{assoc_name}_provides", ->(provides) { joins(assoc_name).merge(target_model.with_providing(provides)) }
  end

  class << self
    # @param [#to_s] name
    # @param [:actual, :draft] solution_kind
    # @return [ControlledVocabularyConnection]
    def lookup(name:, solution_kind:)
      where(
        name: ControlledVocabularies::Types::Assoc[name],
        solution_kind: ControlledVocabularies::Types::SourceKind[solution_kind]
      ).first!
    end
  end
end
