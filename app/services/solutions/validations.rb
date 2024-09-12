# frozen_string_literal: true

module Solutions
  class Validations
    include Dry::Effects::Handler.Reader(:import_active)
    include Dry::Effects::Handler.Reader(:skip_editor_validations)
    include Dry::Effects.Reader(:import_active, default: false)
    include Dry::Effects.Reader(:skip_editor_validations, default: false)

    alias import_active? import_active
    alias skip_editor_validations? skip_editor_validations

    # @return [void]
    def importing!
      with_import_active(true) do
        yield
      end
    end

    def should_skip_editor_validations?
      import_active? || skip_editor_validations?
    end

    # @return [void]
    def skip_editor_validations!
      with_skip_editor_validations(true) do
        yield
      end
    end

    class << self
      def instance
        @instance ||= new
      end

      delegate_missing_to :instance
    end
  end
end
