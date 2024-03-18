# frozen_string_literal: true

# Connective tissue between a {SolutionOption} record and a {Solution} and a {SolutionDraft}.
module SolutionOptionLink
  extend ActiveSupport::Concern

  include ExposesRansackable
  include TimestampScopes

  included do
    extend Dry::Core::ClassAttributes

    defines :option_association_name, type: Solutions::Types::Symbol.enum(:license, :solution_category, :user_contribution)
    defines :solution_kind, type: Solutions::Types::Kind
    defines :solution_association_name, type: Solutions::Types::Symbol.enum(:solution, :solution_draft)

    solution_kind derive_solution_kind
    solution_association_name derive_solution_association_name
    option_association_name derive_option_association_name

    scope :in_default_order, -> { joins(option_association.name).merge(option_association.klass.in_alphabetical_order) }

    expose_ransackable_associations! option_association_name, solution_association_name, on: :admin
  end

  module ClassMethods
    def option_association
      # :nocov:
      reflect_on_association(option_association_name)
      # :nocov:
    end

    def solution_association
      # :nocov:
      reflect_on_association(solution_association_name)
      # :nocov:
    end

    private

    def derive_option_association_name
      case name
      when /\ASolutionCategory/
        :solution_category
      when /License\z/
        :license
      when /UserContribution\z/
        :user_contribution
      else
        # :nocov:
        raise "Unknown option association name for #{name}"
        # :nocov:
      end
    end

    def derive_solution_association_name
      case solution_kind
      in :draft
        :solution_draft
      else
        :solution
      end
    end

    # @return [Solutions::Types::Kind]
    def derive_solution_kind
      case name
      when /Draft/
        :draft
      when /\ASolution/
        :actual
      else
        # :nocov:
        raise "Unknown solution kind for #{name}"
        # :nocov:
      end
    end
  end
end
