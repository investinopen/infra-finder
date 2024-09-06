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
-- Name: fooble; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.fooble AS ENUM (
    'hello my darling',
    'hello my honey'
);


--
-- Name: implementation_name; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.implementation_name AS ENUM (
    'bylaws',
    'code_license',
    'code_of_conduct',
    'code_repository',
    'community_engagement',
    'equity_and_inclusion',
    'governance_records',
    'governance_structure',
    'open_api',
    'open_data',
    'product_roadmap',
    'pricing',
    'privacy_policy',
    'contribution_pathways',
    'user_documentation',
    'web_accessibility'
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
-- Name: pricing_implementation_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.pricing_implementation_status AS ENUM (
    'available',
    'in_progress',
    'considering',
    'not_planning',
    'no_direct_costs',
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
-- Name: solution_data_version; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.solution_data_version AS ENUM (
    'v2',
    'unknown'
);


--
-- Name: solution_import_strategy; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.solution_import_strategy AS ENUM (
    'legacy',
    'eoi',
    'v2'
);


--
-- Name: solution_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.solution_kind AS ENUM (
    'actual',
    'draft'
);


--
-- Name: solution_revision_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.solution_revision_kind AS ENUM (
    'initial',
    'direct',
    'draft',
    'import',
    'other'
);


--
-- Name: solution_revision_provider_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.solution_revision_provider_state AS ENUM (
    'same',
    'initial',
    'diff'
);


--
-- Name: subscription; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.subscription AS ENUM (
    'subscribed',
    'unsubscribed'
);


--
-- Name: subscription_kind; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.subscription_kind AS ENUM (
    'comment_notifications',
    'solution_notifications',
    'reminder_notifications'
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
-- Name: calculate_staffing_range(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_staffing_range(min_value integer, max_value integer) RETURNS int4range
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $_$
SELECT CASE
WHEN $1 IS NOT NULL OR $2 IS NOT NULL THEN int4range($1, $2, '[)')
ELSE
  NULL
END;
$_$;


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
-- Name: is_solution_revision_snapshot(text, jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_solution_revision_snapshot(text, jsonb) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$
SELECT
  $1 = 'Solution'
  AND
  $2 ? 'kind'
  AND
  $2 ? 'diffs'
  AND
  $2 ? 'revision'
;
$_$;


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


--
-- Name: parse_solution_data_version(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.parse_solution_data_version(text) RETURNS public.solution_data_version
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $_$
SELECT
CASE $1
WHEN 'v2' THEN 'v2'::public.solution_data_version
ELSE
  'unknown'::public.solution_data_version
END;
$_$;


--
-- Name: parse_solution_revision_kind(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.parse_solution_revision_kind(text) RETURNS public.solution_revision_kind
    LANGUAGE sql IMMUTABLE PARALLEL SAFE
    AS $_$
SELECT
CASE $1
WHEN 'direct' THEN 'direct'::public.solution_revision_kind
WHEN 'draft' THEN 'draft'::public.solution_revision_kind
WHEN 'initial' THEN 'initial'::public.solution_revision_kind
WHEN 'import' THEN 'import'::public.solution_revision_kind
ELSE
  'other'::public.solution_revision_kind
END;
$_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accessibility_scopes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accessibility_scopes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


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
-- Name: authentication_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authentication_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
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
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    term public.citext NOT NULL,
    enforced_slug public.citext,
    provides public.citext
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
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    term public.citext NOT NULL,
    enforced_slug public.citext,
    provides public.citext
);


--
-- Name: community_engagement_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community_engagement_activities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    term public.citext NOT NULL,
    enforced_slug public.citext,
    provides public.citext
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
-- Name: content_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_licenses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    term public.citext NOT NULL,
    enforced_slug public.citext,
    provides public.citext
);


--
-- Name: integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.integrations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: invitation_transitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invitation_transitions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    invitation_id uuid NOT NULL,
    most_recent boolean NOT NULL,
    sort_key integer NOT NULL,
    to_state character varying NOT NULL,
    metadata jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invitations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_id uuid NOT NULL,
    admin_id uuid,
    user_id uuid,
    email public.citext NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    memo text,
    notification_sent_at timestamp without time zone,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    term public.citext NOT NULL,
    enforced_slug public.citext,
    provides public.citext
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
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    term public.citext NOT NULL,
    enforced_slug public.citext,
    provides public.citext
);


--
-- Name: metadata_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metadata_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: metrics_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metrics_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: nonprofit_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nonprofit_statuses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: persistent_identifier_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.persistent_identifier_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: preservation_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.preservation_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    term public.citext NOT NULL,
    enforced_slug public.citext,
    provides public.citext
);


--
-- Name: programming_languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programming_languages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: provider_editor_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provider_editor_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    term public.citext NOT NULL,
    enforced_slug public.citext,
    provides public.citext
);


--
-- Name: reporting_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reporting_levels (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
-- Name: security_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.security_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
    created_at timestamp(6) without time zone NOT NULL,
    solution_revision_kind public.solution_revision_kind GENERATED ALWAYS AS (public.parse_solution_revision_kind((metadata ->> 'kind'::text))) STORED NOT NULL,
    solution_revision_snapshot boolean GENERATED ALWAYS AS (public.is_solution_revision_snapshot((item_type)::text, metadata)) STORED NOT NULL
);


--
-- Name: solution_accessibility_scopes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_accessibility_scopes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    accessibility_scope_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_authentication_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_authentication_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    authentication_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_board_structures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_board_structures (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    board_structure_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_business_forms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_business_forms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    business_form_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    term public.citext NOT NULL,
    enforced_slug public.citext,
    provides public.citext
);


--
-- Name: solution_category_draft_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_category_draft_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    solution_category_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL
);


--
-- Name: solution_category_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_category_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    solution_category_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL
);


--
-- Name: solution_community_engagement_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_community_engagement_activities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    community_engagement_activity_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_community_governances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_community_governances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    community_governance_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_content_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_content_licenses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    content_license_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_accessibility_scopes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_accessibility_scopes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    accessibility_scope_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_authentication_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_authentication_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    authentication_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_board_structures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_board_structures (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    board_structure_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_business_forms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_business_forms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    business_form_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_community_engagement_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_community_engagement_activities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    community_engagement_activity_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_community_governances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_community_governances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    community_governance_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_content_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_content_licenses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    content_license_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_hosting_strategies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_hosting_strategies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    hosting_strategy_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_integrations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    integration_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
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
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL
);


--
-- Name: solution_draft_maintenance_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_maintenance_statuses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    maintenance_status_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_metadata_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_metadata_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    metadata_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_metrics_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_metrics_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    metrics_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_nonprofit_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_nonprofit_statuses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    nonprofit_status_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_persistent_identifier_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_persistent_identifier_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    persistent_identifier_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_preservation_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_preservation_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    preservation_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_primary_funding_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_primary_funding_sources (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    primary_funding_source_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_programming_languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_programming_languages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    programming_language_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_readiness_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_readiness_levels (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    readiness_level_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_reporting_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_reporting_levels (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    reporting_level_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_security_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_security_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    security_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_draft_staffings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_staffings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    staffing_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
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
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL
);


--
-- Name: solution_draft_values_frameworks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_draft_values_frameworks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_draft_id uuid NOT NULL,
    values_framework_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
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
    phase_1_board_structure_id uuid,
    phase_1_business_form_id uuid,
    phase_1_community_governance_id uuid,
    phase_1_hosting_strategy_id uuid,
    phase_1_maintenance_status_id uuid,
    phase_1_primary_funding_source_id uuid,
    phase_1_readiness_level_id uuid,
    identifier public.citext DEFAULT (gen_random_uuid())::text NOT NULL,
    contact_method public.contact_method DEFAULT 'unavailable'::public.contact_method NOT NULL,
    name public.citext NOT NULL,
    founded_on date,
    phase_1_location_of_incorporation text,
    member_count bigint,
    current_staffing numeric(19,2),
    website text,
    contact text,
    research_organization_registry_url text,
    mission text,
    key_achievements text,
    organizational_history text,
    funding_needs text,
    governance_summary text,
    phase_1_content_licensing text,
    phase_1_special_certifications_or_statuses text,
    phase_1_standards_employed text,
    phase_1_registered_service_provider_description text,
    phase_1_technology_dependencies text,
    phase_1_integrations_and_compatibility text,
    phase_1_annual_expenses bigint,
    phase_1_annual_revenue bigint,
    phase_1_investment_income bigint,
    phase_1_other_revenue bigint,
    phase_1_program_revenue bigint,
    phase_1_total_assets bigint,
    phase_1_total_contributions bigint,
    phase_1_total_liabilities bigint,
    phase_1_financial_numbers_applicability public.financial_numbers_applicability DEFAULT 'unknown'::public.financial_numbers_applicability NOT NULL,
    financial_numbers_publishability public.financial_numbers_publishability DEFAULT 'unknown'::public.financial_numbers_publishability NOT NULL,
    financial_information_scope public.financial_information_scope DEFAULT 'unknown'::public.financial_information_scope NOT NULL,
    financial_numbers_documented_url text,
    phase_1_comparable_products jsonb DEFAULT '[]'::jsonb NOT NULL,
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
    governance_records_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    governance_records jsonb DEFAULT '{}'::jsonb NOT NULL,
    governance_structure_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    governance_structure jsonb DEFAULT '{}'::jsonb NOT NULL,
    open_api_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    open_api jsonb DEFAULT '{}'::jsonb NOT NULL,
    open_data_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    open_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    product_roadmap_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    product_roadmap jsonb DEFAULT '{}'::jsonb NOT NULL,
    pricing_implementation public.pricing_implementation_status DEFAULT 'unknown'::public.pricing_implementation_status NOT NULL,
    pricing jsonb DEFAULT '{}'::jsonb NOT NULL,
    privacy_policy_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    privacy_policy jsonb DEFAULT '{}'::jsonb NOT NULL,
    contribution_pathways_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    contribution_pathways jsonb DEFAULT '{}'::jsonb NOT NULL,
    user_documentation_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    user_documentation jsonb DEFAULT '{}'::jsonb NOT NULL,
    web_accessibility_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    web_accessibility jsonb DEFAULT '{}'::jsonb NOT NULL,
    logo_data jsonb,
    draft_overrides public.citext[] DEFAULT '{}'::public.citext[],
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    phase_1_engagement_with_values_frameworks text,
    service_summary text,
    code_license_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    code_license jsonb DEFAULT '{}'::jsonb NOT NULL,
    recent_grants jsonb DEFAULT '[]'::jsonb NOT NULL,
    top_granting_institutions jsonb DEFAULT '[]'::jsonb NOT NULL,
    normalized_name public.citext GENERATED ALWAYS AS (public.normalize_ransackable(name)) STORED NOT NULL,
    phase_1_maintenance_status public.maintenance_status DEFAULT 'unknown'::public.maintenance_status NOT NULL,
    country_code public.citext,
    currency public.citext DEFAULT 'USD'::public.citext NOT NULL,
    annual_expenses_cents bigint DEFAULT 0 NOT NULL,
    annual_revenue_cents bigint DEFAULT 0 NOT NULL,
    investment_income_cents bigint DEFAULT 0 NOT NULL,
    other_revenue_cents bigint DEFAULT 0 NOT NULL,
    program_revenue_cents bigint DEFAULT 0 NOT NULL,
    total_assets_cents bigint DEFAULT 0 NOT NULL,
    total_contributions_cents bigint DEFAULT 0 NOT NULL,
    total_liabilities_cents bigint DEFAULT 0 NOT NULL,
    board_members_url text,
    financial_date_range text,
    financial_date_range_started_on date,
    financial_date_range_ended_on date,
    membership_program_url text,
    scoss boolean DEFAULT false NOT NULL,
    shareholders boolean DEFAULT false NOT NULL,
    free_inputs jsonb DEFAULT '{}'::jsonb NOT NULL,
    first_name text,
    last_name text,
    email public.citext
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
-- Name: solution_hosting_strategies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_hosting_strategies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    hosting_strategy_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
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
-- Name: solution_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_integrations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    integration_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_licenses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    license_id uuid NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL
);


--
-- Name: solution_maintenance_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_maintenance_statuses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    maintenance_status_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_metadata_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_metadata_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    metadata_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_metrics_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_metrics_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    metrics_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_nonprofit_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_nonprofit_statuses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    nonprofit_status_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_persistent_identifier_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_persistent_identifier_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    persistent_identifier_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_preservation_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_preservation_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    preservation_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_primary_funding_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_primary_funding_sources (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    primary_funding_source_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_programming_languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_programming_languages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    programming_language_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_readiness_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_readiness_levels (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    readiness_level_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_reporting_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_reporting_levels (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    reporting_level_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_revisions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    provider_id uuid,
    solution_draft_id uuid,
    snapshot_id uuid,
    user_id uuid,
    kind public.solution_revision_kind DEFAULT 'other'::public.solution_revision_kind NOT NULL,
    data_version public.solution_data_version DEFAULT 'unknown'::public.solution_data_version NOT NULL,
    provider_state public.solution_revision_provider_state DEFAULT 'same'::public.solution_revision_provider_state NOT NULL,
    identifier public.citext,
    diffs jsonb DEFAULT '[]'::jsonb NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    note text,
    reason text,
    diffs_count bigint GENERATED ALWAYS AS (jsonb_array_length(diffs)) STORED NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT valid_data CHECK ((jsonb_typeof(data) = 'object'::text)),
    CONSTRAINT valid_diffs CHECK ((jsonb_typeof(diffs) = 'array'::text))
);


--
-- Name: solution_security_standards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_security_standards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    security_standard_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_staffings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_staffings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    staffing_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
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
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL
);


--
-- Name: solution_values_frameworks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solution_values_frameworks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    solution_id uuid NOT NULL,
    values_framework_id uuid NOT NULL,
    single boolean DEFAULT false NOT NULL,
    assoc public.citext NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solutions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_id uuid NOT NULL,
    phase_1_board_structure_id uuid,
    phase_1_business_form_id uuid,
    phase_1_community_governance_id uuid,
    phase_1_hosting_strategy_id uuid,
    phase_1_maintenance_status_id uuid,
    phase_1_primary_funding_source_id uuid,
    phase_1_readiness_level_id uuid,
    identifier public.citext DEFAULT (gen_random_uuid())::public.citext NOT NULL,
    contact_method public.contact_method DEFAULT 'unavailable'::public.contact_method NOT NULL,
    slug public.citext NOT NULL,
    name public.citext NOT NULL,
    founded_on date,
    phase_1_location_of_incorporation text,
    member_count bigint,
    current_staffing numeric(19,2),
    website text,
    contact text,
    research_organization_registry_url text,
    mission text,
    key_achievements text,
    organizational_history text,
    funding_needs text,
    governance_summary text,
    phase_1_content_licensing text,
    phase_1_special_certifications_or_statuses text,
    phase_1_standards_employed text,
    phase_1_registered_service_provider_description text,
    phase_1_technology_dependencies text,
    phase_1_integrations_and_compatibility text,
    phase_1_annual_expenses bigint,
    phase_1_annual_revenue bigint,
    phase_1_investment_income bigint,
    phase_1_other_revenue bigint,
    phase_1_program_revenue bigint,
    phase_1_total_assets bigint,
    phase_1_total_contributions bigint,
    phase_1_total_liabilities bigint,
    phase_1_financial_numbers_applicability public.financial_numbers_applicability DEFAULT 'unknown'::public.financial_numbers_applicability NOT NULL,
    financial_numbers_publishability public.financial_numbers_publishability DEFAULT 'unknown'::public.financial_numbers_publishability NOT NULL,
    financial_information_scope public.financial_information_scope DEFAULT 'unknown'::public.financial_information_scope NOT NULL,
    financial_numbers_documented_url text,
    phase_1_comparable_products jsonb DEFAULT '[]'::jsonb NOT NULL,
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
    governance_records_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    governance_records jsonb DEFAULT '{}'::jsonb NOT NULL,
    governance_structure_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    governance_structure jsonb DEFAULT '{}'::jsonb NOT NULL,
    open_api_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    open_api jsonb DEFAULT '{}'::jsonb NOT NULL,
    open_data_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    open_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    product_roadmap_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    product_roadmap jsonb DEFAULT '{}'::jsonb NOT NULL,
    pricing_implementation public.pricing_implementation_status DEFAULT 'unknown'::public.pricing_implementation_status NOT NULL,
    pricing jsonb DEFAULT '{}'::jsonb NOT NULL,
    privacy_policy_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    privacy_policy jsonb DEFAULT '{}'::jsonb NOT NULL,
    contribution_pathways_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    contribution_pathways jsonb DEFAULT '{}'::jsonb NOT NULL,
    user_documentation_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    user_documentation jsonb DEFAULT '{}'::jsonb NOT NULL,
    web_accessibility_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    web_accessibility jsonb DEFAULT '{}'::jsonb NOT NULL,
    logo_data jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    phase_1_engagement_with_values_frameworks text,
    service_summary text,
    code_license_implementation public.implementation_status DEFAULT 'unknown'::public.implementation_status NOT NULL,
    code_license jsonb DEFAULT '{}'::jsonb NOT NULL,
    recent_grants jsonb DEFAULT '[]'::jsonb NOT NULL,
    top_granting_institutions jsonb DEFAULT '[]'::jsonb NOT NULL,
    normalized_name public.citext GENERATED ALWAYS AS (public.normalize_ransackable(name)) STORED NOT NULL,
    publication public.publication DEFAULT 'unpublished'::public.publication NOT NULL,
    published_at timestamp without time zone,
    phase_1_maintenance_status public.maintenance_status DEFAULT 'unknown'::public.maintenance_status NOT NULL,
    country_code public.citext,
    currency public.citext DEFAULT 'USD'::public.citext NOT NULL,
    annual_expenses_cents bigint DEFAULT 0 NOT NULL,
    annual_revenue_cents bigint DEFAULT 0 NOT NULL,
    investment_income_cents bigint DEFAULT 0 NOT NULL,
    other_revenue_cents bigint DEFAULT 0 NOT NULL,
    program_revenue_cents bigint DEFAULT 0 NOT NULL,
    total_assets_cents bigint DEFAULT 0 NOT NULL,
    total_contributions_cents bigint DEFAULT 0 NOT NULL,
    total_liabilities_cents bigint DEFAULT 0 NOT NULL,
    board_members_url text,
    financial_date_range text,
    financial_date_range_started_on date,
    financial_date_range_ended_on date,
    membership_program_url text,
    scoss boolean DEFAULT false NOT NULL,
    shareholders boolean DEFAULT false NOT NULL,
    free_inputs jsonb DEFAULT '{}'::jsonb NOT NULL,
    first_name text,
    last_name text,
    email public.citext
);


--
-- Name: staffings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.staffings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    min_value integer,
    max_value integer,
    coverage int4range GENERATED ALWAYS AS (public.calculate_staffing_range(min_value, max_value)) STORED,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: subscription_transitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscription_transitions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subscription_id uuid NOT NULL,
    most_recent boolean NOT NULL,
    sort_key integer NOT NULL,
    to_state character varying NOT NULL,
    metadata jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subscribable_type character varying NOT NULL,
    subscribable_id uuid NOT NULL,
    kind public.subscription_kind NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    term public.citext NOT NULL,
    enforced_slug public.citext,
    provides public.citext
);


