# frozen_string_literal: true

require "stimulus/manifest"

module Patches
  module ImproveStimulusManifests
    SANS_SEMICOLON = /(?<!;)\z/

    # @param
    def extract_controllers_from(...)
      super.reject do |path|
        path.basename.fnmatch(".*")
      end
    end

    def generate_from(...)
      manifest = super

      imports, registrations = manifest.flat_map do |line|
        line.split("\n").compact_blank.map { _1.sub(SANS_SEMICOLON, ?;) }
      end.partition { _1.start_with? "import " }

      [*imports, "\n", *registrations]
    end
  end
end

Stimulus::Manifest.singleton_class.prepend Patches::ImproveStimulusManifests
