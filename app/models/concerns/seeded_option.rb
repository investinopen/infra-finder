# frozen_string_literal: true

# A concern for models that are options that get seeded initially, but can be modified afterwards.
#
# @see Seeding::OptionSeeder
module SeededOption
  extend ActiveSupport::Concern

  include SolutionOption

  included do
    scope :seeded, -> { where.not(seed_identifier: nil) }

    validates :seed_identifier, uniqueness: { if: :seed_identifier? }
  end

  module ClassMethods
    # @api private
    # @param [Integer] seed_identifier
    # @param [CSV::Row] row
    # @return [SeededOption]
    def seed_for!(seed_identifier, row)
      record = where(seed_identifier:).first_or_initialize

      record.assign_attributes row.to_h

      record.save!

      return record
    end

    # @param [Integer, nil] seed_identifier
    # @return [SeededOption, nil]
    def by_seed_identifier(seed_identifier)
      return unless seed_identifier.present?

      seeded.find_by(seed_identifier:)
    end
  end
end
