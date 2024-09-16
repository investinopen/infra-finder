# frozen_string_literal: true

# @abstract
class ApplicationController < ActionController::Base
  extend Dry::Core::ClassAttributes
  include CallsCommonOperation
  include WorksWithComparisons

  defines :skip_terms_enforcement, type: Support::Types::Bool

  skip_terms_enforcement false

  protect_from_forgery prepend: true, with: :null_session

  before_action :store_user!
  after_action :clear_user!
  before_action :prepare_open_graph!
  before_action :prepare_page_meta!

  include Pundit::Authorization

  # @return [OpenGraph::Properties]
  attr_reader :open_graph

  helper_method :open_graph

  # @return [PageMeta::Properties]
  attr_reader :page_meta

  helper_method :page_meta

  # @return [void]
  def clear_user!
    RequestStore.store[:current_user] = nil
  end

  def access_denied(error = nil)
    if user_signed_in? && current_user.has_any_admin_or_editor_access?
      redirect_back fallback_location: root_path
    else
      redirect_to root_path
    end
  end

  def enforce_acceptance_of_terms!
    return unless user_signed_in? && current_user.has_unaccepted_terms?

    return if skip_terms_enforcement?

    alert = t("admin.terms_and_conditions.accept.alert", raise: true)

    redirect_to(admin_terms_and_conditions_path, alert:)
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

  def skip_terms_enforcement?
    self.class.skip_terms_enforcement || controller_path == "admin/terms_and_conditions"
  end

  # @return [void]
  def store_user!
    RequestStore.store[:current_user] = user_signed_in? ? current_user : nil
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
