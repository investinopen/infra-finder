# frozen_string_literal: true

module VOGMutations
  # A GraphQL response object for mutations.
  #
  # It contains many helper methods for managing errors and attaching
  # data to the response.
  #
  # It is stored within the {VOGMutations::Current current mutation context}
  # and is accessible from within mutation implementations.
  #
  # @see VOGMutations::ReadsCurrentMutation
  class Response
    include VOGMutations::FlowControl

    # Keys that are always preserved in the response data.
    DEFAULT_PRESERVED_KEYS = %i[halt_code global_errors attribute_errors].freeze

    # @api private
    # @return [Hash{Symbol => Object}]
    attr_reader :data

    # "Something went wrong"
    # @return [String]
    attr_reader :default_error_message

    # @return [VOGMutations::ErrorCompiler]
    attr_reader :error_compiler

    # @return [<Symbol>]
    attr_reader :preserved_keys

    # @return [Boolean]
    attr_reader :invalid

    alias has_errors? invalid
    alias invalid? invalid

    # @param [VOGMutations::ErrorCompiler] error_compiler
    def initialize(error_compiler: VOGMutations::ErrorCompiler.new)
      @data = build_data
      @default_error_message = I18n.t("server_messages.errors.something_went_wrong", raise: true)
      @error_compiler = error_compiler
      @preserved_keys = [*DEFAULT_PRESERVED_KEYS]
      @invalid = false
    end

    # Mark keys to be presereved in the response data in the event
    # that the response is invalid.
    #
    # @param [#to_sym] keys
    # @return [void]
    def preserve!(*keys)
      valid_keys = keys.flatten.compact_blank.uniq.map(&:to_sym)

      @preserved_keys |= valid_keys
    end

    # @return [Hash{Symbol => Object}]
    def to_h
      if invalid?
        data.slice(*preserved_keys)
      else
        data.dup
      end
    end

    # @!group Assignment

    # @param [Symbol, String] key
    # @return [Object]
    def [](key)
      data[key]
    end

    # Attach a `value` on `key` of the GraphQL response.
    #
    # @see #attach_many!
    # @param [Symbol, String] key
    # @param [Object] value
    # @return [void]
    def attach!(key, value)
      return if key.blank?

      data[key] = value
    end

    alias []= attach!

    # @see #attach!
    # @param [{ Symbol => Object }] pairs
    # @return [void]
    def attach_many!(**pairs)
      pairs.each do |key, value|
        attach! key, value
      end
    end

    def attached?(key) = data.key?(key)

    # @!endgroup Assignment

    # @!group Error Management

    # @param [String] message
    # @param [String] code
    # @param [String, String[]] path
    # @param [Hash] extensions
    # @return [void]
    def add_attribute_error!(message, code: nil, path: nil)
      error = error_compiler.attribute(message, code:, path:)

      add_compiled_attribute_error! error
    end

    def attribute_errors_for(*raw_path, type: VOGMutations::Error::SERVER)
      _, attribute_path = error_compiler.standardize_attribute_path(raw_path)

      data[:attribute_errors][[attribute_path, type]] || []
    end

    # @param [String] message
    # @return [void]
    def add_global_error!(message, type: "$global")
      error = error_compiler.global message, code: type

      add_compiled_global_error! error
    end

    # @param [Symbol] code
    # @param [String] scope
    # @return [void]
    def add_global_validation_error!(code, scope: "dry_validation.errors.rules")
      message = I18n.t(code, scope:, raise: true)

      error = error_compiler.global(message, code:)

      add_compiled_global_error! error
    end

    # @param [#errors] model
    # @return [void]
    def add_model_errors!(model)
      model.errors.full_messages.each do |message|
        add_global_error! "Problem persisting #{model.model_name}: #{message}", type: "$model_error"
      end
    end

    # @api private
    # @param [(Symbol, String), Object] failure
    # @return [void]
    def handle_operation_failure!(failure)
      mark_invalid!

      if failure.kind_of?(Array) && failure.length == 2
        add_global_error! failure[1], type: failure[0].to_s
      else
        add_global_error! default_error_message
      end

      return nil
    end

    # @return [void]
    def mark_invalid!
      @invalid = true
    end

    # Short-circuits and ends the mutation's execution.
    #
    # @see #throw_invalid
    # @param [String] error_message
    # @raise [VOGMutations::Halting::Invalid]
    # @return [void]
    def something_went_wrong!(error_message: default_error_message)
      add_global_error! error_message

      throw_invalid
    end

    # @!endgroup Error Management

    private

    # @param [VOGMutations::Error] error
    # @return [void]
    def add_compiled_attribute_error!(error)
      mark_invalid!

      key = error.attribute_error_key

      data[:attribute_errors][key] ||= []

      data[:attribute_errors][key] << error.message

      data[:attribute_errors][key].uniq!
    end

    # @param [VOGMutations::Error] error
    # @return [void]
    def add_compiled_global_error!(error)
      mark_invalid!

      data[:global_errors] << error.to_global_error
      data[:global_errors].uniq!
    end

    # @return [ActiveSupport::HashWithIndifferentAccess]
    def build_data
      {
        attribute_errors: {},
        global_errors: [],
      }.with_indifferent_access
    end
  end
end
