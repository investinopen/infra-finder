# frozen_string_literal: true

module Filtering
  # A builder class that helps construct annotated dry-rb types for GraphQL arguments.
  #
  # @api private
  class ArgumentBuilder
    include Dry::Initializer[undefined: false].define -> do
      param :type, Support::DryGQL::Types::Type

      option :required, Support::DryGQL::Types::Bool.default(false), optional: true, as: :provided_required
    end

    # @return [Support::DryGQL::Types::Type]
    def call
      @current_type = type

      # simplecov:disable
      required! if provided_required

      yield self if block_given?
      # simplecov:enable

      return @current_type
    end

    # @param [Object] value
    # @param [Boolean] replace_null
    # @return [void]
    def default(value, replace_null: false)
      augment_type do |t|
        # simplecov:disable
        t.meta(
          gql_default_value: value,
          gql_replace_null: replace_null,
        ) unless value.nil?
        # simplecov:enable
      end
    end

    # @param [String] text
    # @return [void]
    def description(text)
      augment_type do |t|
        t.gql_description text.to_s.strip
      end
    end

    # @return [void]
    def required!
      # simplecov:disable
      augment_type do |t|
        t.gql_required true
      end
      # simplecov:enable
    end

    private

    # Augment the current type by yielding it to the given block.
    # @yield [current_type] a block to modify the current type
    # @yieldparam [Support::DryGQL::Types::Type] current_type
    # @yieldreturn [Support::DryGQL::Types::Type]
    # @return [void]
    def augment_type
      new_type = yield @current_type

      @current_type = Support::DryGQL::Types::Type[new_type] if new_type.present?

      return
    end
  end
end
