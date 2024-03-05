# frozen_string_literal: true

Formtastic::FormBuilder.default_text_area_height = 5

Formtastic::FormBuilder.i18n_cache_lookups = !Rails.env.development?

Formtastic::FormBuilder.i18n_lookups_by_default = { hint: true, label: true }

Formtastic::FormBuilder.include_blank_for_select_by_default = false
