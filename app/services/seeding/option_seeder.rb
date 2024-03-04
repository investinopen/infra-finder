# frozen_string_literal: true

module Seeding
  # @see SeededOption
  class OptionSeeder < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :klass, Support::Models::Types::ModelClass
    end

    standard_execution!

    SEED_ROOT = Rails.root.join("vendor", "seeds")

    # @return [<CSV::Table>]
    attr_reader :csv

    # @return [<SeededOption>]
    attr_reader :records

    # @return [Pathname]
    attr_reader :seed_path

    def call
      run_callbacks :execute do
        yield prepare!

        yield parse!

        yield seed_all!
      end

      Success()
    end

    wrapped_hook! def prepare
      @records = []
      @seed_path = SEED_ROOT.join("#{klass.model_name.collection}.csv")
    end

    wrapped_hook! def parse
      @csv = CSV.table(seed_path, headers: true)

      super
    end

    wrapped_hook! def seed_all
      csv.each do |row|
        seed_identifier = row.to_h.fetch(:seed_identifier)

        records << klass.seed_for!(seed_identifier, row)
      end

      super
    end
  end
end
