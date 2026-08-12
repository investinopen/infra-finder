# frozen_string_literal: true

RSpec.describe Emails::Allow, type: :operation do
  using RSpec::Parameterized::TableSyntax

  context "with a valid combo of arguments" do
    where(
      case_names: ->(emails, enabled, allowed_domains) do
        if allowed_domains.empty?
          "allowance with no whitelist"
        else
          "allowance limited to #{allowed_domains.join(", ")}"
        end
      end,
      emails: [%w[test@example.com]],
      enabled: [true],
      allowed_domains: [
        %w[example.com],
        [],
      ]
    )

    with_them do
      it "allows the email through" do
        expect_calling_with(emails, enabled:, allowed_domains:).to succeed
      end
    end
  end

  context "with an invalid combo of arguments" do
    where(:case_name, :emails, :enabled, :allowed_domains, :error_key) do
      "when a domain whitelist is active" | %w[test@example.com] | true | %w[other.com] | :disallowed_domains
      "when delivery is disabled" | %w[test@example.com] | false | %w[example.com] | :email_disabled
      "when provided invalid emails" | ["not-an-email"] | true | [] | :invalid_emails
    end

    with_them do
      it "fails with #{params[:error_key]}" do
        expect_calling_with(emails, enabled:, allowed_domains:).to monad_fail.with_key(error_key)
      end
    end
  end
end