--
-- Name: user_transitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_transitions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    most_recent boolean NOT NULL,
    sort_key integer NOT NULL,
    to_state character varying NOT NULL,
    metadata jsonb,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
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
    kind public.user_kind DEFAULT 'default'::public.user_kind NOT NULL,
    accepted_terms_at timestamp without time zone,
    comment_notifications public.subscription DEFAULT 'unsubscribed'::public.subscription NOT NULL,
    comment_notifications_updated_at timestamp without time zone,
    solution_notifications public.subscription DEFAULT 'unsubscribed'::public.subscription NOT NULL,
    solution_notifications_updated_at timestamp without time zone,
    reminder_notifications public.subscription DEFAULT 'unsubscribed'::public.subscription NOT NULL,
    reminder_notifications_updated_at timestamp without time zone
);


--
-- Name: users_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_roles (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL
);


--
-- Name: values_frameworks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.values_frameworks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name public.citext NOT NULL,
    slug public.citext NOT NULL,
    term public.citext NOT NULL,
    provides public.citext,
    enforced_slug text,
    description text,
    visibility public.visibility DEFAULT 'hidden'::public.visibility NOT NULL,
    solutions_count bigint DEFAULT 0 NOT NULL,
    solution_drafts_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: solution_imports identifier; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_imports ALTER COLUMN identifier SET DEFAULT nextval('public.solution_imports_identifier_seq'::regclass);


--
-- Name: accessibility_scopes accessibility_scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accessibility_scopes
    ADD CONSTRAINT accessibility_scopes_pkey PRIMARY KEY (id);


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
-- Name: authentication_standards authentication_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authentication_standards
    ADD CONSTRAINT authentication_standards_pkey PRIMARY KEY (id);


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
-- Name: community_engagement_activities community_engagement_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community_engagement_activities
    ADD CONSTRAINT community_engagement_activities_pkey PRIMARY KEY (id);


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
-- Name: content_licenses content_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_licenses
    ADD CONSTRAINT content_licenses_pkey PRIMARY KEY (id);


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
-- Name: integrations integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations
    ADD CONSTRAINT integrations_pkey PRIMARY KEY (id);


--
-- Name: invitation_transitions invitation_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_transitions
    ADD CONSTRAINT invitation_transitions_pkey PRIMARY KEY (id);


--
-- Name: invitations invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


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
-- Name: metadata_standards metadata_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metadata_standards
    ADD CONSTRAINT metadata_standards_pkey PRIMARY KEY (id);


--
-- Name: metrics_standards metrics_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics_standards
    ADD CONSTRAINT metrics_standards_pkey PRIMARY KEY (id);


--
-- Name: nonprofit_statuses nonprofit_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nonprofit_statuses
    ADD CONSTRAINT nonprofit_statuses_pkey PRIMARY KEY (id);


--
-- Name: persistent_identifier_standards persistent_identifier_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.persistent_identifier_standards
    ADD CONSTRAINT persistent_identifier_standards_pkey PRIMARY KEY (id);


--
-- Name: preservation_standards preservation_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.preservation_standards
    ADD CONSTRAINT preservation_standards_pkey PRIMARY KEY (id);


--
-- Name: primary_funding_sources primary_funding_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.primary_funding_sources
    ADD CONSTRAINT primary_funding_sources_pkey PRIMARY KEY (id);


--
-- Name: programming_languages programming_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programming_languages
    ADD CONSTRAINT programming_languages_pkey PRIMARY KEY (id);


--
-- Name: provider_editor_assignments provider_editor_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_editor_assignments
    ADD CONSTRAINT provider_editor_assignments_pkey PRIMARY KEY (id);


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
-- Name: reporting_levels reporting_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reporting_levels
    ADD CONSTRAINT reporting_levels_pkey PRIMARY KEY (id);


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
-- Name: security_standards security_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.security_standards
    ADD CONSTRAINT security_standards_pkey PRIMARY KEY (id);


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
-- Name: solution_accessibility_scopes solution_accessibility_scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_accessibility_scopes
    ADD CONSTRAINT solution_accessibility_scopes_pkey PRIMARY KEY (id);


--
-- Name: solution_authentication_standards solution_authentication_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_authentication_standards
    ADD CONSTRAINT solution_authentication_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_board_structures solution_board_structures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_board_structures
    ADD CONSTRAINT solution_board_structures_pkey PRIMARY KEY (id);


--
-- Name: solution_business_forms solution_business_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_business_forms
    ADD CONSTRAINT solution_business_forms_pkey PRIMARY KEY (id);


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
-- Name: solution_community_engagement_activities solution_community_engagement_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_community_engagement_activities
    ADD CONSTRAINT solution_community_engagement_activities_pkey PRIMARY KEY (id);


--
-- Name: solution_community_governances solution_community_governances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_community_governances
    ADD CONSTRAINT solution_community_governances_pkey PRIMARY KEY (id);


