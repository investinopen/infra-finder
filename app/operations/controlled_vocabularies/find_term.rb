# frozen_string_literal: true

module ControlledVocabularies
  # @see ControlledVocabularies::FindTerm
  class FindTerm < Support::SimpleServiceOperation
    service_klass ControlledVocabularies::TermFinder
  end
end
