# Intake Form → Controlled Vocabulary Mapping

Cross-reference of the JotForm we're rebuilding
([form.jotform.com/241292497201050](https://form.jotform.com/241292497201050)) against the
choice-based data sources already in this app.

## Background: existing choice sources

The app already has a rich system for controlled choices:

- **`ControlledVocabulary`** — a FrozenRecord registry (backed by
  `lib/frozen_record/controlled_vocabularies.yml`) with 29 named vocabularies. Each has a
  `strategy`: `countries`, `currencies`, `enum` (inline mapping), or `model` (DB-backed table).
- **`model`-strategy vocabularies** are backed by `ControlledVocabularyRecord` models
  (`SolutionCategory`, `License`, `Integration`, etc.), seeded from the YAML `terms:` via
  `System::InitialSeed`. Extending one = add `terms:` to the YAML + re-seed (no schema change).
- **`enum`-strategy vocabularies** (`impl_scale`, `impl_scale_pricing`) are Postgres enum types.
- The definitive field→vocabulary wiring for solutions lives in
  `lib/frozen_record/solution_properties.yml` — check there for the exact vocab each property
  expects before building anything new.
- Countries come from the `countries` gem (`ISO3166::Country`); currencies from the `money` gem
  (`Money::Currency.all`). No local list.

Status legend: ✓ have it · ⚠️ extend / reconcile · ✗ net-new

## A. Status-scale single-selects → shared `impl_scale` enum ✓

All use the identical "Not planning / Considering / In progress / Implemented/available /
(Not applicable) / Unknown" scale, which already exists as the `impl_scale` vocabulary
(Postgres enum `implementation_status`). No new vocab needed for any of them.

| Field | Type | Existing source | Status |
|---|---|---|---|
| Open code repository | select | `impl_scale` | ✓ have it |
| Technical documentation | select | `impl_scale` | ✓ |
| Open product roadmap | select | `impl_scale` | ✓ |
| Open APIs | select | `impl_scale` | ✓ |
| Open data statement | select | `impl_scale` | ✓ |
| Open code license | select | `impl_scale` | ✓ |
| Code of conduct | select | `impl_scale` | ✓ |
| Commitment to community engagement | select | `impl_scale` | ✓ |
| Bylaws | select | `impl_scale` | ✓ |
| Commitment to equity and inclusion | select | `impl_scale` | ✓ |
| Privacy policy | select | `impl_scale` | ✓ |
| Web accessibility | select | `impl_scale` | ✓ |
| Governance records | select | `impl_scale` | ✓ |
| Governance structure | select | `impl_scale` | ✓ |
| Transparent pricing | select | `impl_scale_pricing` (adds "No direct costs") | ✓ |

## B. Other single-select dropdowns

| Field | Options (form) | Existing source | Status |
|---|---|---|---|
| Location | ~195 countries | `countries` (ISO3166 gem) | ✓ have it |
| Currency | ~180 ISO codes | `currencies` (Money gem) | ✓ |
| Maintenance status | 4 | `maint` / `MaintenanceStatus` | ✓ |
| Technology readiness level | 5 | `tech_read` / `ReadinessLevel` | ✓ |
| Hosting/SaaS options | 5 | `saas` / `HostingStrategy` | ✓ |
| Web accessibility applicability | 2 | `acc_scope` / `AccessibilityScope` | ✓ |
| Business form | 8 | `bus_form` / `BusinessForm` | ✓ |
| Staff (FTE) | 6 | `staffing` / `Staffing` | ✓ |
| Volunteers | 6 | `staffing` / `Staffing` (reuse) | ✓ |
| Community governance type | 3 | `gov_stat` / `CommunityGovernance` | ✓ |
| Board structure | 4 | `board` / `BoardStructure` | ✓ |
| Primary funding source | 3 | `pr_fund` / `PrimaryFundingSource` | ✓ |
| **Non-profit status** | 23 | `nonprofit_status` (20) | ⚠️ **extend** — form adds 501(c)4, e.V., Stichting ×2, Other, None |
| **Board oversight level** | Provider/**Solution**/Both/Other | `rprt_lvl` / `ReportingLevel` (Provider/**Host**/Both/Other) | ⚠️ label mismatch — "Host" vs "Solution" |
| **Financial reporting level** | Provider/**Solution**/Both/Other | `rprt_lvl` / `ReportingLevel` | ⚠️ same mismatch |
| **SCOSS participation** | Yes/No/Not sure | — | ✗ **net-new** |
| **Shareholders** | Yes/No/Not sure | — | ✗ **net-new** |
| **Permission to share financials** | Yes/No | related: `financial_numbers_publishability` enum (unknown/not_applicable/unapproved/approved) | ⚠️ related, not clean Yes/No |

## C. Multi-select / checkbox groups

| Field | Options (form) | Existing source | Status |
|---|---|---|---|
| Primary programming languages | 19 | `prgrm_lng` / `ProgrammingLanguage` | ✓ have it (exact match) |
| Content licenses | 4 | `cont_lcns` / `ContentLicense` | ✓ |
| Code license types | 7 | `code_lcns` / `License` | ✓ |
| Persistent identifiers | 4 | `standards_pids` | ✓ |
| Authentication protocols | 6 | `standards_auth` | ✓ |
| Security standards | 8 | `standards_sec` | ✓ |
| Preservation standards | 3 | `standards_pres` ("OCF"≈"OCFL") | ✓ |
| Metrics reporting | 4 | `standards_metrics` | ✓ |
| Community engagement activities | 13 | `comm_eng` | ✓ |
| Metadata/markup standards | ~38 | `standards_metadata` (~37) | ✓ (verify a couple of labels) |
| **User contribution opportunities** | 10 | `user_paths` (9) | ⚠️ **extend** — form adds "Unknown" |
| **Values frameworks** | 14 | `values` (12) | ⚠️ **extend** — form adds "Open Source Software Sustainability toolkit" + Humetics split |
| **Solution category** | 36 | `soln_cat` (23) | ⚠️ **extend** — 13 new (ILS/LSP, computing library/framework, digital preservation service/system/tool, web archiving service/system, geospatial, research software community, etc.) |
| **Integrations and compatibility** | ~150 | `integrations` (~60) | ⚠️ **big extend** — form roughly doubles the list |

## Summary

- **Already have it, no work (28 fields):** the entire status-scale group (A), plus countries,
  currencies, maintenance, TRL, SaaS, accessibility scope, business form, staffing (×2),
  governance type, board structure, primary funding source, and 10 of the
  standards/licenses/languages/engagement checkbox groups.
- **Extend an existing vocab (5):** Non-profit status, User contribution opportunities, Values
  frameworks, Solution category, Integrations. All `model`-strategy vocabs, so extending = add
  `terms:` to `lib/frozen_record/controlled_vocabularies.yml` and re-seed — no schema change.
- **Reconcile a label (2):** Board oversight level & Financial reporting level want "Solution"
  where `ReportingLevel` says "Host". Decide whether to rename the term or add one.
- **Genuinely net-new (2–3):** SCOSS participation and Shareholders (both Yes/No/Not sure — could
  share one small vocab); Permission to share financials overlaps the existing
  `financial_numbers_publishability` enum but isn't a clean Yes/No.

### Caveats

- Several form field *labels* differ cosmetically from stored term labels (e.g. "OCF" vs "OCFL").
  Matches here are on meaning — diff the extend-candidates carefully before seeding.
- Option counts for gem-sourced lists (countries, currencies) and large checkbox groups are
  approximate.
