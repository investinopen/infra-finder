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

  delegate :comparison_share, :search_filters, to: :current_comparison, allow_nil: true, prefix: :current

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
    # :nocov:
    session.update(xx: ?b) unless session.exists?
    # :nocov:

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
  def refetch_current_comparison!
    @current_comparison = fetch_comparison!
  end

  def skip_current_comparison?
    if current_comparison.blank?
      redirect_to solutions_path, notice: t("comparisons.show.select_some_comparisons")

      return true
    end

    unless current_comparison.comparison_items.many?
      redirect_to solutions_path, notice: t("comparisons.show.not_enough_selected")

      return true
    end

    if controller_name == "comparisons" && action_name == "show"
      redirect_to comparison_share_url(current_comparison_share, m: ?c)

      return true
    end
  end

  def render_current_comparison!
    return if skip_current_comparison?

    set_current_open_graph!(image: "og/compare.png")

    open_graph.url = comparison_share_url(current_comparison_share)

    page_meta.canonical_url = comparison_share_url(current_comparison_share)

    page_meta.no_index!

    page_meta.site_title = t(".site_title", raise: true)
  end

  COMPARISON_CONTROLLERS = %w[comparisons comparison_shares].freeze

  def request_from_comparison?
    ref = Rails.application.routes.recognize_path(request.referer)

    ref[:controller].in?(COMPARISON_CONTROLLERS) && ref[:action] == "show"
  rescue ActionController::RoutingError
    # :nocov:
    false
    # :nocov:
  end

  # @return [void]
  def search_and_load_solutions!(refetch_comparison: true)
    refetch_current_comparison! if refetch_comparison

    search_filters = current_search_filters || Comparisons::SearchFilters.new

    @solution_search = solution_scope.ransack(current_search_filters&.as_json)
    @solution_search.sorts = [Comparisons::SearchFilters::DEFAULT_SORT] if @solution_search.sorts.empty?

    @relogicked_solution_search = search_filters.apply_ransack(scope: solution_scope)

    @solutions = @relogicked_solution_search.result(distinct: true).with_all_facets_loaded

    render "solutions/index"
  end

  # @return [ActiveRecord::Relation]
  def solution_scope
    Solution.publicly_accessible_for(current_user)
  end
end
