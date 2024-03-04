# frozen_string_literal: true

# Provide human-readable select options for Statesman machines.
module StateMachineSelectOptions
  extend ActiveSupport::Concern

  module ClassMethods
    # @return [<(String, String)>]
    def select_options
      states.map do |state|
        [state.titleize, state]
      end
    end
  end
end
