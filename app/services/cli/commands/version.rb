# frozen_string_literal: true

module CLI
  module Commands
    class Version < ::CLI::Commands::AbstractCommand
      desc "Show the current version of the API"

      def perform!(**)
        puts "InfraFinder #{InfraFinder::Version}"
      end
    end
  end
end
