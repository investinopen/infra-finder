# frozen_string_literal: true

RSpec::Matchers.define :be_xml_content do
  match do |actual|
    raise TypeError, "expected #{actual.inspect} to respond to #content_type" unless actual.respond_to?(:content_type)

    %r{\Aapplication/xml(?:;.+)?\z}.match? actual.content_type
  end
end
