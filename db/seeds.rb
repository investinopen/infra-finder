# frozen_string_literal: true

warn "Seeding controlled vocabularies"

InfraFinder::Container["system.initial_seed"].().value!

InfraFinder::Container["oauth.sync_applications"].().value!

Shrine.logger.level = :FATAL

unless Solution.exists?
  warn "Seeding test solutions"

  InfraFinder::Container["testing.seed_test_solutions"].().value!
end
