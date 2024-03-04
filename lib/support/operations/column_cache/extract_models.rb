# frozen_string_literal: true

module Support
  module ColumnCache
    class ExtractModels
      include Dry::Monads[:result, :do]

      include Support::Deps[
        extract_model: "column_cache.extract_model",
      ]

      # @param [Class<ActiveRecord::Base>]
      def call
        Rails.application.eager_load!

        models = [ActsAsTaggableOn::Tag, ActsAsTaggableOn::Tagging]

        models += ApplicationRecord.descendants.reject(&:abstract_class)

        models.sort_by!(&:name)

        columns = models.flat_map do |model_klass|
          yield extract_model.(model_klass)
        end

        Success columns
      end
    end
  end
end
