# frozen_string_literal: true

module VOGMutations
  # A class that compiles mutation errors and ensures that
  # they are properly formatted with paths and attribute information.
  #
  # It relies heavily upon an {VOGMutations::Arguments::Set} to
  # normalize attribute paths.
  #
  # @api private
  class ErrorCompiler
    include Dry::Initializer[undefined: false].define -> do
      option :argument_set, VOGMutations::Arguments::Set::Type, default: proc { VOGMutations::Arguments::Set.new }
    end

    delegate :argument_path?, :normalize_attribute_path, to: :argument_set

    # The default path for global errors.
    # @api private
    GLOBAL_PATH = %w[$global].freeze

    # @param [String] message
    # @return [VOGMutations::Error]
    def attribute(message, path:, code: nil)
      # simplecov:disable
      raise "must provide a path for attribute errors" if path.blank?
      # simplecov:enable

      path, attribute_path = standardize_attribute_path(path)

      VOGMutations::Error.new(
        message:,
        code:,
        path:,
        attribute_path:,
        global: false
      )
    end

    # Compile a model's error as an error on the input field it belongs to.
    #
    # @param [ActiveModel::Error] error
    # @return [VOGMutations::Error, nil] nil when no argument sets that attribute
    def model_error(error)
      path = error.attribute.to_s.split(?.).map(&:to_sym)

      return unless argument_path?(path)

      # Errors added with a literal message use that message as their type.
      code = error.type if error.type.kind_of?(Symbol)

      attribute(error.message, path:, code:)
    end

    # @return [VOGMutations::Error]
    def global(message, code: nil)
      VOGMutations::Error.new(
        message:,
        code:,
        path: GLOBAL_PATH,
        attribute_path: "$global",
        global: true
      )
    end

    # @param [String, <Symbol, Integer>] raw_path
    # @return [(<String>, String)]
    def standardize_attribute_path(raw_path)
      path = normalize_attribute_path(raw_path)

      attribute_path = path.join(?.)

      [path, attribute_path]
    end
  end
end
