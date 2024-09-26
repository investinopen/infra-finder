# frozen_string_literal: true

# @abstract
class ApplicationComponent < ViewComponent::Base
  include ApplicationHelper
  include HeroiconHelper
  include Ransack::Helpers::FormHelper
  include Turbo::FramesHelper

  NBSP = "&nbsp;".html_safe.freeze

  INFRA_SANITIZE_OPTIONS = {
    tags: %w[p a ul ol li span strong em b i],
    attributes: %w[href target],
  }.freeze

  # @param [String] content
  # @return [ActiveSupport::SafeBuffer]
  def infra_format(content)
    simple_format(content, { class: 't-rte' }, { wrapper_tag: "div", sanitize: true, sanitize_options: INFRA_SANITIZE_OPTIONS })
  end

  module AcceptsImplementation
    extend ActiveSupport::Concern

    included do
      delegate :available?, to: :implementation
      delegate :in_progress?, to: :implementation
    end

    IMPLEMENTATION = ::Solutions::Types.Instance(::Implementations::AbstractImplementation)

    # @return [Implementations::AbstractImplementation]
    attr_reader :implementation

    # The name of the implementation
    # @return [String]
    attr_reader :name

    alias implementation_name name

    # @param [Solution] solution
    # @param [#to_s] name
    def initialize(solution:, name:)
      @solution = solution
      @name = ::Solutions::Types::Implementation[name]

      @implementation = IMPLEMENTATION[solution.__send__(@name)]
    end

    # @note Only applies to `"web_accessibility"` implementation.
    # @see #web_accessibility?
    # @see #any_web_accessibility_applicability?
    def applies_to_solution?
      any_web_accessibility_applicability?(&:applies_to_solution?)
    end

    # @note Only applies to `"web_accessibility"` implementation.
    # @see #web_accessibility?
    # @see #any_web_accessibility_applicability?
    def applies_to_website?
      any_web_accessibility_applicability?(&:applies_to_website?)
    end

    # A predicate for use with `#render?` for selecting only implementations
    # that are in a desired state.
    def available_or_in_progress?
      available? || in_progress?
    end

    # @return [void]
    def each_implementation_link
      # :nocov:
      return enum_for(__method__) unless block_given?
      # :nocov:

      links = [].tap do |a|
        a.concat implementation.links if has_many_links?
        a << implementation.link if has_single_link?
      end

      iteration = ActionView::PartialIteration.new(links.length)

      links.each do |link|
        yield link, iteration
      ensure
        iteration.iterate!
      end
    end

    def has_any_links?
      has_many_links? || has_single_link?
    end

    # A predicate that determines whether an implementation both has many links
    # and has at least one link populated.
    def has_many_links?
      implementation.has_many_links? && implementation.links.present?
    end

    # A predicate that determiens whether an implement has only a single link
    # and if said link is populated.
    def has_single_link?
      implementation.has_single_link? && implementation.link.present?
    end

    def web_accessibility?
      name == "web_accessibility"
    end

    private

    def any_web_accessibility_applicability?(&)
      web_accessibility? && @solution.web_accessibility_applicabilities.any?(&)
    end
  end

  module AcceptsSolution
    def render_tag_list(name)
      render TagListComponent.new(name:, solution:)
    end
  end

  module GeneratesSolutionSearch
    extend ActiveSupport::Concern

    # @return [Ransack::Search]
    attr_reader :solution_search

    # @api private
    # @return [Hash]
    attr_reader :search_form_options

    # @param [Ransack::Search] solution_search
    def initialize(solution_search: Solution.all.ransack({}))
      @solution_search = solution_search
    end

    def before_render
      # :nocov:
      super if defined?(super)
      # :nocov:

      @search_form_options = build_search_form_options
    end

    private

    def build_search_form_options
      {
        url: solution_search_path,
        html: {
          autocomplete: "off",
          data: {
            method: "post",
            "turbo-frame": "solutions-list",
            "turbo-method": "post",
          },
          method: :post,
        },
      }
    end
  end

  # @api private
  module LoadsCurrentUser
    extend ActiveSupport::Concern

    delegate :current_user, :user_signed_in?, to: :helpers
    delegate :has_any_admin_or_editor_access?, to: :current_user, allow_nil: true
  end
end
