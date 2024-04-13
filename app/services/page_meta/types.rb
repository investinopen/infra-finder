# frozen_string_literal: true

module PageMeta
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    SiteTitle = String.constrained(filled: true).default { I18n.t("globals.site_title", raise: true) }

    URL = String.constrained(http_uri: true)
  end
end
