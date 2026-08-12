# frozen_string_literal: true

RSpec.describe Emails::Parse, type: :operation do
  using RSpec::Parameterized::TableSyntax

  context "with valid inputs" do
    where(:case_name, :input) do
      "simple email" | "test@example.com"
      "email with name" | "Test User <test@example.com>"
      "address instance" | Mail::Address.new("test@example.com")
      "list of emails" | ["test@example.com", "other@example.com"]
      "mixed addresses and emails" | ["Test User <test@example.com>", Mail::Address.new("foo@bar.com")]
    end

    with_them do
      if params[:input].kind_of?(Array)
        it "parses the list of emails" do
          expect_calling_with(input).to succeed.with all(be_a_kind_of(Mail::Address))
        end
      else
        it "parses the email" do
          expect_calling_with(input).to succeed.with be_a_kind_of(Mail::Address)
        end
      end
    end
  end

  context "with invalid inputs" do
    where(:case_name, :input, :error_key) do
      "blank string" | "   " | :empty_email
      "empty string" | "" | :empty_email
      "nil" | nil | :empty_email
      "invalid email" | "blah blah" | :invalid_email
      "missing domain" | "user" | :missing_domain
      "list with invalid email" | ["user@example.com", "invalid email address"] | :invalid_emails
      "an empty list" | [] | :empty_emails
      "invalid input" | 123 | :invalid_input
    end

    with_them do
      it "fails with #{params[:error_key]}" do
        expect_calling_with(input).to monad_fail.with_key(error_key)
      end
    end
  end
end