--
-- Name: solution_content_licenses solution_content_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_content_licenses
    ADD CONSTRAINT solution_content_licenses_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_accessibility_scopes solution_draft_accessibility_scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_accessibility_scopes
    ADD CONSTRAINT solution_draft_accessibility_scopes_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_authentication_standards solution_draft_authentication_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_authentication_standards
    ADD CONSTRAINT solution_draft_authentication_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_board_structures solution_draft_board_structures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_board_structures
    ADD CONSTRAINT solution_draft_board_structures_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_business_forms solution_draft_business_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_business_forms
    ADD CONSTRAINT solution_draft_business_forms_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_community_engagement_activities solution_draft_community_engagement_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_community_engagement_activities
    ADD CONSTRAINT solution_draft_community_engagement_activities_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_community_governances solution_draft_community_governances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_community_governances
    ADD CONSTRAINT solution_draft_community_governances_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_content_licenses solution_draft_content_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_content_licenses
    ADD CONSTRAINT solution_draft_content_licenses_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_hosting_strategies solution_draft_hosting_strategies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_hosting_strategies
    ADD CONSTRAINT solution_draft_hosting_strategies_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_integrations solution_draft_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_integrations
    ADD CONSTRAINT solution_draft_integrations_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_licenses solution_draft_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_licenses
    ADD CONSTRAINT solution_draft_licenses_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_maintenance_statuses solution_draft_maintenance_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_maintenance_statuses
    ADD CONSTRAINT solution_draft_maintenance_statuses_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_metadata_standards solution_draft_metadata_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_metadata_standards
    ADD CONSTRAINT solution_draft_metadata_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_metrics_standards solution_draft_metrics_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_metrics_standards
    ADD CONSTRAINT solution_draft_metrics_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_nonprofit_statuses solution_draft_nonprofit_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_nonprofit_statuses
    ADD CONSTRAINT solution_draft_nonprofit_statuses_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_persistent_identifier_standards solution_draft_persistent_identifier_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_persistent_identifier_standards
    ADD CONSTRAINT solution_draft_persistent_identifier_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_preservation_standards solution_draft_preservation_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_preservation_standards
    ADD CONSTRAINT solution_draft_preservation_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_primary_funding_sources solution_draft_primary_funding_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_primary_funding_sources
    ADD CONSTRAINT solution_draft_primary_funding_sources_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_programming_languages solution_draft_programming_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_programming_languages
    ADD CONSTRAINT solution_draft_programming_languages_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_readiness_levels solution_draft_readiness_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_readiness_levels
    ADD CONSTRAINT solution_draft_readiness_levels_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_reporting_levels solution_draft_reporting_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_reporting_levels
    ADD CONSTRAINT solution_draft_reporting_levels_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_security_standards solution_draft_security_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_security_standards
    ADD CONSTRAINT solution_draft_security_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_draft_staffings solution_draft_staffings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_staffings
    ADD CONSTRAINT solution_draft_staffings_pkey PRIMARY KEY (id);


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
-- Name: solution_draft_values_frameworks solution_draft_values_frameworks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_values_frameworks
    ADD CONSTRAINT solution_draft_values_frameworks_pkey PRIMARY KEY (id);


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
-- Name: solution_hosting_strategies solution_hosting_strategies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_hosting_strategies
    ADD CONSTRAINT solution_hosting_strategies_pkey PRIMARY KEY (id);


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
-- Name: solution_integrations solution_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_integrations
    ADD CONSTRAINT solution_integrations_pkey PRIMARY KEY (id);


--
-- Name: solution_licenses solution_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_licenses
    ADD CONSTRAINT solution_licenses_pkey PRIMARY KEY (id);


--
-- Name: solution_maintenance_statuses solution_maintenance_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_maintenance_statuses
    ADD CONSTRAINT solution_maintenance_statuses_pkey PRIMARY KEY (id);


--
-- Name: solution_metadata_standards solution_metadata_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_metadata_standards
    ADD CONSTRAINT solution_metadata_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_metrics_standards solution_metrics_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_metrics_standards
    ADD CONSTRAINT solution_metrics_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_nonprofit_statuses solution_nonprofit_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_nonprofit_statuses
    ADD CONSTRAINT solution_nonprofit_statuses_pkey PRIMARY KEY (id);


--
-- Name: solution_persistent_identifier_standards solution_persistent_identifier_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_persistent_identifier_standards
    ADD CONSTRAINT solution_persistent_identifier_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_preservation_standards solution_preservation_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_preservation_standards
    ADD CONSTRAINT solution_preservation_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_primary_funding_sources solution_primary_funding_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_primary_funding_sources
    ADD CONSTRAINT solution_primary_funding_sources_pkey PRIMARY KEY (id);


--
-- Name: solution_programming_languages solution_programming_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_programming_languages
    ADD CONSTRAINT solution_programming_languages_pkey PRIMARY KEY (id);


--
-- Name: solution_readiness_levels solution_readiness_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_readiness_levels
    ADD CONSTRAINT solution_readiness_levels_pkey PRIMARY KEY (id);


--
-- Name: solution_reporting_levels solution_reporting_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_reporting_levels
    ADD CONSTRAINT solution_reporting_levels_pkey PRIMARY KEY (id);


--
-- Name: solution_revisions solution_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_revisions
    ADD CONSTRAINT solution_revisions_pkey PRIMARY KEY (id);


--
-- Name: solution_security_standards solution_security_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_security_standards
    ADD CONSTRAINT solution_security_standards_pkey PRIMARY KEY (id);


--
-- Name: solution_staffings solution_staffings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_staffings
    ADD CONSTRAINT solution_staffings_pkey PRIMARY KEY (id);


--
-- Name: solution_user_contributions solution_user_contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_user_contributions
    ADD CONSTRAINT solution_user_contributions_pkey PRIMARY KEY (id);


--
-- Name: solution_values_frameworks solution_values_frameworks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_values_frameworks
    ADD CONSTRAINT solution_values_frameworks_pkey PRIMARY KEY (id);


--
-- Name: solutions solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT solutions_pkey PRIMARY KEY (id);


--
-- Name: staffings staffings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staffings
    ADD CONSTRAINT staffings_pkey PRIMARY KEY (id);


--
-- Name: subscription_transitions subscription_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_transitions
    ADD CONSTRAINT subscription_transitions_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


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
-- Name: user_transitions user_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_transitions
    ADD CONSTRAINT user_transitions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: values_frameworks values_frameworks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.values_frameworks
    ADD CONSTRAINT values_frameworks_pkey PRIMARY KEY (id);


--
-- Name: idx_on_accessibility_scope_id_8cfeee5e03; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_accessibility_scope_id_8cfeee5e03 ON public.solution_draft_accessibility_scopes USING btree (accessibility_scope_id);


--
-- Name: idx_on_authentication_standard_id_83b18b5410; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_authentication_standard_id_83b18b5410 ON public.solution_draft_authentication_standards USING btree (authentication_standard_id);


--
-- Name: idx_on_authentication_standard_id_f729ce6a4d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_authentication_standard_id_f729ce6a4d ON public.solution_authentication_standards USING btree (authentication_standard_id);


--
-- Name: idx_on_community_engagement_activity_id_a660ede9c2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_community_engagement_activity_id_a660ede9c2 ON public.solution_draft_community_engagement_activities USING btree (community_engagement_activity_id);


--
-- Name: idx_on_community_engagement_activity_id_a6b7e59278; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_community_engagement_activity_id_a6b7e59278 ON public.solution_community_engagement_activities USING btree (community_engagement_activity_id);


--
-- Name: idx_on_community_governance_id_9be13ea80c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_community_governance_id_9be13ea80c ON public.solution_community_governances USING btree (community_governance_id);


--
-- Name: idx_on_community_governance_id_ea4df91232; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_community_governance_id_ea4df91232 ON public.solution_draft_community_governances USING btree (community_governance_id);


--
-- Name: idx_on_maintenance_status_id_ba7aa33ae5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_maintenance_status_id_ba7aa33ae5 ON public.solution_draft_maintenance_statuses USING btree (maintenance_status_id);


--
-- Name: idx_on_metadata_standard_id_b63801d884; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_metadata_standard_id_b63801d884 ON public.solution_draft_metadata_standards USING btree (metadata_standard_id);


--
-- Name: idx_on_persistent_identifier_standard_id_7f253d646b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_persistent_identifier_standard_id_7f253d646b ON public.solution_persistent_identifier_standards USING btree (persistent_identifier_standard_id);


--
-- Name: idx_on_persistent_identifier_standard_id_971588cbf6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_persistent_identifier_standard_id_971588cbf6 ON public.solution_draft_persistent_identifier_standards USING btree (persistent_identifier_standard_id);


--
-- Name: idx_on_preservation_standard_id_4448d346db; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_preservation_standard_id_4448d346db ON public.solution_draft_preservation_standards USING btree (preservation_standard_id);


--
-- Name: idx_on_preservation_standard_id_adc4fffef7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_preservation_standard_id_adc4fffef7 ON public.solution_preservation_standards USING btree (preservation_standard_id);


--
-- Name: idx_on_primary_funding_source_id_5f1f221f70; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_primary_funding_source_id_5f1f221f70 ON public.solution_draft_primary_funding_sources USING btree (primary_funding_source_id);


--
-- Name: idx_on_primary_funding_source_id_67d9414fd7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_primary_funding_source_id_67d9414fd7 ON public.solution_primary_funding_sources USING btree (primary_funding_source_id);


--
-- Name: idx_on_programming_language_id_988c7525dd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_programming_language_id_988c7525dd ON public.solution_programming_languages USING btree (programming_language_id);


--
-- Name: idx_on_programming_language_id_ea4ddae88c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_programming_language_id_ea4ddae88c ON public.solution_draft_programming_languages USING btree (programming_language_id);


--
-- Name: idx_on_security_standard_id_6b1dbe0a20; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_security_standard_id_6b1dbe0a20 ON public.solution_draft_security_standards USING btree (security_standard_id);


--
-- Name: idx_on_solution_draft_id_117fe11f0d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_solution_draft_id_117fe11f0d ON public.solution_draft_primary_funding_sources USING btree (solution_draft_id);


--
-- Name: idx_on_solution_draft_id_2d748b32cd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_solution_draft_id_2d748b32cd ON public.solution_draft_persistent_identifier_standards USING btree (solution_draft_id);


--
-- Name: idx_on_solution_draft_id_7192742c65; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_solution_draft_id_7192742c65 ON public.solution_draft_preservation_standards USING btree (solution_draft_id);


--
-- Name: idx_on_solution_draft_id_849bfb38ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_solution_draft_id_849bfb38ad ON public.solution_draft_community_governances USING btree (solution_draft_id);


--
-- Name: idx_on_solution_draft_id_a951c05879; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_solution_draft_id_a951c05879 ON public.solution_draft_authentication_standards USING btree (solution_draft_id);


--
-- Name: idx_on_solution_draft_id_dcea24e157; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_solution_draft_id_dcea24e157 ON public.solution_draft_community_engagement_activities USING btree (solution_draft_id);


--
-- Name: idx_on_solution_draft_id_f1434c4565; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_solution_draft_id_f1434c4565 ON public.solution_draft_programming_languages USING btree (solution_draft_id);


--
-- Name: idx_on_user_contribution_id_e5e19dfc8b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_user_contribution_id_e5e19dfc8b ON public.solution_draft_user_contributions USING btree (user_contribution_id);


--
-- Name: index_accessibility_scopes_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accessibility_scopes_on_provides ON public.accessibility_scopes USING btree (provides);


--
-- Name: index_accessibility_scopes_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accessibility_scopes_on_slug ON public.accessibility_scopes USING btree (slug);


--
-- Name: index_accessibility_scopes_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accessibility_scopes_on_term ON public.accessibility_scopes USING btree (term);


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
-- Name: index_authentication_standards_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_authentication_standards_on_provides ON public.authentication_standards USING btree (provides);


--
-- Name: index_authentication_standards_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_authentication_standards_on_slug ON public.authentication_standards USING btree (slug);


--
-- Name: index_authentication_standards_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_authentication_standards_on_term ON public.authentication_standards USING btree (term);


--
-- Name: index_board_structures_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_structures_on_provides ON public.board_structures USING btree (provides);


--
-- Name: index_board_structures_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_board_structures_on_seed_identifier ON public.board_structures USING btree (seed_identifier);


--
-- Name: index_board_structures_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_board_structures_on_slug ON public.board_structures USING btree (slug);


--
-- Name: index_board_structures_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_board_structures_on_term ON public.board_structures USING btree (term);


--
-- Name: index_business_forms_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_forms_on_provides ON public.business_forms USING btree (provides);


--
-- Name: index_business_forms_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_business_forms_on_seed_identifier ON public.business_forms USING btree (seed_identifier);


--
-- Name: index_business_forms_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_business_forms_on_slug ON public.business_forms USING btree (slug);


--
-- Name: index_business_forms_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_business_forms_on_term ON public.business_forms USING btree (term);


--
-- Name: index_community_engagement_activities_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_community_engagement_activities_on_provides ON public.community_engagement_activities USING btree (provides);


--
-- Name: index_community_engagement_activities_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_community_engagement_activities_on_slug ON public.community_engagement_activities USING btree (slug);


--
-- Name: index_community_engagement_activities_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_community_engagement_activities_on_term ON public.community_engagement_activities USING btree (term);


--
-- Name: index_community_governances_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_community_governances_on_provides ON public.community_governances USING btree (provides);


--
-- Name: index_community_governances_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_community_governances_on_term ON public.community_governances USING btree (term);


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
-- Name: index_content_licenses_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_content_licenses_on_provides ON public.content_licenses USING btree (provides);


--
-- Name: index_content_licenses_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_content_licenses_on_slug ON public.content_licenses USING btree (slug);


--
-- Name: index_content_licenses_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_content_licenses_on_term ON public.content_licenses USING btree (term);


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
-- Name: index_hosting_strategies_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hosting_strategies_on_provides ON public.hosting_strategies USING btree (provides);


--
-- Name: index_hosting_strategies_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hosting_strategies_on_seed_identifier ON public.hosting_strategies USING btree (seed_identifier);


--
-- Name: index_hosting_strategies_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hosting_strategies_on_slug ON public.hosting_strategies USING btree (slug);


--
-- Name: index_hosting_strategies_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_hosting_strategies_on_term ON public.hosting_strategies USING btree (term);


