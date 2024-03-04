# frozen_string_literal: true

RSpec::Matchers.define :be_global_validation_rule do
  attr_reader :scope

  match do |actual|
    @scope ||= "dry_validation.errors.rules"

    begin
      I18n.t(actual, scope:, raise: true)
    rescue I18n::MissingTranslationData
      false
    else
      true
    end
  end

  chain :with_scope do |scope|
    @scope = scope
  end
end
