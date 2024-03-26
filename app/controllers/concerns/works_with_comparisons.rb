# frozen_string_literal: true

# Concerns for working with a {Comparison} based on the request's current session.
module WorksWithComparisons
  extend ActiveSupport::Concern

  include CallsCommonOperation

  included do
    extend Dry::Core::ClassAttributes

    defines :comparison_load_strategy, type: Comparisons::Types::LoadStrategy

    comparison_load_strategy :skip

    helper_method :current_comparison

    helper_method :current_search_filters

    before_action :load_current_comparison!
  end

  private

  # @return [Comparison, nil]
  attr_reader :current_comparison

  delegate :search_filters, to: :current_comparison, allow_nil: true, prefix: :current

  # @return [Comparisons::Types::LoadStrategy]
  def comparison_load_strategy
    self.class.comparison_load_strategy
  end

  def load_current_comparison
    case comparison_load_strategy
    in :fetch
      fetch_comparison!
    in :find_existing
      find_existing_comparison
    else
      # :nocov:
      # Intentionally left blank when skipped.
      # :nocov:
    end
  end

  def load_current_comparison!
    return @current_comparison if instance_variable_defined?(:@current_comparison)

    @current_comparison = load_current_comparison
  end

  # @return [Comparison, nil]
  def find_existing_comparison
    call_operation("comparisons.find_existing", session.try(:id)).value_or(nil)
  end

  # @raise [Comparisons::FetchFailed] in the event of some weird error.
  #   Should never occur under normal circumstances.
  # @return [Comparison]
  def fetch_comparison!
    session_id = session.try(:id)

    ip = request.remote_ip

    call_operation("comparisons.fetch", session_id:, ip:) do |m|
      m.success do |comparison|
        @current_comparison = comparison

        return comparison
      end

      m.failure do |*err|
        # :nocov:
        raise Comparisons::FetchFailed, "Could not fetch comparison: #{err.inspect}"
        # :nocov:
      end
    end
  end

  # @return [void]
  def search_and_load_solutions!
    @solution_search = solution_scope.ransack(current_search_filters)
    @solution_search.sorts = [Comparison::DEFAULT_SORT] if @solution_search.sorts.empty?

    @solutions = @solution_search.result(distinct: true).with_all_facets_loaded

    render "solutions/index"
  end

  # @return [ActiveRecord::Relation]
  def solution_scope
    Pundit.policy_scope!(current_user, Solution.all)
  end
end
