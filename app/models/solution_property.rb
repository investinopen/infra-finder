# frozen_string_literal: true

# @see Solution
# @see SolutionDraft
# @see SolutionInterface
# @see SolutionPropertyKind
class SolutionProperty < Support::FrozenRecordHelpers::AbstractRecord
  include ActiveModel::Validations
  include Comparable

  SOURCE_KINDS = SolutionProperties::Types::SourceKind.values.freeze

  CODED_EXT_PATTERN = /\A(?<code>\d{3})_(?<ext_name>\w+)\z/

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

  STANDARD_VOCABS = %w[
    countries
    currencies
  ].freeze

  type_registry SolutionProperties::TypeRegistry

  schema!(types: SolutionProperties::TypeRegistry) do
    required(:name).filled(:string)
    required(:code).value(:integer) { gt?(0) }
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
    required(:skip_admin).value(:bool)
    required(:skip_csv_export).value(:bool)

    optional(:max_length).maybe(:integer) { gt?(0) }

    # External defined input. Does not necessarily correspond to how the field is used,
    # but we store it.
    optional(:input).value(:input)

    # The name of the {ControlledVocabulary} associated with this option,
    # if applicable.
    optional(:vocab_name).maybe(:vocab_name)

    # @!group Calculated attributes

    required(:attribute_name).filled(:string)

    optional(:csv_header).maybe(:string)

    required(:structured).value(:bool)

    optional(:structured_attr).maybe(:symbol)
    optional(:structured_header).maybe(:symbol)

    required(:property_kind).value(SolutionPropertyKind::Type)

    optional(:implementation).maybe(:implementation)

    required(:for_implementation).value(:bool)

    required(:implementation_subproperty).value(:bool)

    # @api private
    required(:actual_attribute_name).filled(:string)

    optional(:vocab).maybe(:vocab)

    required(:has_vocab).value(:bool)

    required(:accepts_other).value(:bool)

    optional(:free_input_name).maybe(:symbol)

    required(:has_free_input).value(:bool)

    required(:free_input_accessors).array(:symbol)

    # The name of the attribute to use when in an active admin form input.
    #
    # For has_one through associations, we need to return our special `:"#{assoc_name}_id"` keys.
    # @return [Symbol]
    required(:input_attr).filled(:symbol)

    optional(:input_kind).maybe(:symbol)

    required(:only_for_actual).value(:bool)
    required(:only_for_draft).value(:bool)

    required(:skip_for_actual).value(:bool)
    required(:skip_for_draft).value(:bool)
    required(:skip_for_intake).value(:bool)

    # @!endgroup Calculated attributes
  end

  default_attributes!(
    exported: false,
    required: false,
    skip_admin: false,
    skip_csv_export: false,
    meta: false,
    description: nil,
    fe_position: 0,
    fe_visibility: "hidden",
    vocab_name: nil
  )

  calculates! :attribute_name do |record|
    record["attr"].presence || record["name"]
  end

  calculates! :csv_header do |record|
    code = record.fetch("code")
    ext_name = record.fetch("ext_name", record.fetch("attr"))

    "%<code>03d_%<ext_name>s" % { code:, ext_name: }
  end

  calculates! :structured do |record|
    record["kind"].to_sym == :store_model_list
  end

  calculates! :structured_attr do |record|
    :"#{record["name"]}_structured" if record["kind"].to_sym == :store_model_list
  end

  calculates! :structured_header do |record|
    :"#{record["csv_header"]}_structured" if record["kind"].to_sym == :store_model_list
  end

  calculates! :implementation do |record|
    Implementation.find(record["implementation_name"]) if record["implementation_name"].present?
  end

  calculates! :for_implementation do |record|
    record["implementation_name"].present? && record["implementation"].present?
  end

  calculates! :implementation_subproperty do |record|
    record["for_implementation"] && record["implementation_property"].present? && record["implementation_property"] != "enum"
  end

  calculates! :property_kind do |record|
    SolutionPropertyKind.find(record["kind"])
  end

  calculates! :vocab do |record|
    ControlledVocabulary.find(record["vocab_name"]) if record["vocab_name"].present?
  end

  calculates! :has_vocab do |record|
    record["vocab"].present?
  end

  calculates! :accepts_other do |record|
    record["vocab"].present? && record["vocab"].accepts_other?
  end

  calculates! :free_input_name do |record|
    base = record["attribute_name"].to_s.singularize

    if record["accepts_other"]
      :"#{base}_other"
    elsif record["kind"].to_sym == :store_model_list
      :"#{base}_free_input"
    end
  end

  calculates! :has_free_input do |record|
    record["free_input_name"].present?
  end

  calculates! :free_input_accessors do |record|
    next Dry::Core::Constants::EMPTY_ARRAY unless record["has_free_input"]

    [
      record["free_input_name"],
      :"#{record["free_input_name"]}=",
      :"#{record["free_input_name"]}?"
    ]
  end

  calculates! :actual_attribute_name do |record|
    if record["implementation_subproperty"]
      record["implementation_name"]
    else
      record["attribute_name"]
    end
  end

  calculates! :input_attr do |record|
    if record["kind"].to_sym == :single_option && record["vocab"].present? && record["vocab"].uses_model?
      :"#{record["attribute_name"]}_id"
    else
      record["attribute_name"].to_sym
    end
  end

  calculates! :input_kind do |record|
    record["property_kind"].input_kind_for(record)
  end

  calculates! :only_for_actual do |record|
    record["only"]&.to_sym == :actual
  end

  calculates! :only_for_draft do |record|
    record["only"]&.to_sym == :draft
  end

  calculates! :skip_for_actual do |record|
    record["only_for_draft"]
  end

  calculates! :skip_for_draft do |record|
    record["only_for_actual"]
  end

  calculates! :skip_for_intake do |record|
    record["only_for_actual"] || record["only_for_draft"]
  end

  self.primary_key = :name

  add_index :name, unique: true
  add_index :ext_name, unique: true

  scope :in_use, -> { all }

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
  scope :with_model_vocab, -> { where.not(vocab_name: [nil, "", "impl_scale", "impl_scale_pricing", *STANDARD_VOCABS]) }

  scope :for_connections, -> { in_use.with_vocab.where(input: %w[select multiselect]).order(name: :asc) }

  scope :with_standard_kind, -> { where(kind: SolutionPropertyKind.standard_kinds) }
  scope :with_non_standard_kind, -> { where(kind: SolutionPropertyKind.non_standard_kinds) }

  scope :should_be_in_admin_form, -> { in_use.sans_meta.sans_implementation_links.where(skip_admin: false) }

  scope :default_standard, -> { in_use.with_standard_kind.sans_meta }
  scope :standard_options, -> { in_use.where(kind: :single_option).by_vocab_name(STANDARD_VOCABS) }
  scope :standard, -> { default_standard.pluck(:name).concat(standard_options.pluck(:name)).then { |name| where(name:) } }
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

  def <=>(other)
    comparison_tuple <=> other.comparison_tuple
  end

  def exists?
    SOURCE_KINDS.all? { skip_for?(_1) || exists_for?(_1) }
  end

  # @param [ControlledVocabularies::Types::SourceKind] kind
  def exists_for?(kind)
    record = self.class.solution_record_for(kind)

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

  # @!attribute [r] input_hint
  # The hint to display in ActiveAdmin when rendering the property.
  # @return [String]
  def input_hint
    path = "solution_properties.static.input_hint.#{kind}"

    options = { default: description, raise: true }

    I18n.t(path, **options)
  end

  # @!attribute [r] input_label
  # @return [String]
  def input_label
    path = "solution_properties.static.input_label.#{kind}"

    options = { default: be_label, raise: true }

    options[:owner_label] = owner_property.be_label if other_option?

    I18n.t(path, **options)
  end

  # @!attribute [r] input_options
  # @return [Hash]
  def input_options
    {
      as: input_kind,
      label: input_label,
      hint: input_hint,
      input_html: property_kind.input_html,
    }.compact.reverse_merge(property_kind.input_options).tap do |opts|
      opts[:end_year] = Date.current.year if :start_year.in?(opts)
    end
  end

  # @param [ControlledVocabularies::Types::SourceKind] kind
  def only_for?(kind) = only == kind.to_sym

  def other_option? = kind == :other_option

  def required_presence_options
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
    when :intake
      only_for?(:actual) || only_for?(:draft)
    else
      false
    end
  end

  def has_structured_attr? = structured_attr?

  def has_structured_header? = structured_header?

  # @return [String]
  def field_label
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
  def field_position
    if owner?
      owner_property.field_position + 3
    elsif kind == :implementation
      implementation.enum_property.field_position + 1
    else
      code * 10
    end
  end

  # @return [SolutionProperty, nil]
  def free_input_property
    memoize :free_input_property do
      SolutionProperty.find(free_input_name.to_s) if free_input_name?
    end
  end

  # @return [SolutionProperty, nil]
  def other_property
    memoize :other_property do
      return unless accepts_other?

      SolutionProperty.find(free_input_name.to_s)
    end
  end

  # @return [SolutionProperty, nil]
  def owner_property
    memoize :owner_property do
      SolutionProperty.find(owner) if owner?
    end
  end

  # @!group Accessor Logic

  # @return [SolutionProperties::Accessors::AbstractAccessor]
  def accessor(**options)
    accessor_klass.new(self, **options)
  end

  # @!endgroup

  INTAKE_SKIPPED_PRESENCE = %w[
    board_structures
    founded_on
    governance_summary
    readiness_level
  ].freeze

  # @param [:actual, :draft, :intake] solution_kind
  def validate_presence_for?(solution_kind)
    return false unless required?

    case solution_kind
    in :intake
      !name.in?(INTAKE_SKIPPED_PRESENCE)
    else
      true
    end
  end

  protected

  def comparison_code
    @comparison_code ||= owner_property&.code || code
  end

  def primary_code
    @primary_code ||= comparison_code == code ? 0 : 1
  end

  def comparison_tuple
    @comparison_tuple ||= [].tap do |tuple|
      tuple << comparison_code
      tuple << primary_code
      tuple << code
      tuple << name.to_s
    end.freeze
  end

  private

  # @return [void]
  def free_input_property_exists!
    return unless exists? && free_input_name.present?

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
    return if meta?

    SOURCE_KINDS.each do |kind|
      # :nocov:
      next if skip_for?(kind) || exists_for?(kind)

      errors.add :base, "Missing #{attribute_name.inspect} on #{kind.inspect} models"
      # :nocov:
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

    # @param [String] name
    # @return [SolutionProperty]
    def lookup_coded_ext(name)
      case name
      in CODED_EXT_PATTERN
        code = Regexp.last_match[:code].to_i
        ext_name = Regexp.last_match[:ext_name]

        find_by!(code:, ext_name:)
      end
    end

    # @!group Base Groupings

    # @param [:actual, :draft] kind
    # @return [<String>]
    def admin_fields_for(kind)
      should_be_in_admin_form.pluck(:name).tap do |fields|
        implementation_names = Implementation.pluck(:name)

        if kind == :actual
          fields << find("publication").name << find("provider_name").name
        end

        fields.concat(implementation_names)
      end.uniq.sort.freeze
    end

    # @return [<Symbol>]
    def attachment_values
      attribute_names_from in_use.attachments
    end

    # @return [<Symbol>]
    def blurb_values
      attribute_names_from in_use.blurbs
    end

    # @deprecated
    # @return [<Symbol>]
    def core_values
      # :nocov:
      attribute_names_from in_use.core
      # :nocov:
    end

    # @return [<Symbol>]
    def currency_values
      attribute_names_from in_use.money
    end

    # @deprecated
    # @return [<Symbol>]
    def finance_values
      # :nocov:
      attribute_names_from in_use.finances
      # :nocov:
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

    def eager_load_associations
      @eager_load_associations ||= [
        *has_many_associations,
        *has_one_associations,
      ].then { symbolize_list _1 }
    end

    def free_input_names
      each_free_input.map(&:free_input_name)
    end

    def store_model_list_names
      store_model_lists.pluck(:name)
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

    # @param [Pathname, String] raw_path
    # @return [void]
    def write_locale!(raw_path: Rails.root.join("config", "locales", "solution_property_labels.en.yml"))
      locale = generate_locale

      path = Pathname(raw_path)

      path.open("wb+") do |f|
        f.write YAML.dump(locale)
      end
    end

    def ransackable_associations
      @ransackable_associations ||= [
        *eager_load_associations
      ].then { symbolize_list _1 }
    end

    def ransackable_attributes
      @ransackable_attributes ||= [].tap do |a|
        a.concat(standard_values)
        a << "country_code"
        a.concat(Implementation.pluck(:name, :enum).flatten)
      end.then { symbolize_list _1 }
    end

    def to_clone
      @to_clone ||= [].tap do |a|
        a.concat attachment_values
        a.concat standard_values
        a.concat free_input_names
        a.concat Implementation.pluck(:name, :enum).flatten
        a.concat has_one_associations
        a.concat has_many_associations
        a.concat store_model_list_names
      end.then { symbolize_list _1 }
    end

    # @return [<SolutionProperty>]
    def in_property_order
      return enum_for(__method__) unless block_given?

      clones = to_clone.map(&:to_s)

      where(name: clones).to_a.sort.each do |prop|
        yield prop
      end
    end

    # @param [:actual, :draft, :intake] solution_kind
    # @return [<SolutionProperty>]
    def with_presence_required_for(solution_kind)
      records = with_presence_required.to_a

      records.select do |prop|
        prop.validate_presence_for?(solution_kind)
      end
    end

    # @return [ActiveSupport::HashWithIndifferentAccess{ String => Integer }]
    def field_ordering
      @field_ordering ||= SolutionProperty.in_use.map { [_1.name, _1.field_position] }.sort_by(&:last).to_h.with_indifferent_access
    end

    # @!endgroup

    # Used in a generator in order to populate {ControlledVocabularyConnection}.
    #
    # @api private
    # @return [<Hash>]
    def build_raw_connections
      for_connections.flat_map do |property|
        # :nocov:
        property => { name:, connection_mode:, vocab_name:, }
        # :nocov:

        connection_mode = connection_mode.to_s

        vocab = ControlledVocabulary.find(vocab_name)

        # :nocov:
        vocab => { strategy:, }
        # :nocov:

        ApplicationRecord.pg_enum_values("solution_kind").map do |solution_kind|
          key = "#{solution_kind}/#{name}"

          { key:, name:, solution_kind:, connection_mode:, strategy:, vocab_name:, }
        end
      end
    end

    # @param [:draft, :intake, :actual] solution_kind
    # @return [Solution, SolutionDraft, SolutionIntake]
    def solution_record_for(solution_kind)
      solution_records.compute_if_absent solution_kind do |kind|
        case solution_kind
        in :intake
          SolutionIntake.new.freeze
        in :draft
          SolutionDraft.new.freeze
        in :actual
          Solution.new.freeze
        else
          raise ArgumentError, "Unknown solution kind: #{solution_kind.inspect}"
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

    def solution_records
      @solution_records ||= Concurrent::Map.new
    end
  end
end
