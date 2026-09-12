# frozen_string_literal: true

RSpec.describe GoodJob do
  describe "cron entries" do
    where(:case_name, :cron, :job_class) do
      described_class.configuration.cron.map do |key, params|
        [key, params[:cron], params[:class]]
      end
    end

    with_them do
      it "has a valid cron entry" do
        expect(cron).to be_a_cron_entry
      end

      it "has a valid job class" do
        expect(job_class.constantize).to be < ActiveJob::Base
      end
    end
  end
end
