# frozen_string_literal: true

RSpec.describe Emails::Intercept do
  include Dry::Monads[:result]

  let(:allow_emails) { instance_double(Emails::Allow) }

  subject(:interceptor) { described_class.new(allow_emails:) }

  let(:mail) { instance_double(Mail::Message, to: ["example.com"]) }

  before do
    allow(mail).to receive(:perform_deliveries=)
  end

  describe "#delivering_email" do
    context "when delivery is allowed" do
      before do
        allow(allow_emails).to receive(:call).with(mail.to).and_return(Success())
      end

      it "allows delivery" do
        expect do
          interceptor.delivering_email(mail)
        end.to execute_safely

        expect(mail).to have_received(:perform_deliveries=).with(true)
      end
    end

    context "when delivery is not allowed" do
      before do
        allow(allow_emails).to receive(:call).with(mail.to).and_return(Failure(:disabled))
      end

      it "disables delivery" do
        expect do
          interceptor.delivering_email(mail)
        end.to execute_safely

        expect(mail).to have_received(:perform_deliveries=).with(false)
      end
    end
  end
end
