# Intake form field mapping

The `IntakeFormComponent` template (`app/components/intake_form_component/intake_form_component.html.erb`)
was written against a stale field vocabulary that no longer matches the `SolutionIntake` model
(whose attributes come from the `SolutionProperties::*` concerns). This records the reconciliation.

It happened in two parts:

1. **Name renames** — the form used stale attribute names (systematic drift).
2. **Type/binding fixes** — some renamed attributes are not plain strings (store-models,
   booleans, lists), so the input helper had to change too.

Naming drift was systematic:

- `X_url` → `X` (the property's base attribute; but see "Store-model URL binding" — `X` is a store-model, not a string)
- `other_X` → `X_other` (controlled-vocabulary free-text "other" input)
- bespoke contact/identity names → the model's real accessors

## Applied renames (40 fields)

### Contact / identity
| Form (old) | Model (new) |
| --- | --- |
| `contact_first_name` | `first_name` |
| `contact_last_name` | `last_name` |
| `contact_email` | `email` |
| `public_contact` (+ label `public_contact_information`) | `contact` |

### Registry
| Form (old) | Model (new) |
| --- | --- |
| `ror` | `research_organization_registry_url` |

### `X_url` → `X` (implementation store-models — see binding note below)
| Form (old) | Model (new) |
| --- | --- |
| `code_license_url` | `code_license` |
| `code_of_conduct_url` | `code_of_conduct` |
| `community_engagement_url` | `community_engagement` |
| `governance_records_url` | `governance_records` |
| `governance_structure_url` | `governance_structure` |
| `open_code_repository_url` | `code_repository` |
| `open_data_statement_url` | `open_data` |
| `pricing_url` | `pricing` |
| `product_roadmap_url` | `product_roadmap` |
| `technical_user_documentation_url` | `user_documentation` |
| `web_accessibility_url` | `web_accessibility` |
| `contribution_guidelines` | `contribution_pathways` |
| `financial_documentation_url` | `financial_numbers_documented_url` (plain text column — flat `text_field` is fine) |

### `other_X` → `X_other`
| Form (old) | Model (new) |
| --- | --- |
| `other_authentication_standards` | `authentication_standard_other` |
| `other_board_structure` | `board_structure_other` |
| `other_business_form` | `business_form_other` |
| `other_code_licenses` | `license_other` |
| `other_content_licenses` | `content_license_other` |
| `other_financial_reporting_level` | `financial_reporting_level_other` |
| `other_metadata_standards` | `metadata_standard_other` |
| `other_metrics_standards` | `metrics_standard_other` |
| `other_persistent_identifier_standards` | `persistent_identifier_standard_other` |
| `other_preservation_standards` | `preservation_standard_other` |
| `other_primary_funding_source` | `primary_funding_source_other` |
| `other_programming_languages` | `programming_language_other` |
| `other_security_standards` | `security_standard_other` |
| `other_user_contributions` | `user_contribution_other` |
| `other_community_engagement_activities` | `community_engagement_activity_other` |

### Misc
| Form (old) | Model (new) |
| --- | --- |
| `scoss_participation` | `scoss` (boolean — Yes/No value-mapped select; "Not sure" dropped) |
| `number_of_members` | `member_count` (integer — `number_field` correct) |
| `financial_reporting_period` | `financial_date_range` (text column — free-text "MM-YYYY to MM-YYYY", `text_field` correct) |

### Free-input list fields
These fields are `StoreModelList` arrays, but the intake form captures them as free text via the
model's `*_free_input` string accessors (the same textareas admin uses — "imported/exported via EOI").
So they bind to the free-input string and stay a `text_area`. An earlier pass wrongly pointed
`affiliations` at the `current_affiliations` *list*; corrected here.

| Form (old) | Model (new) |
| --- | --- |
| `affiliations` | `current_affiliation_free_input` |
| `founders` | `founding_institution_free_input` |
| `top_granting_institutions` | `top_granting_institution_free_input` |
| `vendor_registry_url` | `service_provider_free_input` (single link — kept as `text_field`) |

### Probable — paired with a working `_implementation` select
| Form (old) | Model (new) |
| --- | --- |
| `api_url` | `open_api` |
| `commitment_to_equity_url` | `equity_and_inclusion` |
| `commitment_to_privacy_url` | `privacy_policy` |
| `other_board_oversight` | `board_level_other` |
| `solution_name` | `name` |

## Store-model URL binding (implementation properties)

The 16 implementation properties below are **not URL strings** — each is an
`Implementations::*` store-model. The URL lives inside the model's link(s):

- **Single link** (2): `code_license`, `web_accessibility` → `X.link.url`
- **Multiple links** (14): everything else → `X.links` (array of `{ label, url }`)

A flat `f.text_field :X` binds to the whole object (rendered garbage). These are now
rendered via the `implementation_url_field(f, :X)` helper (in `IntakeFormComponent`),
which emits a `url_field` bound to the nested link:

- multi: `solution_intake[<name>_attributes][links][][url]` (one field → one-element array)
- single: `solution_intake[<name>_attributes][link][url]`

Each field's label uses `for: implementation_url_field_id(f, :X)` to stay associated.
No controller change was needed — `permit!` + `assign_attributes` routes these through
the model's `<name>_attributes=` setters.

Applied to: `code_license`, `code_of_conduct`, `code_repository`, `community_engagement`,
`contribution_pathways`, `equity_and_inclusion`, `governance_records`, `governance_structure`,
`open_api`, `open_data`, `pricing`, `privacy_policy`, `product_roadmap`, `user_documentation`,
`web_accessibility`, and `bylaws`.

**`bylaws`** was previously the orphan `community_governance_url` — its conditional fires on
`bylaws_implementation == "available"` and its label is "Link to bylaws", so it was rebound to
`implementation_url_field(f, :bylaws)`.

Conditional visibility is unaffected: the `FormFieldWrapperComponent` controller keys show/hide
off the controlling `X_implementation` select and the wrapper's `condition:` data, never the
dependent input.

## Readonly

| Field | Treatment |
| --- | --- |
| `provider_name` | Readable (delegated from `provider`) but not writable. Rendered `readonly: true, name: nil` so it displays the delegated value and is never submitted (no writer needed). Wrapper/field `required` removed. |

## Client-only (not a model attribute)

| Field | Treatment |
| --- | --- |
| `terms_and_privacy_agreement` | Consent gate, not persisted. Rendered as a top-level `check_box_tag` (no `solution_intake[...]` binding, so it never reaches `assign_attributes`). The `IntakeFormComponent` Stimulus controller disables the submit button until it's checked (`consent`/`submit` targets + `toggleSubmit`). Progressive enhancement: the checkbox keeps native `required`, so submission is gated even without JS. |

## Controlled-vocabulary association binding (id writers)

The vocab fields are **associations**, not scalar columns, so binding a select/checkbox to
the association name (e.g. `:maintenance_status`) assigns a raw string to the association and
raises `ActiveRecord::AssociationTypeMismatch` on submit. Each now binds to the association's
generated **id writer** instead:

- **Single `model` vocabs** (`has_one` through a link) → `f.select :X_id` (option value is the
  record id; the `X_id=` writer maps `""` → `nil`). Applied to: `maintenance_status`,
  `hosting_strategy`, `readiness_level`, `nonprofit_status`, `staffing_full_time`,
  `staffing_volunteer`, `board_level`, `financial_reporting_level`.
- **Multiple `model` vocabs** (`has_many` through links) → the `collection_singular_ids=` writer
  (`X_ids=`). Single-select UIs post a one-element array via an explicit `name: "…[X_ids][]"`;
  checkbox groups / typeaheads already post arrays. Applied to the `f.select` fields
  `business_forms`, `community_governances`, `board_structures`, `primary_funding_sources`,
  `web_accessibility_applicabilities`, and the group-component fields `solution_categories`,
  `programming_languages`, `content_licenses`, `licenses`, `metadata_standards`,
  `security_standards`, `authentication_standards`, `persistent_identifier_standards`,
  `preservation_standards`, `metrics_standards`, `integrations`,
  `community_engagement_activities`, `user_contributions`, `values_frameworks`.

Each field's `condition: { field: … }` and `<label for>` were renamed in lockstep so conditional
show/hide (matched by input `name`) and label association still resolve. `enum`-strategy vocabs
(the `*_implementation` selects), `countries` (`country_code`), and `currencies` (`currency`) are
plain columns and were left bound to the attribute directly.

## NOT NULL blank handling (no migration)

For a draft (`skip_validations`), the DB still rejects `NULL` on `NOT NULL` columns — `validate:
false` can't bypass a database constraint. A blank select posts `""`, which typecasts to `nil`
for booleans/enums and violates the constraint. Rather than migrate to nullable, the blank option
was removed so these fields always post a concrete value:

- **`*_implementation` enums** (15, `NOT NULL`, default `"unknown"`): dropped `include_blank` **and**
  `required: true`. `required` alone makes Rails auto-insert a phantom blank `<option value="">`,
  which would re-admit `""`; without it the select pre-selects `"Unknown"` and can only post a real
  enum value.
- **`scoss`** (`NOT NULL` boolean): value-mapped `[["Yes", true], ["No", false]]`, no `include_blank`,
  no `required`. Pre-selects `"No"` (default `false`).
- **`shareholders`** (`NOT NULL` boolean): same treatment; **"Not sure" dropped** and the options
  value-mapped to real booleans (previously `["Yes", "No", "Not sure"]` strings cast to a boolean,
  so `"No"` wrongly stored `true`).

Trade-off (accepted): blank no longer round-trips as "unanswered" — enums show `"Unknown"` and the
booleans show `"No"` on return.

**`financial_numbers_publishability`** (plain `pg_enum`: `unknown`/`not_applicable`/`unapproved`/
`approved`, default `unknown`) was a select with hardcoded `["Yes", "No"]` options. Those string
values don't match the stored enum, so it saved (via the enum's boolean alias: `Yes→approved`,
`No→unapproved`) but never pre-selected on reload — it *looked* like it wasn't saving. Now rendered
via `enum_options(:financial_numbers_publishability)` (values = enum keys, labels from the
`pg_enums` i18n scope), no `include_blank`/`required` — defaults to `"Unknown"` and round-trips.
It's the only plain `pg_enum` exposed in the form; the `*_implementation` enums bind through
`vocab_options` (whose option values already are the enum values), and `financial_information_scope`
/ `contact_method` / `state` aren't in the form.

