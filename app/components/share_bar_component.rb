# frozen_string_literal: true

class ShareBarComponent < ApplicationComponent
  ShareMode = Dry::Types["coercible.string"].enum("comparison", "none", "solution_list", "solution_detail").fallback("none")

  # @return [Comparison, nil]
  attr_reader :comparison

  # @return [ComparisonShare, nil]
  attr_reader :comparison_share

  # @return [ShareMode]
  attr_reader :share_mode

  # @return [String, nil]
  attr_reader :share_url

  # A URL that accepts a `PUT` request with no body that is fired
  # when the {#share_url} is shared/copied.
  #
  # @return [String, nil]
  attr_reader :shared_url

  # @return [Solution, nil]
  attr_reader :solution

  delegate :sharable?, to: :comparison, prefix: true, allow_nil: true

  # @param [Boolean] show_back
  # @param [Boolean] is_narrow
  def initialize(mode: "none", comparison: nil, solution: nil)
    @share_mode = ShareMode[mode]
    @comparison = comparison
    @comparison_share = comparison&.comparison_share
    @solution = solution

    validate_share_mode!
  end

  def before_render
    super if defined? super

    @share_url = calculate_share_url
    @shared_url = calculate_shared_url
  end

  private

  def calculate_share_url
    case share_mode
    when "comparison"
      comparison_share_url(comparison_share, m: ?c)
    when "solution_list"
      if comparison_sharable?
        comparison_share_url(comparison_share, m: ?f)
      else
        solutions_url
      end
    when "solution_detail"
      solution_url(solution)
    else
      # :nocov:
      ""
      # :nocov:
    end
  end

  def calculate_shared_url
    if share_mode.in?(["comparison", "solution_list"]) && comparison_sharable?
      shared_comparison_share_url(comparison_share)
    else
      # :nocov:
      ""
      # :nocov:
    end
  end

  def share_mode_valid?
    case share_mode
    when "comparison"
      comparison_sharable?
    when "solution_detail"
      solution.present?
    else
      # :nocov:
      true
      # :nocov:
    end
  end

  # @return [void]
  def validate_share_mode!
    @share_mode = "none" unless share_mode_valid?
  end
end
