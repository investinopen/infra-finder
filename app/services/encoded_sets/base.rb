# frozen_string_literal: true

module EncodedSets
  # @abstract
  class Base
    extend Dry::Core::ClassAttributes

    include Support::EnhancedStoreModel
    include Support::GQL::ExposesType

    include EncodedSets::Assignment

    private

    # @return [void]
    def set_report_name!
      return unless self.class.report_name.present?

      self.report_name ||= self.class.report_name
    end

    class << self
      # @return [void]
      def abstract_class!
        namespace_prefix derive_namespace_prefix
        base_type self
      end

      # @param [String] report_name
      # @return [Class<Reports::Common::EncodedSet>]
      def klass_for(report_name)
        case report_name
        in /\Asnapshots\./
          "#{namespace_prefix}/#{report_name.tr(?., ?/)}".camelize(:upper).constantize
        else
          # simplecov:disable
          base_type
          # simplecov:enable
        end
      end

      # @param [Symbol] model_name
      # @return [void]
      def references_many!(model_name)
        base = model_name.to_s.singularize.to_sym

        plural = model_name.to_s.pluralize.to_sym

        attribute plural, EncodedSets::Reference.to_array_type

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{base}_ids = Array(#{plural}).map(&:encoded_id)
        RUBY
      end

      # @param [Symbol] model_name
      # @return [void]
      def references_one!(model_name)
        base = model_name.to_s.singularize.to_sym

        attribute base, EncodedSets::Reference.to_type

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{base}_id = #{base}&.encoded_id
        RUBY
      end

      protected

      # @return [String]
      def derive_namespace_prefix = name.deconstantize.underscore
    end
  end
end