--
-- Name: index_integrations_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_integrations_on_provides ON public.integrations USING btree (provides);


--
-- Name: index_integrations_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_integrations_on_slug ON public.integrations USING btree (slug);


--
-- Name: index_integrations_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_integrations_on_term ON public.integrations USING btree (term);


--
-- Name: index_invitation_transitions_parent_most_recent; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_invitation_transitions_parent_most_recent ON public.invitation_transitions USING btree (invitation_id, most_recent) WHERE most_recent;


--
-- Name: index_invitation_transitions_parent_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_invitation_transitions_parent_sort ON public.invitation_transitions USING btree (invitation_id, sort_key);


--
-- Name: index_invitations_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_admin_id ON public.invitations USING btree (admin_id);


--
-- Name: index_invitations_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_invitations_on_email ON public.invitations USING btree (email);


--
-- Name: index_invitations_on_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_provider_id ON public.invitations USING btree (provider_id);


--
-- Name: index_invitations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_invitations_on_user_id ON public.invitations USING btree (user_id);


--
-- Name: index_licenses_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_licenses_on_provides ON public.licenses USING btree (provides);


--
-- Name: index_licenses_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_licenses_on_seed_identifier ON public.licenses USING btree (seed_identifier);


--
-- Name: index_licenses_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_licenses_on_slug ON public.licenses USING btree (slug);


--
-- Name: index_licenses_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_licenses_on_term ON public.licenses USING btree (term);


--
-- Name: index_maintenance_statuses_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_maintenance_statuses_on_provides ON public.maintenance_statuses USING btree (provides);


--
-- Name: index_maintenance_statuses_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_maintenance_statuses_on_seed_identifier ON public.maintenance_statuses USING btree (seed_identifier);


--
-- Name: index_maintenance_statuses_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_maintenance_statuses_on_slug ON public.maintenance_statuses USING btree (slug);


--
-- Name: index_maintenance_statuses_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_maintenance_statuses_on_term ON public.maintenance_statuses USING btree (term);


--
-- Name: index_metadata_standards_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metadata_standards_on_provides ON public.metadata_standards USING btree (provides);


--
-- Name: index_metadata_standards_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metadata_standards_on_slug ON public.metadata_standards USING btree (slug);


--
-- Name: index_metadata_standards_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metadata_standards_on_term ON public.metadata_standards USING btree (term);


--
-- Name: index_metrics_standards_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metrics_standards_on_provides ON public.metrics_standards USING btree (provides);


--
-- Name: index_metrics_standards_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metrics_standards_on_slug ON public.metrics_standards USING btree (slug);


--
-- Name: index_metrics_standards_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_metrics_standards_on_term ON public.metrics_standards USING btree (term);


--
-- Name: index_nonprofit_statuses_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_nonprofit_statuses_on_provides ON public.nonprofit_statuses USING btree (provides);


--
-- Name: index_nonprofit_statuses_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_nonprofit_statuses_on_slug ON public.nonprofit_statuses USING btree (slug);


--
-- Name: index_nonprofit_statuses_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_nonprofit_statuses_on_term ON public.nonprofit_statuses USING btree (term);


--
-- Name: index_persistent_identifier_standards_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_persistent_identifier_standards_on_provides ON public.persistent_identifier_standards USING btree (provides);


--
-- Name: index_persistent_identifier_standards_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_persistent_identifier_standards_on_slug ON public.persistent_identifier_standards USING btree (slug);


--
-- Name: index_persistent_identifier_standards_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_persistent_identifier_standards_on_term ON public.persistent_identifier_standards USING btree (term);


--
-- Name: index_preservation_standards_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_preservation_standards_on_provides ON public.preservation_standards USING btree (provides);


--
-- Name: index_preservation_standards_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_preservation_standards_on_slug ON public.preservation_standards USING btree (slug);


--
-- Name: index_preservation_standards_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_preservation_standards_on_term ON public.preservation_standards USING btree (term);


--
-- Name: index_primary_funding_sources_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_primary_funding_sources_on_provides ON public.primary_funding_sources USING btree (provides);


--
-- Name: index_primary_funding_sources_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_primary_funding_sources_on_seed_identifier ON public.primary_funding_sources USING btree (seed_identifier);


--
-- Name: index_primary_funding_sources_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_primary_funding_sources_on_slug ON public.primary_funding_sources USING btree (slug);


--
-- Name: index_primary_funding_sources_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_primary_funding_sources_on_term ON public.primary_funding_sources USING btree (term);


--
-- Name: index_programming_languages_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_programming_languages_on_provides ON public.programming_languages USING btree (provides);


--
-- Name: index_programming_languages_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_programming_languages_on_slug ON public.programming_languages USING btree (slug);


--
-- Name: index_programming_languages_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_programming_languages_on_term ON public.programming_languages USING btree (term);


--
-- Name: index_provider_editor_assignments_on_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_provider_editor_assignments_on_provider_id ON public.provider_editor_assignments USING btree (provider_id);


--
-- Name: index_provider_editor_assignments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_provider_editor_assignments_on_user_id ON public.provider_editor_assignments USING btree (user_id);


--
-- Name: index_provider_editor_assignments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_provider_editor_assignments_uniqueness ON public.provider_editor_assignments USING btree (provider_id, user_id);


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
-- Name: index_readiness_levels_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_readiness_levels_on_provides ON public.readiness_levels USING btree (provides);


--
-- Name: index_readiness_levels_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_readiness_levels_on_seed_identifier ON public.readiness_levels USING btree (seed_identifier);


--
-- Name: index_readiness_levels_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_readiness_levels_on_slug ON public.readiness_levels USING btree (slug);


--
-- Name: index_readiness_levels_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_readiness_levels_on_term ON public.readiness_levels USING btree (term);


--
-- Name: index_reporting_levels_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reporting_levels_on_provides ON public.reporting_levels USING btree (provides);


--
-- Name: index_reporting_levels_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_reporting_levels_on_slug ON public.reporting_levels USING btree (slug);


--
-- Name: index_reporting_levels_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_reporting_levels_on_term ON public.reporting_levels USING btree (term);


--
-- Name: index_roles_on_name_and_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_name_and_resource_type_and_resource_id ON public.roles USING btree (name, resource_type, resource_id);


--
-- Name: index_security_standards_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_security_standards_on_provides ON public.security_standards USING btree (provides);


--
-- Name: index_security_standards_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_security_standards_on_slug ON public.security_standards USING btree (slug);


--
-- Name: index_security_standards_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_security_standards_on_term ON public.security_standards USING btree (term);


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
-- Name: index_snapshots_on_solution_revision_kind; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_solution_revision_kind ON public.snapshots USING btree (solution_revision_kind);


--
-- Name: index_snapshots_on_solution_revision_snapshot; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_solution_revision_snapshot ON public.snapshots USING btree (solution_revision_snapshot);


--
-- Name: index_snapshots_on_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_user ON public.snapshots USING btree (user_type, user_id);


--
-- Name: index_snapshots_solution_revision_ordering; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_solution_revision_ordering ON public.snapshots USING btree (item_id, created_at DESC) WHERE solution_revision_snapshot;


--
-- Name: index_solution_accessibility_scopes_on_accessibility_scope_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_accessibility_scopes_on_accessibility_scope_id ON public.solution_accessibility_scopes USING btree (accessibility_scope_id);


--
-- Name: index_solution_accessibility_scopes_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_accessibility_scopes_on_solution_id ON public.solution_accessibility_scopes USING btree (solution_id);


--
-- Name: index_solution_authentication_standards_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_authentication_standards_on_solution_id ON public.solution_authentication_standards USING btree (solution_id);


--
-- Name: index_solution_board_structures_on_board_structure_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_board_structures_on_board_structure_id ON public.solution_board_structures USING btree (board_structure_id);


--
-- Name: index_solution_board_structures_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_board_structures_on_solution_id ON public.solution_board_structures USING btree (solution_id);


--
-- Name: index_solution_business_forms_on_business_form_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_business_forms_on_business_form_id ON public.solution_business_forms USING btree (business_form_id);


--
-- Name: index_solution_business_forms_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_business_forms_on_solution_id ON public.solution_business_forms USING btree (solution_id);


--
-- Name: index_solution_categories_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_categories_on_provides ON public.solution_categories USING btree (provides);


--
-- Name: index_solution_categories_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_categories_on_seed_identifier ON public.solution_categories USING btree (seed_identifier);


--
-- Name: index_solution_categories_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_categories_on_slug ON public.solution_categories USING btree (slug);


--
-- Name: index_solution_categories_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_categories_on_term ON public.solution_categories USING btree (term);


--
-- Name: index_solution_category_draft_links_on_solution_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_category_draft_links_on_solution_category_id ON public.solution_category_draft_links USING btree (solution_category_id);


--
-- Name: index_solution_category_draft_links_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_category_draft_links_on_solution_draft_id ON public.solution_category_draft_links USING btree (solution_draft_id);


--
-- Name: index_solution_category_links_on_solution_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_category_links_on_solution_category_id ON public.solution_category_links USING btree (solution_category_id);


--
-- Name: index_solution_category_links_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_category_links_on_solution_id ON public.solution_category_links USING btree (solution_id);


--
-- Name: index_solution_community_engagement_activities_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_community_engagement_activities_on_solution_id ON public.solution_community_engagement_activities USING btree (solution_id);


--
-- Name: index_solution_community_governances_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_community_governances_on_solution_id ON public.solution_community_governances USING btree (solution_id);


--
-- Name: index_solution_content_licenses_on_content_license_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_content_licenses_on_content_license_id ON public.solution_content_licenses USING btree (content_license_id);


--
-- Name: index_solution_content_licenses_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_content_licenses_on_solution_id ON public.solution_content_licenses USING btree (solution_id);


--
-- Name: index_solution_draft_accessibility_scopes_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_accessibility_scopes_on_solution_draft_id ON public.solution_draft_accessibility_scopes USING btree (solution_draft_id);


--
-- Name: index_solution_draft_board_structures_on_board_structure_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_board_structures_on_board_structure_id ON public.solution_draft_board_structures USING btree (board_structure_id);


--
-- Name: index_solution_draft_board_structures_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_board_structures_on_solution_draft_id ON public.solution_draft_board_structures USING btree (solution_draft_id);


--
-- Name: index_solution_draft_business_forms_on_business_form_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_business_forms_on_business_form_id ON public.solution_draft_business_forms USING btree (business_form_id);


--
-- Name: index_solution_draft_business_forms_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_business_forms_on_solution_draft_id ON public.solution_draft_business_forms USING btree (solution_draft_id);


--
-- Name: index_solution_draft_content_licenses_on_content_license_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_content_licenses_on_content_license_id ON public.solution_draft_content_licenses USING btree (content_license_id);


--
-- Name: index_solution_draft_content_licenses_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_content_licenses_on_solution_draft_id ON public.solution_draft_content_licenses USING btree (solution_draft_id);


--
-- Name: index_solution_draft_hosting_strategies_on_hosting_strategy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_hosting_strategies_on_hosting_strategy_id ON public.solution_draft_hosting_strategies USING btree (hosting_strategy_id);


--
-- Name: index_solution_draft_hosting_strategies_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_hosting_strategies_on_solution_draft_id ON public.solution_draft_hosting_strategies USING btree (solution_draft_id);


--
-- Name: index_solution_draft_integrations_on_integration_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_integrations_on_integration_id ON public.solution_draft_integrations USING btree (integration_id);


--
-- Name: index_solution_draft_integrations_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_integrations_on_solution_draft_id ON public.solution_draft_integrations USING btree (solution_draft_id);


--
-- Name: index_solution_draft_licenses_on_license_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_licenses_on_license_id ON public.solution_draft_licenses USING btree (license_id);


--
-- Name: index_solution_draft_licenses_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_licenses_on_solution_draft_id ON public.solution_draft_licenses USING btree (solution_draft_id);


--
-- Name: index_solution_draft_maintenance_statuses_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_maintenance_statuses_on_solution_draft_id ON public.solution_draft_maintenance_statuses USING btree (solution_draft_id);


--
-- Name: index_solution_draft_metadata_standards_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_metadata_standards_on_solution_draft_id ON public.solution_draft_metadata_standards USING btree (solution_draft_id);


--
-- Name: index_solution_draft_metrics_standards_on_metrics_standard_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_metrics_standards_on_metrics_standard_id ON public.solution_draft_metrics_standards USING btree (metrics_standard_id);


--
-- Name: index_solution_draft_metrics_standards_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_metrics_standards_on_solution_draft_id ON public.solution_draft_metrics_standards USING btree (solution_draft_id);


--
-- Name: index_solution_draft_nonprofit_statuses_on_nonprofit_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_nonprofit_statuses_on_nonprofit_status_id ON public.solution_draft_nonprofit_statuses USING btree (nonprofit_status_id);


--
-- Name: index_solution_draft_nonprofit_statuses_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_nonprofit_statuses_on_solution_draft_id ON public.solution_draft_nonprofit_statuses USING btree (solution_draft_id);


