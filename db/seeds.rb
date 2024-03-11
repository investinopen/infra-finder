# frozen_string_literal: true

warn "Seeding options"
InfraFinder::Container["system.initial_seed"].().value!

Shrine.logger.level = :FATAL

warn "Seeding legacy solutions"
InfraFinder::Container["seeding.import_legacy_solutions"].().value!
