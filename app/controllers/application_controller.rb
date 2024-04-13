# frozen_string_literal: true

# @abstract
class ApplicationController < ActionController::Base
  include CallsCommonOperation
  include WorksWithComparisons

  before_action :prepare_open_graph!
  before_action :prepare_page_meta!

  protect_from_forgery with: :null_session

  include Pundit::Authorization

  # @return [OpenGraph::Properties]
  attr_reader :open_graph

  helper_method :open_graph

  # @return [PageMeta::Properties]
  attr_reader :page_meta

  helper_method :page_meta

  def access_denied(error = nil)
    if user_signed_in? && current_user.has_any_admin_or_editor_access?
      redirect_back fallback_location: root_path
    else
      redirect_to root_path
    end
  end

  # @return [void]
  def prepare_open_graph!
    @open_graph = OpenGraph::Properties.new
  end

  # @return [void]
  def prepare_page_meta!
    @page_meta = PageMeta::Properties.new
  end

  def set_current_open_graph!(image: nil, **options)
    open_graph.title = t(".open_graph_title", **options, raise: true)
    open_graph.description = t(".open_graph_description", **options, raise: true)

    open_graph.image = helpers.image_url(image) if image.present?
  end

  def uncacheable!
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
  end

  class << self
    # @param [<Symbol>] actions
    # @return [void]
    def uncacheable!(*actions)
      before_action :uncacheable!, only: actions
    end
  end
end
