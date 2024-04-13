# frozen_string_literal: true

module OpenGraph
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Type = String.default("website").enum("website", "article")

    Title = String.constrained(filled: true).default { I18n.t("globals.open_graph_title", raise: true) }

    URL = String.constrained(http_uri: true)
  end
end
