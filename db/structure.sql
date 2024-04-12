SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: intarray; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS intarray WITH SCHEMA public;


--
-- Name: EXTENSION intarray; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION intarray IS 'functions, operators, and index support for 1-D arrays of integers';


--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: comparison_item_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.comparison_item_state AS ENUM (
    'empty',
    'single',
    'many',
    'maxed_out'
);


--
-- Name: contact_method; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.contact_method AS ENUM (
    'unavailable',
    'email',
    'website'
);


--
-- Name: financial_information_scope; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.financial_information_scope AS ENUM (
    'unknown',
    'not_applicable',
    'project',
    'host'
);


--
-- Name: financial_numbers_applicability; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.financial_numbers_applicability AS ENUM (
    'unknown',
    'not_applicable',
    'applicable'
);


--
-- Name: financial_numbers_publishability; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.financial_numbers_publishability AS ENUM (
    'unknown',
    'not_applicable',
    'unapproved',
    'approved'
);


--
-- Name: implementation_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.implementation_status AS ENUM (
    'available',
    'in_progress',
    'considering',
    'not_planning',
    'not_applicable',
    'unknown'
);


--
-- Name: maintenance_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.maintenance_status AS ENUM (
    'active',
    'inactive',
    'unknown'
);


--
-- Name: publication; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.publication AS ENUM (
    'published',
    'unpublished'
);


--
-- Name: solution_implementation; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.solution_implementation AS ENUM (
    'bylaws',
    'code_license',
    'code_of_conduct',
    'code_repository',
    'community_engagement',
    'equity_and_inclusion',
    'governance_activities',
    'governance_structure',
    'open_api',
    'open_data',
    'product_roadmap',
    'pricing',
    'privacy_policy',
    'user_contribution_pathways',
    'user_documentation',
    'web_accessibility'
);


--
-- Name: solution_import_strategy; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.solution_import_strategy AS ENUM (
    'legacy',
    'modern'
);


--
-- Name: user_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_kind AS ENUM (
    'super_admin',
    'admin',
    'editor',
    'default',
    'anonymous'
);


--
-- Name: visibility; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.visibility AS ENUM (
    'visible',
    'hidden'
);


--
-- Name: immutable_unaccent(regdictionary, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.immutable_unaccent(regdictionary, text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    RETURN public.unaccent($1, $2);


--
-- Name: f_unaccent(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.f_unaccent(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    RETURN public.immutable_unaccent('public.unaccent'::regdictionary, $1);


--
-- Name: normalize_ransackable(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.normalize_ransackable(text) RETURNS public.citext
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    RETURN (lower(public.f_unaccent($1)))::public.citext;


--
-- Name: normalize_ransackable(public.citext); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.normalize_ransackable(public.citext) RETURNS public.citext
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    RETURN (lower(public.f_unaccent(($1)::text)))::public.citext;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_admin_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    namespace character varying,
    body text,
    resource_type character varying,
    resource_id uuid,
    author_type character varying,
    author_id uuid,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: board_structures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.board_structures (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    seed_identifier bigint,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL
);


--
-- Name: business_forms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.business_forms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    seed_identifier bigint,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL
);


--
-- Name: community_governances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community_governances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    seed_identifier bigint,
    name public.citext,
    slug public.citext,
    description text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL
);


--
-- Name: comparison_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comparison_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    comparison_id uuid NOT NULL,
    solution_id uuid NOT NULL,
    "position" bigint,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: comparison_share_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comparison_share_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    comparison_share_id uuid NOT NULL,
    solution_id uuid NOT NULL,
    "position" bigint,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: comparison_shares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comparison_shares (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    comparison_share_items_count bigint DEFAULT 0 NOT NULL,
    share_count bigint DEFAULT 0 NOT NULL,
    item_state public.comparison_item_state DEFAULT 'empty'::public.comparison_item_state NOT NULL,
    last_used_at timestamp without time zone,
    shared_at timestamp without time zone,
    fingerprint text NOT NULL,
    search_filters jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: comparisons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comparisons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ip inet,
    last_seen_at timestamp without time zone,
    session_id text NOT NULL,
    search_filters jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    comparison_items_count bigint DEFAULT 0 NOT NULL,
    item_state public.comparison_item_state DEFAULT 'empty'::public.comparison_item_state NOT NULL,
    fingerprint text
);


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendly_id_slugs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug public.citext NOT NULL,
    sluggable_type character varying NOT NULL,
    sluggable_id uuid NOT NULL,
    scope public.citext,
    created_at timestamp(6) without time zone
);


--
-- Name: good_job_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_batches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    description text,
    serialized_properties jsonb,
    on_finish text,
    on_success text,
    on_discard text,
    callback_queue_name text,
    callback_priority integer,
    enqueued_at timestamp(6) without time zone,
    discarded_at timestamp(6) without time zone,
    finished_at timestamp(6) without time zone
);


--
-- Name: good_job_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_executions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    active_job_id uuid NOT NULL,
    job_class text,
    queue_name text,
    serialized_params jsonb,
    scheduled_at timestamp(6) without time zone,
    finished_at timestamp(6) without time zone,
    error text,
    error_event smallint
);


--
-- Name: good_job_processes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_processes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    state jsonb
);


--
-- Name: good_job_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    key text,
    value jsonb
);


--
-- Name: good_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    queue_name text,
    priority integer,
    serialized_params jsonb,
    scheduled_at timestamp(6) without time zone,
    performed_at timestamp(6) without time zone,
    finished_at timestamp(6) without time zone,
    error text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    active_job_id uuid,
    concurrency_key text,
    cron_key text,
    retried_good_job_id uuid,
    cron_at timestamp(6) without time zone,
    batch_id uuid,
    batch_callback_id uuid,
    is_discrete boolean,
    executions_count integer,
    job_class text,
    error_event smallint,
    labels text[]
);


