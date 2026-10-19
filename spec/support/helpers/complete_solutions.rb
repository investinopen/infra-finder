# frozen_string_literal: true

module TestHelpers
  # Builds values for every property the editor validations require, from the same
  # metadata the validations use.
  #
  # @see SolutionProperty.with_presence_required_for
  module CompleteSolutions
    # @param [Solutions::Types::Kind] kind
    # @return [{ Symbol => Object }] model attributes
    def complete_solution_attributes(kind)
      SolutionProperty.with_presence_required_for(kind).each_with_object({}) do |prop, attrs|
        value = complete_value_for(prop)

        attrs[prop.attribute_name.to_sym] = value unless value.nil?
      end
    end

    # @param [Solutions::Types::Kind] kind
    # @return [{ Symbol => Object }] mutation input, keyed by argument name
    def complete_solution_input(kind)
      complete_solution_attributes(kind).each_with_object({}) do |(attribute, value), input|
        case value
        when Array then input[:"#{attribute.to_s.singularize}_ids"] = value.map(&:to_encoded_id)
        when ApplicationRecord then input[:"#{attribute}_id"] = value.to_encoded_id
        when Date then input[attribute] = value.iso8601
        else
          input[attribute] = value
        end
      end
    end

    private

    # @param [SolutionProperty] prop
    # @return [Object, nil] nil when the default already satisfies the validation
    def complete_value_for(prop)
      case prop.kind
      in :blurb | :string then "#{prop.name.humanize} text"
      in :url then "https://example.org/#{prop.name.dasherize}"
      in :date then Date.new(2020, 1, 1)
      in :single_option then FactoryBot.create(prop.vocab.model_klass.factory_bot_name)
      in :multi_option then [FactoryBot.create(prop.vocab.model_klass.factory_bot_name)]
      else
        nil
      end
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::CompleteSolutions, type: :request
end
