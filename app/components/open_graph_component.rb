# frozen_string_literal: true

class OpenGraphComponent < ApplicationComponent
  # @return [OpenGraph::Properties]
  attr_reader :open_graph

  delegate :valid?, to: :open_graph

  def initialize(open_graph: OpenGraph::Properites.new)
    @open_graph = open_graph
  end

  # @param [String] property
  # @param [String] content
  def meta_tag(property, content)
    content_tag(:meta, "", property:, content:)
  end
end