## Date / attachment / virtual-accessor fields

A few fields aren't plain columns and needed the input rebound to the right accessor:

- **`founded_on`** (`date` column, shown as "Launch year"): was a `text_field` fed a bare year,
  which can't cast to a `Date` (`"2020"` → `nil`, silently dropped on save). Now bound to a
  `SolutionIntake#launch_year` virtual accessor (`number_field`, `min: 1960`, `max: current year`)
  that reads `founded_on&.year` and writes `Date.new(year)` (Jan 1) — matching admin's year-only
  date select (`start_year: 1960`, month/day discarded).
- **`logo`** (Shrine attachment on `logo_data` jsonb): was a `text_field` bound to `logo`, so a
  pasted URL hit Shrine's `logo=` (which `JSON.parse`s the string as cached-file data) → 500
  `JSON::ParserError`. Now a `url_field` bound to **`logo_remote_url`** (Shrine `remote_url` plugin),
  which downloads the image from the URL. **Follow-up:** `logo_remote_url` downloads synchronously on
  every save (drafts included) and only accepts image URLs. Revisit with a proper file-upload input
  (direct/presigned Shrine upload) with URL paste as a fallback.
- **`financial_date_range`** (virtual accessor → `financial_date_range_started_on` / `_ended_on`
  `date` columns): parsed by a `before_validation` callback, which `save(validate: false)` skips.
  Not a bug — the raw text persists and round-trips on drafts; the derived date columns populate on
  full submit. Noted because it's the general "callbacks don't run on `validate: false`" shape.

## Deferred type mismatches

None — resolved (see the sections above).

## Not reconciled — no matching model attribute

None — every field the template references now resolves to a real model accessor,
or is intentionally client-only (`terms_and_privacy_agreement`) or readonly (`provider_name`).
