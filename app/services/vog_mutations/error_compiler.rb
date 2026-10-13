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

    delegate :normalize_attribute_path, to: :argument_set

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
