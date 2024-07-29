# frozen_string_literal: true

module ControlledVocabularies
  class ConnectionIntrospection < Module
    # @return [ControlledVocabularyConnection]
    attr_reader :connection

    # @return [String]
    attr_reader :name

    # @return [Symbol, nil]
    attr_reader :id_finder

    # @return [Symbol, nil]
    attr_reader :id_reader

    # @return [Symbol, nil]
    attr_reader :id_writer

    alias inspect name

    delegate :assoc_name, :key, :vocab, to: :connection

    # @param [ControlledVocabularyConnection]
    def initialize(connection)
      @connection = connection
      @name = "ControlledVocabularies::ConnectionIntrospection[#{key.to_sym.inspect}]"

      define_methods!

      define_single_model_methods! if connection.single? && connection.uses_model?
    end

    private

    def define_methods!
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{assoc_name}_connection
        ControlledVocabularyConnection.find(#{key.inspect})
      end

      def #{assoc_name}_options
        #{assoc_name}_connection.fetch_options!
      end
      RUBY
    end

    # @return [void]
    def define_single_model_methods!
      @id_reader = :"#{assoc_name}_id"
      @id_writer = :"#{assoc_name}_id="
      @id_finder = :"#{assoc_name}_find_record"

      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{id_reader}
        #{assoc_name}&.id
      end

      def #{id_writer}(new_id)
        self.#{assoc_name} = #{id_finder}(new_id)
      end

      def #{id_finder}(value)
        case value
        when #{vocab.model_name}
          value
        when "" then nil
        when String
          #{vocab.model_name}.find(value)
        end
      end
      RUBY
    end
  end
end
