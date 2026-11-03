# frozen_string_literal: true

RSpec.describe SolutionInterface do
  def errors_for(model, attribute, value)
    model.new(attribute => value).tap(&:validate).errors[attribute]
  end

  [Solution, SolutionDraft, SolutionIntake].each do |model|
    describe model do
      SolutionProperty.urls.each do |prop|
        it "requires #{prop.attribute_name} to be an http(s) URL with a host" do
          [nil, "", "https://example.org/path"].each do |value|
            expect(errors_for(model, prop.attribute_name, value)).to be_empty
          end

          ["example.org", "ftp://example.org", "https://", "https://a.org; https://b.org"].each do |value|
            expect(errors_for(model, prop.attribute_name, value)).to be_present
          end
        end
      end

      SolutionProperty.emails.each do |prop|
        it "requires #{prop.attribute_name} to be an email address" do
          [nil, "", "someone@example.org"].each do |value|
            expect(errors_for(model, prop.attribute_name, value)).to be_empty
          end

          ["someone", "someone@", "some one@example.org"].each do |value|
            expect(errors_for(model, prop.attribute_name, value)).to be_present
          end
        end
      end
    end
  end
end
