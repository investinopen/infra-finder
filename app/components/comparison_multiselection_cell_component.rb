# frozen_string_literal: true

class ComparisonMultiselectionCellComponent < ApplicationComponent
  include AcceptsSolution

  # @return [Array]
  attr_reader :selections

  # @return [String, nil]
  attr_reader :other_value

  # @return [Boolean]
  attr_reader :has_value

  alias has_value? has_value

  # @return [Symbol]
  attr_reader :mode

  # @return [Boolean]
  attr_reader :truncate

  alias truncate? truncate

  # @param [Solution] solution
  # @param [Symbol] name
  def initialize(solution:, name:, truncate:)
    solution.vocab_selected_and_other_for(name) => { selected:, has_other:, other_value:, mode:, conn: }

    @selections = Array(selected)
    @other_value = other_value
    @has_value = (@selections.present? || @other_value.present?)
    @mode = mode
    @truncate = truncate
  end

  def should_render_list?
    mode == :multiple && selections.many?
  end

  def should_truncate?
    has_value? && truncate?
  end
end
