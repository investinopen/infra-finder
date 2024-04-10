# frozen_string_literal: true

# Static routes for the site that don't correspond to a specific resource.
class StaticController < ApplicationController
  # The home page / `/` route.
  def root
    redirect_to solutions_path
  end
end
