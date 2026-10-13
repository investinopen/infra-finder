# frozen_string_literal: true

RSpec::Matchers.define :be_an_encoded_slug do
  match do |actual|
    Support::System["slugs.decode_id"].(actual).success?
  end
end
