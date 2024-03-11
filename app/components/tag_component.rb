# frozen_string_literal: true

# @see TagListComponent
class TagComponent < ApplicationComponent
  # @return [Tag]
  attr_reader :tag

  # @return [ActionView::PartialIteration]
  attr_reader :iteration

  delegate :name, to: :tag

  # @param [ActsAsTaggableOn::Tag] tag
  def initialize(tag:, tag_iteration: ActionView::PartialIteration.new(1))
    @tag = tag
    @iteration = tag_iteration
  end
end