--
-- Name: hosting_strategies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hosting_strategies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    seed_identifier bigint,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL
);


--
-- Name: licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.licenses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    seed_identifier bigint,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    description text,
    url text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL
);


--
-- Name: maintenance_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.maintenance_statuses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    seed_identifier bigint,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL
);


--
-- Name: primary_funding_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.primary_funding_sources (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    seed_identifier bigint,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL
);


--
-- Name: providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    identifier public.citext DEFAULT (gen_random_uuid())::text NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    url text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    normalized_name public.citext GENERATED ALWAYS AS (public.normalize_ransackable(name)) STORED NOT NULL
);


--
-- Name: readiness_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.readiness_levels (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    seed_identifier bigint,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    resource_type character varying,
    resource_id uuid,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: snapshot_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snapshot_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    snapshot_id uuid NOT NULL,
    item_type character varying NOT NULL,
    item_id uuid NOT NULL,
    object jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    child_group_name text
);


--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snapshots (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    item_type character varying NOT NULL,
    item_id uuid NOT NULL,
    user_type character varying,
    user_id uuid,
    identifier character varying,
    metadata jsonb,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: solution_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    seed_identifier bigint,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL
);


--
-- Name: solution_category_draft_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_category_draft_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    solution_category_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_category_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_category_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    solution_category_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_licenses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    license_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_transitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_transitions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    most_recent boolean NOT NULL,
    sort_key integer NOT NULL,
    to_state character varying NOT NULL,
    metadata jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_user_contributions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_user_contributions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    user_contribution_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_drafts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_drafts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid,
    user_id uuid,
    board_structure_id uuid,
    business_form_id uuid,
    community_governance_id uuid,
    hosting_strategy_id uuid,
    maintenance_status_id uuid,
    primary_funding_source_id uuid,
    readiness_level_id uuid,
    identifier public.citext DEFAULT (gen_random_uuid())::text NOT NULL,
    contact_method public.contact_method DEFAULT 'unavailable'::public.contact_method NOT NULL,
    name public.citext NOT NULL,
    founded_on date,
    location_of_incorporation text,
    member_count bigint,
    current_staffing bigint,
    website text,
    contact text,
    research_organization_registry_url text,
    mission text,
    key_achievements text,
    organizational_history text,
    funding_needs text,
    governance_summary text,
    content_licensing text,
    special_certifications_or_statuses text,
    standards_employed text,
    registered_service_provider_description text,
    technology_dependencies text,
    integrations_and_compatibility text,
    annual_expenses bigint,
    annual_revenue bigint,
    investment_income bigint,
    other_revenue bigint,
    program_revenue bigint,
    total_assets bigint,
    total_contributions bigint,
    total_liabilities bigint,
    financial_numbers_applicability public.financial_numbers_applicability DEFAULT 'unknown'::public.financial_numbers_applicability NOT NULL,
    financial_numbers_publishability public.financial_numbers_publishability DEFAULT 'unknown'::public.financial_numbers_publishability NOT NULL,
    financial_information_scope public.financial_information_scope DEFAULT 'unknown'::public.financial_information_scope NOT NULL,
    financial_numbers_documented_url text,
    comparable_products jsonb DEFAULT '[]'::jsonb NOT NULL,
    current_affiliations jsonb DEFAULT '[]'::jsonb NOT NULL,
    founding_institutions jsonb DEFAULT '[]'::jsonb NOT NULL,
    service_providers jsonb DEFAULT '[]'::jsonb NOT NULL,
    bylaws_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    bylaws jsonb DEFAULT '{}'::jsonb NOT NULL,
    code_of_conduct_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    code_of_conduct jsonb DEFAULT '{}'::jsonb NOT NULL,
    code_repository_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    code_repository jsonb DEFAULT '{}'::jsonb NOT NULL,
    community_engagement_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    community_engagement jsonb DEFAULT '{}'::jsonb NOT NULL,
    equity_and_inclusion_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    equity_and_inclusion jsonb DEFAULT '{}'::jsonb NOT NULL,
    governance_activities_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    governance_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    governance_structure_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    governance_structure jsonb DEFAULT '{}'::jsonb NOT NULL,
    open_api_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    open_api jsonb DEFAULT '{}'::jsonb NOT NULL,
    open_data_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    open_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    product_roadmap_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    product_roadmap jsonb DEFAULT '{}'::jsonb NOT NULL,
    pricing_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    pricing jsonb DEFAULT '{}'::jsonb NOT NULL,
    privacy_policy_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    privacy_policy jsonb DEFAULT '{}'::jsonb NOT NULL,
    user_contribution_pathways_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    user_contribution_pathways jsonb DEFAULT '{}'::jsonb NOT NULL,
    user_documentation_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    user_documentation jsonb DEFAULT '{}'::jsonb NOT NULL,
    web_accessibility_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    web_accessibility jsonb DEFAULT '{}'::jsonb NOT NULL,
    logo_data jsonb,
    draft_overrides public.citext[] DEFAULT '{}'::public.citext[],
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    engagement_with_values_frameworks text,
    service_summary text,
    code_license_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    code_license jsonb DEFAULT '{}'::jsonb NOT NULL,
    recent_grants jsonb DEFAULT '[]'::jsonb NOT NULL,
    top_granting_institutions jsonb DEFAULT '[]'::jsonb NOT NULL,
    normalized_name public.citext GENERATED ALWAYS AS (public.normalize_ransackable(name)) STORED NOT NULL,
    maintenance_status public.maintenance_status DEFAULT 'unknown'::public.maintenance_status NOT NULL
);


