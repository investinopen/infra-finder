# frozen_string_literal: true

# A concern for models that are options that get seeded initially, but can be modified afterwards.
#
# @see Seeding::OptionSeeder
module SeededOption
  extend ActiveSupport::Concern

  include SolutionOption

  included do
    validates :seed_identifier, uniqueness: { if: :seed_identifier? }
  end

  module ClassMethods
    # @api private
    # @param [String] seed_identifier
    # @param [CSV::Row] row
    # @return [SeededOption]
    def seed_for!(seed_identifier, row)
      record = where(seed_identifier:).first_or_initialize

      record.assign_attributes row.to_h

      record.save!

      return record
    end
  end
end
