# frozen_string_literal: true

module ControlledVocabularies
  class Accessor
    include Dry::Initializer[undefined: false].define -> do
      param :vocab, Types.Instance(::ControlledVocabulary)

      option :csv_strategy, SolutionProperties::Types::CSVStrategy, default: -> { :modern }
    end

    def from_single_csv(input)
    end

    def to_csv(instance)
    end
  end
end
