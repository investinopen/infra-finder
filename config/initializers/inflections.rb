# frozen_string_literal: true

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "API"
  inflect.acronym "CSV"
  inflect.acronym "EOI"
  inflect.acronym "HTML"
  inflect.acronym "JSON"
  inflect.acronym "URL"
end

ActiveModel::Validations::URLValidator = ActiveModel::Validations::UrlValidator
Formtastic::Inputs::URLInput = Formtastic::Inputs::UrlInput
