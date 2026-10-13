# frozen_string_literal: true

module VOGTesting
  module GQL
    class GlobalErrorsBuilder < ObjectsShaper
      alias error item

      def build_item(...)
        GlobalErrorBuilder.build(...)
      end

      def coded_error(input, type: input.to_s, **options)
        error input, **options, type:
      end

      def something_went_wrong!(type: "$global", **options)
        message = /\A#{I18n.t("server_messages.errors.something_went_wrong")}\z/

        coded_error(message, **options, type:)
      end
    end
  end
end
