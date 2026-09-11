# frozen_string_literal: true

RSpec::Matchers.define :be_a_cron_entry do
  match do |actual|
    Fugit.parse(actual).kind_of?(Fugit::Cron)
  rescue StandardError
    false
  end
end
