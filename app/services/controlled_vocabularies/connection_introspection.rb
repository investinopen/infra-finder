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
      define_limited_collection_methods! if connection.multiple? && connection.uses_model? && connection.limits_max_length?
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
    def define_limited_collection_methods!
      @id_reader = :"#{assoc_name.to_s.singularize}_ids"
      @id_writer = :"#{id_reader}="

      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{assoc_name}=(records)
        collection = association(#{assoc_name.inspect})

        if persisted? && records.size > #{connection.max_length} && records.all? { |record| record.is_a?(#{vocab.model_name}) }
          collection.target = records.to_a.dup
        else
          collection.reset if persisted? && collection.loaded? && collection.target.size > #{connection.max_length}

          super
        end
      end

      def #{id_writer}(ids)
        self.#{assoc_name} = #{vocab.model_name}.find(Array(ids).compact_blank)
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