--
-- Name: solution_editor_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_editor_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_import_transitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_import_transitions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_import_id uuid NOT NULL,
    most_recent boolean NOT NULL,
    sort_key integer NOT NULL,
    to_state character varying NOT NULL,
    metadata jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_imports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_imports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    strategy public.solution_import_strategy NOT NULL,
    started_at timestamp without time zone,
    success_at timestamp without time zone,
    failure_at timestamp without time zone,
    identifier bigint NOT NULL,
    providers_count bigint DEFAULT 0 NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    source_data jsonb NOT NULL,
    options jsonb DEFAULT '{}'::jsonb NOT NULL,
    messages jsonb DEFAULT '[]'::jsonb NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_imports_identifier_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solution_imports_identifier_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solution_imports_identifier_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solution_imports_identifier_seq OWNED BY public.solution_imports.identifier;


--
-- Name: solution_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_licenses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    license_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_user_contributions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_user_contributions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    user_contribution_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solutions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_id uuid NOT NULL,
    board_structure_id uuid,
    business_form_id uuid,
    community_governance_id uuid,
    hosting_strategy_id uuid,
    maintenance_status_id uuid,
    primary_funding_source_id uuid,
    readiness_level_id uuid,
    identifier public.citext DEFAULT (gen_random_uuid())::public.citext NOT NULL,
    contact_method public.contact_method DEFAULT 'unavailable'::public.contact_method NOT NULL,
    slug public.citext NOT NULL,
    name public.citext NOT NULL,
    founded_on date,
    location_of_incorporation text,
    member_count bigint,
    current_staffing bigint,
    website text,
    contact text,
    research_organization_registry_url text,
    mission text,
    key_achievements text,
    organizational_history text,
    funding_needs text,
    governance_summary text,
    content_licensing text,
    special_certifications_or_statuses text,
    standards_employed text,
    registered_service_provider_description text,
    technology_dependencies text,
    integrations_and_compatibility text,
    annual_expenses bigint,
    annual_revenue bigint,
    investment_income bigint,
    other_revenue bigint,
    program_revenue bigint,
    total_assets bigint,
    total_contributions bigint,
    total_liabilities bigint,
    financial_numbers_applicability public.financial_numbers_applicability DEFAULT 'unknown'::public.financial_numbers_applicability NOT NULL,
    financial_numbers_publishability public.financial_numbers_publishability DEFAULT 'unknown'::public.financial_numbers_publishability NOT NULL,
    financial_information_scope public.financial_information_scope DEFAULT 'unknown'::public.financial_information_scope NOT NULL,
    financial_numbers_documented_url text,
    comparable_products jsonb DEFAULT '[]'::jsonb NOT NULL,
    current_affiliations jsonb DEFAULT '[]'::jsonb NOT NULL,
    founding_institutions jsonb DEFAULT '[]'::jsonb NOT NULL,
    service_providers jsonb DEFAULT '[]'::jsonb NOT NULL,
    bylaws_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    bylaws jsonb DEFAULT '{}'::jsonb NOT NULL,
    code_of_conduct_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    code_of_conduct jsonb DEFAULT '{}'::jsonb NOT NULL,
    code_repository_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    code_repository jsonb DEFAULT '{}'::jsonb NOT NULL,
    community_engagement_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    community_engagement jsonb DEFAULT '{}'::jsonb NOT NULL,
    equity_and_inclusion_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    equity_and_inclusion jsonb DEFAULT '{}'::jsonb NOT NULL,
    governance_activities_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    governance_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    governance_structure_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    governance_structure jsonb DEFAULT '{}'::jsonb NOT NULL,
    open_api_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    open_api jsonb DEFAULT '{}'::jsonb NOT NULL,
    open_data_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    open_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    product_roadmap_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    product_roadmap jsonb DEFAULT '{}'::jsonb NOT NULL,
    pricing_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    pricing jsonb DEFAULT '{}'::jsonb NOT NULL,
    privacy_policy_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    privacy_policy jsonb DEFAULT '{}'::jsonb NOT NULL,
    user_contribution_pathways_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    user_contribution_pathways jsonb DEFAULT '{}'::jsonb NOT NULL,
    user_documentation_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    user_documentation jsonb DEFAULT '{}'::jsonb NOT NULL,
    web_accessibility_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    web_accessibility jsonb DEFAULT '{}'::jsonb NOT NULL,
    logo_data jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    engagement_with_values_frameworks text,
    service_summary text,
    code_license_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    code_license jsonb DEFAULT '{}'::jsonb NOT NULL,
    recent_grants jsonb DEFAULT '[]'::jsonb NOT NULL,
    top_granting_institutions jsonb DEFAULT '[]'::jsonb NOT NULL,
    normalized_name public.citext GENERATED ALWAYS AS (public.normalize_ransackable(name)) STORED NOT NULL,
    publication public.publication DEFAULT 'unpublished'::public.publication NOT NULL,
    published_at timestamp without time zone,
    maintenance_status public.maintenance_status DEFAULT 'unknown'::public.maintenance_status NOT NULL
);


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tag_id uuid,
    taggable_type character varying,
    taggable_id uuid,
    tagger_type character varying,
    tagger_id uuid,
    context text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    taggings_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: user_contributions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_contributions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    seed_identifier bigint,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    description text,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email public.citext DEFAULT ''::public.citext NOT NULL,
    encrypted_password text DEFAULT ''::text NOT NULL,
    name text NOT NULL,
    super_admin boolean DEFAULT false NOT NULL,
    reset_password_token text,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    sign_in_count bigint DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp(6) without time zone,
    last_sign_in_at timestamp(6) without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token text,
    confirmed_at timestamp(6) without time zone,
    confirmation_sent_at timestamp(6) without time zone,
    unconfirmed_email public.citext,
    failed_attempts bigint DEFAULT 0 NOT NULL,
    unlock_token text,
    locked_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    kind public.user_kind DEFAULT 'default'::public.user_kind NOT NULL
);


