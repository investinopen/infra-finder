# frozen_string_literal: true

RSpec.describe EmailValidator do
  let(:model_class) { described_class::TestModel }

  let(:email) { "" }

  subject(:instance) { model_class.new(email:) }

  before do
    instance.validate
  end

  context "with valid inputs" do
    where(:case_name, :email) do
      [
        ["a simple email", "hello@example.com"],
        ["an email with an alias", "hello+foo@example.com"]
      ]
    end

    with_them do
      it { is_expected.to be_valid }
    end
  end

  context "with invalid inputs" do
    where(:case_name, :email, :expected_error_key) do
      [
        ["an empty email", "", :invalid_email],
        ["a single word", "hello", :invalid_email_domain],
        ["an email with a display name", "Hello <foo@example.com>", :invalid_email_structure],
        ["null", nil, :invalid_email]
      ]
    end

    with_them do
      it { is_expected.to be_invalid }

      its(:errors) { are_expected.to be_of_kind(:email, expected_error_key) }
    end
  end
end
