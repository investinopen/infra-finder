# frozen_string_literal: true

namespace :app do
  desc "Generate static error pages from Rails templates"
  task static_error_pages: :environment do
    # The pages are built once into an image that every destination shares,
    # and each destination pushes assets to its own CDN. Serve them from the
    # app instead.
    ApplicationController.asset_host = nil

    renderer = ApplicationController.renderer.new(
      http_host: LocationsConfig.root_domain,
      https: !Rails.env.local?,
      # Provide a bare warden proxy so devise helpers (e.g. current_user)
      # work outside of a real request. No strategies will succeed, so
      # pages render as an anonymous user.
      warden: Warden::Proxy.new({ "rack.session" => {} }, Warden::Manager.new(nil))
    )

    pages = {
      "403" => "errors/403",
      "404" => "errors/404",
      "422" => "errors/422",
      "500" => "errors/500",
      "503" => "errors/503",
      "504" => "errors/504",
    }

    pages.each do |code, template|
      html = renderer.render(
        template:,
        layout: "errors"
      )

      output_path = Rails.public_path.join("#{code}.html")

      output_path.write html
      puts "Generated #{output_path}"
    end
  end
end
