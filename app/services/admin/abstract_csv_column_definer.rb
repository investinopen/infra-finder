# frozen_string_literal: true

module Admin
  class AbstractCSVColumnDefiner < Support::HookBased::Actor
    extend Dry::Core::ClassAttributes
    extend Dry::Initializer

    param :builder, Types::CSVBuilder

    option :scope, Types::CSVScope, default: proc { :private }

    standard_execution!

    defines :scope_skips, type: Types::CSVScopeSkips

    scope_skips(Admin::Types::CSVScopeSkips.value.())

    # Skips for the current scope.
    #
    # @return [<Symbol>]
    attr_reader :skips

    # @return [Dry::Monads::Success]
    def call
      run_callbacks :execute do
        yield prepare!

        yield define_columns!
      end

      Success builder
    end

    wrapped_hook! def prepare
      @skips = self.class.scope_skips.fetch(scope)

      super
    end

    wrapped_hook! :define_columns

    private

    # @param [Symbol] name
    # @return [void]
    def column!(name, ...)
      return if skip?(name)

      builder.column(name, ...)
    end

    # @param [Symbol] name
    def skip?(name)
      name.in?(skips)
    end

    class << self
      alias define_columns! after_define_columns

      def skip_public!(*columns)
        skip_columns! *columns, scope: :public
      end

      # @param [<Symbol>] columns
      # @param [Admin::Types::CSVScope] scope
      # @return [void]
      def skip_columns!(*columns, scope:)
        columns.flatten!

        skips = scope_skips.fetch(scope).dup

        skips |= columns

        skips.sort!

        scope_skips scope_skips.merge(scope => skips.freeze).freeze
      end
    end
  end
end
