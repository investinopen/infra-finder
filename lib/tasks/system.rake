# frozen_string_literal: true

namespace :system do
  desc "Deploy the application in production. Migrate db, push assets, etc"
  task deploy: %i[environment] do
    puts "Starting deployment."

    puts "Migrating database."

    Rake::Task["db:migrate"].invoke

    puts "Pushing assets."

    Rake::Task["system:push_assets"].invoke

    puts "Deployment complete."
  end

  desc "Push pre-compiled assets to S3 / CDN"
  task push_assets: :environment do
    InfraFinder::Container["system.push_assets"].() do |m|
      m.success do
        puts "Pushed assets to S3 / DO Spaces."
      end

      m.failure do |*err|
        warn "Failed to push assets"

        warn "\t#{err.inspect}"

        exit 1
      end
    end
  end
end
