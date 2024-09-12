# frozen_string_literal: true

# @see Solution
# @see SolutionDraft
# @see SolutionInterface
# @see SolutionPropertyKind
class SolutionProperty < Support::FrozenRecordHelpers::AbstractRecord
  include ActiveModel::Validations
  include Dry::Core::Memoizable

  SOURCE_KINDS = %i[actual draft].freeze

  CORE = %w[
    name
    founded_on
    country_code
    member_count
  ].freeze

  CONTACT = %w[
    contact
    website
    research_organization_registry_url
  ].freeze

  FINANCES = %w[
    annual_expenses
    annual_revenue
    investment_income
    other_revenue
    program_revenue
    total_assets
    total_contributions
    total_liabilities

    financial_numbers_publishability
    financial_information_scope
    financial_numbers_documented_url
  ].freeze

  schema!(types: SolutionProperties::TypeRegistry) do
    required(:name).filled(:string)
    optional(:code).value(:integer)
    optional(:attr).maybe(:string)
    optional(:kind).maybe(:kind)
    required(:meta).value(:bool)
    optional(:only).maybe(:only)
    optional(:owner).maybe(:owner)
    optional(:description).maybe(:string)
    required(:exported).value(:bool)
    required(:required).value(:bool)
    optional(:implementation_name).maybe(:implementation_name)
    optional(:implementation_property).maybe(:implementation_property)
    optional(:store_model_type_name).maybe(:string)
    # The external name set by IOI. Most of these do not conform
    # to Rails best practices so we do not use them as the internal,
    # authoritative name. But we need to store them to refer back to
    # them when exporting / importing, etc.
    optional(:ext_name).filled(:string)
    required(:be_label).filled(:string)
    optional(:be_position).maybe(:integer)
    optional(:be_section).maybe(:string)
    optional(:fe_label).maybe(:string)
    optional(:fe_position).maybe(:integer)
    optional(:fe_section).maybe(:string)
    required(:fe_visibility).value(:visibility)
    required(:phase_2_status).value(:phase_2_status)
    required(:skip_csv_export).value(:bool)
    optional(:max_length).maybe(:integer) { gt?(0) }
    # External defined input. Does not necessarily correspond to how the field is used,
    # but we store it.
    optional(:input).value(:input)
    # The name of the {ControlledVocabulary} associated with this option,
    # if applicable.
    optional(:vocab_name).maybe(:vocab_name)
    # Used to derive input from original spreadsheet.
    optional(:original_input).maybe(:string)
  end

  default_attributes!(
    exported: false,
    required: false,
    skip_csv_export: false,
    meta: false,
    description: nil,
    fe_position: 0,
    fe_visibility: "hidden",
    phase_2_status: "none",
    vocab_name: nil
  )

  self.primary_key = :name

  add_index :name, unique: true
  add_index :ext_name, unique: true

  scope :changing_labels, -> { where(phase_2_status: "change_label") }
  scope :changing_inputs, -> { where(phase_2_status: "change_input") }
  scope :changing_vocabs, -> { where(phase_2_status: "change_vocab") }

  scope :dropping, -> { where(phase_2_status: "drop") }

  scope :in_use, -> { where.not(phase_2_status: "drop") }

  scope :attachments, -> { in_use.where(kind: :attachment) }

  scope :blurbs, -> { in_use.where(kind: :blurb) }

  scope :contact, -> { in_use.where(name: CONTACT) }

  scope :core, -> { in_use.where(name: CORE) }

  scope :finances, -> { in_use.where(name: FINANCES) }

  scope :for_implementation, ->(implementation) { where(implementation_name: implementation.to_s) }

  scope :implementation_enums, -> { in_use.where(kind: :implementation_enum) }
  scope :implementation_enum_for, ->(implementation) { implementation_enums.for_implementation(implementation) }
  scope :implementation_properties, -> { in_use.where(kind: :implementation_property) }
  scope :implementation_properties_for, ->(implementation) { implementation_properties.order(code: :asc).for_implementation(implementation) }

  scope :money, -> { in_use.where(kind: :money) }

  scope :other_options, -> { in_use.where(kind: :other_option) }

  scope :store_model_inputs, -> { in_use.where(kind: :store_model_input) }
  scope :store_model_lists, -> { in_use.where(kind: :store_model_list) }

  scope :strings, -> { in_use.where(kind: :string) }

  scope :urls, -> { in_use.where(kind: :url) }

  scope :accepts_other, -> { in_use.where(vocab_name: ControlledVocabulary.accepts_other_names) }

  scope :by_vocab_name, ->(vocab_name) { where(vocab_name:) }

  scope :only_for, ->(only) { where(only: only.to_sym) }
  scope :only_for_actual, -> { only_for(:actual) }
  scope :only_for_draft, -> { only_for(:draft) }

  scope :sans_implementation_links, -> { where.not(implementation_property: %w[link links]) }
  scope :sans_meta, -> { where(meta: false) }
  scope :meta, -> { where(meta: true) }

  scope :with_vocab, -> { where.not(vocab_name: [nil, ""]) }
  scope :with_model_vocab, -> { where.not(vocab_name: [nil, "", "impl_scale", "impl_scale_pricing", "currencies", "countries"]) }

  scope :for_connections, -> { in_use.with_vocab.where(input: %w[select multiselect]).order(name: :asc) }

  scope :with_standard_kind, -> { where(kind: SolutionPropertyKind.standard_kinds) }
  scope :with_non_standard_kind, -> { where(kind: SolutionPropertYKind.non_standard_kind) }

  scope :should_be_in_admin_form, -> { in_use.sans_meta.sans_implementation_links }

  scope :standard, -> { in_use.with_standard_kind.sans_meta }
  scope :non_standard, -> { in_use.with_non_standard_kind.sans_meta }

  scope :with_presence_required, -> { in_use.sans_meta.where(required: true) }
  scope :with_max_length, -> { in_use.where.not(max_length: nil) }

  AUTO_EXCLUDE_CSV_KINDS = %i[
    implementation
    standard
    store_model_input
  ].freeze

  scope :expected_to_handle_in_csv, -> { in_use.where(skip_csv_export: false).where.not(kind: AUTO_EXCLUDE_CSV_KINDS) }

  EXCLUDED_EXTRACTIONS = %w[
    name
  ].freeze

  scope :to_extract, -> { in_use.sans_meta.where.not(name: EXCLUDED_EXTRACTIONS) }

  delegate :accessor_klass, :assign_method, :connection_mode, :diff_klass, to: :property_kind

  validate :free_input_property_exists!
  validate :other_property_exists!
  validate :property_exists_on_models!
  validate :required_owner_property_exists!
  validates :owner, presence: { if: :other_option? }

  def accepts_other?
    has_vocab? && vocab.accepts_other?
  end

  # @api private
  def actual_attribute_name
    if implementation_subproperty?
      implementation_name
    else
      attribute_name
    end
  end

  # @return [String]
  memoize def attribute_name
    attr.presence || name
  end

  memoize def csv_header
    "%<code>03d_%<ext_name>s" % { code:, ext_name:, }
  end

  def dropping?
    phase_2_status == "drop"
  end

  def exists?
    SOURCE_KINDS.all? { skip_for?(_1) || exists_for?(_1) }
  end

  # @param [ControlledVocabularies::Types::SourceKind] kind
  def exists_for?(kind)
    record = kind.to_sym == :draft ? SolutionDraft.new : Solution.new

    record.respond_to?(actual_attribute_name)
  end

  # @param [:private, :public] csv_scope
  def export_for?(csv_scope)
    case csv_scope
    when /\Apublic\z/i then exported
    else
      true
    end
  end

  def for_implementation?
    implementation_name.present?
  end

  # @return [<Symbol>]
  memoize def free_input_accessors
    return [] unless has_free_input?

    [
      free_input_name,
      :"#{free_input_name}=",
      :"#{free_input_name}?"
    ]
  end

  # @return [Symbol, nil]
  memoize def free_input_name
    base = attribute_name.to_s.singularize

    if accepts_other?
      :"#{base}_other"
    elsif kind === :store_model_list
      :"#{base}_free_input"
    end
  end

  def has_free_input?
    free_input_name.present?
  end

  def has_vocab?
    vocab.present?
  end

  def implementation_subproperty?
    for_implementation? && implementation_property != "enum"
  end

  # The name of the attribute to use when in an active admin form input.
  #
  # For has_one through associations, we need to return our special `:"#{assoc_name}_id"` keys.
  # @return [Symbol]
  memoize def input_attr
    if kind == :single_option && vocab.uses_model?
      :"#{attribute_name}_id"
    else
      attribute_name
    end
  end

  # @!attribute [r] input_hint
  # The hint to display in ActiveAdmin when rendering the property.
  # @return [String]
  memoize def input_hint
    path = "solution_properties.static.input_hint.#{kind}"

    options = { default: description, raise: true }

    I18n.t(path, **options)
  end

  # @!attribute [r] input_kind
  # @see SolutionPropertyKind#input_kind_for
  # @return [Symbol, nil]
  memoize def input_kind
    property_kind.input_kind_for(self)
  end

  # @!attribute [r] input_label
  memoize def input_label
    path = "solution_properties.static.input_label.#{kind}"

    options = { default: be_label, raise: true }

    options[:owner_label] = owner_property.be_label if other_option?

    I18n.t(path, **options)
  end

  # @!attribute [r] input_options
  # @return [Hash]
  memoize def input_options
    {
      as: input_kind,
      label: input_label,
      hint: input_hint,
      input_html: property_kind.input_html,
    }.compact.reverse_merge(property_kind.input_options).tap do |opts|
      opts[:end_year] = Date.current.year if :start_year.in?(opts)
    end
  end

  def only_for_actual?
    only_for? :actual
  end

  def only_for_draft?
    only_for? :draft
  end

  # @param [ControlledVocabularies::Types::SourceKind] kind
  def only_for?(kind)
    only == kind.to_sym
  end

  def other_option?
    kind == :other_option
  end

  memoize def required_presence_options
    {}.tap do |x|
      x[:if] = :apply_editor_validations?

      if accepts_other?
        x[:unless] = [:"#{free_input_name}?", :should_skip_editor_validations?]
      else
        x[:unless] = :should_skip_editor_validations?
      end
    end
  end

  # @param [ControlledVocabularies::Types::SourceKind] kind
  def skip_for?(kind)
    case kind.to_sym
    when :actual then only_for?(:draft)
    when :draft then only_for?(:actual)
    else
      false
    end
  end

  memoize def structured_attr
    return unless kind == :store_model_list

    :"#{name}_structured"
  end

  memoize def structured_header
    return unless kind == :store_model_list

    :"#{csv_header}_structured"
  end

  # @return [String]
  memoize def field_label
    case kind
    in :implementation
      "#{be_label} (Implementation Details)"
    in :other_option
      input_label
    else
      be_label
    end
  end

  # @return [Integer]
  memoize def field_position
    if owner?
      owner_property.field_position + 3
    elsif kind == :implementation
      implementation.enum_property.field_position + 1
    else
      code * 10
    end
  end

  memoize def free_input_property
    SolutionProperty.find(free_input_name.to_s) if free_input_name.present?
  end

  memoize def implementation
    Implementation.find(implementation_name) if implementation_name?
  end

  memoize def other_property
    SolutionProperty.find(free_input_name.to_s) if accepts_other?
  end

  memoize def owner_property
    SolutionProperty.find(owner) if owner?
  end

  # @return [SolutionPropertyKind]
  memoize def property_kind
    SolutionPropertyKind.find(kind)
  end

  # @return [ControlledVocabulary, nil]
  memoize def vocab
    ControlledVocabulary.find(vocab_name) if vocab_name?
  end

  # @!group Accessor Logic

  # @return [SolutionProperties::Accessors::AbstractAccessor]
  def accessor(**options)
    accessor_klass.new(self, **options)
  end

  # @!endgroup

  private

  # @return [void]
  def free_input_property_exists!
    return unless free_input_name.present?

    free_input_property
  rescue FrozenRecord::RecordNotFound
    # :nocov:
    errors.add :base, "Expected #{free_input_name} property to exist, but it is not found"
    # :nocov:
  end

  # @return [void]
  def other_property_exists!
    return unless accepts_other?

    other_property
  rescue FrozenRecord::RecordNotFound
    # :nocov:
    errors.add :base, "Expected #{free_input_name} property to exist, but it is not found"
    # :nocov:
  end

  # @return [void]
  def property_exists_on_models!
    return if dropping? || meta?

    SOURCE_KINDS.each do |kind|
      next if skip_for?(kind) || exists_for?(kind)

      errors.add :base, "Missing #{attribute_name.inspect} on #{kind.inspect} models"
    end
  end

  # @return [void]
  def required_owner_property_exists!
    return unless owner?

    owner_property
  rescue FrozenRecord::RecordNotFound => e
    # :nocov:
    errors.add :owner, "does not exist: #{e.message}"
    # :nocov:
  end

  class << self
    include Dry::Core::Memoizable

    # @param [#to_s] property_name
    # @return [Class(Solutions::Revisions::Diffs::BaseDiff)]
    def diff_klass_for(property_name)
      prop = find(property_name.to_s)

      prop.diff_klass
    rescue FrozenRecord::RecordNotFound
      Solutions::Revisions::Diffs::UnknownDiff
    end

    def each_free_input
      return enum_for(__method__) unless block_given?

      SolutionProperty.accepts_other.find_each do |prop|
        yield prop
      end

      SolutionProperty.store_model_lists.find_each do |prop|
        yield prop
      end
    end

    # @!group Base Groupings

    # @return [<Symbol>]
    def attachment_values
      attribute_names_from in_use.attachments
    end

    # @return [<Symbol>]
    def blurb_values
      attribute_names_from in_use.blurbs
    end

    # @return [<Symbol>]
    def core_values
      attribute_names_from in_use.core
    end

    # @return [<Symbol>]
    def currency_values
      attribute_names_from in_use.money
    end

    # @return [<Symbol>]
    def finance_values
      attribute_names_from in_use.finances
    end

    # @return [<Symbol>]
    def standard_values
      attribute_names_from in_use.standard
    end

    # @return [<Symbol>]
    def string_values
      attribute_names_from in_use.strings.sans_meta
    end

    def url_values
      attribute_names_from in_use.urls.sans_meta
    end

    # @!endgroup

    # @!group Composite Groupings

    # @return [<Symbol>]
    def has_many_associations
      attribute_names_from with_model_vocab.where(kind: :multi_option)
    end

    # @return [<Symbol>]
    def has_one_associations
      attribute_names_from with_model_vocab.where(kind: :single_option)
    end

    memoize def eager_load_associations
      [
        *has_many_associations,
        *has_one_associations,
      ].then { symbolize_list _1 }
    end

    memoize def free_input_names
      each_free_input.map(&:free_input_name)
    end

    # @return [Hash]
    def generate_locale
      mapping = in_use.order(name: :asc).each_with_object({}) do |prop, h|
        next if prop.input_label == "N/A"

        h[prop.attribute_name.to_s] = prop.input_label
      end

      attributes = { solution: mapping, solution_draft: mapping }

      { en: { activerecord: { attributes:, } } }.deep_stringify_keys
    end

    # @return [void]
    def write_locale!
      locale = generate_locale

      Rails.root.join("config", "locales", "solution_property_labels.en.yml").open("wb+") do |f|
        f.write YAML.dump(locale)
      end
    end

    memoize def ransackable_associations
      [
        *eager_load_associations
      ].then { symbolize_list _1 }
    end

    memoize def ransackable_attributes
      [].tap do |a|
        a.concat(standard_values)
        a << "country_code"
        a.concat(Implementation.pluck(:name, :enum).flatten)
      end.then { symbolize_list _1 }
    end

    memoize def to_clone
      [].tap do |a|
        a.concat attachment_values
        a.concat standard_values
        a.concat free_input_names
        a.concat Implementation.pluck(:name, :enum).flatten
        a.concat has_one_associations
        a.concat has_many_associations
      end.then { symbolize_list _1 }
    end

    memoize def to_clone_draft
      [].tap do |a|
        a.concat standard_values
        a.concat free_input_names
        a.concat Implementation.pluck(:name, :enum).flatten
        a.concat has_one_associations
        a.concat has_many_associations
      end.then { symbolize_list _1 }
    end

    # @return [ActiveSupport::HashWithIndifferentAccess{ String => Integer }]
    memoize def field_ordering
      SolutionProperty.in_use.map { [_1.name, _1.field_position] }.sort_by(&:last).to_h.with_indifferent_access
    end

    def to_validate_csv
      Rails.root.join("phase-2-property-validation.csv").open("wb+") do |f|
        content = CSV.generate(headers: true, encoding: "utf-8") do |csv|
          csv << %w[csv_header code name status input vocab accepts_other]

          SolutionProperty.in_use.order(code: :asc).each do |prop|
            accepts_other = prop.accepts_other? ? ?Y : ?N
            accepts_other = "n/a" unless prop.has_vocab? && prop.vocab.uses_model?

            csv << [
              prop.csv_header,
              prop.code,
              prop.ext_name,
              prop.phase_2_status,
              prop.original_input,
              prop.vocab_name,
              accepts_other
            ]
          end
        end

        f.write content
      end
    end

    # @!endgroup

    # Used in a generator in order to populate {ControlledVocabularyConnection}.
    #
    # @api private
    # @return [<Hash>]
    def build_raw_connections
      for_connections.flat_map do |property|
        property => { name:, connection_mode:, vocab_name:, }

        vocab = ControlledVocabulary.find(vocab_name)

        vocab => { strategy:, }

        %w[actual draft].map do |solution_kind|
          key = "#{solution_kind}/#{name}"

          { key:, name:, solution_kind:, connection_mode:, strategy:, vocab_name:, }
        end
      end
    end

    private

    # @return [<Symbol>]
    def attribute_names_from(scope)
      symbolize_list scope.pluck(:attribute_name)
    end

    # @return [<Symbol>]
    def symbolize_list(value)
      value.uniq.map(&:to_sym).freeze
    end
  end
end
