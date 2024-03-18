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

  # @api private
  module LoadsCurrentUser
    extend ActiveSupport::Concern

    delegate :current_user, :user_signed_in?, to: :helpers
    delegate :has_any_admin_or_editor_access?, to: :current_user, allow_nil: true
  end
end
