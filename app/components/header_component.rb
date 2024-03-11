# frozen_string_literal: true

# The component for the site header, navigation, etc.
class HeaderComponent < ApplicationComponent
  include LoadsCurrentUser

  def before_render
    @nav_link_options = build_nav_link_options
  end

  # @param [String] label
  # @param [String] href
  # @param [Hash] options
  # @return [String] the generated link HTML
  def nav_link(label, href, **options)
    opts = @nav_link_options.merge(**options)

    active_link_to(label, href, **opts)
  end

  private

  def build_nav_link_options
    {
      class: "block py-2 px-3",
      class_active: "nav-link--active",
      class_inactive: "nav-link--inactive",
      data: {
        turbo_frame: "_top",
      }
    }
  end
end