--
-- Name: users_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_roles (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL
);


--
-- Name: solution_imports identifier; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_imports ALTER COLUMN identifier SET DEFAULT nextval('public.solution_imports_identifier_seq'::regclass);


--
-- Name: active_admin_comments active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: board_structures board_structures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_structures
    ADD CONSTRAINT board_structures_pkey PRIMARY KEY (id);


--
-- Name: business_forms business_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_forms
    ADD CONSTRAINT business_forms_pkey PRIMARY KEY (id);


--
-- Name: community_governances community_governances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_governances
    ADD CONSTRAINT community_governances_pkey PRIMARY KEY (id);


--
-- Name: comparison_items comparison_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comparison_items
    ADD CONSTRAINT comparison_items_pkey PRIMARY KEY (id);


--
-- Name: comparison_share_items comparison_share_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comparison_share_items
    ADD CONSTRAINT comparison_share_items_pkey PRIMARY KEY (id);


--
-- Name: comparison_shares comparison_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comparison_shares
    ADD CONSTRAINT comparison_shares_pkey PRIMARY KEY (id);


--
-- Name: comparisons comparisons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comparisons
    ADD CONSTRAINT comparisons_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: good_job_batches good_job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_batches
    ADD CONSTRAINT good_job_batches_pkey PRIMARY KEY (id);


--
-- Name: good_job_executions good_job_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_executions
    ADD CONSTRAINT good_job_executions_pkey PRIMARY KEY (id);


--
-- Name: good_job_processes good_job_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_processes
    ADD CONSTRAINT good_job_processes_pkey PRIMARY KEY (id);


--
-- Name: good_job_settings good_job_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_settings
    ADD CONSTRAINT good_job_settings_pkey PRIMARY KEY (id);


--
-- Name: good_jobs good_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_jobs
    ADD CONSTRAINT good_jobs_pkey PRIMARY KEY (id);


--
-- Name: hosting_strategies hosting_strategies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hosting_strategies
    ADD CONSTRAINT hosting_strategies_pkey PRIMARY KEY (id);


--
-- Name: licenses licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.licenses
    ADD CONSTRAINT licenses_pkey PRIMARY KEY (id);


--
-- Name: maintenance_statuses maintenance_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.maintenance_statuses
    ADD CONSTRAINT maintenance_statuses_pkey PRIMARY KEY (id);


--
-- Name: primary_funding_sources primary_funding_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.primary_funding_sources
    ADD CONSTRAINT primary_funding_sources_pkey PRIMARY KEY (id);


--
-- Name: providers providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (id);


--
-- Name: readiness_levels readiness_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.readiness_levels
    ADD CONSTRAINT readiness_levels_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: snapshot_items snapshot_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshot_items
    ADD CONSTRAINT snapshot_items_pkey PRIMARY KEY (id);


--
-- Name: snapshots snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots
    ADD CONSTRAINT snapshots_pkey PRIMARY KEY (id);


--
-- Name: solution_categories solution_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_categories
    ADD CONSTRAINT solution_categories_pkey PRIMARY KEY (id);


--
-- Name: solution_category_draft_links solution_category_draft_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_category_draft_links
    ADD CONSTRAINT solution_category_draft_links_pkey PRIMARY KEY (id);


--
-- Name: solution_category_links solution_category_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_category_links
    ADD CONSTRAINT solution_category_links_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_licenses solution_draft_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_licenses
    ADD CONSTRAINT solution_draft_licenses_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_transitions solution_draft_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_transitions
    ADD CONSTRAINT solution_draft_transitions_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_user_contributions solution_draft_user_contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_user_contributions
    ADD CONSTRAINT solution_draft_user_contributions_pkey PRIMARY KEY (id);


--
-- Name: solution_drafts solution_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT solution_drafts_pkey PRIMARY KEY (id);


--
-- Name: solution_editor_assignments solution_editor_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_editor_assignments
    ADD CONSTRAINT solution_editor_assignments_pkey PRIMARY KEY (id);


--
-- Name: solution_import_transitions solution_import_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_import_transitions
    ADD CONSTRAINT solution_import_transitions_pkey PRIMARY KEY (id);


--
-- Name: solution_imports solution_imports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_imports
    ADD CONSTRAINT solution_imports_pkey PRIMARY KEY (id);


--
-- Name: solution_licenses solution_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_licenses
    ADD CONSTRAINT solution_licenses_pkey PRIMARY KEY (id);


--
-- Name: solution_user_contributions solution_user_contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_user_contributions
    ADD CONSTRAINT solution_user_contributions_pkey PRIMARY KEY (id);


--
-- Name: solutions solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT solutions_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: user_contributions user_contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contributions
    ADD CONSTRAINT user_contributions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_on_user_contribution_id_e5e19dfc8b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_user_contribution_id_e5e19dfc8b ON public.solution_draft_user_contributions USING btree (user_contribution_id);


--
-- Name: index_active_admin_comments_on_author; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_author ON public.active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_namespace ON public.active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_resource ON public.active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_board_structures_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_board_structures_on_seed_identifier ON public.board_structures USING btree (seed_identifier);


--
-- Name: index_board_structures_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_board_structures_on_slug ON public.board_structures USING btree (slug);


--
-- Name: index_business_forms_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_business_forms_on_seed_identifier ON public.business_forms USING btree (seed_identifier);


--
-- Name: index_business_forms_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_business_forms_on_slug ON public.business_forms USING btree (slug);


--
-- Name: index_comparison_items_ordering; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comparison_items_ordering ON public.comparison_items USING btree (comparison_id, "position", solution_id);


--
-- Name: index_comparison_items_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_comparison_items_uniqueness ON public.comparison_items USING btree (comparison_id, solution_id);


