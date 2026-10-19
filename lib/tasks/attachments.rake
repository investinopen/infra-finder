# frozen_string_literal: true

namespace :attachments do
  desc "Regenerate the derivatives of every stored solution, draft, and intake logo"
  task regenerate_logo_derivatives: :environment do
    [Solution, SolutionDraft, SolutionIntake].each do |model|
      model.with_stored_logo.find_each do |record|
        Processing::RegenerateDerivativesJob.perform_later(record, "logo")
      end
    end
  end
end
