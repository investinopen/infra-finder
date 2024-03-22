# frozen_string_literal: true

require "i18n"
require "dry/core/class_builder"
require "dry/core/equalizer"
require "dry/core/memoizable"
require "dry/matcher/result_matcher"
require "dry/monads/all"
require "dry/schema"
require "dry/types"
require "dry/validation"
require "vips"

Anyway::Settings.future.use :unwrap_known_environments

Anyway::Settings.known_environments << "staging"

FrozenRecord::Base.base_path = Pathname(__dir__).join("..", "..", "frozen_record").realpath