--
-- Name: index_comparison_share_items_ordering; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comparison_share_items_ordering ON public.comparison_share_items USING btree (comparison_share_id, "position", solution_id);


--
-- Name: index_comparison_share_items_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_comparison_share_items_uniqueness ON public.comparison_share_items USING btree (comparison_share_id, solution_id);


--
-- Name: index_comparison_shares_on_fingerprint; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_comparison_shares_on_fingerprint ON public.comparison_shares USING btree (fingerprint);


--
-- Name: index_comparison_shares_prunability; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comparison_shares_prunability ON public.comparison_shares USING btree (shared_at, last_used_at, fingerprint);


--
-- Name: index_comparisons_on_fingerprint; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comparisons_on_fingerprint ON public.comparisons USING btree (fingerprint);


--
-- Name: index_comparisons_on_last_seen_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comparisons_on_last_seen_at ON public.comparisons USING btree (last_seen_at);


--
-- Name: index_comparisons_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_comparisons_on_session_id ON public.comparisons USING btree (session_id);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON public.friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON public.friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable ON public.friendly_id_slugs USING btree (sluggable_type, sluggable_id);


--
-- Name: index_good_job_executions_on_active_job_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_executions_on_active_job_id_and_created_at ON public.good_job_executions USING btree (active_job_id, created_at);