--
-- Name: index_solution_draft_readiness_levels_on_readiness_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_readiness_levels_on_readiness_level_id ON public.solution_draft_readiness_levels USING btree (readiness_level_id);


--
-- Name: index_solution_draft_readiness_levels_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_readiness_levels_on_solution_draft_id ON public.solution_draft_readiness_levels USING btree (solution_draft_id);


--
-- Name: index_solution_draft_reporting_levels_on_reporting_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_reporting_levels_on_reporting_level_id ON public.solution_draft_reporting_levels USING btree (reporting_level_id);


--
-- Name: index_solution_draft_reporting_levels_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_reporting_levels_on_solution_draft_id ON public.solution_draft_reporting_levels USING btree (solution_draft_id);


--
-- Name: index_solution_draft_security_standards_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_security_standards_on_solution_draft_id ON public.solution_draft_security_standards USING btree (solution_draft_id);


--
-- Name: index_solution_draft_staffings_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_staffings_on_solution_draft_id ON public.solution_draft_staffings USING btree (solution_draft_id);


--
-- Name: index_solution_draft_staffings_on_staffing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_staffings_on_staffing_id ON public.solution_draft_staffings USING btree (staffing_id);


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
-- Name: index_solution_draft_values_frameworks_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_values_frameworks_on_solution_draft_id ON public.solution_draft_values_frameworks USING btree (solution_draft_id);


--
-- Name: index_solution_draft_values_frameworks_on_values_framework_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_draft_values_frameworks_on_values_framework_id ON public.solution_draft_values_frameworks USING btree (values_framework_id);


--
-- Name: index_solution_drafts_on_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_identifier ON public.solution_drafts USING btree (identifier);


--
-- Name: index_solution_drafts_on_normalized_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_normalized_name ON public.solution_drafts USING btree (normalized_name);


--
-- Name: index_solution_drafts_on_phase_1_board_structure_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_phase_1_board_structure_id ON public.solution_drafts USING btree (phase_1_board_structure_id);


--
-- Name: index_solution_drafts_on_phase_1_business_form_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_phase_1_business_form_id ON public.solution_drafts USING btree (phase_1_business_form_id);


--
-- Name: index_solution_drafts_on_phase_1_community_governance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_phase_1_community_governance_id ON public.solution_drafts USING btree (phase_1_community_governance_id);


--
-- Name: index_solution_drafts_on_phase_1_hosting_strategy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_phase_1_hosting_strategy_id ON public.solution_drafts USING btree (phase_1_hosting_strategy_id);


--
-- Name: index_solution_drafts_on_phase_1_maintenance_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_phase_1_maintenance_status ON public.solution_drafts USING btree (phase_1_maintenance_status);


--
-- Name: index_solution_drafts_on_phase_1_maintenance_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_phase_1_maintenance_status_id ON public.solution_drafts USING btree (phase_1_maintenance_status_id);


--
-- Name: index_solution_drafts_on_phase_1_primary_funding_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_phase_1_primary_funding_source_id ON public.solution_drafts USING btree (phase_1_primary_funding_source_id);


--
-- Name: index_solution_drafts_on_phase_1_readiness_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_drafts_on_phase_1_readiness_level_id ON public.solution_drafts USING btree (phase_1_readiness_level_id);


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
-- Name: index_solution_hosting_strategies_on_hosting_strategy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_hosting_strategies_on_hosting_strategy_id ON public.solution_hosting_strategies USING btree (hosting_strategy_id);


--
-- Name: index_solution_hosting_strategies_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_hosting_strategies_on_solution_id ON public.solution_hosting_strategies USING btree (solution_id);


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
-- Name: index_solution_integrations_on_integration_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_integrations_on_integration_id ON public.solution_integrations USING btree (integration_id);


--
-- Name: index_solution_integrations_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_integrations_on_solution_id ON public.solution_integrations USING btree (solution_id);


--
-- Name: index_solution_licenses_on_license_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_licenses_on_license_id ON public.solution_licenses USING btree (license_id);


--
-- Name: index_solution_licenses_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_licenses_on_solution_id ON public.solution_licenses USING btree (solution_id);


--
-- Name: index_solution_maintenance_statuses_on_maintenance_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_maintenance_statuses_on_maintenance_status_id ON public.solution_maintenance_statuses USING btree (maintenance_status_id);


--
-- Name: index_solution_maintenance_statuses_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_maintenance_statuses_on_solution_id ON public.solution_maintenance_statuses USING btree (solution_id);


--
-- Name: index_solution_metadata_standards_on_metadata_standard_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_metadata_standards_on_metadata_standard_id ON public.solution_metadata_standards USING btree (metadata_standard_id);


--
-- Name: index_solution_metadata_standards_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_metadata_standards_on_solution_id ON public.solution_metadata_standards USING btree (solution_id);


--
-- Name: index_solution_metrics_standards_on_metrics_standard_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_metrics_standards_on_metrics_standard_id ON public.solution_metrics_standards USING btree (metrics_standard_id);


--
-- Name: index_solution_metrics_standards_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_metrics_standards_on_solution_id ON public.solution_metrics_standards USING btree (solution_id);


--
-- Name: index_solution_nonprofit_statuses_on_nonprofit_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_nonprofit_statuses_on_nonprofit_status_id ON public.solution_nonprofit_statuses USING btree (nonprofit_status_id);


--
-- Name: index_solution_nonprofit_statuses_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_nonprofit_statuses_on_solution_id ON public.solution_nonprofit_statuses USING btree (solution_id);


--
-- Name: index_solution_persistent_identifier_standards_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_persistent_identifier_standards_on_solution_id ON public.solution_persistent_identifier_standards USING btree (solution_id);


--
-- Name: index_solution_preservation_standards_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_preservation_standards_on_solution_id ON public.solution_preservation_standards USING btree (solution_id);


--
-- Name: index_solution_primary_funding_sources_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_primary_funding_sources_on_solution_id ON public.solution_primary_funding_sources USING btree (solution_id);


--
-- Name: index_solution_programming_languages_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_programming_languages_on_solution_id ON public.solution_programming_languages USING btree (solution_id);


--
-- Name: index_solution_readiness_levels_on_readiness_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_readiness_levels_on_readiness_level_id ON public.solution_readiness_levels USING btree (readiness_level_id);


--
-- Name: index_solution_readiness_levels_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_readiness_levels_on_solution_id ON public.solution_readiness_levels USING btree (solution_id);


--
-- Name: index_solution_reporting_levels_on_reporting_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_reporting_levels_on_reporting_level_id ON public.solution_reporting_levels USING btree (reporting_level_id);


--
-- Name: index_solution_reporting_levels_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_reporting_levels_on_solution_id ON public.solution_reporting_levels USING btree (solution_id);


--
-- Name: index_solution_revisions_on_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_revisions_on_provider_id ON public.solution_revisions USING btree (provider_id);


--
-- Name: index_solution_revisions_on_snapshot_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solution_revisions_on_snapshot_id ON public.solution_revisions USING btree (snapshot_id);


--
-- Name: index_solution_revisions_on_solution_draft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_revisions_on_solution_draft_id ON public.solution_revisions USING btree (solution_draft_id);


--
-- Name: index_solution_revisions_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_revisions_on_solution_id ON public.solution_revisions USING btree (solution_id);


--
-- Name: index_solution_revisions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_revisions_on_user_id ON public.solution_revisions USING btree (user_id);


--
-- Name: index_solution_revisions_ordering; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_revisions_ordering ON public.solution_revisions USING btree (solution_id, created_at DESC);


--
-- Name: index_solution_security_standards_on_security_standard_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_security_standards_on_security_standard_id ON public.solution_security_standards USING btree (security_standard_id);


--
-- Name: index_solution_security_standards_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_security_standards_on_solution_id ON public.solution_security_standards USING btree (solution_id);


--
-- Name: index_solution_staffings_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_staffings_on_solution_id ON public.solution_staffings USING btree (solution_id);


--
-- Name: index_solution_staffings_on_staffing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_staffings_on_staffing_id ON public.solution_staffings USING btree (staffing_id);


--
-- Name: index_solution_user_contributions_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_user_contributions_on_solution_id ON public.solution_user_contributions USING btree (solution_id);


--
-- Name: index_solution_user_contributions_on_user_contribution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_user_contributions_on_user_contribution_id ON public.solution_user_contributions USING btree (user_contribution_id);


--
-- Name: index_solution_values_frameworks_on_solution_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_values_frameworks_on_solution_id ON public.solution_values_frameworks USING btree (solution_id);


--
-- Name: index_solution_values_frameworks_on_values_framework_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solution_values_frameworks_on_values_framework_id ON public.solution_values_frameworks USING btree (values_framework_id);


--
-- Name: index_solutions_on_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solutions_on_identifier ON public.solutions USING btree (identifier);


--
-- Name: index_solutions_on_normalized_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_normalized_name ON public.solutions USING btree (normalized_name);


--
-- Name: index_solutions_on_phase_1_board_structure_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_phase_1_board_structure_id ON public.solutions USING btree (phase_1_board_structure_id);


--
-- Name: index_solutions_on_phase_1_business_form_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_phase_1_business_form_id ON public.solutions USING btree (phase_1_business_form_id);


--
-- Name: index_solutions_on_phase_1_community_governance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_phase_1_community_governance_id ON public.solutions USING btree (phase_1_community_governance_id);


--
-- Name: index_solutions_on_phase_1_hosting_strategy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_phase_1_hosting_strategy_id ON public.solutions USING btree (phase_1_hosting_strategy_id);


--
-- Name: index_solutions_on_phase_1_maintenance_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_phase_1_maintenance_status ON public.solutions USING btree (phase_1_maintenance_status);


--
-- Name: index_solutions_on_phase_1_maintenance_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_phase_1_maintenance_status_id ON public.solutions USING btree (phase_1_maintenance_status_id);


--
-- Name: index_solutions_on_phase_1_primary_funding_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_phase_1_primary_funding_source_id ON public.solutions USING btree (phase_1_primary_funding_source_id);


--
-- Name: index_solutions_on_phase_1_readiness_level_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_phase_1_readiness_level_id ON public.solutions USING btree (phase_1_readiness_level_id);


--
-- Name: index_solutions_on_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_provider_id ON public.solutions USING btree (provider_id);


--
-- Name: index_solutions_on_publication; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solutions_on_publication ON public.solutions USING btree (publication);


--
-- Name: index_solutions_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solutions_on_slug ON public.solutions USING btree (slug);


--
-- Name: index_staffings_on_coverage; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_staffings_on_coverage ON public.staffings USING gist (coverage);


--
-- Name: index_staffings_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_staffings_on_provides ON public.staffings USING btree (provides);


--
-- Name: index_staffings_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_staffings_on_slug ON public.staffings USING btree (slug);


--
-- Name: index_staffings_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_staffings_on_term ON public.staffings USING btree (term);


--
-- Name: index_subscription_transitions_parent_most_recent; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscription_transitions_parent_most_recent ON public.subscription_transitions USING btree (subscription_id, most_recent) WHERE most_recent;


--
-- Name: index_subscription_transitions_parent_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscription_transitions_parent_sort ON public.subscription_transitions USING btree (subscription_id, sort_key);


--
-- Name: index_subscriptions_on_subscribable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_subscribable ON public.subscriptions USING btree (subscribable_type, subscribable_id);


--
-- Name: index_subscriptions_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscriptions_uniqueness ON public.subscriptions USING btree (subscribable_id, subscribable_type, kind);


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
-- Name: index_user_contributions_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_contributions_on_provides ON public.user_contributions USING btree (provides);


--
-- Name: index_user_contributions_on_seed_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_contributions_on_seed_identifier ON public.user_contributions USING btree (seed_identifier);


--
-- Name: index_user_contributions_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_contributions_on_slug ON public.user_contributions USING btree (slug);


--
-- Name: index_user_contributions_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_contributions_on_term ON public.user_contributions USING btree (term);


--
-- Name: index_user_transitions_parent_most_recent; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_transitions_parent_most_recent ON public.user_transitions USING btree (user_id, most_recent) WHERE most_recent;


--
-- Name: index_user_transitions_parent_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_transitions_parent_sort ON public.user_transitions USING btree (user_id, sort_key);


--
-- Name: index_users_on_accepted_terms_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_accepted_terms_at ON public.users USING btree (accepted_terms_at);


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
-- Name: index_values_frameworks_on_provides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_values_frameworks_on_provides ON public.values_frameworks USING btree (provides);


--
-- Name: index_values_frameworks_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_values_frameworks_on_slug ON public.values_frameworks USING btree (slug);


