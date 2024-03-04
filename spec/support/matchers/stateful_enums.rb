# frozen_string_literal: true

RSpec::Matchers.define :encapsulate_all_states_for do |expected|
  match do |actual|
    case expected
    when AppTypes.Inherits(Statesman::Machine)
      expect(actual).to encapsulate_all_states_for(expected.states)
    else
      @actual = actual.actual_values

      expect(expected).to match_array @actual
    end
  end

  diffable
end