--
-- Name: index_good_job_jobs_for_candidate_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_jobs_for_candidate_lookup ON public.good_jobs USING btree (priority, created_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_job_settings_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_good_job_settings_on_key ON public.good_job_settings USING btree (key);


--
-- Name: index_good_jobs_jobs_on_finished_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_jobs_on_finished_at ON public.good_jobs USING btree (finished_at) WHERE ((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL));


--
-- Name: index_good_jobs_jobs_on_priority_created_at_when_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_jobs_on_priority_created_at_when_unfinished ON public.good_jobs USING btree (priority DESC NULLS LAST, created_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_active_job_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_active_job_id_and_created_at ON public.good_jobs USING btree (active_job_id, created_at);


--
-- Name: index_good_jobs_on_batch_callback_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_callback_id ON public.good_jobs USING btree (batch_callback_id) WHERE (batch_callback_id IS NOT NULL);


--
-- Name: index_good_jobs_on_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_id ON public.good_jobs USING btree (batch_id) WHERE (batch_id IS NOT NULL);


--
-- Name: index_good_jobs_on_concurrency_key_when_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_concurrency_key_when_unfinished ON public.good_jobs USING btree (concurrency_key) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_cron_key_and_created_at_cond; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_cron_key_and_created_at_cond ON public.good_jobs USING btree (cron_key, created_at) WHERE (cron_key IS NOT NULL);


--
-- Name: index_good_jobs_on_cron_key_and_cron_at_cond; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_good_jobs_on_cron_key_and_cron_at_cond ON public.good_jobs USING btree (cron_key, cron_at) WHERE (cron_key IS NOT NULL);


--
-- Name: index_good_jobs_on_labels; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_labels ON public.good_jobs USING gin (labels) WHERE (labels IS NOT NULL);


--
-- Name: index_good_jobs_on_queue_name_and_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_queue_name_and_scheduled_at ON public.good_jobs USING btree (queue_name, scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_scheduled_at ON public.good_jobs USING btree (scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_hosting_strategies_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hosting_strategies_on_seed_identifier ON public.hosting_strategies USING btree (seed_identifier);


--
-- Name: index_hosting_strategies_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hosting_strategies_on_slug ON public.hosting_strategies USING btree (slug);


--
-- Name: index_licenses_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_licenses_on_seed_identifier ON public.licenses USING btree (seed_identifier);


--
-- Name: index_licenses_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_licenses_on_slug ON public.licenses USING btree (slug);


--
-- Name: index_maintenance_statuses_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_maintenance_statuses_on_seed_identifier ON public.maintenance_statuses USING btree (seed_identifier);


--
-- Name: index_maintenance_statuses_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_maintenance_statuses_on_slug ON public.maintenance_statuses USING btree (slug);


--
-- Name: index_primary_funding_sources_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_primary_funding_sources_on_seed_identifier ON public.primary_funding_sources USING btree (seed_identifier);


--
-- Name: index_primary_funding_sources_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_primary_funding_sources_on_slug ON public.primary_funding_sources USING btree (slug);


--
-- Name: index_providers_on_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_providers_on_identifier ON public.providers USING btree (identifier);


--
-- Name: index_providers_on_normalized_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_providers_on_normalized_name ON public.providers USING btree (normalized_name);


--
-- Name: index_providers_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_providers_on_slug ON public.providers USING btree (slug);


--
-- Name: index_readiness_levels_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_readiness_levels_on_seed_identifier ON public.readiness_levels USING btree (seed_identifier);


--
-- Name: index_readiness_levels_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_readiness_levels_on_slug ON public.readiness_levels USING btree (slug);


--
-- Name: index_roles_on_name_and_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_name_and_resource_type_and_resource_id ON public.roles USING btree (name, resource_type, resource_id);


--
-- Name: index_snapshot_items_on_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshot_items_on_item ON public.snapshot_items USING btree (item_type, item_id);


--
-- Name: index_snapshot_items_on_snapshot_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshot_items_on_snapshot_id ON public.snapshot_items USING btree (snapshot_id);


--
-- Name: index_snapshot_items_on_snapshot_id_and_item_id_and_item_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_snapshot_items_on_snapshot_id_and_item_id_and_item_type ON public.snapshot_items USING btree (snapshot_id, item_id, item_type);


--
-- Name: index_snapshots_on_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_identifier ON public.snapshots USING btree (identifier);


--
-- Name: index_snapshots_on_identifier_and_item_id_and_item_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_snapshots_on_identifier_and_item_id_and_item_type ON public.snapshots USING btree (identifier, item_id, item_type);


--
-- Name: index_snapshots_on_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_item ON public.snapshots USING btree (item_type, item_id);


--
-- Name: index_snapshots_on_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_user ON public.snapshots USING btree (user_type, user_id);


--
-- Name: index_solution_categories_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_categories_on_seed_identifier ON public.solution_categories USING btree (seed_identifier);


--
-- Name: index_solution_categories_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_categories_on_slug ON public.solution_categories USING btree (slug);


--
-- Name: index_solution_category_draft_links_on_solution_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_category_draft_links_on_solution_category_id ON public.solution_category_draft_links USING btree (solution_category_id);


--
-- Name: index_solution_category_draft_links_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_category_draft_links_on_solution_draft_id ON public.solution_category_draft_links USING btree (solution_draft_id);


--
-- Name: index_solution_category_draft_links_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_category_draft_links_uniqueness ON public.solution_category_draft_links USING btree (solution_draft_id, solution_category_id);


--
-- Name: index_solution_category_link_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_category_link_uniqueness ON public.solution_category_links USING btree (solution_id, solution_category_id);


--
-- Name: index_solution_category_links_on_solution_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_category_links_on_solution_category_id ON public.solution_category_links USING btree (solution_category_id);


--
-- Name: index_solution_category_links_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_category_links_on_solution_id ON public.solution_category_links USING btree (solution_id);


--
-- Name: index_solution_draft_licenses_on_license_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_licenses_on_license_id ON public.solution_draft_licenses USING btree (license_id);


--
-- Name: index_solution_draft_licenses_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_licenses_on_solution_draft_id ON public.solution_draft_licenses USING btree (solution_draft_id);


--
-- Name: index_solution_draft_licenses_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_draft_licenses_uniqueness ON public.solution_draft_licenses USING btree (solution_draft_id, license_id);


--
-- Name: index_solution_draft_transitions_parent_most_recent; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_draft_transitions_parent_most_recent ON public.solution_draft_transitions USING btree (solution_draft_id, most_recent) WHERE most_recent;


--
-- Name: index_solution_draft_transitions_parent_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_draft_transitions_parent_sort ON public.solution_draft_transitions USING btree (solution_draft_id, sort_key);


--
-- Name: index_solution_draft_user_contributions_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_user_contributions_on_solution_draft_id ON public.solution_draft_user_contributions USING btree (solution_draft_id);


--
-- Name: index_solution_draft_user_contributions_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_draft_user_contributions_uniqueness ON public.solution_draft_user_contributions USING btree (solution_draft_id, user_contribution_id);


--
-- Name: index_solution_drafts_on_board_structure_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_board_structure_id ON public.solution_drafts USING btree (board_structure_id);


--
-- Name: index_solution_drafts_on_business_form_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_business_form_id ON public.solution_drafts USING btree (business_form_id);


--
-- Name: index_solution_drafts_on_community_governance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_community_governance_id ON public.solution_drafts USING btree (community_governance_id);


--
-- Name: index_solution_drafts_on_hosting_strategy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_hosting_strategy_id ON public.solution_drafts USING btree (hosting_strategy_id);


--
-- Name: index_solution_drafts_on_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_identifier ON public.solution_drafts USING btree (identifier);


--
-- Name: index_solution_drafts_on_maintenance_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_maintenance_status ON public.solution_drafts USING btree (maintenance_status);


--
-- Name: index_solution_drafts_on_maintenance_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_maintenance_status_id ON public.solution_drafts USING btree (maintenance_status_id);


--
-- Name: index_solution_drafts_on_normalized_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_normalized_name ON public.solution_drafts USING btree (normalized_name);


--
-- Name: index_solution_drafts_on_primary_funding_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_primary_funding_source_id ON public.solution_drafts USING btree (primary_funding_source_id);


--
-- Name: index_solution_drafts_on_readiness_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_readiness_level_id ON public.solution_drafts USING btree (readiness_level_id);


--
-- Name: index_solution_drafts_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_solution_id ON public.solution_drafts USING btree (solution_id);


--
-- Name: index_solution_drafts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_user_id ON public.solution_drafts USING btree (user_id);


--
-- Name: index_solution_editor_assignments_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_editor_assignments_on_solution_id ON public.solution_editor_assignments USING btree (solution_id);


--
-- Name: index_solution_editor_assignments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_editor_assignments_on_user_id ON public.solution_editor_assignments USING btree (user_id);


--
-- Name: index_solution_editor_assignments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_editor_assignments_uniqueness ON public.solution_editor_assignments USING btree (solution_id, user_id);


--
-- Name: index_solution_import_transitions_parent_most_recent; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_import_transitions_parent_most_recent ON public.solution_import_transitions USING btree (solution_import_id, most_recent) WHERE most_recent;


--
-- Name: index_solution_import_transitions_parent_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_import_transitions_parent_sort ON public.solution_import_transitions USING btree (solution_import_id, sort_key);


--
-- Name: index_solution_imports_on_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_imports_on_identifier ON public.solution_imports USING btree (identifier);


--
-- Name: index_solution_imports_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_imports_on_user_id ON public.solution_imports USING btree (user_id);


--
-- Name: index_solution_licenses_on_license_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_licenses_on_license_id ON public.solution_licenses USING btree (license_id);


--
-- Name: index_solution_licenses_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_licenses_on_solution_id ON public.solution_licenses USING btree (solution_id);


--
-- Name: index_solution_licenses_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_licenses_uniqueness ON public.solution_licenses USING btree (solution_id, license_id);


--
-- Name: index_solution_user_contributions_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_user_contributions_on_solution_id ON public.solution_user_contributions USING btree (solution_id);


--
-- Name: index_solution_user_contributions_on_user_contribution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_user_contributions_on_user_contribution_id ON public.solution_user_contributions USING btree (user_contribution_id);


--
-- Name: index_solution_user_contributions_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_user_contributions_uniqueness ON public.solution_user_contributions USING btree (solution_id, user_contribution_id);


--
-- Name: index_solutions_on_board_structure_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_board_structure_id ON public.solutions USING btree (board_structure_id);


--
-- Name: index_solutions_on_business_form_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_business_form_id ON public.solutions USING btree (business_form_id);


--
-- Name: index_solutions_on_community_governance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_community_governance_id ON public.solutions USING btree (community_governance_id);


--
-- Name: index_solutions_on_hosting_strategy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_hosting_strategy_id ON public.solutions USING btree (hosting_strategy_id);


--
-- Name: index_solutions_on_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solutions_on_identifier ON public.solutions USING btree (identifier);


--
-- Name: index_solutions_on_maintenance_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_maintenance_status ON public.solutions USING btree (maintenance_status);


--
-- Name: index_solutions_on_maintenance_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_maintenance_status_id ON public.solutions USING btree (maintenance_status_id);


--
-- Name: index_solutions_on_normalized_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_normalized_name ON public.solutions USING btree (normalized_name);


--
-- Name: index_solutions_on_primary_funding_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_primary_funding_source_id ON public.solutions USING btree (primary_funding_source_id);


--
-- Name: index_solutions_on_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_provider_id ON public.solutions USING btree (provider_id);


--
-- Name: index_solutions_on_publication; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_publication ON public.solutions USING btree (publication);


--
-- Name: index_solutions_on_readiness_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_readiness_level_id ON public.solutions USING btree (readiness_level_id);


--
-- Name: index_solutions_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solutions_on_slug ON public.solutions USING btree (slug);


--
-- Name: index_taggings_on_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_context ON public.taggings USING btree (context);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tag_id ON public.taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_type_and_taggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_type_and_taggable_id ON public.taggings USING btree (taggable_type, taggable_id);


--
-- Name: index_taggings_on_tagger_type_and_tagger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tagger_type_and_tagger_id ON public.taggings USING btree (tagger_type, tagger_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_user_contributions_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_contributions_on_seed_identifier ON public.user_contributions USING btree (seed_identifier);


--
-- Name: index_user_contributions_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_contributions_on_slug ON public.user_contributions USING btree (slug);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_kind; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_kind ON public.users USING btree (kind);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: index_users_roles_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_roles_on_role_id ON public.users_roles USING btree (role_id);


--
-- Name: index_users_roles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_roles_on_user_id ON public.users_roles USING btree (user_id);


--
-- Name: index_users_roles_on_user_id_and_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_roles_on_user_id_and_role_id ON public.users_roles USING btree (user_id, role_id);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: taggings_idy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggings_idy ON public.taggings USING btree (taggable_id, taggable_type, tagger_id, context);


--
-- Name: taggings_taggable_content_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggings_taggable_content_idx ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: solution_category_links fk_rails_0ca6b07585; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_category_links
    ADD CONSTRAINT fk_rails_0ca6b07585 FOREIGN KEY (solution_category_id) REFERENCES public.solution_categories(id) ON DELETE CASCADE;


--
-- Name: solution_import_transitions fk_rails_14d9b58b8e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_import_transitions
    ADD CONSTRAINT fk_rails_14d9b58b8e FOREIGN KEY (solution_import_id) REFERENCES public.solution_imports(id) ON DELETE CASCADE;


--
-- Name: solution_category_draft_links fk_rails_16e9f886f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_category_draft_links
    ADD CONSTRAINT fk_rails_16e9f886f1 FOREIGN KEY (solution_category_id) REFERENCES public.solution_categories(id) ON DELETE CASCADE;


--
-- Name: solution_category_links fk_rails_1be6c1a9bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_category_links
    ADD CONSTRAINT fk_rails_1be6c1a9bc FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solutions fk_rails_25e1f3faa1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_25e1f3faa1 FOREIGN KEY (community_governance_id) REFERENCES public.community_governances(id) ON DELETE RESTRICT;


--
-- Name: solution_editor_assignments fk_rails_2a45cfef5e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_editor_assignments
    ADD CONSTRAINT fk_rails_2a45cfef5e FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE RESTRICT;


--
-- Name: solution_drafts fk_rails_2eda529d66; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_2eda529d66 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: solution_user_contributions fk_rails_4195bf7ce7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_user_contributions
    ADD CONSTRAINT fk_rails_4195bf7ce7 FOREIGN KEY (user_contribution_id) REFERENCES public.user_contributions(id) ON DELETE CASCADE;


--
-- Name: solution_user_contributions fk_rails_4642c0eaf4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_user_contributions
    ADD CONSTRAINT fk_rails_4642c0eaf4 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_496e0d601c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_496e0d601c FOREIGN KEY (community_governance_id) REFERENCES public.community_governances(id) ON DELETE RESTRICT;


--
-- Name: users_roles fk_rails_4a41696df6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT fk_rails_4a41696df6 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: solutions fk_rails_522f0b764c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_522f0b764c FOREIGN KEY (readiness_level_id) REFERENCES public.readiness_levels(id) ON DELETE RESTRICT;


--
-- Name: solution_drafts fk_rails_57b1e3753d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_57b1e3753d FOREIGN KEY (primary_funding_source_id) REFERENCES public.primary_funding_sources(id) ON DELETE RESTRICT;


--
-- Name: solutions fk_rails_57bffcae2d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_57bffcae2d FOREIGN KEY (hosting_strategy_id) REFERENCES public.hosting_strategies(id) ON DELETE RESTRICT;


--
-- Name: solution_licenses fk_rails_5a0b4e7775; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_licenses
    ADD CONSTRAINT fk_rails_5a0b4e7775 FOREIGN KEY (license_id) REFERENCES public.licenses(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_5b8c678d1e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_5b8c678d1e FOREIGN KEY (readiness_level_id) REFERENCES public.readiness_levels(id) ON DELETE RESTRICT;


--
-- Name: solution_category_draft_links fk_rails_733215f1ae; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_category_draft_links
    ADD CONSTRAINT fk_rails_733215f1ae FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solutions fk_rails_73c7b0a3ae; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_73c7b0a3ae FOREIGN KEY (maintenance_status_id) REFERENCES public.maintenance_statuses(id) ON DELETE RESTRICT;


--
-- Name: solution_imports fk_rails_7928c4b4bd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_imports
    ADD CONSTRAINT fk_rails_7928c4b4bd FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: solution_editor_assignments fk_rails_7a2dd1903d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_editor_assignments
    ADD CONSTRAINT fk_rails_7a2dd1903d FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: solution_draft_licenses fk_rails_7e7ad198c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_licenses
    ADD CONSTRAINT fk_rails_7e7ad198c7 FOREIGN KEY (license_id) REFERENCES public.licenses(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_7e91bf84ef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_7e91bf84ef FOREIGN KEY (maintenance_status_id) REFERENCES public.maintenance_statuses(id) ON DELETE RESTRICT;


--
-- Name: comparison_share_items fk_rails_7fdf8277aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comparison_share_items
    ADD CONSTRAINT fk_rails_7fdf8277aa FOREIGN KEY (comparison_share_id) REFERENCES public.comparison_shares(id) ON DELETE CASCADE;


--
-- Name: solutions fk_rails_84c054e1eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_84c054e1eb FOREIGN KEY (provider_id) REFERENCES public.providers(id) ON DELETE RESTRICT;


--
-- Name: solution_draft_transitions fk_rails_8d1bd9f228; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_transitions
    ADD CONSTRAINT fk_rails_8d1bd9f228 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: comparison_share_items fk_rails_9df2127bc4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comparison_share_items
    ADD CONSTRAINT fk_rails_9df2127bc4 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: taggings fk_rails_9fcd2e236b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT fk_rails_9fcd2e236b FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_a937b670c8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_a937b670c8 FOREIGN KEY (business_form_id) REFERENCES public.business_forms(id) ON DELETE RESTRICT;


--
-- Name: comparison_items fk_rails_b0877dc5c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comparison_items
    ADD CONSTRAINT fk_rails_b0877dc5c7 FOREIGN KEY (comparison_id) REFERENCES public.comparisons(id) ON DELETE CASCADE;


--
-- Name: solution_draft_user_contributions fk_rails_b604ad2471; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_user_contributions
    ADD CONSTRAINT fk_rails_b604ad2471 FOREIGN KEY (user_contribution_id) REFERENCES public.user_contributions(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_bf7a540f25; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_bf7a540f25 FOREIGN KEY (hosting_strategy_id) REFERENCES public.hosting_strategies(id) ON DELETE RESTRICT;


--
-- Name: solutions fk_rails_c3189e0953; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_c3189e0953 FOREIGN KEY (board_structure_id) REFERENCES public.board_structures(id) ON DELETE RESTRICT;


--
-- Name: solutions fk_rails_c35caf4647; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_c35caf4647 FOREIGN KEY (business_form_id) REFERENCES public.business_forms(id) ON DELETE RESTRICT;


--
-- Name: solution_draft_user_contributions fk_rails_c74d8d1a1b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_user_contributions
    ADD CONSTRAINT fk_rails_c74d8d1a1b FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_d15fd7352a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_d15fd7352a FOREIGN KEY (board_structure_id) REFERENCES public.board_structures(id) ON DELETE RESTRICT;


--
-- Name: solution_drafts fk_rails_d1df87d0d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_d1df87d0d1 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE SET NULL;


--
-- Name: comparison_items fk_rails_d4c511baf3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comparison_items
    ADD CONSTRAINT fk_rails_d4c511baf3 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solutions fk_rails_d7b00384c2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_d7b00384c2 FOREIGN KEY (primary_funding_source_id) REFERENCES public.primary_funding_sources(id) ON DELETE RESTRICT;


--
-- Name: solution_draft_licenses fk_rails_dfcfc51119; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_licenses
    ADD CONSTRAINT fk_rails_dfcfc51119 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_licenses fk_rails_e892108205; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_licenses
    ADD CONSTRAINT fk_rails_e892108205 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: users_roles fk_rails_eb7b4658f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT fk_rails_eb7b4658f8 FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240412195958'),
('20240411211514'),
('20240411164445'),
('20240410175652'),
('20240410175613'),
('20240409183241'),
('20240409174440'),
('20240408175528'),
('20240325215622'),
('20240325214531'),
('20240322084261'),
('20240322084260'),
('20240322084259'),
('20240322084258'),
('20240322084257'),
('20240322084256'),
('20240322084255'),
('20240322084254'),
('20240322084253'),
('20240322084252'),
('20240306012508'),
('20240306012426'),
('20240304235024'),
('20240304210653'),
('20240304205557'),
('20240227190134'),
('20240223210705'),
('20240223201239'),
('20240223144805'),
('20240216195932'),
('20240216195921'),
('20240216195340'),
('20240216195324'),
('20240216192554'),
('20240216192532'),
('20240213195001'),
('20240213191612'),
('20240213191444'),
('20240213190951'),
('20240213190313'),
('20240209213500'),
('20240209204728'),
('20240209204641'),
('20240209203818'),
('20240209200649'),
('20240209195844'),
('20240209195830'),
('20240209195349'),
('20240209195118'),
('20240209192809'),
('20240209191746'),
('20240209191508'),
('20240209191151'),
('20240209190455'),
('20240209190200'),
('20240209190109'),
('20240208223202');

