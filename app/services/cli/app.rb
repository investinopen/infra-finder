# frozen_string_literal: true

module CLI
  module App
    extend Dry::CLI::Registry

    register "users" do |prefix|
      prefix.register "add-super-admin", CLI::Commands::Users::AddSuperAdmin
    end

    register "version", CLI::Commands::Version, aliases: ["--version"]
  end
end
