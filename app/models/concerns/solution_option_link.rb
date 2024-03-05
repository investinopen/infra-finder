# frozen_string_literal: true

# Connective tissue between a {SolutionOption} record and a {Solution} and a {SolutionDraft}.
module SolutionOptionLink
  extend ActiveSupport::Concern

  include TimestampScopes

  included do
    scope :in_default_order, -> { joins(option_association.name).merge(option_association.klass.in_alphabetical_order) }
  end

  STANDARD_RANSACKABLE_ATTRIBUTES = %w[
    id
    created_at
    updated_at
  ].freeze

  module ClassMethods
    def solution_kind
      @solution_kind ||= derive_solution_kind
    end

    def option_association
      @option_association ||= derive_option_association
    end

    def solution_association
      case solution_kind
      in :actual
        reflect_on_association(:solution)
      in :draft
        reflect_on_association(:solution_draft)
      end
    end

    def ransackable_associations(auth_object = nil)
      [
        option_association.name.to_s,
        solution_association.name.to_s,
      ]
    end

    def ransackable_attributes(auth_object = nil)
      STANDARD_RANSACKABLE_ATTRIBUTES
    end

    private

    def derive_option_association
      reflect_on_all_associations.detect do |assoc|
        next if assoc.name.in?([:solution, :draft_solution])

        assoc.klass < SolutionOption
      end
    end

    # @return [Solutions::Types::Kind]
    def derive_solution_kind
      if reflect_on_association(:solution)
        :actual
      elsif reflect_on_association(:solution_draft)
        :draft
      else
        # :nocov:
        raise "Unknown solution kind for #{name}"
        # :nocov:
      end.then { Solutions::Types::Kind[_1] }
    end
  end
end
