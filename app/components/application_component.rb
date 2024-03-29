# frozen_string_literal: true

# @abstract
class ApplicationComponent < ViewComponent::Base
  include ApplicationHelper
  include HeroiconHelper
  include Ransack::Helpers::FormHelper
  include Turbo::FramesHelper

  NBSP = "&nbsp;".html_safe.freeze

  module AcceptsImplementation
    extend ActiveSupport::Concern

    included do
      delegate :available?, to: :implementation
    end

    IMPLEMENTATION = ::Solutions::Types.Instance(::Solutions::AbstractImplementation)

    # @return [Solutions::AbstractImplementation]
    attr_reader :implementation

    # The name of the implementation
    # @return [Symbol]
    attr_reader :name

    alias implementation_name name

    # @param [Solution] solution
    # @param [#to_s] name
    def initialize(solution:, name:)
      @solution = solution
      @name = ::Solutions::Types::Implementation[name]

      @implementation = IMPLEMENTATION[solution.__send__(@name)]
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
