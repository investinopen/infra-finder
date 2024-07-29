# frozen_string_literal: true

module SolutionProperties
  class Parser < Support::HookBased::Actor
    include SolutionProperties::Constants

    include Dry::Initializer[undefined: false].define -> do
      option :input_path, Types.Instance(::Pathname), default: proc { DEFAULT_INPUT_PATH }
      option :output_path, Types.Instance(::Pathname), default: proc { DEFAULT_OUTPUT_PATH }
    end

    standard_execution!

    # @return [CSV::Table]
    attr_reader :csv

    # @see SolutionProperties::LoadExisting
    # @return [Hash]
    attr_reader :existing

    # @return [<Hash>]
    attr_reader :properties

    INPUT_MAPPING = {
      "Auto-populated" => "none",
      "Boolean (TRUE / FALSE)" => "boolean",
      "Controlled dropdown" => "select",
      "Controlled multi-select" => "multiselect",
      "Free text" => "text",
      "IOI data mgmt" => "none",
      "Integer" => "integer",
      "URL" => "url",
    }.freeze

    PHASE_2_STATUS_MAPPING = {
      "Add" => "add",
      "Change - input type" => "change_input",
      "Change - label" => "change_label",
      "Change - list options" => "change_vocab",
      "Drop" => "drop",
      "Keep" => "keep",
    }.freeze

    NA = %r,\An/a\z/i,

    def call
      run_callbacks :execute do
        yield prepare!

        yield parse!

        yield process!

        yield dump!
      end

      Success output_path.size
    end

    wrapped_hook! def prepare
      @existing = yield InfraFinder::Container["solution_properties.load_existing"].()

      @properties = []

      super
    end

    wrapped_hook! def parse
      @csv = CSV.table(input_path)

      super
    end

    wrapped_hook! def process
      csv.each do |row|
        prop = process_row(row)

        properties << prop
      end

      super
    end

    wrapped_hook! def dump
      output_path.open("wb+") do |f|
        f.write YAML.dump(properties)
      end

      super
    end

    private

    def money?(*labels)
      labels.flatten!
      labels.compact_blank!

      labels.any? { /currency/i.match?(_1) }
    end

    # @param [CSV::Row] row
    # @return [Hash]
    def process_row(row)
      merge_with_existing(row) => {
        name:,
        code:,
        attr:,
        kind:,
        ext_name:,
        **rest
      }

      be_label = process_text(rest.delete(:be_label))
      fe_label = process_text(rest.delete(:fe_label))
      description = process_text(rest.delete(:description))
      vocab_name = process_vocab_name(rest.delete(:vocab_name))

      input, original_input = process_input(rest.delete(:input), be_label, fe_label, description)

      out = {
        name:,
        code:,
        attr:,
        kind:,
        ext_name:,
        be_label:,
        fe_label:,
        input:,
        vocab_name:,
        description:,
        exported: process_bool(rest.delete(:exported)),
        required: process_bool(rest.delete(:required)),
        phase_2_status: process_phase_2_status(rest.delete(:status)),
        original_input:,
      }.reverse_merge(**rest)

      SolutionProperty.assign_defaults!(out)
    end

    # @param [CSV::Row] row
    # @return [Hash]
    def merge_with_existing(row)
      ext_name = row[:name]

      curr = (existing.values.detect { _1[:ext_name] == ext_name || _1[:name] == ext_name } || {}).deep_symbolize_keys

      name = curr[:name] || ext_name

      row.to_h.merge(name:).reverse_merge(curr).reverse_merge(name:, ext_name:, attr: nil, kind: nil)
    end

    # @param [String] value
    def process_bool(value)
      case value
      when NA then false
      else
        SolutionProperties::Types::Params::Bool.fallback(false)[value]
      end
    end

    def process_input(original_input, *labels)
      input = INPUT_MAPPING.fetch(original_input)

      return ["money", original_input] if input == "integer" && money?(*labels)

      return [input, original_input]
    end

    def process_phase_2_status(value)
      PHASE_2_STATUS_MAPPING.fetch value, "none"
    end

    def process_text(value)
      return nil if NA.match?(value) || value == "No label"

      value.to_s.strip
    end

    def process_vocab_name(value)
      InfraFinder::Container["solution_properties.parse_vocab_name"].(value).value_or(nil)
    end
  end
end
