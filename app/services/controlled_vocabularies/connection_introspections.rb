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

    # @param [#to_s] name
    # @return [String, nil]
    def other_value_for(name)
      vocab_connection_for(name).then { public_send(_1.other_attribute_name) if _1.accepts_other? }
    end

    # @param [#to_s] name
    # @return [Hash]
    def vocab_selected_and_other_for(name)
      conn = vocab_connection_for(name)

      case conn.connection_mode
      in :multiple
        multiple_selected_and_other_for(conn)
      in :single
        single_selected_and_other_for(conn)
      end.merge(conn:, mode: conn.connection_mode)
    end

    private

    def multiple_selected_and_other_for(conn)
      # :nocov:
      raise "only for :multiple-mode connections" unless conn.multiple?
      # :nocov:

      selected, other = public_send(conn.name).partition { !_1.provides_other? }

      other_value = other_value_for(conn.name) if conn.accepts_other?

      has_other = conn.accepts_other? && other.present? && other_value.present?

      { selected:, has_other:, other_value:, }
    end

    def single_selected_and_other_for(conn)
      # :nocov:
      raise "only for :single-mode connections" unless conn.single?
      # :nocov:

      current = public_send(conn.name)

      selected = current unless conn.accepts_other? && current.try(:provides_other?)

      other_value = other_value_for(conn.name) if conn.accepts_other?

      has_other = conn.accepts_other? && current.try(:provides_other?) && other_value.present?

      { selected:, has_other:, other_value:, }
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