--
-- Name: index_values_frameworks_on_term; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_values_frameworks_on_term ON public.values_frameworks USING btree (term);


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
-- Name: udx_solution_accessibility_scopes_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_accessibility_scopes_multi ON public.solution_accessibility_scopes USING btree (solution_id, accessibility_scope_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_accessibility_scopes_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_accessibility_scopes_single ON public.solution_accessibility_scopes USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_authentication_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_authentication_standards_multi ON public.solution_authentication_standards USING btree (solution_id, authentication_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_authentication_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_authentication_standards_single ON public.solution_authentication_standards USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_board_structures_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_board_structures_multi ON public.solution_board_structures USING btree (solution_id, board_structure_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_board_structures_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_board_structures_single ON public.solution_board_structures USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_business_forms_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_business_forms_multi ON public.solution_business_forms USING btree (solution_id, business_form_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_business_forms_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_business_forms_single ON public.solution_business_forms USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_category_draft_links_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_category_draft_links_multi ON public.solution_category_draft_links USING btree (solution_draft_id, solution_category_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_category_draft_links_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_category_draft_links_single ON public.solution_category_draft_links USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_category_links_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_category_links_multi ON public.solution_category_links USING btree (solution_id, solution_category_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_category_links_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_category_links_single ON public.solution_category_links USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_community_engagement_activities_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_community_engagement_activities_multi ON public.solution_community_engagement_activities USING btree (solution_id, community_engagement_activity_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_community_engagement_activities_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_community_engagement_activities_single ON public.solution_community_engagement_activities USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_community_governances_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_community_governances_multi ON public.solution_community_governances USING btree (solution_id, community_governance_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_community_governances_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_community_governances_single ON public.solution_community_governances USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_content_licenses_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_content_licenses_multi ON public.solution_content_licenses USING btree (solution_id, content_license_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_content_licenses_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_content_licenses_single ON public.solution_content_licenses USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_accessibility_scopes_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_accessibility_scopes_multi ON public.solution_draft_accessibility_scopes USING btree (solution_draft_id, accessibility_scope_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_accessibility_scopes_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_accessibility_scopes_single ON public.solution_draft_accessibility_scopes USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_authentication_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_authentication_standards_multi ON public.solution_draft_authentication_standards USING btree (solution_draft_id, authentication_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_authentication_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_authentication_standards_single ON public.solution_draft_authentication_standards USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_board_structures_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_board_structures_multi ON public.solution_draft_board_structures USING btree (solution_draft_id, board_structure_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_board_structures_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_board_structures_single ON public.solution_draft_board_structures USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_business_forms_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_business_forms_multi ON public.solution_draft_business_forms USING btree (solution_draft_id, business_form_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_business_forms_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_business_forms_single ON public.solution_draft_business_forms USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_community_engagement_activities_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_community_engagement_activities_multi ON public.solution_draft_community_engagement_activities USING btree (solution_draft_id, community_engagement_activity_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_community_engagement_activities_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_community_engagement_activities_single ON public.solution_draft_community_engagement_activities USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_community_governances_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_community_governances_multi ON public.solution_draft_community_governances USING btree (solution_draft_id, community_governance_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_community_governances_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_community_governances_single ON public.solution_draft_community_governances USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_content_licenses_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_content_licenses_multi ON public.solution_draft_content_licenses USING btree (solution_draft_id, content_license_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_content_licenses_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_content_licenses_single ON public.solution_draft_content_licenses USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_hosting_strategies_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_hosting_strategies_multi ON public.solution_draft_hosting_strategies USING btree (solution_draft_id, hosting_strategy_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_hosting_strategies_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_hosting_strategies_single ON public.solution_draft_hosting_strategies USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_integrations_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_integrations_multi ON public.solution_draft_integrations USING btree (solution_draft_id, integration_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_integrations_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_integrations_single ON public.solution_draft_integrations USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_licenses_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_licenses_multi ON public.solution_draft_licenses USING btree (solution_draft_id, license_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_licenses_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_licenses_single ON public.solution_draft_licenses USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_maintenance_statuses_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_maintenance_statuses_multi ON public.solution_draft_maintenance_statuses USING btree (solution_draft_id, maintenance_status_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_maintenance_statuses_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_maintenance_statuses_single ON public.solution_draft_maintenance_statuses USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_metadata_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_metadata_standards_multi ON public.solution_draft_metadata_standards USING btree (solution_draft_id, metadata_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_metadata_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_metadata_standards_single ON public.solution_draft_metadata_standards USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_metrics_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_metrics_standards_multi ON public.solution_draft_metrics_standards USING btree (solution_draft_id, metrics_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_metrics_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_metrics_standards_single ON public.solution_draft_metrics_standards USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_nonprofit_statuses_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_nonprofit_statuses_multi ON public.solution_draft_nonprofit_statuses USING btree (solution_draft_id, nonprofit_status_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_nonprofit_statuses_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_nonprofit_statuses_single ON public.solution_draft_nonprofit_statuses USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_persistent_identifier_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_persistent_identifier_standards_multi ON public.solution_draft_persistent_identifier_standards USING btree (solution_draft_id, persistent_identifier_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_persistent_identifier_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_persistent_identifier_standards_single ON public.solution_draft_persistent_identifier_standards USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_preservation_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_preservation_standards_multi ON public.solution_draft_preservation_standards USING btree (solution_draft_id, preservation_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_preservation_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_preservation_standards_single ON public.solution_draft_preservation_standards USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_primary_funding_sources_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_primary_funding_sources_multi ON public.solution_draft_primary_funding_sources USING btree (solution_draft_id, primary_funding_source_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_primary_funding_sources_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_primary_funding_sources_single ON public.solution_draft_primary_funding_sources USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_programming_languages_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_programming_languages_multi ON public.solution_draft_programming_languages USING btree (solution_draft_id, programming_language_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_programming_languages_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_programming_languages_single ON public.solution_draft_programming_languages USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_readiness_levels_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_readiness_levels_multi ON public.solution_draft_readiness_levels USING btree (solution_draft_id, readiness_level_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_readiness_levels_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_readiness_levels_single ON public.solution_draft_readiness_levels USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_reporting_levels_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_reporting_levels_multi ON public.solution_draft_reporting_levels USING btree (solution_draft_id, reporting_level_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_reporting_levels_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_reporting_levels_single ON public.solution_draft_reporting_levels USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_security_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_security_standards_multi ON public.solution_draft_security_standards USING btree (solution_draft_id, security_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_security_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_security_standards_single ON public.solution_draft_security_standards USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_staffings_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_staffings_multi ON public.solution_draft_staffings USING btree (solution_draft_id, staffing_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_staffings_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_staffings_single ON public.solution_draft_staffings USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_user_contributions_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_user_contributions_multi ON public.solution_draft_user_contributions USING btree (solution_draft_id, user_contribution_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_user_contributions_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_user_contributions_single ON public.solution_draft_user_contributions USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_draft_values_frameworks_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_values_frameworks_multi ON public.solution_draft_values_frameworks USING btree (solution_draft_id, values_framework_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_draft_values_frameworks_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_draft_values_frameworks_single ON public.solution_draft_values_frameworks USING btree (solution_draft_id, assoc) WHERE single;


--
-- Name: udx_solution_hosting_strategies_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_hosting_strategies_multi ON public.solution_hosting_strategies USING btree (solution_id, hosting_strategy_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_hosting_strategies_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_hosting_strategies_single ON public.solution_hosting_strategies USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_integrations_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_integrations_multi ON public.solution_integrations USING btree (solution_id, integration_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_integrations_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_integrations_single ON public.solution_integrations USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_licenses_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_licenses_multi ON public.solution_licenses USING btree (solution_id, license_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_licenses_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_licenses_single ON public.solution_licenses USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_maintenance_statuses_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_maintenance_statuses_multi ON public.solution_maintenance_statuses USING btree (solution_id, maintenance_status_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_maintenance_statuses_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_maintenance_statuses_single ON public.solution_maintenance_statuses USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_metadata_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_metadata_standards_multi ON public.solution_metadata_standards USING btree (solution_id, metadata_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_metadata_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_metadata_standards_single ON public.solution_metadata_standards USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_metrics_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_metrics_standards_multi ON public.solution_metrics_standards USING btree (solution_id, metrics_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_metrics_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_metrics_standards_single ON public.solution_metrics_standards USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_nonprofit_statuses_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_nonprofit_statuses_multi ON public.solution_nonprofit_statuses USING btree (solution_id, nonprofit_status_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_nonprofit_statuses_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_nonprofit_statuses_single ON public.solution_nonprofit_statuses USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_persistent_identifier_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_persistent_identifier_standards_multi ON public.solution_persistent_identifier_standards USING btree (solution_id, persistent_identifier_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_persistent_identifier_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_persistent_identifier_standards_single ON public.solution_persistent_identifier_standards USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_preservation_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_preservation_standards_multi ON public.solution_preservation_standards USING btree (solution_id, preservation_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_preservation_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_preservation_standards_single ON public.solution_preservation_standards USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_primary_funding_sources_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_primary_funding_sources_multi ON public.solution_primary_funding_sources USING btree (solution_id, primary_funding_source_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_primary_funding_sources_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_primary_funding_sources_single ON public.solution_primary_funding_sources USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_programming_languages_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_programming_languages_multi ON public.solution_programming_languages USING btree (solution_id, programming_language_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_programming_languages_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_programming_languages_single ON public.solution_programming_languages USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_readiness_levels_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_readiness_levels_multi ON public.solution_readiness_levels USING btree (solution_id, readiness_level_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_readiness_levels_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_readiness_levels_single ON public.solution_readiness_levels USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_reporting_levels_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_reporting_levels_multi ON public.solution_reporting_levels USING btree (solution_id, reporting_level_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_reporting_levels_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_reporting_levels_single ON public.solution_reporting_levels USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_security_standards_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_security_standards_multi ON public.solution_security_standards USING btree (solution_id, security_standard_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_security_standards_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_security_standards_single ON public.solution_security_standards USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_staffings_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_staffings_multi ON public.solution_staffings USING btree (solution_id, staffing_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_staffings_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_staffings_single ON public.solution_staffings USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_user_contributions_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_user_contributions_multi ON public.solution_user_contributions USING btree (solution_id, user_contribution_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_user_contributions_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_user_contributions_single ON public.solution_user_contributions USING btree (solution_id, assoc) WHERE single;


--
-- Name: udx_solution_values_frameworks_multi; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_values_frameworks_multi ON public.solution_values_frameworks USING btree (solution_id, values_framework_id, assoc) WHERE (NOT single);


--
-- Name: udx_solution_values_frameworks_single; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX udx_solution_values_frameworks_single ON public.solution_values_frameworks USING btree (solution_id, assoc) WHERE single;


--
-- Name: solution_draft_community_governances fk_rails_07798790cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_community_governances
    ADD CONSTRAINT fk_rails_07798790cb FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_draft_authentication_standards fk_rails_07923db27c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_authentication_standards
    ADD CONSTRAINT fk_rails_07923db27c FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_accessibility_scopes fk_rails_0c2c08a720; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_accessibility_scopes
    ADD CONSTRAINT fk_rails_0c2c08a720 FOREIGN KEY (accessibility_scope_id) REFERENCES public.accessibility_scopes(id) ON DELETE CASCADE;


--
-- Name: solution_category_links fk_rails_0ca6b07585; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_category_links
    ADD CONSTRAINT fk_rails_0ca6b07585 FOREIGN KEY (solution_category_id) REFERENCES public.solution_categories(id) ON DELETE CASCADE;


--
-- Name: solution_draft_board_structures fk_rails_0d6a7d2685; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_board_structures
    ADD CONSTRAINT fk_rails_0d6a7d2685 FOREIGN KEY (board_structure_id) REFERENCES public.board_structures(id) ON DELETE CASCADE;


--
-- Name: solution_community_engagement_activities fk_rails_0e89b57f6e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_community_engagement_activities
    ADD CONSTRAINT fk_rails_0e89b57f6e FOREIGN KEY (community_engagement_activity_id) REFERENCES public.community_engagement_activities(id) ON DELETE CASCADE;


--
-- Name: solution_board_structures fk_rails_0fcb78e654; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_board_structures
    ADD CONSTRAINT fk_rails_0fcb78e654 FOREIGN KEY (board_structure_id) REFERENCES public.board_structures(id) ON DELETE CASCADE;


--
-- Name: solution_draft_content_licenses fk_rails_1012558e31; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_content_licenses
    ADD CONSTRAINT fk_rails_1012558e31 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_draft_maintenance_statuses fk_rails_1019f633a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_maintenance_statuses
    ADD CONSTRAINT fk_rails_1019f633a9 FOREIGN KEY (maintenance_status_id) REFERENCES public.maintenance_statuses(id) ON DELETE CASCADE;


--
-- Name: solution_nonprofit_statuses fk_rails_10a66b590c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_nonprofit_statuses
    ADD CONSTRAINT fk_rails_10a66b590c FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_draft_metadata_standards fk_rails_10df1a09ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_metadata_standards
    ADD CONSTRAINT fk_rails_10df1a09ec FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_draft_business_forms fk_rails_13a4e705b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_business_forms
    ADD CONSTRAINT fk_rails_13a4e705b5 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_import_transitions fk_rails_14d9b58b8e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_import_transitions
    ADD CONSTRAINT fk_rails_14d9b58b8e FOREIGN KEY (solution_import_id) REFERENCES public.solution_imports(id) ON DELETE CASCADE;


--
-- Name: solution_metrics_standards fk_rails_1664361248; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_metrics_standards
    ADD CONSTRAINT fk_rails_1664361248 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_category_draft_links fk_rails_16e9f886f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_category_draft_links
    ADD CONSTRAINT fk_rails_16e9f886f1 FOREIGN KEY (solution_category_id) REFERENCES public.solution_categories(id) ON DELETE CASCADE;


--
-- Name: solution_programming_languages fk_rails_185ad16ab8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_programming_languages
    ADD CONSTRAINT fk_rails_185ad16ab8 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_category_links fk_rails_1be6c1a9bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_category_links
    ADD CONSTRAINT fk_rails_1be6c1a9bc FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_maintenance_statuses fk_rails_1c50e5d0a8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_maintenance_statuses
    ADD CONSTRAINT fk_rails_1c50e5d0a8 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_primary_funding_sources fk_rails_1c9dc51b64; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_primary_funding_sources
    ADD CONSTRAINT fk_rails_1c9dc51b64 FOREIGN KEY (primary_funding_source_id) REFERENCES public.primary_funding_sources(id) ON DELETE CASCADE;


--
-- Name: solution_draft_readiness_levels fk_rails_1d71312376; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_readiness_levels
    ADD CONSTRAINT fk_rails_1d71312376 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_draft_accessibility_scopes fk_rails_1ddc052973; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_accessibility_scopes
    ADD CONSTRAINT fk_rails_1ddc052973 FOREIGN KEY (accessibility_scope_id) REFERENCES public.accessibility_scopes(id) ON DELETE CASCADE;


--
-- Name: solution_maintenance_statuses fk_rails_1e9fba19ac; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_maintenance_statuses
    ADD CONSTRAINT fk_rails_1e9fba19ac FOREIGN KEY (maintenance_status_id) REFERENCES public.maintenance_statuses(id) ON DELETE CASCADE;


--
-- Name: solution_draft_persistent_identifier_standards fk_rails_1f919eaeba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_persistent_identifier_standards
    ADD CONSTRAINT fk_rails_1f919eaeba FOREIGN KEY (persistent_identifier_standard_id) REFERENCES public.persistent_identifier_standards(id) ON DELETE CASCADE;


--
-- Name: solution_draft_business_forms fk_rails_20734c00fb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_business_forms
    ADD CONSTRAINT fk_rails_20734c00fb FOREIGN KEY (business_form_id) REFERENCES public.business_forms(id) ON DELETE CASCADE;


--
-- Name: solution_draft_accessibility_scopes fk_rails_208a2f36e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_accessibility_scopes
    ADD CONSTRAINT fk_rails_208a2f36e3 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solutions fk_rails_25e1f3faa1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_25e1f3faa1 FOREIGN KEY (phase_1_community_governance_id) REFERENCES public.community_governances(id) ON DELETE RESTRICT;


--
-- Name: solution_editor_assignments fk_rails_2a45cfef5e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_editor_assignments
    ADD CONSTRAINT fk_rails_2a45cfef5e FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE RESTRICT;


--
-- Name: invitations fk_rails_2a8e93f297; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_2a8e93f297 FOREIGN KEY (provider_id) REFERENCES public.providers(id) ON DELETE CASCADE;


--
-- Name: solution_draft_community_engagement_activities fk_rails_2af0559c4a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_community_engagement_activities
    ADD CONSTRAINT fk_rails_2af0559c4a FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_2eda529d66; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_2eda529d66 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: solution_draft_board_structures fk_rails_3249830b6b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_board_structures
    ADD CONSTRAINT fk_rails_3249830b6b FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_staffings fk_rails_34006937dc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_staffings
    ADD CONSTRAINT fk_rails_34006937dc FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_revisions fk_rails_3737f05d80; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_revisions
    ADD CONSTRAINT fk_rails_3737f05d80 FOREIGN KEY (snapshot_id) REFERENCES public.snapshots(id) ON DELETE SET NULL;


--
-- Name: invitation_transitions fk_rails_377ab08668; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitation_transitions
    ADD CONSTRAINT fk_rails_377ab08668 FOREIGN KEY (invitation_id) REFERENCES public.invitations(id) ON DELETE CASCADE;


--
-- Name: solution_content_licenses fk_rails_3c49afced2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_content_licenses
    ADD CONSTRAINT fk_rails_3c49afced2 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_revisions fk_rails_4081750da4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_revisions
    ADD CONSTRAINT fk_rails_4081750da4 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE SET NULL;


--
-- Name: solution_draft_maintenance_statuses fk_rails_416f518fc6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_maintenance_statuses
    ADD CONSTRAINT fk_rails_416f518fc6 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_user_contributions fk_rails_4195bf7ce7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_user_contributions
    ADD CONSTRAINT fk_rails_4195bf7ce7 FOREIGN KEY (user_contribution_id) REFERENCES public.user_contributions(id) ON DELETE CASCADE;


--
-- Name: solution_primary_funding_sources fk_rails_44cf17a7f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_primary_funding_sources
    ADD CONSTRAINT fk_rails_44cf17a7f6 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_draft_hosting_strategies fk_rails_46367c0765; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_hosting_strategies
    ADD CONSTRAINT fk_rails_46367c0765 FOREIGN KEY (hosting_strategy_id) REFERENCES public.hosting_strategies(id) ON DELETE CASCADE;


--
-- Name: solution_user_contributions fk_rails_4642c0eaf4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_user_contributions
    ADD CONSTRAINT fk_rails_4642c0eaf4 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_496e0d601c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_496e0d601c FOREIGN KEY (phase_1_community_governance_id) REFERENCES public.community_governances(id) ON DELETE RESTRICT;


--
-- Name: solution_draft_nonprofit_statuses fk_rails_499fb46de6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_nonprofit_statuses
    ADD CONSTRAINT fk_rails_499fb46de6 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: users_roles fk_rails_4a41696df6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT fk_rails_4a41696df6 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: solution_draft_reporting_levels fk_rails_4e11fcb854; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_reporting_levels
    ADD CONSTRAINT fk_rails_4e11fcb854 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_content_licenses fk_rails_50b3b2085f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_content_licenses
    ADD CONSTRAINT fk_rails_50b3b2085f FOREIGN KEY (content_license_id) REFERENCES public.content_licenses(id) ON DELETE CASCADE;


--
-- Name: solution_accessibility_scopes fk_rails_5187268b1c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_accessibility_scopes
    ADD CONSTRAINT fk_rails_5187268b1c FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solutions fk_rails_522f0b764c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_522f0b764c FOREIGN KEY (phase_1_readiness_level_id) REFERENCES public.readiness_levels(id) ON DELETE RESTRICT;


--
-- Name: solution_draft_preservation_standards fk_rails_528a826e0d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_preservation_standards
    ADD CONSTRAINT fk_rails_528a826e0d FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_nonprofit_statuses fk_rails_53ebbbe4f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_nonprofit_statuses
    ADD CONSTRAINT fk_rails_53ebbbe4f8 FOREIGN KEY (nonprofit_status_id) REFERENCES public.nonprofit_statuses(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_57b1e3753d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_57b1e3753d FOREIGN KEY (phase_1_primary_funding_source_id) REFERENCES public.primary_funding_sources(id) ON DELETE RESTRICT;


--
-- Name: solutions fk_rails_57bffcae2d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_57bffcae2d FOREIGN KEY (phase_1_hosting_strategy_id) REFERENCES public.hosting_strategies(id) ON DELETE RESTRICT;


--
-- Name: solution_security_standards fk_rails_59fc726812; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_security_standards
    ADD CONSTRAINT fk_rails_59fc726812 FOREIGN KEY (security_standard_id) REFERENCES public.security_standards(id) ON DELETE CASCADE;


--
-- Name: solution_licenses fk_rails_5a0b4e7775; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_licenses
    ADD CONSTRAINT fk_rails_5a0b4e7775 FOREIGN KEY (license_id) REFERENCES public.licenses(id) ON DELETE CASCADE;


--
-- Name: solution_draft_programming_languages fk_rails_5a874d5703; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_programming_languages
    ADD CONSTRAINT fk_rails_5a874d5703 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_5b8c678d1e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_5b8c678d1e FOREIGN KEY (phase_1_readiness_level_id) REFERENCES public.readiness_levels(id) ON DELETE RESTRICT;


--
-- Name: solution_persistent_identifier_standards fk_rails_5bd22e4323; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_persistent_identifier_standards
    ADD CONSTRAINT fk_rails_5bd22e4323 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_draft_primary_funding_sources fk_rails_614e311856; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_primary_funding_sources
    ADD CONSTRAINT fk_rails_614e311856 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_revisions fk_rails_64c472c54c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_revisions
    ADD CONSTRAINT fk_rails_64c472c54c FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: solution_draft_hosting_strategies fk_rails_66e3788d52; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_hosting_strategies
    ADD CONSTRAINT fk_rails_66e3788d52 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_draft_community_governances fk_rails_685722192d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_community_governances
    ADD CONSTRAINT fk_rails_685722192d FOREIGN KEY (community_governance_id) REFERENCES public.community_governances(id) ON DELETE CASCADE;


--
-- Name: solution_hosting_strategies fk_rails_68eed1d3fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_hosting_strategies
    ADD CONSTRAINT fk_rails_68eed1d3fc FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_draft_integrations fk_rails_6cfe5f279e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_integrations
    ADD CONSTRAINT fk_rails_6cfe5f279e FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_category_draft_links fk_rails_733215f1ae; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_category_draft_links
    ADD CONSTRAINT fk_rails_733215f1ae FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solutions fk_rails_73c7b0a3ae; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_73c7b0a3ae FOREIGN KEY (phase_1_maintenance_status_id) REFERENCES public.maintenance_statuses(id) ON DELETE RESTRICT;


--
-- Name: solution_draft_community_engagement_activities fk_rails_74990b81fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_community_engagement_activities
    ADD CONSTRAINT fk_rails_74990b81fc FOREIGN KEY (community_engagement_activity_id) REFERENCES public.community_engagement_activities(id) ON DELETE CASCADE;


--
-- Name: solution_programming_languages fk_rails_7673528d0a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_programming_languages
    ADD CONSTRAINT fk_rails_7673528d0a FOREIGN KEY (programming_language_id) REFERENCES public.programming_languages(id) ON DELETE CASCADE;


--
-- Name: solution_integrations fk_rails_79073ac813; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_integrations
    ADD CONSTRAINT fk_rails_79073ac813 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


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
-- Name: solution_draft_reporting_levels fk_rails_7c4d58c2ad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_reporting_levels
    ADD CONSTRAINT fk_rails_7c4d58c2ad FOREIGN KEY (reporting_level_id) REFERENCES public.reporting_levels(id) ON DELETE CASCADE;


--
-- Name: solution_draft_preservation_standards fk_rails_7ccd99eb55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_preservation_standards
    ADD CONSTRAINT fk_rails_7ccd99eb55 FOREIGN KEY (preservation_standard_id) REFERENCES public.preservation_standards(id) ON DELETE CASCADE;


--
-- Name: solution_draft_licenses fk_rails_7e7ad198c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_licenses
    ADD CONSTRAINT fk_rails_7e7ad198c7 FOREIGN KEY (license_id) REFERENCES public.licenses(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_7e91bf84ef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_7e91bf84ef FOREIGN KEY (phase_1_maintenance_status_id) REFERENCES public.maintenance_statuses(id) ON DELETE RESTRICT;


--
-- Name: invitations fk_rails_7eae413fe6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_7eae413fe6 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: solution_authentication_standards fk_rails_7f74f35c2a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_authentication_standards
    ADD CONSTRAINT fk_rails_7f74f35c2a FOREIGN KEY (authentication_standard_id) REFERENCES public.authentication_standards(id) ON DELETE CASCADE;


--
-- Name: comparison_share_items fk_rails_7fdf8277aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comparison_share_items
    ADD CONSTRAINT fk_rails_7fdf8277aa FOREIGN KEY (comparison_share_id) REFERENCES public.comparison_shares(id) ON DELETE CASCADE;


--
-- Name: solution_draft_security_standards fk_rails_837f6d3800; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_security_standards
    ADD CONSTRAINT fk_rails_837f6d3800 FOREIGN KEY (security_standard_id) REFERENCES public.security_standards(id) ON DELETE CASCADE;


--
-- Name: solutions fk_rails_84c054e1eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_84c054e1eb FOREIGN KEY (provider_id) REFERENCES public.providers(id) ON DELETE RESTRICT;


--
-- Name: solution_revisions fk_rails_8520c87162; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_revisions
    ADD CONSTRAINT fk_rails_8520c87162 FOREIGN KEY (provider_id) REFERENCES public.providers(id) ON DELETE SET NULL;


--
-- Name: solution_reporting_levels fk_rails_878f5a3eff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_reporting_levels
    ADD CONSTRAINT fk_rails_878f5a3eff FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_security_standards fk_rails_8997e6fa8b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_security_standards
    ADD CONSTRAINT fk_rails_8997e6fa8b FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_metadata_standards fk_rails_8bd7a107b0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_metadata_standards
    ADD CONSTRAINT fk_rails_8bd7a107b0 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_draft_transitions fk_rails_8d1bd9f228; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_transitions
    ADD CONSTRAINT fk_rails_8d1bd9f228 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_draft_persistent_identifier_standards fk_rails_908287340a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_persistent_identifier_standards
    ADD CONSTRAINT fk_rails_908287340a FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: provider_editor_assignments fk_rails_94f5b94419; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_editor_assignments
    ADD CONSTRAINT fk_rails_94f5b94419 FOREIGN KEY (provider_id) REFERENCES public.providers(id) ON DELETE RESTRICT;


--
-- Name: solution_draft_staffings fk_rails_9578850529; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_staffings
    ADD CONSTRAINT fk_rails_9578850529 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_readiness_levels fk_rails_96b3a498a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_readiness_levels
    ADD CONSTRAINT fk_rails_96b3a498a7 FOREIGN KEY (readiness_level_id) REFERENCES public.readiness_levels(id) ON DELETE CASCADE;


--
-- Name: solution_community_engagement_activities fk_rails_9b4ffde830; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_community_engagement_activities
    ADD CONSTRAINT fk_rails_9b4ffde830 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_draft_nonprofit_statuses fk_rails_9c295dbf4c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_nonprofit_statuses
    ADD CONSTRAINT fk_rails_9c295dbf4c FOREIGN KEY (nonprofit_status_id) REFERENCES public.nonprofit_statuses(id) ON DELETE CASCADE;


--
-- Name: solution_draft_readiness_levels fk_rails_9c516f9c60; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_readiness_levels
    ADD CONSTRAINT fk_rails_9c516f9c60 FOREIGN KEY (readiness_level_id) REFERENCES public.readiness_levels(id) ON DELETE CASCADE;


--
-- Name: solution_readiness_levels fk_rails_9dc00e4b6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_readiness_levels
    ADD CONSTRAINT fk_rails_9dc00e4b6a FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: comparison_share_items fk_rails_9df2127bc4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comparison_share_items
    ADD CONSTRAINT fk_rails_9df2127bc4 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_persistent_identifier_standards fk_rails_9f0efe5c15; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_persistent_identifier_standards
    ADD CONSTRAINT fk_rails_9f0efe5c15 FOREIGN KEY (persistent_identifier_standard_id) REFERENCES public.persistent_identifier_standards(id) ON DELETE CASCADE;


--
-- Name: taggings fk_rails_9fcd2e236b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT fk_rails_9fcd2e236b FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- Name: solution_draft_programming_languages fk_rails_a1841518b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_programming_languages
    ADD CONSTRAINT fk_rails_a1841518b7 FOREIGN KEY (programming_language_id) REFERENCES public.programming_languages(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_a937b670c8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_a937b670c8 FOREIGN KEY (phase_1_business_form_id) REFERENCES public.business_forms(id) ON DELETE RESTRICT;


--
-- Name: solution_draft_values_frameworks fk_rails_b02a77e849; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_values_frameworks
    ADD CONSTRAINT fk_rails_b02a77e849 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_community_governances fk_rails_b06a8f1fb1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_community_governances
    ADD CONSTRAINT fk_rails_b06a8f1fb1 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: comparison_items fk_rails_b0877dc5c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comparison_items
    ADD CONSTRAINT fk_rails_b0877dc5c7 FOREIGN KEY (comparison_id) REFERENCES public.comparisons(id) ON DELETE CASCADE;


--
-- Name: solution_metrics_standards fk_rails_b16c6d5c49; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_metrics_standards
    ADD CONSTRAINT fk_rails_b16c6d5c49 FOREIGN KEY (metrics_standard_id) REFERENCES public.metrics_standards(id) ON DELETE CASCADE;


--
-- Name: solution_draft_user_contributions fk_rails_b604ad2471; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_user_contributions
    ADD CONSTRAINT fk_rails_b604ad2471 FOREIGN KEY (user_contribution_id) REFERENCES public.user_contributions(id) ON DELETE CASCADE;


--
-- Name: solution_business_forms fk_rails_b72a0ecbdb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_business_forms
    ADD CONSTRAINT fk_rails_b72a0ecbdb FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_authentication_standards fk_rails_b7b7c1db7d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_authentication_standards
    ADD CONSTRAINT fk_rails_b7b7c1db7d FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_hosting_strategies fk_rails_bab15c6db8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_hosting_strategies
    ADD CONSTRAINT fk_rails_bab15c6db8 FOREIGN KEY (hosting_strategy_id) REFERENCES public.hosting_strategies(id) ON DELETE CASCADE;


--
-- Name: solution_draft_metadata_standards fk_rails_bb19a03fc7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_metadata_standards
    ADD CONSTRAINT fk_rails_bb19a03fc7 FOREIGN KEY (metadata_standard_id) REFERENCES public.metadata_standards(id) ON DELETE CASCADE;


--
-- Name: subscription_transitions fk_rails_bc86ba57c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_transitions
    ADD CONSTRAINT fk_rails_bc86ba57c7 FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id) ON DELETE CASCADE;


--
-- Name: solution_draft_content_licenses fk_rails_be3a5110c9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_content_licenses
    ADD CONSTRAINT fk_rails_be3a5110c9 FOREIGN KEY (content_license_id) REFERENCES public.content_licenses(id) ON DELETE CASCADE;


--
-- Name: solution_draft_metrics_standards fk_rails_be8337f63f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_metrics_standards
    ADD CONSTRAINT fk_rails_be8337f63f FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_bf7a540f25; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_bf7a540f25 FOREIGN KEY (phase_1_hosting_strategy_id) REFERENCES public.hosting_strategies(id) ON DELETE RESTRICT;


--
-- Name: solutions fk_rails_c3189e0953; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_c3189e0953 FOREIGN KEY (phase_1_board_structure_id) REFERENCES public.board_structures(id) ON DELETE RESTRICT;


--
-- Name: solutions fk_rails_c35caf4647; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_c35caf4647 FOREIGN KEY (phase_1_business_form_id) REFERENCES public.business_forms(id) ON DELETE RESTRICT;


--
-- Name: solution_values_frameworks fk_rails_c39a93b2b2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_values_frameworks
    ADD CONSTRAINT fk_rails_c39a93b2b2 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_draft_user_contributions fk_rails_c74d8d1a1b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_user_contributions
    ADD CONSTRAINT fk_rails_c74d8d1a1b FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_draft_metrics_standards fk_rails_cb04600be4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_metrics_standards
    ADD CONSTRAINT fk_rails_cb04600be4 FOREIGN KEY (metrics_standard_id) REFERENCES public.metrics_standards(id) ON DELETE CASCADE;


--
-- Name: invitations fk_rails_cb5fd998bd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_cb5fd998bd FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: solution_draft_primary_funding_sources fk_rails_d0ded8820f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_primary_funding_sources
    ADD CONSTRAINT fk_rails_d0ded8820f FOREIGN KEY (primary_funding_source_id) REFERENCES public.primary_funding_sources(id) ON DELETE CASCADE;


--
-- Name: solution_drafts fk_rails_d15fd7352a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_drafts
    ADD CONSTRAINT fk_rails_d15fd7352a FOREIGN KEY (phase_1_board_structure_id) REFERENCES public.board_structures(id) ON DELETE RESTRICT;


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
-- Name: solution_board_structures fk_rails_d53d13de17; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_board_structures
    ADD CONSTRAINT fk_rails_d53d13de17 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_draft_values_frameworks fk_rails_d5c238e008; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_values_frameworks
    ADD CONSTRAINT fk_rails_d5c238e008 FOREIGN KEY (values_framework_id) REFERENCES public.values_frameworks(id) ON DELETE CASCADE;


--
-- Name: solution_values_frameworks fk_rails_d729cfd728; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_values_frameworks
    ADD CONSTRAINT fk_rails_d729cfd728 FOREIGN KEY (values_framework_id) REFERENCES public.values_frameworks(id) ON DELETE CASCADE;


--
-- Name: solution_community_governances fk_rails_d732fc2d31; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_community_governances
    ADD CONSTRAINT fk_rails_d732fc2d31 FOREIGN KEY (community_governance_id) REFERENCES public.community_governances(id) ON DELETE CASCADE;


--
-- Name: solutions fk_rails_d7b00384c2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solutions
    ADD CONSTRAINT fk_rails_d7b00384c2 FOREIGN KEY (phase_1_primary_funding_source_id) REFERENCES public.primary_funding_sources(id) ON DELETE RESTRICT;


--
-- Name: solution_draft_staffings fk_rails_da8213030d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_staffings
    ADD CONSTRAINT fk_rails_da8213030d FOREIGN KEY (staffing_id) REFERENCES public.staffings(id) ON DELETE CASCADE;


--
-- Name: solution_reporting_levels fk_rails_de54e3f5f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_reporting_levels
    ADD CONSTRAINT fk_rails_de54e3f5f0 FOREIGN KEY (reporting_level_id) REFERENCES public.reporting_levels(id) ON DELETE CASCADE;


--
-- Name: solution_draft_licenses fk_rails_dfcfc51119; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_licenses
    ADD CONSTRAINT fk_rails_dfcfc51119 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_draft_authentication_standards fk_rails_e0aa18621d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_authentication_standards
    ADD CONSTRAINT fk_rails_e0aa18621d FOREIGN KEY (authentication_standard_id) REFERENCES public.authentication_standards(id) ON DELETE CASCADE;


--
-- Name: solution_staffings fk_rails_e28f9dbbd5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_staffings
    ADD CONSTRAINT fk_rails_e28f9dbbd5 FOREIGN KEY (staffing_id) REFERENCES public.staffings(id) ON DELETE CASCADE;


--
-- Name: solution_revisions fk_rails_e7b83e2c6e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_revisions
    ADD CONSTRAINT fk_rails_e7b83e2c6e FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_licenses fk_rails_e892108205; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_licenses
    ADD CONSTRAINT fk_rails_e892108205 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: provider_editor_assignments fk_rails_e8f22619c6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_editor_assignments
    ADD CONSTRAINT fk_rails_e8f22619c6 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: users_roles fk_rails_eb7b4658f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT fk_rails_eb7b4658f8 FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: solution_draft_security_standards fk_rails_ec4adfd750; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_security_standards
    ADD CONSTRAINT fk_rails_ec4adfd750 FOREIGN KEY (solution_draft_id) REFERENCES public.solution_drafts(id) ON DELETE CASCADE;


--
-- Name: solution_integrations fk_rails_f1ac4084b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_integrations
    ADD CONSTRAINT fk_rails_f1ac4084b4 FOREIGN KEY (integration_id) REFERENCES public.integrations(id) ON DELETE CASCADE;


--
-- Name: user_transitions fk_rails_f626c47310; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_transitions
    ADD CONSTRAINT fk_rails_f626c47310 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: solution_preservation_standards fk_rails_f849952176; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_preservation_standards
    ADD CONSTRAINT fk_rails_f849952176 FOREIGN KEY (preservation_standard_id) REFERENCES public.preservation_standards(id) ON DELETE CASCADE;


--
-- Name: solution_metadata_standards fk_rails_f9c6b2031e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_metadata_standards
    ADD CONSTRAINT fk_rails_f9c6b2031e FOREIGN KEY (metadata_standard_id) REFERENCES public.metadata_standards(id) ON DELETE CASCADE;


--
-- Name: solution_business_forms fk_rails_fab81acb84; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_business_forms
    ADD CONSTRAINT fk_rails_fab81acb84 FOREIGN KEY (business_form_id) REFERENCES public.business_forms(id) ON DELETE CASCADE;


--
-- Name: solution_preservation_standards fk_rails_fba1bc1da1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_preservation_standards
    ADD CONSTRAINT fk_rails_fba1bc1da1 FOREIGN KEY (solution_id) REFERENCES public.solutions(id) ON DELETE CASCADE;


--
-- Name: solution_draft_integrations fk_rails_fee9c6ba03; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solution_draft_integrations
    ADD CONSTRAINT fk_rails_fee9c6ba03 FOREIGN KEY (integration_id) REFERENCES public.integrations(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240909171553'),
('20240909171445'),
('20240829191102'),
('20240829191007'),
('20240829183351'),
('20240822202129'),
('20240822182549'),
('20240822182356'),
('20240822162633'),
('20240820161128'),
('20240802183019'),
('20240731204910'),
('20240729171330'),
('20240422160207'),
('20240417214156'),
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

