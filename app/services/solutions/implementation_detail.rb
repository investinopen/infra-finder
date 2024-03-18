# frozen_string_literal: true

module Solutions
  class ImplementationDetail < Support::FlexibleStruct
    include Dry::Core::Memoizable

    SCOPE_SUFFIXES = %w[available].freeze

    attribute :name, Types::Symbol
    attribute :type, Types::Class
    attribute :enum, Types::Symbol

    delegate :has_any_links?, :has_many_links?, :has_no_links?, :has_single_link?, :has_statement?, :link_mode, :linked?, :unlinked?, to: :type

    # @return [<String>]
    memoize def ransackable_scopes
      SCOPE_SUFFIXES.map { "#{name}_#{_1}" }
    end
  end
end
