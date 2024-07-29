# frozen_string_literal: true

module ControlledVocabularies
  class Replace < Support::SimpleServiceOperation
    service_klass ControlledVocabularies::Replacer
  end
end
