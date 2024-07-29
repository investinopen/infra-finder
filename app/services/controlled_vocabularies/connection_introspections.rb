# frozen_string_literal: true

module ControlledVocabularies
  module ConnectionIntrospections
    extend ActiveSupport::Concern

    include SolutionProperties::HasSolutionKind

    included do
      delegate :vocab_connection_for,
        :vocab_for,
        :vocab_options_for,
        to: :class
    end

    module ClassMethods
      # @param [#to_s] name
      # @return [ControlledVocabularyConnection]
      def vocab_connection_for(name)
        ControlledVocabularyConnection.lookup(name:, solution_kind:)
      end

      # @param [#to_s] name
      # @return [ControlledVocabulary]
      def vocab_for(name)
        vocab_connection_for(name).vocab
      end

      # @param [#to_s] name
      # @return [<(String, String, Hash)>]
      def vocab_options_for(name)
        vocab_for(name).fetch_options!
      end
    end
  end
end
