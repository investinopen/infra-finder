# frozen_string_literal: true

# A component for rendering many tags.
class TagListComponent < ApplicationComponent
  # @param [Symbol]
  attr_reader :name

  # @return [Solution]
  attr_reader :solution

  # @return [<ActsAsTaggableOn::Tag>]
  attr_reader :tags

  # @param [Symbol] name the name of the tag list
  # @param [Solution] solution
  def initialize(name:, solution:)
    @name = name.to_sym
    @solution = solution

    @tags = Array(solution.__send__(name))
  end

  def tags?
    tags.present?
  end
end
