# frozen_string_literal: true

module Initiator
  extend ActiveSupport::Concern
  extend Support::Typing

  included do
    has_initiated_transitions_for "Invitation"
    has_initiated_transitions_for "SolutionDraft"
    has_initiated_transitions_for "SolutionImport"
    has_initiated_transitions_for "SolutionIntake"
    has_initiated_transitions_for "Subscription"
    has_initiated_transitions_for "User"
  end

  module ClassMethods
    # @param [String] base_model
    # @param [String] class_name
    # @param [Symbol] association
    # @return [void]
    def has_initiated_transitions_for(base_model, class_name: "#{base_model}Transition", association: :"initiated_#{base_model.to_s.tableize}")
      # rubocop:disable-next Rails/ReflectionClassName
      has_many association, as: :initiator, class_name:, dependent: :nullify
    end
  end
end
