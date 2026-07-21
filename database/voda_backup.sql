--
-- PostgreSQL database dump
--

\restrict FcUKc6eY6yIEr7uxZFACoWWzqtcTaqgHfw8BjdbFNQOSbPFCc6Ab8TLPhoyFJ7O

-- Dumped from database version 16.14
-- Dumped by pg_dump version 16.14

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity_types; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.activity_types (
    id uuid NOT NULL,
    name character varying(255),
    slug character varying(255),
    description text,
    status character varying(255)
);


ALTER TABLE public.activity_types OWNER TO voda;

--
-- Name: articles; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.articles (
    id uuid NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying,
    title character varying(255),
    slug character varying(255),
    featured_image uuid,
    publish_date timestamp without time zone DEFAULT '2026-07-17 07:31:13.486591'::timestamp without time zone,
    ads json,
    seo json,
    content text
);


ALTER TABLE public.articles OWNER TO voda;

--
-- Name: destinations; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.destinations (
    id uuid NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    name character varying(255),
    slug character varying(255) DEFAULT NULL::character varying,
    description text,
    image uuid,
    region_id uuid,
    gallery json
);


ALTER TABLE public.destinations OWNER TO voda;

--
-- Name: directus_access; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_access (
    id uuid NOT NULL,
    role uuid,
    "user" uuid,
    policy uuid NOT NULL,
    sort integer
);


ALTER TABLE public.directus_access OWNER TO voda;

--
-- Name: directus_activity; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_activity (
    id integer NOT NULL,
    action character varying(45) NOT NULL,
    "user" uuid,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip character varying(50),
    user_agent text,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    origin character varying(255)
);


ALTER TABLE public.directus_activity OWNER TO voda;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: voda
--

CREATE SEQUENCE public.directus_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_activity_id_seq OWNER TO voda;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voda
--

ALTER SEQUENCE public.directus_activity_id_seq OWNED BY public.directus_activity.id;


--
-- Name: directus_collections; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_collections (
    collection character varying(64) NOT NULL,
    icon character varying(64),
    note text,
    display_template character varying(255),
    hidden boolean DEFAULT false NOT NULL,
    singleton boolean DEFAULT false NOT NULL,
    translations json,
    archive_field character varying(64),
    archive_app_filter boolean DEFAULT true NOT NULL,
    archive_value character varying(255),
    unarchive_value character varying(255),
    sort_field character varying(64),
    accountability character varying(255) DEFAULT 'all'::character varying,
    color character varying(255),
    item_duplication_fields json,
    sort integer,
    "group" character varying(64),
    collapse character varying(255) DEFAULT 'open'::character varying NOT NULL,
    preview_url character varying(255),
    versioning boolean DEFAULT false NOT NULL,
    status character varying(255) DEFAULT 'active'::character varying NOT NULL,
    autosave_revision_interval real
);


ALTER TABLE public.directus_collections OWNER TO voda;

--
-- Name: directus_comments; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_comments (
    id uuid NOT NULL,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    comment text NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.directus_comments OWNER TO voda;

--
-- Name: directus_dashboards; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_dashboards (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(64) DEFAULT 'dashboard'::character varying NOT NULL,
    note text,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    color character varying(255)
);


ALTER TABLE public.directus_dashboards OWNER TO voda;

--
-- Name: directus_deployment_projects; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_deployment_projects (
    id uuid NOT NULL,
    deployment uuid NOT NULL,
    external_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    url character varying(255),
    framework character varying(255),
    deployable boolean DEFAULT true NOT NULL
);


ALTER TABLE public.directus_deployment_projects OWNER TO voda;

--
-- Name: directus_deployment_runs; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_deployment_runs (
    id uuid NOT NULL,
    project uuid NOT NULL,
    external_id character varying(255) NOT NULL,
    target character varying(255) NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    status character varying(255),
    url character varying(255),
    started_at timestamp with time zone,
    completed_at timestamp with time zone
);


ALTER TABLE public.directus_deployment_runs OWNER TO voda;

--
-- Name: directus_deployments; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_deployments (
    id uuid NOT NULL,
    provider character varying(255) NOT NULL,
    credentials text,
    options text,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    webhook_ids json,
    webhook_secret character varying(255),
    last_synced_at timestamp with time zone
);


ALTER TABLE public.directus_deployments OWNER TO voda;

--
-- Name: directus_extensions; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_extensions (
    enabled boolean DEFAULT true NOT NULL,
    id uuid NOT NULL,
    folder character varying(255) NOT NULL,
    source character varying(255) NOT NULL,
    bundle uuid
);


ALTER TABLE public.directus_extensions OWNER TO voda;

--
-- Name: directus_fields; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_fields (
    id integer NOT NULL,
    collection character varying(64) NOT NULL,
    field character varying(64) NOT NULL,
    special character varying(64),
    interface character varying(64),
    options json,
    display character varying(64),
    display_options json,
    readonly boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    sort integer,
    width character varying(30) DEFAULT 'full'::character varying,
    translations json,
    note text,
    conditions json,
    required boolean DEFAULT false,
    "group" character varying(64),
    validation json,
    validation_message text,
    searchable boolean DEFAULT true NOT NULL
);


ALTER TABLE public.directus_fields OWNER TO voda;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: voda
--

CREATE SEQUENCE public.directus_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_fields_id_seq OWNER TO voda;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voda
--

ALTER SEQUENCE public.directus_fields_id_seq OWNED BY public.directus_fields.id;


--
-- Name: directus_files; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_files (
    id uuid NOT NULL,
    storage character varying(255) NOT NULL,
    filename_disk character varying(255),
    filename_download character varying(255) NOT NULL,
    title character varying(255),
    type character varying(255),
    folder uuid,
    uploaded_by uuid,
    created_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by uuid,
    modified_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    charset character varying(50),
    filesize bigint,
    width integer,
    height integer,
    duration integer,
    embed character varying(200),
    description text,
    location text,
    tags text,
    metadata json,
    focal_point_x integer,
    focal_point_y integer,
    tus_id character varying(64),
    tus_data json,
    uploaded_on timestamp with time zone
);


ALTER TABLE public.directus_files OWNER TO voda;

--
-- Name: directus_flows; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_flows (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(64),
    color character varying(255),
    description text,
    status character varying(255) DEFAULT 'active'::character varying NOT NULL,
    trigger character varying(255),
    accountability character varying(255) DEFAULT 'all'::character varying,
    options json,
    operation uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_flows OWNER TO voda;

--
-- Name: directus_folders; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_folders (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    parent uuid
);


ALTER TABLE public.directus_folders OWNER TO voda;

--
-- Name: directus_migrations; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_migrations (
    version character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.directus_migrations OWNER TO voda;

--
-- Name: directus_notifications; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_notifications (
    id integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(255) DEFAULT 'inbox'::character varying,
    recipient uuid NOT NULL,
    sender uuid,
    subject character varying(255) NOT NULL,
    message text,
    collection character varying(64),
    item character varying(255)
);


ALTER TABLE public.directus_notifications OWNER TO voda;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: voda
--

CREATE SEQUENCE public.directus_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_notifications_id_seq OWNER TO voda;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voda
--

ALTER SEQUENCE public.directus_notifications_id_seq OWNED BY public.directus_notifications.id;


--
-- Name: directus_oauth_clients; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_oauth_clients (
    client_id character varying(255) NOT NULL,
    client_name character varying(200) NOT NULL,
    redirect_uris json NOT NULL,
    grant_types json NOT NULL,
    token_endpoint_auth_method character varying(255) DEFAULT 'none'::character varying NOT NULL,
    client_secret_hash character varying(64),
    registration_type character varying(10) DEFAULT 'dcr'::character varying NOT NULL,
    client_uri text,
    logo_uri text,
    tos_uri text,
    policy_uri text,
    metadata_fetched_at timestamp with time zone,
    metadata_expires_at timestamp with time zone,
    metadata_etag character varying(255),
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.directus_oauth_clients OWNER TO voda;

--
-- Name: directus_oauth_codes; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_oauth_codes (
    id uuid NOT NULL,
    code_hash character varying(64) NOT NULL,
    client character varying(255) NOT NULL,
    "user" uuid NOT NULL,
    redirect_uri character varying(255) NOT NULL,
    resource character varying(255) NOT NULL,
    code_challenge character varying(128) NOT NULL,
    code_challenge_method character varying(10) NOT NULL,
    scope character varying(255),
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone
);


ALTER TABLE public.directus_oauth_codes OWNER TO voda;

--
-- Name: directus_oauth_consents; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_oauth_consents (
    id uuid NOT NULL,
    "user" uuid NOT NULL,
    client character varying(255) NOT NULL,
    redirect_uri character varying(255) NOT NULL,
    scope character varying(255),
    date_created timestamp with time zone NOT NULL,
    date_updated timestamp with time zone NOT NULL
);


ALTER TABLE public.directus_oauth_consents OWNER TO voda;

--
-- Name: directus_oauth_tokens; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_oauth_tokens (
    id uuid NOT NULL,
    client character varying(255) NOT NULL,
    "user" uuid NOT NULL,
    session character varying(64) NOT NULL,
    previous_session character varying(64),
    resource character varying(255) NOT NULL,
    code_hash character varying(64) NOT NULL,
    scope character varying(255),
    expires_at timestamp with time zone NOT NULL,
    date_created timestamp with time zone NOT NULL
);


ALTER TABLE public.directus_oauth_tokens OWNER TO voda;

--
-- Name: directus_operations; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_operations (
    id uuid NOT NULL,
    name character varying(255),
    key character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    options json,
    resolve uuid,
    reject uuid,
    flow uuid NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_operations OWNER TO voda;

--
-- Name: directus_panels; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_panels (
    id uuid NOT NULL,
    dashboard uuid NOT NULL,
    name character varying(255),
    icon character varying(64) DEFAULT NULL::character varying,
    color character varying(10),
    show_header boolean DEFAULT false NOT NULL,
    note text,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    options json,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_panels OWNER TO voda;

--
-- Name: directus_permissions; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_permissions (
    id integer NOT NULL,
    collection character varying(64) NOT NULL,
    action character varying(10) NOT NULL,
    permissions json,
    validation json,
    presets json,
    fields text,
    policy uuid NOT NULL
);


ALTER TABLE public.directus_permissions OWNER TO voda;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: voda
--

CREATE SEQUENCE public.directus_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_permissions_id_seq OWNER TO voda;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voda
--

ALTER SEQUENCE public.directus_permissions_id_seq OWNED BY public.directus_permissions.id;


--
-- Name: directus_policies; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_policies (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(64) DEFAULT 'badge'::character varying NOT NULL,
    description text,
    ip_access text,
    enforce_tfa boolean DEFAULT false NOT NULL,
    admin_access boolean DEFAULT false NOT NULL,
    app_access boolean DEFAULT false NOT NULL
);


ALTER TABLE public.directus_policies OWNER TO voda;

--
-- Name: directus_presets; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_presets (
    id integer NOT NULL,
    bookmark character varying(255),
    "user" uuid,
    role uuid,
    collection character varying(64),
    search character varying(100),
    layout character varying(100) DEFAULT 'tabular'::character varying,
    layout_query json,
    layout_options json,
    refresh_interval integer,
    filter json,
    icon character varying(64) DEFAULT 'bookmark'::character varying,
    color character varying(255)
);


ALTER TABLE public.directus_presets OWNER TO voda;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE; Schema: public; Owner: voda
--

CREATE SEQUENCE public.directus_presets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_presets_id_seq OWNER TO voda;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voda
--

ALTER SEQUENCE public.directus_presets_id_seq OWNED BY public.directus_presets.id;


--
-- Name: directus_relations; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_relations (
    id integer NOT NULL,
    many_collection character varying(64) NOT NULL,
    many_field character varying(64) NOT NULL,
    one_collection character varying(64),
    one_field character varying(64),
    one_collection_field character varying(64),
    one_allowed_collections text,
    junction_field character varying(64),
    sort_field character varying(64),
    one_deselect_action character varying(255) DEFAULT 'nullify'::character varying NOT NULL
);


ALTER TABLE public.directus_relations OWNER TO voda;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: voda
--

CREATE SEQUENCE public.directus_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_relations_id_seq OWNER TO voda;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voda
--

ALTER SEQUENCE public.directus_relations_id_seq OWNED BY public.directus_relations.id;


--
-- Name: directus_revisions; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_revisions (
    id integer NOT NULL,
    activity integer NOT NULL,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    data json,
    delta json,
    parent integer,
    version uuid
);


ALTER TABLE public.directus_revisions OWNER TO voda;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: voda
--

CREATE SEQUENCE public.directus_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_revisions_id_seq OWNER TO voda;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voda
--

ALTER SEQUENCE public.directus_revisions_id_seq OWNED BY public.directus_revisions.id;


--
-- Name: directus_roles; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_roles (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(64) DEFAULT 'supervised_user_circle'::character varying NOT NULL,
    description text,
    parent uuid
);


ALTER TABLE public.directus_roles OWNER TO voda;

--
-- Name: directus_sessions; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_sessions (
    token character varying(64) NOT NULL,
    "user" uuid,
    expires timestamp with time zone NOT NULL,
    ip character varying(255),
    user_agent text,
    share uuid,
    origin character varying(255),
    next_token character varying(64),
    oauth_client character varying(255)
);


ALTER TABLE public.directus_sessions OWNER TO voda;

--
-- Name: directus_settings; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_settings (
    id integer NOT NULL,
    project_name character varying(100) DEFAULT 'Directus'::character varying NOT NULL,
    project_url character varying(255),
    project_color character varying(255) DEFAULT '#6644FF'::character varying NOT NULL,
    project_logo uuid,
    public_foreground uuid,
    public_background uuid,
    public_note text,
    auth_login_attempts integer DEFAULT 25,
    auth_password_policy character varying(100),
    storage_asset_transform character varying(7) DEFAULT 'all'::character varying,
    storage_asset_presets json,
    custom_css text,
    storage_default_folder uuid,
    basemaps json,
    mapbox_key character varying(255),
    module_bar json,
    project_descriptor character varying(100),
    default_language character varying(255) DEFAULT 'en-US'::character varying NOT NULL,
    custom_aspect_ratios json,
    public_favicon uuid,
    default_appearance character varying(255) DEFAULT 'auto'::character varying NOT NULL,
    default_theme_light character varying(255),
    theme_light_overrides json,
    default_theme_dark character varying(255),
    theme_dark_overrides json,
    report_error_url character varying(255),
    report_bug_url character varying(255),
    report_feature_url character varying(255),
    public_registration boolean DEFAULT false NOT NULL,
    public_registration_verify_email boolean DEFAULT true NOT NULL,
    public_registration_role uuid,
    public_registration_email_filter json,
    visual_editor_urls json,
    project_id uuid,
    mcp_enabled boolean DEFAULT false NOT NULL,
    mcp_allow_deletes boolean DEFAULT false NOT NULL,
    mcp_prompts_collection character varying(255) DEFAULT NULL::character varying,
    mcp_system_prompt_enabled boolean DEFAULT true NOT NULL,
    mcp_system_prompt text,
    project_owner character varying(255),
    project_usage character varying(255),
    org_name character varying(255),
    product_updates boolean,
    project_status character varying(255),
    ai_openai_api_key text,
    ai_anthropic_api_key text,
    ai_system_prompt text,
    ai_google_api_key text,
    ai_openai_compatible_api_key text,
    ai_openai_compatible_base_url text,
    ai_openai_compatible_name text,
    ai_openai_compatible_models json,
    ai_openai_compatible_headers json,
    ai_openai_allowed_models json,
    ai_anthropic_allowed_models json,
    ai_google_allowed_models json,
    collaborative_editing_enabled boolean DEFAULT false NOT NULL,
    ai_translation_default_model text,
    ai_translation_glossary json,
    ai_translation_style_guide text,
    license_key character varying(255) DEFAULT NULL::character varying,
    license_token text,
    mcp_oauth_enabled boolean DEFAULT false NOT NULL,
    mcp_oauth_dcr_enabled boolean DEFAULT false NOT NULL,
    mcp_oauth_cimd_enabled boolean DEFAULT false NOT NULL
);


ALTER TABLE public.directus_settings OWNER TO voda;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: voda
--

CREATE SEQUENCE public.directus_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_settings_id_seq OWNER TO voda;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voda
--

ALTER SEQUENCE public.directus_settings_id_seq OWNED BY public.directus_settings.id;


--
-- Name: directus_shares; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_shares (
    id uuid NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    role uuid,
    password character varying(255),
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_start timestamp with time zone,
    date_end timestamp with time zone,
    times_used integer DEFAULT 0,
    max_uses integer
);


ALTER TABLE public.directus_shares OWNER TO voda;

--
-- Name: directus_translations; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_translations (
    id uuid NOT NULL,
    language character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.directus_translations OWNER TO voda;

--
-- Name: directus_users; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_users (
    id uuid NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    email character varying(128),
    password character varying(255),
    location character varying(255),
    title character varying(50),
    description text,
    tags json,
    avatar uuid,
    language character varying(255) DEFAULT NULL::character varying,
    tfa_secret character varying(255),
    status character varying(16) DEFAULT 'active'::character varying NOT NULL,
    role uuid,
    token character varying(255),
    last_access timestamp with time zone,
    last_page character varying(255),
    provider character varying(128) DEFAULT 'default'::character varying NOT NULL,
    external_identifier character varying(255),
    auth_data json,
    email_notifications boolean DEFAULT true,
    appearance character varying(255),
    theme_dark character varying(255),
    theme_light character varying(255),
    theme_light_overrides json,
    theme_dark_overrides json,
    text_direction character varying(255) DEFAULT 'auto'::character varying NOT NULL
);


ALTER TABLE public.directus_users OWNER TO voda;

--
-- Name: directus_versions; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.directus_versions (
    id uuid NOT NULL,
    key character varying(64) NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255),
    hash character varying(255),
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    user_updated uuid,
    delta json
);


ALTER TABLE public.directus_versions OWNER TO voda;

--
-- Name: packages; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.packages (
    id uuid NOT NULL,
    name character varying(255),
    slug character varying(255),
    description text,
    destination_id uuid,
    image uuid,
    duration character varying(100),
    itinerary json,
    price_tiers json,
    facilities json,
    status character varying(255),
    gallery json,
    addons json
);


ALTER TABLE public.packages OWNER TO voda;

--
-- Name: packages_activity_types; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.packages_activity_types (
    id uuid NOT NULL,
    package_id uuid,
    activity_type_id uuid
);


ALTER TABLE public.packages_activity_types OWNER TO voda;

--
-- Name: regions; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.regions (
    id uuid NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    name character varying(255),
    slug character varying(255) DEFAULT NULL::character varying,
    description text,
    image uuid
);


ALTER TABLE public.regions OWNER TO voda;

--
-- Name: searches; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.searches (
    id integer NOT NULL,
    destination_name character varying(255),
    region_name character varying(255),
    activity_type_name character varying(255),
    pax_count integer,
    travel_date date,
    visitor_ip character varying(45)
);


ALTER TABLE public.searches OWNER TO voda;

--
-- Name: searches_id_seq; Type: SEQUENCE; Schema: public; Owner: voda
--

CREATE SEQUENCE public.searches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.searches_id_seq OWNER TO voda;

--
-- Name: searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voda
--

ALTER SEQUENCE public.searches_id_seq OWNED BY public.searches.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: voda
--

CREATE TABLE public.settings (
    id integer NOT NULL,
    key character varying(255),
    value text,
    description text
);


ALTER TABLE public.settings OWNER TO voda;

--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: voda
--

CREATE SEQUENCE public.settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.settings_id_seq OWNER TO voda;

--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: voda
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: directus_activity id; Type: DEFAULT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_activity ALTER COLUMN id SET DEFAULT nextval('public.directus_activity_id_seq'::regclass);


--
-- Name: directus_fields id; Type: DEFAULT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_fields ALTER COLUMN id SET DEFAULT nextval('public.directus_fields_id_seq'::regclass);


--
-- Name: directus_notifications id; Type: DEFAULT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_notifications ALTER COLUMN id SET DEFAULT nextval('public.directus_notifications_id_seq'::regclass);


--
-- Name: directus_permissions id; Type: DEFAULT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_permissions ALTER COLUMN id SET DEFAULT nextval('public.directus_permissions_id_seq'::regclass);


--
-- Name: directus_presets id; Type: DEFAULT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_presets ALTER COLUMN id SET DEFAULT nextval('public.directus_presets_id_seq'::regclass);


--
-- Name: directus_relations id; Type: DEFAULT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_relations ALTER COLUMN id SET DEFAULT nextval('public.directus_relations_id_seq'::regclass);


--
-- Name: directus_revisions id; Type: DEFAULT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_revisions ALTER COLUMN id SET DEFAULT nextval('public.directus_revisions_id_seq'::regclass);


--
-- Name: directus_settings id; Type: DEFAULT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_settings ALTER COLUMN id SET DEFAULT nextval('public.directus_settings_id_seq'::regclass);


--
-- Name: searches id; Type: DEFAULT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.searches ALTER COLUMN id SET DEFAULT nextval('public.searches_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Data for Name: activity_types; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.activity_types (id, name, slug, description, status) FROM stdin;
e0506893-412e-4824-8d8b-ae019a08b904	Private Trip	private-trip	Rombongan sendiri (keluarga/teman/kolega), jadwal & itinerary bisa custom, tidak digabung peserta lain.	published
b909dcf6-2837-4369-a6c6-fbfd5b2b5134	Open Trip	open-trip	Digabung dengan peserta lain yang tidak saling kenal, jadwal fixed (biasanya weekend), harga per orang lebih murah.	published
02e09c30-728c-412c-9058-89df82c61c47	Family Trip	family-trip	Trip untuk liburan keluarga, ramah anak dan orang tua, ritme santai, destinasi kid-friendly.	published
e6a14e35-f137-4bf5-a445-21bbff7e2955	Corporate Gathering	corporate-gathering	Acara kantor/perusahaan untuk mempererat kebersamaan tim, biasanya termasuk makan bersama & venue acara.	published
e011abf2-00b4-4dc9-bc4e-60c7bccf290b	Outbound	outbound	Aktivitas fisik luar ruangan berbasis games/tantangan kelompok (flying fox, war game, dsb), biasa untuk sekolah atau kantor.	published
3081b30f-b4d9-4395-b070-336e2d58e9c0	Honeymoon / Pasangan	honeymoon-pasangan	Trip romantis untuk pasangan/bulan madu, biasanya private dan destinasi lebih personal/santai.	published
3e451ca1-7ebd-4f3b-929c-6bd523774f1d	Study Tour / Wisata Edukasi	study-tour-wisata-edukasi	Kunjungan wisata untuk pelajar/mahasiswa dengan muatan edukasi sejarah/budaya/sains.	published
7813e47f-0459-4124-acf2-16fce015f275	Reuni / Komunitas	reuni-komunitas	Trip untuk kelompok alumni, komunitas hobi, atau kumpulan teman lama.	published
447f5da1-837e-4e0f-94c3-3d1c63c1706f	Religi / Ziarah	religi-ziarah	Kunjungan ke situs bersejarah/keagamaan seperti candi, pura, atau tempat ziarah.	published
ef4be35a-a6c5-4e79-9c5c-2a5f7752e586	Team Building	team-building	Fokus pada aktivitas kerja sama tim, biasanya dikombinasikan dengan games/outbound terstruktur dan fasilitator.	published
\.


--
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.articles (id, status, title, slug, featured_image, publish_date, ads, seo, content) FROM stdin;
3def676a-3b03-44aa-82a7-08edf7717d4e	published	Tips Cerdas Travel	tips-cerdas-travel	7af52fd4-e747-4133-8b4a-2522506f8c2f	2026-07-17 14:52:58	\N	\N	<article>\n<h1>20+ Tips Traveling Anti Kena Tipu: Panduan Lengkap Biar Liburan Aman dan Dompet Selamat</h1>\n<p>Traveling itu soal menciptakan kenangan, bukan menciptakan cerita "gara-gara ditipu di jalan". Sayangnya, makin ramai destinasi wisata, makin kreatif juga modus penipuan yang mengincar turis, baik turis domestik maupun mancanegara. Mulai dari calo tiket, penginapan fiktif, sampai QR code palsu di tempat parkir, semua modus ini terus berkembang mengikuti kebiasaan traveler modern.</p>\n<p>Artikel ini merangkum <strong>tips anti kena tipu</strong> yang bisa kamu terapkan mulai dari tahap perencanaan sampai hari-H di lokasi wisata. Simak baik-baik, siapa tahu satu tips di bawah ini bisa menyelamatkan liburan kamu dari drama yang nggak perlu.</p>\n<h2>1. Kenapa Modus Penipuan Traveler Makin Kreatif?</h2>\n<p>Di era digital, penipu nggak cuma beroperasi di jalanan. Mereka juga masuk ke marketplace, media sosial, bahkan aplikasi booking. Modusnya makin variatif karena:</p>\n<ul>\n<li>Turis biasanya nggak familiar dengan harga lokal, jadi gampang di-<em>mark up</em>.</li>\n<li>Turis cenderung terburu-buru dan nggak sempat riset mendalam.</li>\n<li>Bahasa dan budaya yang berbeda membuat turis ragu untuk menawar atau protes.</li>\n<li>Media sosial mempermudah penipu bikin akun palsu yang terlihat meyakinkan.</li>\n</ul>\n<p>Makanya, kunci utama anti kena tipu adalah <strong>persiapan</strong> dan <strong>kewaspadaan yang konsisten</strong>, bukan cuma pas berangkat aja.</p>\n<h2>2. Riset Sebelum Berangkat Itu Wajib Hukumnya</h2>\n<p>Sebelum packing baju, luangkan waktu buat riset destinasi. Beberapa hal yang wajib kamu cek:</p>\n<ol>\n<li><strong>Harga wajar</strong> untuk transportasi lokal, makanan, dan aktivitas wisata di destinasi tersebut.</li>\n<li><strong>Modus penipuan yang umum terjadi</strong> di kota atau negara itu, biasanya banyak dibahas di forum traveler seperti <a href="https://www.tripadvisor.com" target="_blank" rel="noopener noreferrer">TripAdvisor</a> atau grup Facebook komunitas traveler.</li>\n<li><strong>Peraturan setempat</strong>, termasuk soal tawar-menawar, tipping, dan area yang perlu dihindari saat malam hari.</li>\n<li><strong>Nomor darurat lokal</strong> dan lokasi kedutaan/konsulat jika kamu traveling ke luar negeri.</li>\n</ol>\n<blockquote>"Traveler yang siap bukan berarti paranoid, tapi traveler yang siap tahu kapan harus curiga dan kapan harus santai menikmati perjalanan."</blockquote>\n<h2>3. Booking Tiket dan Hotel: Jangan Asal Klik Link</h2>\n<p>Salah satu modus paling klasik adalah <strong>website atau akun palsu</strong> yang menawarkan tiket pesawat atau kamar hotel dengan harga jauh di bawah pasaran. Supaya nggak kena jebakan ini:</p>\n<ul>\n<li>Booking hanya lewat platform resmi seperti situs maskapai langsung, atau agen tepercaya semacam <a href="https://www.booking.com" target="_blank" rel="noopener noreferrer">Booking.com</a> dan <a href="https://www.agoda.com" target="_blank" rel="noopener noreferrer">Agoda</a>.</li>\n<li>Perhatikan URL, pastikan ada ikon gembok (HTTPS) dan domain resmi, bukan tiruan seperti <em>bookiing-com.net</em>.</li>\n<li>Hindari transfer langsung ke rekening pribadi tanpa jejak transaksi resmi, walaupun harganya menggiurkan.</li>\n<li>Cek ulasan penginapan, bukan cuma rating, tapi juga baca komentar detail dari tamu sebelumnya.</li>\n</ul>\n<p>Kalau harga terasa "terlalu bagus untuk jadi kenyataan", biasanya memang bukan kenyataan.</p>\n<h2>4. Waspada di Bandara dan Transportasi Umum</h2>\n<p>Bandara dan stasiun adalah tempat favorit modus penipuan karena traveler biasanya capek dan nggak fokus. Beberapa hal yang perlu diwaspadai:</p>\n<table style="border-collapse: collapse; width: 100%;" border="1" cellspacing="0" cellpadding="8">\n<thead>\n<tr>\n<th>Modus</th>\n<th>Ciri-Ciri</th>\n<th>Cara Menghindari</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>Taksi argo "rusak"</td>\n<td>Sopir bilang argo rusak lalu minta tarif flat yang jauh lebih mahal</td>\n<td>Gunakan aplikasi ride-hailing resmi atau taksi bandara berstiker resmi</td>\n</tr>\n<tr>\n<td>Porter tak diminta</td>\n<td>Tiba-tiba ada orang bawa koper lo tanpa diminta, lalu minta tip besar</td>\n<td>Tolak dengan tegas dan pegang barang bawaan sendiri</td>\n</tr>\n<tr>\n<td>Calo tiket transit</td>\n<td>Menawarkan "bantuan" transit dengan biaya tambahan tidak resmi</td>\n<td>Selalu tanya ke petugas berseragam resmi bandara/stasiun</td>\n</tr>\n<tr>\n<td>SIM card palsu</td>\n<td>Dijual di luar gerai resmi dengan harga tinggi dan kuota tidak sesuai</td>\n<td>Beli SIM card di konter resmi operator dalam bandara</td>\n</tr>\n</tbody>\n</table>\n<h2>5. Cari Penginapan: Ciri-Ciri yang Harus Dicurigai</h2>\n<p>Selain booking online, kadang traveler juga mencari penginapan dadakan di lokasi. Ini beberapa red flag yang wajib diwaspadai:</p>\n<ul>\n<li>Pemilik penginapan menolak memberi bukti pemesanan tertulis.</li>\n<li>Foto kamar di internet jauh berbeda dari kondisi asli.</li>\n<li>Diminta membayar penuh di muka tanpa opsi pembatalan sama sekali.</li>\n<li>Lokasi "5 menit dari pusat kota" ternyata butuh 45 menit naik kendaraan.</li>\n</ul>\n<p>Solusinya, selalu simpan bukti chat, email konfirmasi, dan screenshot histori transaksi sebagai bukti kalau ada sengketa nantinya.</p>\n<h2>6. Modus Calo dan "Guide Dadakan" di Tempat Wisata</h2>\n<p>Di banyak destinasi populer, ada orang yang tiba-tiba menawarkan diri jadi <em>guide</em> dadakan atau membantu "gratis" padahal ujung-ujungnya minta bayaran besar. Tips menghadapinya:</p>\n<ol>\n<li>Sopan tapi tegas menolak tawaran bantuan yang tidak diminta.</li>\n<li>Gunakan guide resmi dari agen wisata terpercaya atau yang direkomendasikan hotel.</li>\n<li>Kalau ragu, cukup jawab "Terima kasih, saya sudah ada rencana sendiri."</li>\n<li>Jangan mudah percaya orang yang mengaku "teman dari hotel/agen kamu".</li>\n</ol>\n<h2>7. Money Changer dan Transaksi Uang</h2>\n<p>Urusan uang adalah target utama penipuan karena traveler sering bingung dengan mata uang asing. Supaya aman:</p>\n<ul>\n<li>Tukar uang di <strong>money changer berizin resmi</strong>, hindari yang menawarkan kurs jauh lebih tinggi dari pasaran di pinggir jalan.</li>\n<li>Selalu hitung ulang uang kembalian di depan kasir, jangan langsung dimasukkan ke dompet.</li>\n<li>Hati-hati dengan trik "salah hitung" saat pecahan uang mata uang asing terlihat mirip.</li>\n<li>Gunakan kartu debit/kredit dari bank yang mendukung transaksi luar negeri sebagai cadangan.</li>\n</ul>\n<h2>8. Belanja dan Kuliner: Jangan Sampai Kena Harga Turis</h2>\n<p>Di pasar tradisional atau area wisata, harga barang sering kali punya "tarif turis" yang jauh lebih mahal dari harga lokal. Cara menyiasatinya:</p>\n<ul>\n<li>Tanyakan harga ke beberapa toko sebelum membeli untuk membandingkan.</li>\n<li>Pelajari kisaran harga wajar dari riset sebelum berangkat.</li>\n<li>Jangan ragu menawar di tempat yang memang budayanya tawar-menawar.</li>\n<li>Pilih restoran dengan daftar harga jelas, hindari tempat yang baru kasih harga setelah makanan disajikan.</li>\n</ul>\n<h2>9. Teknologi Jadi Senjata: Wifi Publik, QR Code Palsu, dan Aplikasi Abal-Abal</h2>\n<p>Modus penipuan modern makin sering memanfaatkan teknologi. Beberapa yang perlu diwaspadai:</p>\n<table style="border-collapse: collapse; width: 100%;" border="1" cellspacing="0" cellpadding="8">\n<thead>\n<tr>\n<th>Ancaman Digital</th>\n<th>Risiko</th>\n<th>Solusi</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>Wifi publik palsu</td>\n<td>Data pribadi dan login akun bisa dicuri</td>\n<td>Gunakan VPN dan hindari transaksi finansial di wifi publik</td>\n</tr>\n<tr>\n<td>QR code tempel palsu</td>\n<td>Pembayaran masuk ke rekening penipu, bukan merchant asli</td>\n<td>Cek nama merchant yang muncul sebelum konfirmasi bayar</td>\n</tr>\n<tr>\n<td>Aplikasi booking abal-abal</td>\n<td>Data kartu kredit dicuri, pemesanan fiktif</td>\n<td>Unduh aplikasi resmi hanya dari App Store/Play Store dengan rating jelas</td>\n</tr>\n<tr>\n<td>Charging station USB publik</td>\n<td>Rawan "juice jacking" alias pencurian data lewat kabel USB</td>\n<td>Gunakan power bank sendiri atau adaptor charger biasa</td>\n</tr>\n</tbody>\n</table>\n<h2>10. Checklist Anti Kena Tipu Sebelum dan Selama Traveling</h2>\n<p>Biar makin gampang diingat, ini rangkuman checklist yang bisa kamu simpan sebelum berangkat:</p>\n<ul>\n<li>✅ Riset harga wajar transportasi, makanan, dan aktivitas di destinasi</li>\n<li>✅ Booking tiket dan hotel hanya lewat platform resmi</li>\n<li>✅ Simpan salinan digital paspor, tiket, dan bukti booking</li>\n<li>✅ Gunakan aplikasi ride-hailing resmi, bukan taksi sembarangan</li>\n<li>✅ Tukar uang hanya di money changer berizin</li>\n<li>✅ Aktifkan VPN saat pakai wifi publik</li>\n<li>✅ Simpan nomor darurat dan alamat kedutaan/konsulat</li>\n<li>✅ Percaya insting, kalau terasa aneh, lebih baik hindari</li>\n</ul>\n<h2>Kesimpulan</h2>\n<p>Traveling anti kena tipu bukan soal jadi parno sepanjang perjalanan, tapi soal <strong>siap sedia</strong> dan tahu pola-pola modus yang sering muncul. Dengan riset yang matang, transaksi yang hati-hati, dan insting yang terus diasah, kamu bisa menikmati perjalanan dengan jauh lebih tenang.</p>\n<p>Ingat, tujuan liburan adalah menciptakan cerita indah, bukan cerita "hampir ketipu di destinasi X". Jadi, siapkan diri, riset destinasi, dan selamat menjelajah dunia dengan aman!</p>\n</article>
\.


--
-- Data for Name: destinations; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.destinations (id, status, user_created, date_created, user_updated, date_updated, name, slug, description, image, region_id, gallery) FROM stdin;
9e57cb99-472b-4605-bc3d-952a1e0a75ba	published	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:46:38.975+00	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:47:01.558+00	Pulau Harapan	pulau-harapan	Pulau Harapan merupakan salah satu pulau penduduk di Kepulauan Seribu yang terkenal dengan aktivitas snorkeling, island hopping, dan wisata bahari. Pulau ini memiliki suasana lokal yang lebih tenang dibanding beberapa pulau wisata populer lainnya, dengan pilihan homestay warga sebagai akomodasi utama. Pulau Harapan cocok untuk wisata keluarga, komunitas, pasangan, maupun rombongan yang ingin menikmati keindahan laut Kepulauan Seribu dengan harga lebih terjangkau.	96c0bc18-ba54-4173-b78c-2910338c56e2	d3eb9365-e929-413f-a770-e0f491bbeb35	\N
e2c9f388-06bd-4a3c-8713-efc97ce59124	published	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:49:16.742+00	\N	\N	Pulau Putri	pulau-putri	Pulau Putri merupakan salah satu resort eksklusif di Kepulauan Seribu yang menawarkan pengalaman menginap di cottage tepi laut dengan berbagai fasilitas rekreasi bahari. Resort ini terkenal dengan Undersea Tunnel Aquarium, Glass Bottom Boat, Sunset Cruise, kolam renang, dan cottage yang seluruhnya menghadap ke laut. Pulau Putri cocok untuk liburan keluarga, pasangan, outing perusahaan, gathering, maupun meeting.	088c8736-3301-4a7f-b0d8-84434409638c	5ec5476a-aad9-4b36-a20e-23b5f8dc7347	\N
393287c3-c166-4522-99d2-a27ab0f62dfa	published	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 07:03:55.38+00	\N	\N	Pulau Pari	pulau-pari	pulau-pari pulau-pari pulau-pari pulau-pari	7af52fd4-e747-4133-8b4a-2522506f8c2f	d3eb9365-e929-413f-a770-e0f491bbeb35	\N
\.


--
-- Data for Name: directus_access; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_access (id, role, "user", policy, sort) FROM stdin;
c719dcb2-13ec-4ef6-a62b-95388976e8f3	\N	\N	abf8a154-5b1c-4a46-ac9c-7300570f4f17	1
486ce7c9-8c8b-4a6a-b97a-ad49b2bd4e0a	67f28eff-0807-43ec-abd6-c8c9da586552	\N	92538bb3-48ab-475e-8239-72531899ad43	\N
\.


--
-- Data for Name: directus_activity; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_activity (id, action, "user", "timestamp", ip, user_agent, collection, item, origin) FROM stdin;
1	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 03:09:36.087+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
2	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 03:11:10.548+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
3	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:23:10.013+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	1	http://localhost:8055
4	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:23:10.049+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	2	http://localhost:8055
5	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:23:10.054+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	3	http://localhost:8055
6	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:23:10.062+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	4	http://localhost:8055
7	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:23:10.067+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	5	http://localhost:8055
8	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:23:10.072+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	regions	http://localhost:8055
9	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:23:54.455+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	6	http://localhost:8055
10	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:24:32.81+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	6	http://localhost:8055
11	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:02.607+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	regions	http://localhost:8055
12	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:02.612+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	1	http://localhost:8055
13	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:02.614+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	2	http://localhost:8055
14	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:02.616+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	3	http://localhost:8055
15	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:02.618+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	4	http://localhost:8055
16	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:02.619+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	5	http://localhost:8055
17	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:30.346+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	7	http://localhost:8055
18	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:30.353+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	8	http://localhost:8055
19	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:30.36+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	9	http://localhost:8055
20	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:30.365+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	10	http://localhost:8055
21	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:30.371+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	11	http://localhost:8055
22	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:30.376+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	12	http://localhost:8055
23	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:30:30.379+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	regions	http://localhost:8055
24	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:32:30.771+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	13	http://localhost:8055
25	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:33:22.612+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	14	http://localhost:8055
26	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:33:44.963+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	15	http://localhost:8055
27	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:34:11.21+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	16	http://localhost:8055
28	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:36:10.187+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
29	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:36:10.194+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
30	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:36:10.201+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
31	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:36:10.206+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
32	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:36:10.21+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	21	http://localhost:8055
33	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:36:10.213+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	22	http://localhost:8055
34	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:36:10.217+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	destinations	http://localhost:8055
35	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:34.361+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	23	http://localhost:8055
36	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:34.479+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	24	http://localhost:8055
37	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:46.632+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
38	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:46.643+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
39	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:46.655+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	23	http://localhost:8055
40	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:46.663+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
41	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:46.674+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
42	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:46.684+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	21	http://localhost:8055
43	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:46.692+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	22	http://localhost:8055
44	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:59.917+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
45	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:59.927+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	23	http://localhost:8055
46	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:59.938+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
47	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:59.947+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
48	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:59.956+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
49	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:59.965+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	21	http://localhost:8055
50	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:40:59.974+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	22	http://localhost:8055
51	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:41:55.41+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	25	http://localhost:8055
52	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:41:59.36+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
53	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:41:59.369+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	23	http://localhost:8055
54	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:41:59.378+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	25	http://localhost:8055
55	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:41:59.386+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
56	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:41:59.395+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
57	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:41:59.403+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
58	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:41:59.415+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	21	http://localhost:8055
59	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:41:59.425+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	22	http://localhost:8055
60	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:43:42.485+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	26	http://localhost:8055
61	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:43:53.021+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	23	http://localhost:8055
62	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:44:17.285+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
63	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:44:17.295+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	23	http://localhost:8055
64	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:44:17.305+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	25	http://localhost:8055
65	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:44:17.315+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	26	http://localhost:8055
66	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:44:17.325+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
67	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:44:17.336+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
68	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:44:17.345+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
69	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:44:17.353+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	21	http://localhost:8055
70	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:44:17.365+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	22	http://localhost:8055
71	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:44:37.362+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	27	http://localhost:8055
72	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:44:50.176+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	25	http://localhost:8055
73	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:45:42.564+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	27	http://localhost:8055
74	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:45:46.52+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
75	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:45:46.528+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	23	http://localhost:8055
76	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:45:46.538+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	25	http://localhost:8055
77	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:45:46.546+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	26	http://localhost:8055
78	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:45:46.555+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	27	http://localhost:8055
79	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:45:46.57+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
80	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:45:46.58+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
81	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:45:46.59+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
82	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:45:46.606+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	21	http://localhost:8055
83	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:45:46.614+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	22	http://localhost:8055
84	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.555+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	destinations	http://localhost:8055
85	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.558+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	17	http://localhost:8055
86	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.559+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	18	http://localhost:8055
87	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.559+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	19	http://localhost:8055
88	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.561+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	20	http://localhost:8055
89	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.561+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	21	http://localhost:8055
90	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.562+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	22	http://localhost:8055
91	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.563+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	23	http://localhost:8055
92	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.564+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	25	http://localhost:8055
93	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.564+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	26	http://localhost:8055
94	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.566+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	27	http://localhost:8055
95	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:08.58+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	24	http://localhost:8055
96	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:10.788+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	regions	http://localhost:8055
97	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:10.792+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	7	http://localhost:8055
98	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:10.793+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	8	http://localhost:8055
99	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:10.794+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	9	http://localhost:8055
100	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:10.794+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	10	http://localhost:8055
101	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:10.795+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	11	http://localhost:8055
102	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:10.797+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	12	http://localhost:8055
103	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:10.797+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	13	http://localhost:8055
104	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:10.798+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	14	http://localhost:8055
105	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:10.799+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	15	http://localhost:8055
106	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 07:47:10.8+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	16	http://localhost:8055
107	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:07:42.846+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	28	http://localhost:8055
108	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:07:42.877+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	29	http://localhost:8055
109	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:07:42.894+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	30	http://localhost:8055
110	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:07:42.903+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	31	http://localhost:8055
111	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:07:42.909+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	32	http://localhost:8055
112	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:07:42.921+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	33	http://localhost:8055
113	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:07:42.936+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	regions	http://localhost:8055
114	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:25:01.801+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	34	http://localhost:8055
115	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:25:01.819+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	35	http://localhost:8055
116	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:25:01.829+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	36	http://localhost:8055
117	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:25:01.842+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	37	http://localhost:8055
118	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:25:01.849+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	38	http://localhost:8055
119	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:25:01.861+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	39	http://localhost:8055
120	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:25:01.878+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	40	http://localhost:8055
121	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:25:01.882+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	destinations	http://localhost:8055
122	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:29:50.595+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	41	http://localhost:8055
123	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:29:50.623+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	42	http://localhost:8055
124	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:29:50.632+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	43	http://localhost:8055
125	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:29:50.638+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	44	http://localhost:8055
126	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:29:50.644+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	45	http://localhost:8055
127	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:29:50.648+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	46	http://localhost:8055
128	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:29:50.655+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	47	http://localhost:8055
129	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-10 08:29:50.663+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	packages	http://localhost:8055
130	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:32:29.36+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
131	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:34:05.679+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
166	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:43.146+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	50	http://localhost:8055
132	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:35:15.174+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
133	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:36:15.609+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
134	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:37:27.824+00	172.20.0.1	curl/8.21.0	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
135	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:37:44.202+00	172.20.0.1	curl/8.21.0	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
136	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:38:08.339+00	172.20.0.1	curl/8.21.0	directus_settings	1	\N
137	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:52:57.467+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	48	http://localhost:8055
138	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:54:12.05+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	49	http://localhost:8055
139	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:54:19.91+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	49	http://localhost:8055
140	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:14.265+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	50	http://localhost:8055
141	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:36.094+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	destinations	http://localhost:8055
142	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:36.096+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	34	http://localhost:8055
143	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:36.097+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	35	http://localhost:8055
144	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:36.098+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	36	http://localhost:8055
145	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:36.098+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	37	http://localhost:8055
146	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:36.099+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	38	http://localhost:8055
147	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:36.1+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	39	http://localhost:8055
148	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:36.101+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	40	http://localhost:8055
149	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:39.383+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	packages	http://localhost:8055
150	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:39.389+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	41	http://localhost:8055
151	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:39.391+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	42	http://localhost:8055
152	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:39.392+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	43	http://localhost:8055
153	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:39.392+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	44	http://localhost:8055
154	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:39.393+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	45	http://localhost:8055
155	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:39.394+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	46	http://localhost:8055
156	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:39.395+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	47	http://localhost:8055
157	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:43.132+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	regions	http://localhost:8055
158	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:43.137+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	28	http://localhost:8055
159	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:43.138+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	29	http://localhost:8055
160	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:43.139+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	30	http://localhost:8055
161	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:43.141+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	31	http://localhost:8055
162	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:43.142+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	32	http://localhost:8055
163	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:43.143+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	33	http://localhost:8055
164	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:43.144+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	48	http://localhost:8055
165	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:56:43.145+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	49	http://localhost:8055
167	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:57:07.535+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	51	http://localhost:8055
168	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:57:07.54+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	52	http://localhost:8055
169	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:57:07.547+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	53	http://localhost:8055
170	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:57:07.554+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	54	http://localhost:8055
171	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:57:07.559+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	55	http://localhost:8055
172	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:57:07.562+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	56	http://localhost:8055
173	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:57:07.565+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	regions	http://localhost:8055
174	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:57:20.95+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	57	http://localhost:8055
175	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:57:52.041+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	58	http://localhost:8055
176	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:57:57.734+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	58	http://localhost:8055
177	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:58:18.003+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	59	http://localhost:8055
178	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 01:58:48.215+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	60	http://localhost:8055
179	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:00:40.849+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	61	http://localhost:8055
180	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:00:40.854+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	62	http://localhost:8055
181	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:00:40.858+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	63	http://localhost:8055
182	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:00:40.862+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	64	http://localhost:8055
183	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:00:40.867+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	65	http://localhost:8055
184	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:00:40.871+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	66	http://localhost:8055
185	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:00:40.877+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	destinations	http://localhost:8055
186	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:00:56.173+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	67	http://localhost:8055
187	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:01:16.753+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	68	http://localhost:8055
188	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:01:34.544+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	69	http://localhost:8055
189	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:01:49.612+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	70	http://localhost:8055
190	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:01:57.165+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	70	http://localhost:8055
191	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:02:12.854+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	71	http://localhost:8055
192	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:06:10.803+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	72	http://localhost:8055
193	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:06:10.914+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	73	http://localhost:8055
194	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:16:05.755+00	172.20.0.1	curl/8.21.0	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
195	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:26.394+00	172.20.0.1	Python-urllib/3.14	directus_fields	58	\N
196	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:26.489+00	172.20.0.1	Python-urllib/3.14	directus_fields	68	\N
197	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:26.591+00	172.20.0.1	Python-urllib/3.14	directus_fields	74	\N
198	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:26.647+00	172.20.0.1	Python-urllib/3.14	directus_fields	75	\N
199	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:26.65+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages	\N
200	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:27.19+00	172.20.0.1	Python-urllib/3.14	directus_fields	76	\N
201	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:27.549+00	172.20.0.1	Python-urllib/3.14	directus_fields	77	\N
202	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:27.903+00	172.20.0.1	Python-urllib/3.14	directus_fields	78	\N
203	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:28.25+00	172.20.0.1	Python-urllib/3.14	directus_fields	79	\N
204	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:28.605+00	172.20.0.1	Python-urllib/3.14	directus_fields	80	\N
205	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:28.957+00	172.20.0.1	Python-urllib/3.14	directus_fields	81	\N
206	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:29.317+00	172.20.0.1	Python-urllib/3.14	directus_fields	82	\N
207	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:29.698+00	172.20.0.1	Python-urllib/3.14	directus_fields	83	\N
208	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:30.093+00	172.20.0.1	Python-urllib/3.14	directus_fields	84	\N
209	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:30.456+00	172.20.0.1	Python-urllib/3.14	directus_fields	85	\N
210	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:30.834+00	172.20.0.1	Python-urllib/3.14	directus_fields	86	\N
211	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:30.841+00	172.20.0.1	Python-urllib/3.14	directus_collections	activity_types	\N
212	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:31.403+00	172.20.0.1	Python-urllib/3.14	directus_fields	87	\N
213	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:31.772+00	172.20.0.1	Python-urllib/3.14	directus_fields	88	\N
214	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:32.141+00	172.20.0.1	Python-urllib/3.14	directus_fields	89	\N
215	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:32.505+00	172.20.0.1	Python-urllib/3.14	directus_fields	90	\N
216	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:32.508+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages_activity_types	\N
217	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:33.044+00	172.20.0.1	Python-urllib/3.14	directus_fields	91	\N
218	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:33.39+00	172.20.0.1	Python-urllib/3.14	directus_fields	92	\N
219	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:33.738+00	172.20.0.1	Python-urllib/3.14	directus_fields	93	\N
220	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:33.741+00	172.20.0.1	Python-urllib/3.14	directus_collections	settings	\N
221	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:34.285+00	172.20.0.1	Python-urllib/3.14	directus_fields	94	\N
222	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:34.642+00	172.20.0.1	Python-urllib/3.14	directus_fields	95	\N
223	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:35.011+00	172.20.0.1	Python-urllib/3.14	directus_fields	96	\N
224	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:35.366+00	172.20.0.1	Python-urllib/3.14	directus_fields	97	\N
225	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:35.371+00	172.20.0.1	Python-urllib/3.14	directus_collections	searches	\N
226	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:35.913+00	172.20.0.1	Python-urllib/3.14	directus_fields	98	\N
227	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:36.273+00	172.20.0.1	Python-urllib/3.14	directus_fields	99	\N
228	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:36.618+00	172.20.0.1	Python-urllib/3.14	directus_fields	100	\N
229	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:36.962+00	172.20.0.1	Python-urllib/3.14	directus_fields	101	\N
230	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:37.312+00	172.20.0.1	Python-urllib/3.14	directus_fields	102	\N
231	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:17:37.662+00	172.20.0.1	Python-urllib/3.14	directus_fields	103	\N
232	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:18.54+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages_activity_types	\N
233	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:18.542+00	172.20.0.1	Python-urllib/3.14	directus_fields	90	\N
234	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:18.543+00	172.20.0.1	Python-urllib/3.14	directus_fields	91	\N
235	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:18.544+00	172.20.0.1	Python-urllib/3.14	directus_fields	92	\N
236	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:32.488+00	172.20.0.1	Python-urllib/3.14	directus_collections	activity_types	\N
237	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:32.491+00	172.20.0.1	Python-urllib/3.14	directus_fields	86	\N
238	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:32.492+00	172.20.0.1	Python-urllib/3.14	directus_fields	87	\N
239	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:32.493+00	172.20.0.1	Python-urllib/3.14	directus_fields	88	\N
240	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:32.494+00	172.20.0.1	Python-urllib/3.14	directus_fields	89	\N
241	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.538+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages	\N
242	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.542+00	172.20.0.1	Python-urllib/3.14	directus_fields	75	\N
243	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.543+00	172.20.0.1	Python-urllib/3.14	directus_fields	76	\N
244	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.544+00	172.20.0.1	Python-urllib/3.14	directus_fields	77	\N
245	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.545+00	172.20.0.1	Python-urllib/3.14	directus_fields	78	\N
246	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.547+00	172.20.0.1	Python-urllib/3.14	directus_fields	79	\N
247	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.548+00	172.20.0.1	Python-urllib/3.14	directus_fields	80	\N
248	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.549+00	172.20.0.1	Python-urllib/3.14	directus_fields	81	\N
249	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.55+00	172.20.0.1	Python-urllib/3.14	directus_fields	82	\N
250	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.551+00	172.20.0.1	Python-urllib/3.14	directus_fields	83	\N
251	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.552+00	172.20.0.1	Python-urllib/3.14	directus_fields	84	\N
252	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:33.555+00	172.20.0.1	Python-urllib/3.14	directus_fields	85	\N
253	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.608+00	172.20.0.1	Python-urllib/3.14	directus_fields	104	\N
254	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.611+00	172.20.0.1	Python-urllib/3.14	directus_fields	105	\N
255	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.613+00	172.20.0.1	Python-urllib/3.14	directus_fields	106	\N
256	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.616+00	172.20.0.1	Python-urllib/3.14	directus_fields	107	\N
257	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.619+00	172.20.0.1	Python-urllib/3.14	directus_fields	108	\N
258	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.622+00	172.20.0.1	Python-urllib/3.14	directus_fields	109	\N
259	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.626+00	172.20.0.1	Python-urllib/3.14	directus_fields	110	\N
260	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.628+00	172.20.0.1	Python-urllib/3.14	directus_fields	111	\N
261	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.631+00	172.20.0.1	Python-urllib/3.14	directus_fields	112	\N
262	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.635+00	172.20.0.1	Python-urllib/3.14	directus_fields	113	\N
263	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.637+00	172.20.0.1	Python-urllib/3.14	directus_fields	114	\N
264	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:34.641+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages	\N
265	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:35.193+00	172.20.0.1	Python-urllib/3.14	directus_fields	115	\N
266	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:35.196+00	172.20.0.1	Python-urllib/3.14	directus_fields	116	\N
267	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:35.199+00	172.20.0.1	Python-urllib/3.14	directus_fields	117	\N
268	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:35.202+00	172.20.0.1	Python-urllib/3.14	directus_fields	118	\N
269	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:35.204+00	172.20.0.1	Python-urllib/3.14	directus_collections	activity_types	\N
270	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:35.746+00	172.20.0.1	Python-urllib/3.14	directus_fields	119	\N
271	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:35.75+00	172.20.0.1	Python-urllib/3.14	directus_fields	120	\N
272	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:35.753+00	172.20.0.1	Python-urllib/3.14	directus_fields	121	\N
273	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:18:35.755+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages_activity_types	\N
274	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:20:16.032+00	172.20.0.1	Python-urllib/3.14	directus_permissions	1	\N
275	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:20:16.392+00	172.20.0.1	Python-urllib/3.14	directus_permissions	2	\N
276	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:20:16.734+00	172.20.0.1	Python-urllib/3.14	directus_permissions	3	\N
277	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:20:17.067+00	172.20.0.1	Python-urllib/3.14	directus_permissions	4	\N
278	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:20:17.405+00	172.20.0.1	Python-urllib/3.14	directus_permissions	5	\N
279	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:20:17.74+00	172.20.0.1	Python-urllib/3.14	directus_permissions	6	\N
280	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:20:18.076+00	172.20.0.1	Python-urllib/3.14	directus_permissions	7	\N
281	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:20:18.411+00	172.20.0.1	Python-urllib/3.14	directus_permissions	8	\N
282	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:47.344+00	172.20.0.1	Python-urllib/3.14	regions	ec6a1937-1fea-467b-ad67-b5cac3b7021d	\N
283	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:47.379+00	172.20.0.1	Python-urllib/3.14	regions	863d7681-4753-4694-a4e3-97f7a643000f	\N
284	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:47.407+00	172.20.0.1	Python-urllib/3.14	regions	9c2fddf3-c0e6-4d1a-a0a9-03628e22dbb9	\N
285	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:47.432+00	172.20.0.1	Python-urllib/3.14	regions	a11bb172-5658-4e98-8879-2dd3ce41dd9f	\N
286	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:47.468+00	172.20.0.1	Python-urllib/3.14	regions	8c84e8ef-34e2-4ff9-976f-e58f73b2a564	\N
287	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.011+00	172.20.0.1	Python-urllib/3.14	destinations	2c0e6233-0a08-44f9-b0dc-3b55c28479e1	\N
288	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.044+00	172.20.0.1	Python-urllib/3.14	destinations	91219cf5-7174-4582-a66d-1d7058424dec	\N
289	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.074+00	172.20.0.1	Python-urllib/3.14	destinations	18e279f9-4aa0-4de4-a486-e815af63eb23	\N
290	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.104+00	172.20.0.1	Python-urllib/3.14	destinations	f0969a63-c1b6-46c9-9f7c-3badaaa9379d	\N
291	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.135+00	172.20.0.1	Python-urllib/3.14	destinations	e16c72f3-778c-482f-b000-9f084b1c8883	\N
292	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.169+00	172.20.0.1	Python-urllib/3.14	destinations	adfb7643-e49a-4280-8708-31150dce740f	\N
293	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.207+00	172.20.0.1	Python-urllib/3.14	destinations	d714b370-eff9-400f-9765-672ce05b7aa5	\N
294	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.244+00	172.20.0.1	Python-urllib/3.14	destinations	14ee958e-d602-41fd-93dc-2e125ca45719	\N
295	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.274+00	172.20.0.1	Python-urllib/3.14	destinations	539e7cd6-32a0-4c42-91d9-05dd4b58ac4d	\N
296	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.305+00	172.20.0.1	Python-urllib/3.14	destinations	f999881b-2066-4539-b648-ac81546ad0af	\N
297	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.336+00	172.20.0.1	Python-urllib/3.14	destinations	09e35c4a-2012-467c-b5a2-e49e29cd2f22	\N
298	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.368+00	172.20.0.1	Python-urllib/3.14	destinations	6f8366b1-eda3-451a-b240-984fe41158d5	\N
299	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.4+00	172.20.0.1	Python-urllib/3.14	destinations	c876b951-6217-4a30-80af-2973f34e31f6	\N
300	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.434+00	172.20.0.1	Python-urllib/3.14	destinations	89862e81-f3f3-4311-9aff-9e8d9a21016c	\N
301	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.958+00	172.20.0.1	Python-urllib/3.14	activity_types	2592b822-c30b-4d26-92fd-a0f806a8c51e	\N
302	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.975+00	172.20.0.1	Python-urllib/3.14	activity_types	bad6232c-9f00-41a8-a699-535245ec3e13	\N
303	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:48.994+00	172.20.0.1	Python-urllib/3.14	activity_types	07885ce8-eeef-4d96-8bc6-799199bfb187	\N
304	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.015+00	172.20.0.1	Python-urllib/3.14	activity_types	49a970e3-a0a8-40be-890a-df45f8867f0b	\N
305	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.033+00	172.20.0.1	Python-urllib/3.14	activity_types	4cc0b3a2-0c22-4506-a639-76a294c66e06	\N
306	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.561+00	172.20.0.1	Python-urllib/3.14	packages	6afe21c3-5c89-405e-ae6b-0d7cf8b19478	\N
307	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.59+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	3d90a7bf-9826-421f-b151-89f1080c9f47	\N
308	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.616+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	f01f768a-1758-4004-9140-78b9ed203473	\N
309	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.642+00	172.20.0.1	Python-urllib/3.14	packages	e581ce95-939d-4d18-a35e-2a01f8aae58f	\N
310	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.666+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	65730318-7bb2-4f19-af61-0201070b1efb	\N
311	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.692+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	6d8e0bc2-87a9-4e4d-9ffb-1f2638799cf0	\N
312	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.723+00	172.20.0.1	Python-urllib/3.14	packages	886d1fea-720d-4114-88bc-bf37f137aa1e	\N
313	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.75+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	c9ba4325-8f48-4884-abcd-80962031d367	\N
314	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.775+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	c21e172b-517d-4e5e-ae80-c7c43068d0e7	\N
315	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.801+00	172.20.0.1	Python-urllib/3.14	packages	5d886186-397c-45bc-bd9c-d559cc1c2678	\N
316	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.833+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	b73b8fa4-8d30-4706-8cbc-172c6d31ba59	\N
317	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.859+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	8146b7e6-062e-433e-8b92-150743308a8f	\N
318	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.891+00	172.20.0.1	Python-urllib/3.14	packages	a331cb51-c5ea-42e8-a45d-9b5beed1a3db	\N
319	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.921+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	e00d88ad-f798-4c3c-926a-123ae111959e	\N
320	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.946+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	4a00b60e-6e35-4ea1-ad2e-014ef278f3b6	\N
321	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:49.973+00	172.20.0.1	Python-urllib/3.14	packages	83d9941a-0672-45e6-b319-7205bb9e24b0	\N
322	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	4612b7ce-b23e-4aee-8602-47f5137d3b78	\N
323	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50.024+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	0bb4321b-bbca-4104-82ad-89fde8408ca4	\N
324	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50.049+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	5be26ef8-f2e9-4342-baa3-a8206ddd937a	\N
325	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50.571+00	172.20.0.1	Python-urllib/3.14	settings	1	\N
326	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50.592+00	172.20.0.1	Python-urllib/3.14	settings	2	\N
327	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50.611+00	172.20.0.1	Python-urllib/3.14	settings	3	\N
328	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50.629+00	172.20.0.1	Python-urllib/3.14	settings	4	\N
329	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50.647+00	172.20.0.1	Python-urllib/3.14	settings	5	\N
330	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50.666+00	172.20.0.1	Python-urllib/3.14	settings	6	\N
331	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50.686+00	172.20.0.1	Python-urllib/3.14	settings	7	\N
332	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50.709+00	172.20.0.1	Python-urllib/3.14	settings	8	\N
333	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:26:50.728+00	172.20.0.1	Python-urllib/3.14	settings	9	\N
334	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:28:34.226+00	172.20.0.1	curl/8.21.0	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
335	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:28:39.15+00	172.20.0.1	curl/8.21.0	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
336	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:28:44.924+00	172.20.0.1	curl/8.21.0	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
337	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:23.868+00	172.20.0.1	Python-urllib/3.14	directus_permissions	1	\N
338	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:23.939+00	172.20.0.1	Python-urllib/3.14	directus_permissions	2	\N
339	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:23.981+00	172.20.0.1	Python-urllib/3.14	directus_permissions	3	\N
340	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:24.026+00	172.20.0.1	Python-urllib/3.14	directus_permissions	4	\N
341	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:24.076+00	172.20.0.1	Python-urllib/3.14	directus_permissions	5	\N
342	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:24.115+00	172.20.0.1	Python-urllib/3.14	directus_permissions	6	\N
343	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:24.157+00	172.20.0.1	Python-urllib/3.14	directus_permissions	7	\N
344	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:52.253+00	172.20.0.1	Python-urllib/3.14	directus_fields	122	\N
345	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:52.627+00	172.20.0.1	Python-urllib/3.14	directus_fields	123	\N
346	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:52.981+00	172.20.0.1	Python-urllib/3.14	packages	5d886186-397c-45bc-bd9c-d559cc1c2678	\N
347	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:52.997+00	172.20.0.1	Python-urllib/3.14	packages	6afe21c3-5c89-405e-ae6b-0d7cf8b19478	\N
348	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:53.014+00	172.20.0.1	Python-urllib/3.14	packages	83d9941a-0672-45e6-b319-7205bb9e24b0	\N
349	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:53.032+00	172.20.0.1	Python-urllib/3.14	packages	886d1fea-720d-4114-88bc-bf37f137aa1e	\N
350	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:53.053+00	172.20.0.1	Python-urllib/3.14	packages	a331cb51-c5ea-42e8-a45d-9b5beed1a3db	\N
351	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:53.067+00	172.20.0.1	Python-urllib/3.14	packages	e581ce95-939d-4d18-a35e-2a01f8aae58f	\N
352	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:53.088+00	172.20.0.1	Python-urllib/3.14	activity_types	07885ce8-eeef-4d96-8bc6-799199bfb187	\N
353	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:53.101+00	172.20.0.1	Python-urllib/3.14	activity_types	2592b822-c30b-4d26-92fd-a0f806a8c51e	\N
354	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:53.115+00	172.20.0.1	Python-urllib/3.14	activity_types	49a970e3-a0a8-40be-890a-df45f8867f0b	\N
355	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:53.128+00	172.20.0.1	Python-urllib/3.14	activity_types	4cc0b3a2-0c22-4506-a639-76a294c66e06	\N
356	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:30:53.142+00	172.20.0.1	Python-urllib/3.14	activity_types	bad6232c-9f00-41a8-a699-535245ec3e13	\N
357	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 02:31:19.753+00	172.20.0.1	curl/8.21.0	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
358	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 03:28:42.726+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	535393f3-444f-4c68-8c6b-5fbbbd55624d	http://localhost:8055
359	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 03:28:48.54+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	863d7681-4753-4694-a4e3-97f7a643000f	http://localhost:8055
360	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 03:29:19.061+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	755848b6-cb80-490d-a0e6-9be9c70f658b	http://localhost:8055
361	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 03:29:22.846+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	e581ce95-939d-4d18-a35e-2a01f8aae58f	http://localhost:8055
362	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 03:32:30.116+00	172.20.0.1	curl/8.21.0	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
363	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 03:32:46.708+00	172.20.0.1	Python-urllib/3.14	directus_permissions	9	\N
364	create	\N	2026-07-13 06:12:11.301+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	1	http://localhost:4321
365	create	\N	2026-07-13 06:12:52.935+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	2	http://localhost:4321
366	create	\N	2026-07-13 06:12:53.294+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	3	http://localhost:4321
367	create	\N	2026-07-13 06:13:01.646+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	4	http://localhost:4321
368	create	\N	2026-07-13 06:18:47.675+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	5	http://localhost:4321
369	create	\N	2026-07-13 06:18:51.503+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	6	http://localhost:4321
370	create	\N	2026-07-13 06:19:08.458+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	7	http://localhost:4321
371	create	\N	2026-07-13 06:22:35.996+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	8	http://localhost:4321
372	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 06:29:22.635+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	1	http://localhost:8055
373	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 06:29:22.638+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	2	http://localhost:8055
374	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 06:29:22.639+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	3	http://localhost:8055
375	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 06:29:22.639+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	4	http://localhost:8055
862	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:39.059+00	172.20.0.1	Python-urllib/3.14	directus_fields	128	\N
376	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 06:29:22.64+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	5	http://localhost:8055
377	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 06:29:22.641+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	6	http://localhost:8055
378	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 06:29:22.642+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	7	http://localhost:8055
379	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 06:29:22.643+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	8	http://localhost:8055
380	create	\N	2026-07-13 06:31:23.161+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	9	http://localhost:4321
381	create	\N	2026-07-13 06:32:45.052+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	10	http://localhost:4321
382	create	\N	2026-07-13 06:40:13.934+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	11	http://localhost:4321
383	create	\N	2026-07-13 06:40:16.138+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	12	http://localhost:4321
384	create	\N	2026-07-13 06:40:22.001+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	13	http://localhost:4321
385	create	\N	2026-07-13 06:41:46.501+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	14	http://localhost:4321
386	create	\N	2026-07-13 06:41:59.479+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	15	http://localhost:4321
387	create	\N	2026-07-13 06:42:20.164+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	16	http://localhost:4321
388	create	\N	2026-07-13 06:43:16.476+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	17	http://localhost:4321
389	create	\N	2026-07-13 06:43:38.951+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	18	http://localhost:4321
390	create	\N	2026-07-13 06:43:46.097+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	19	http://localhost:4321
391	create	\N	2026-07-13 06:44:47.158+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	20	http://localhost:4321
392	create	\N	2026-07-13 08:36:21.796+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	21	http://localhost:4321
393	create	\N	2026-07-13 08:36:32.908+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	22	http://localhost:4321
394	create	\N	2026-07-13 08:36:36.003+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	23	http://localhost:4321
395	create	\N	2026-07-13 08:36:38.62+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	24	http://localhost:4321
396	create	\N	2026-07-13 08:36:41.266+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	25	http://localhost:4321
397	create	\N	2026-07-13 08:36:43.53+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	26	http://localhost:4321
398	create	\N	2026-07-13 08:36:51.074+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	27	http://localhost:4321
399	create	\N	2026-07-13 08:36:55.844+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	28	http://localhost:4321
400	create	\N	2026-07-13 08:37:05.477+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	29	http://localhost:4321
401	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:38:37.102+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
402	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:39:50.35+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
403	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:39:50.775+00	172.20.0.1	Python-urllib/3.14	directus_fields	110	\N
404	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:39:50.909+00	172.20.0.1	Python-urllib/3.14	directus_fields	71	\N
405	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:41:09.916+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
406	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:41:10.349+00	172.20.0.1	Python-urllib/3.14	directus_fields	110	\N
407	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:41:22.779+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
408	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:43:16.445+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
409	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:43:16.85+00	172.20.0.1	Python-urllib/3.14	directus_fields	110	\N
410	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:43:29.971+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
411	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:43:30.389+00	172.20.0.1	Python-urllib/3.14	directus_fields	110	\N
412	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:44:02.56+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
413	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:44:02.988+00	172.20.0.1	Python-urllib/3.14	directus_fields	110	\N
414	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.708+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	fd07dd90-9805-445b-bee9-9bdb1ca6f4c7	http://localhost:8055
415	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.722+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	534fc352-5e04-4f09-9af3-7ca9643fd5bd	http://localhost:8055
416	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.746+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	eb9b84b6-4cb2-4d2a-8896-45a2df9d57c2	http://localhost:8055
418	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.77+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	794bfde6-a082-4ea6-8cfc-438e14ddb651	http://localhost:8055
421	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.881+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	31639889-3b56-4b07-b37f-0bd0951dbfbf	http://localhost:8055
424	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.98+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	48652f44-6b17-4d85-b4db-475f539626b0	http://localhost:8055
427	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:49:23.098+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
428	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:49:56.625+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
429	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:50:20.899+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
430	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:28.634+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
431	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.06+00	172.20.0.1	Python-urllib/3.14	packages	5d886186-397c-45bc-bd9c-d559cc1c2678	\N
432	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.079+00	172.20.0.1	Python-urllib/3.14	packages	6afe21c3-5c89-405e-ae6b-0d7cf8b19478	\N
433	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.093+00	172.20.0.1	Python-urllib/3.14	packages	83d9941a-0672-45e6-b319-7205bb9e24b0	\N
434	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.108+00	172.20.0.1	Python-urllib/3.14	packages	886d1fea-720d-4114-88bc-bf37f137aa1e	\N
435	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.124+00	172.20.0.1	Python-urllib/3.14	packages	a331cb51-c5ea-42e8-a45d-9b5beed1a3db	\N
436	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.139+00	172.20.0.1	Python-urllib/3.14	packages	e581ce95-939d-4d18-a35e-2a01f8aae58f	\N
437	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.168+00	172.20.0.1	Python-urllib/3.14	destinations	09e35c4a-2012-467c-b5a2-e49e29cd2f22	\N
438	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.181+00	172.20.0.1	Python-urllib/3.14	destinations	14ee958e-d602-41fd-93dc-2e125ca45719	\N
439	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.195+00	172.20.0.1	Python-urllib/3.14	destinations	18e279f9-4aa0-4de4-a486-e815af63eb23	\N
440	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.209+00	172.20.0.1	Python-urllib/3.14	destinations	2c0e6233-0a08-44f9-b0dc-3b55c28479e1	\N
441	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.222+00	172.20.0.1	Python-urllib/3.14	destinations	539e7cd6-32a0-4c42-91d9-05dd4b58ac4d	\N
442	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.237+00	172.20.0.1	Python-urllib/3.14	destinations	6f8366b1-eda3-451a-b240-984fe41158d5	\N
443	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:54:29.251+00	172.20.0.1	Python-urllib/3.14	destinations	89862e81-f3f3-4311-9aff-9e8d9a21016c	\N
417	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.752+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	51524283-d867-4686-977c-7d4001d788b8	http://localhost:8055
419	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.78+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	bcfdac07-ed2f-48a8-a1aa-25dd9df45b2d	http://localhost:8055
420	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.876+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	d198bd7d-ff2f-46bd-be0a-8032857dacea	http://localhost:8055
422	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.887+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	b4369210-3088-40bb-8506-bb8049e14bb5	http://localhost:8055
423	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.888+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	3e059818-0378-4270-b737-4aa3f563faac	http://localhost:8055
425	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.991+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	088c8736-3301-4a7f-b0d8-84434409638c	http://localhost:8055
426	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.994+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	ebcb498f-0a85-419f-b340-787ce26d4800	http://localhost:8055
444	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:11:20.196+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
445	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:11:57.506+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
446	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.744+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	9	http://localhost:8055
447	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.753+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	10	http://localhost:8055
448	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.754+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	11	http://localhost:8055
449	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.756+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	12	http://localhost:8055
450	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.757+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	13	http://localhost:8055
451	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.758+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	14	http://localhost:8055
452	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.759+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	15	http://localhost:8055
1065	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 07:36:02.481+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
453	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.759+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	16	http://localhost:8055
454	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.76+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	17	http://localhost:8055
455	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.761+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	18	http://localhost:8055
456	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.761+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	19	http://localhost:8055
457	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.762+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	20	http://localhost:8055
458	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.763+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	21	http://localhost:8055
459	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.764+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	22	http://localhost:8055
460	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.764+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	23	http://localhost:8055
461	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.765+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	24	http://localhost:8055
462	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.767+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	25	http://localhost:8055
463	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.768+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	26	http://localhost:8055
464	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.769+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	27	http://localhost:8055
465	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.769+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	28	http://localhost:8055
466	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:06.77+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	29	http://localhost:8055
467	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.069+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	0bb4321b-bbca-4104-82ad-89fde8408ca4	http://localhost:8055
468	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.071+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	3d90a7bf-9826-421f-b151-89f1080c9f47	http://localhost:8055
526	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.596+00	172.20.0.1	Python-urllib/3.14	activity_types	3e451ca1-7ebd-4f3b-929c-6bd523774f1d	\N
469	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.072+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	4612b7ce-b23e-4aee-8602-47f5137d3b78	http://localhost:8055
470	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.074+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	4a00b60e-6e35-4ea1-ad2e-014ef278f3b6	http://localhost:8055
471	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.075+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	5be26ef8-f2e9-4342-baa3-a8206ddd937a	http://localhost:8055
472	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.075+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	65730318-7bb2-4f19-af61-0201070b1efb	http://localhost:8055
473	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.076+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	6d8e0bc2-87a9-4e4d-9ffb-1f2638799cf0	http://localhost:8055
474	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.077+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	8146b7e6-062e-433e-8b92-150743308a8f	http://localhost:8055
475	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.078+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	b73b8fa4-8d30-4706-8cbc-172c6d31ba59	http://localhost:8055
476	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.078+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	c21e172b-517d-4e5e-ae80-c7c43068d0e7	http://localhost:8055
477	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.079+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	c9ba4325-8f48-4884-abcd-80962031d367	http://localhost:8055
478	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.079+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	e00d88ad-f798-4c3c-926a-123ae111959e	http://localhost:8055
479	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:31.08+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	f01f768a-1758-4004-9140-78b9ed203473	http://localhost:8055
480	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:34.254+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	5d886186-397c-45bc-bd9c-d559cc1c2678	http://localhost:8055
481	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:34.255+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	6afe21c3-5c89-405e-ae6b-0d7cf8b19478	http://localhost:8055
482	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:34.256+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	83d9941a-0672-45e6-b319-7205bb9e24b0	http://localhost:8055
483	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:34.257+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	886d1fea-720d-4114-88bc-bf37f137aa1e	http://localhost:8055
1153	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:26:07.856+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
484	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:34.258+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	a331cb51-c5ea-42e8-a45d-9b5beed1a3db	http://localhost:8055
485	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:34.258+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	e581ce95-939d-4d18-a35e-2a01f8aae58f	http://localhost:8055
500	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:42.161+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	863d7681-4753-4694-a4e3-97f7a643000f	http://localhost:8055
501	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:42.162+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	8c84e8ef-34e2-4ff9-976f-e58f73b2a564	http://localhost:8055
502	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:42.163+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	9c2fddf3-c0e6-4d1a-a0a9-03628e22dbb9	http://localhost:8055
503	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:42.164+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	a11bb172-5658-4e98-8879-2dd3ce41dd9f	http://localhost:8055
504	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:42.164+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	ec6a1937-1fea-467b-ad67-b5cac3b7021d	http://localhost:8055
511	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:00:27.582+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	0b89c9cd-3cf1-49be-a6d6-544e116782da	http://localhost:8055
486	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.099+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	09e35c4a-2012-467c-b5a2-e49e29cd2f22	http://localhost:8055
487	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.101+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	14ee958e-d602-41fd-93dc-2e125ca45719	http://localhost:8055
488	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.102+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	18e279f9-4aa0-4de4-a486-e815af63eb23	http://localhost:8055
489	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.102+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	2c0e6233-0a08-44f9-b0dc-3b55c28479e1	http://localhost:8055
490	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.103+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	539e7cd6-32a0-4c42-91d9-05dd4b58ac4d	http://localhost:8055
491	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.104+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	6f8366b1-eda3-451a-b240-984fe41158d5	http://localhost:8055
492	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.105+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	89862e81-f3f3-4311-9aff-9e8d9a21016c	http://localhost:8055
493	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.106+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	91219cf5-7174-4582-a66d-1d7058424dec	http://localhost:8055
494	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.106+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	adfb7643-e49a-4280-8708-31150dce740f	http://localhost:8055
495	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.107+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	c876b951-6217-4a30-80af-2973f34e31f6	http://localhost:8055
496	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.108+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	d714b370-eff9-400f-9765-672ce05b7aa5	http://localhost:8055
497	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.109+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	e16c72f3-778c-482f-b000-9f084b1c8883	http://localhost:8055
498	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.109+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	f0969a63-c1b6-46c9-9f7c-3badaaa9379d	http://localhost:8055
499	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:38.11+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	f999881b-2066-4539-b648-ac81546ad0af	http://localhost:8055
505	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:47.802+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	07885ce8-eeef-4d96-8bc6-799199bfb187	http://localhost:8055
506	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:47.803+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	2592b822-c30b-4d26-92fd-a0f806a8c51e	http://localhost:8055
507	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:47.804+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	49a970e3-a0a8-40be-890a-df45f8867f0b	http://localhost:8055
508	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:47.804+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	4cc0b3a2-0c22-4506-a639-76a294c66e06	http://localhost:8055
509	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:58:47.805+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	bad6232c-9f00-41a8-a699-535245ec3e13	http://localhost:8055
510	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 03:59:57.299+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	2039cf88-bd53-45e8-a822-63d50cf8c52d	http://localhost:8055
512	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:01:14.53+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	0b89c9cd-3cf1-49be-a6d6-544e116782da	http://localhost:8055
513	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:01:14.532+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	2039cf88-bd53-45e8-a822-63d50cf8c52d	http://localhost:8055
514	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:02:39.793+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
515	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:02:52.705+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
516	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:03:02.664+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
517	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:03:32.399+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
518	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.058+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
519	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.487+00	172.20.0.1	Python-urllib/3.14	activity_types	e0506893-412e-4824-8d8b-ae019a08b904	\N
520	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.502+00	172.20.0.1	Python-urllib/3.14	activity_types	b909dcf6-2837-4369-a6c6-fbfd5b2b5134	\N
521	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.515+00	172.20.0.1	Python-urllib/3.14	activity_types	02e09c30-728c-412c-9058-89df82c61c47	\N
522	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.529+00	172.20.0.1	Python-urllib/3.14	activity_types	e6a14e35-f137-4bf5-a445-21bbff7e2955	\N
523	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.544+00	172.20.0.1	Python-urllib/3.14	activity_types	ef4be35a-a6c5-4e79-9c5c-2a5f7752e586	\N
524	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.562+00	172.20.0.1	Python-urllib/3.14	activity_types	e011abf2-00b4-4dc9-bc4e-60c7bccf290b	\N
525	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.583+00	172.20.0.1	Python-urllib/3.14	activity_types	3081b30f-b4d9-4395-b070-336e2d58e9c0	\N
527	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.609+00	172.20.0.1	Python-urllib/3.14	activity_types	0d22a213-d42d-4c87-bc2c-555d972ed4b4	\N
528	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.622+00	172.20.0.1	Python-urllib/3.14	activity_types	7813e47f-0459-4124-acf2-16fce015f275	\N
529	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.633+00	172.20.0.1	Python-urllib/3.14	activity_types	447f5da1-837e-4e0f-94c3-3d1c63c1706f	\N
530	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.649+00	172.20.0.1	Python-urllib/3.14	regions	7607935a-feaa-4a17-a49e-381b0e03ecc1	\N
531	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.664+00	172.20.0.1	Python-urllib/3.14	regions	4dad15db-1ad3-4bae-8304-1274800a84c4	\N
532	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.676+00	172.20.0.1	Python-urllib/3.14	regions	75359e6a-68ec-4057-b461-33114ec4b0e5	\N
533	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.692+00	172.20.0.1	Python-urllib/3.14	regions	b28b63cc-fdcf-4cf0-a422-6222a2af6d09	\N
534	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.705+00	172.20.0.1	Python-urllib/3.14	destinations	5e1e009e-724d-4199-a06b-06e7f15fcd6f	\N
535	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.718+00	172.20.0.1	Python-urllib/3.14	destinations	9963b299-a397-4a88-98fc-56beb9457b33	\N
536	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.73+00	172.20.0.1	Python-urllib/3.14	destinations	c7a08815-baf0-43dd-b3c2-2fd2a0d9a0a3	\N
537	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.743+00	172.20.0.1	Python-urllib/3.14	destinations	240f8811-9cf5-47e4-a184-7e3aca8caabd	\N
538	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.755+00	172.20.0.1	Python-urllib/3.14	destinations	d01cbf02-0d25-4e45-a94c-836d861176c4	\N
539	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.768+00	172.20.0.1	Python-urllib/3.14	destinations	dddcf318-008f-4e42-a958-b22ac19431ea	\N
540	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.781+00	172.20.0.1	Python-urllib/3.14	destinations	eb420955-f41f-4205-bf70-7460d2ec7ccb	\N
541	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.792+00	172.20.0.1	Python-urllib/3.14	destinations	c3fb1f20-dd99-4ad2-927f-441f612914df	\N
542	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.804+00	172.20.0.1	Python-urllib/3.14	destinations	52067f06-39de-44ce-9ab7-5bf13d124037	\N
543	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.815+00	172.20.0.1	Python-urllib/3.14	destinations	ea044597-5d2c-4a94-9018-9f627ce83335	\N
544	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.827+00	172.20.0.1	Python-urllib/3.14	destinations	75347490-a06e-4694-9aeb-040c6434a3c2	\N
545	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.84+00	172.20.0.1	Python-urllib/3.14	destinations	3027302d-aaae-4c8f-ac5e-220cad95472c	\N
546	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.852+00	172.20.0.1	Python-urllib/3.14	destinations	5b25b0bb-b579-4803-87ad-511402239021	\N
547	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.866+00	172.20.0.1	Python-urllib/3.14	destinations	80af48c1-0ae5-4aa3-8b0b-5179ba3360e7	\N
548	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.878+00	172.20.0.1	Python-urllib/3.14	destinations	36ce8c0f-8826-4c88-93fb-b9e98740e6c8	\N
549	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.89+00	172.20.0.1	Python-urllib/3.14	destinations	bcb418ab-dfa8-4315-b719-69be3b33383b	\N
550	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.904+00	172.20.0.1	Python-urllib/3.14	destinations	76ed31ce-c17f-4fa9-809e-4c7cac35420d	\N
551	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.916+00	172.20.0.1	Python-urllib/3.14	destinations	2c0ae5a6-4da4-44ae-b369-a8ad4bc2c318	\N
552	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.928+00	172.20.0.1	Python-urllib/3.14	destinations	1b096fc1-4467-4d70-b45a-2295860f42f8	\N
553	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.94+00	172.20.0.1	Python-urllib/3.14	destinations	9f7eafc4-3ead-48fc-9fec-dcebd2e70392	\N
554	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.952+00	172.20.0.1	Python-urllib/3.14	destinations	d3040ee2-357e-4993-a425-4c7573377eb9	\N
555	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.964+00	172.20.0.1	Python-urllib/3.14	destinations	601c7361-6557-4fa3-9a1f-e25f5983b0e1	\N
556	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.975+00	172.20.0.1	Python-urllib/3.14	destinations	97a6dbb8-f4bf-4944-8482-b02000cacfb0	\N
557	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:27.989+00	172.20.0.1	Python-urllib/3.14	destinations	9a40c0bd-1f09-4b16-8c2a-1438810e8cd9	\N
558	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.001+00	172.20.0.1	Python-urllib/3.14	destinations	c47613f1-4ece-4763-bf82-f1838b71d174	\N
559	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.013+00	172.20.0.1	Python-urllib/3.14	destinations	9cc0d9ec-8564-4f73-a10a-73b5f9e7494d	\N
560	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.024+00	172.20.0.1	Python-urllib/3.14	destinations	0d2e4be4-ec44-4d4d-a222-f0718a188e7c	\N
561	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.037+00	172.20.0.1	Python-urllib/3.14	packages	636ccecc-7f35-4e56-bdf1-2525c3a9f14d	\N
562	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.052+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	33dbe184-ba71-4ffc-8836-bc31e7359a01	\N
563	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.063+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	efdbbfb0-f628-4125-ab75-41b2ac7030e9	\N
564	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.074+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	3a6ee389-c48c-43c8-8647-87facf07eb9b	\N
565	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.086+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	32d3f7d7-08f3-4762-9e2d-3937cebc148d	\N
566	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.098+00	172.20.0.1	Python-urllib/3.14	packages	ad41fa23-9c4e-4ad8-a174-7e13083bd8e9	\N
567	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.112+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	4124317a-34a3-48df-95bb-9f7fd5247efe	\N
568	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.123+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	0571e371-671c-4ca2-b74f-2f29243e2807	\N
569	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.133+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	d9d4650a-2dc1-40e3-a5c3-32e675bf744f	\N
570	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.144+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	d4fe6af9-b92e-4e42-a477-7ae2e55414bf	\N
571	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.157+00	172.20.0.1	Python-urllib/3.14	packages	e6e3a104-0626-4acb-8aac-328b49d0dfb6	\N
572	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.169+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	a1022371-b983-456c-99b5-93e145a8f63d	\N
573	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.18+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	ebea9bf3-9999-4e77-8a1c-82cde1da2d73	\N
574	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.192+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	7ebb60c4-31df-423c-ae16-f6de13a891a0	\N
575	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.203+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	1db82dc1-02c9-4809-b253-cb61e839c19c	\N
576	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.214+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	21b1b57f-f098-4b78-8804-cf7af803a223	\N
863	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:39.198+00	172.20.0.1	Python-urllib/3.14	directus_fields	129	\N
577	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.225+00	172.20.0.1	Python-urllib/3.14	packages	9e7ea98a-057f-4d87-8cb9-1d3c90fc8059	\N
578	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.237+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	d62c3e31-b178-4eeb-88f3-3d678353b828	\N
579	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.248+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	ade7685d-ab53-4b14-9ea3-edf56fedee1e	\N
580	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.259+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	6fa77e56-c225-4c93-9a5b-c5ad3a82a5f2	\N
581	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.271+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	0e4683b9-d2f4-48bc-9df1-42e0c18265df	\N
582	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.285+00	172.20.0.1	Python-urllib/3.14	packages	9bb6eab0-21c4-4bcf-b8c9-23d1e91258b8	\N
583	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.297+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	166d2be9-76ea-4b05-aa21-7611f90572dc	\N
584	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.307+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	6d107ceb-b260-4f2c-b0fb-8211aefb698e	\N
585	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.318+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	3e950f50-d3ae-41e3-9193-67ea6517252b	\N
586	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.33+00	172.20.0.1	Python-urllib/3.14	packages	22e68179-0f7c-40f0-9b67-01b939302387	\N
587	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.341+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	a62ed89e-5395-4280-8248-7e1b01b3f58c	\N
588	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.352+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	f0498db9-eb28-4b91-ad9b-143e20f69099	\N
589	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.366+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	efa8736b-84c9-46f0-bce0-d1df5824aef6	\N
590	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.379+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	5f6e42c4-5ca9-4a32-a2f1-ad57c183a90e	\N
591	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.392+00	172.20.0.1	Python-urllib/3.14	packages	24855a16-6ce9-4b6f-9996-d24cba57c52b	\N
592	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.404+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	3786c9b0-cc80-4509-b119-de544840a0a0	\N
593	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.415+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	e3ff42b5-8b8e-4365-9333-b018918765ba	\N
594	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.428+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	dae0c239-e7c2-40ec-9442-a980453591d5	\N
595	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.44+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	d0c6ed08-78ac-4185-8fb8-300b9535e403	\N
596	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.454+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	6d5fa3ac-8637-4e7f-8b47-fa4c0103c1b7	\N
597	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.466+00	172.20.0.1	Python-urllib/3.14	packages	ac5a1994-faad-4d3d-95ff-9600dca0f757	\N
598	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.477+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	f2e06230-d081-4a36-8825-fc54411aa140	\N
599	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.489+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	61cf14aa-c165-4596-b5ca-ceeaa3984166	\N
600	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.5+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	36ff8e04-14fa-4c89-8094-57a4538fa5f6	\N
601	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.512+00	172.20.0.1	Python-urllib/3.14	packages	82f987ec-652c-4467-9573-7ca3087a30a3	\N
602	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.525+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	d0c5ff5c-2e4a-4eab-90f8-d19d03295b78	\N
603	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.538+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	7ab75c73-fb22-436b-869e-5a371a8102b6	\N
604	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.551+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	dc3a7480-6e64-40c3-8fc1-f7fe3a143550	\N
605	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.563+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	16b79d72-09a2-46e3-9de9-5ecd81865d2e	\N
606	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.574+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	0cffdba8-85de-472a-8214-c64095a200d1	\N
607	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.586+00	172.20.0.1	Python-urllib/3.14	packages	de809aa6-80af-4e58-bb6a-280db9df6894	\N
608	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.598+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	7fcf676c-0936-4255-a3a2-493dc77365fc	\N
609	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.609+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	0c59b676-5777-4c59-9420-43929bf4bfc8	\N
610	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.621+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	9b6dcd70-2590-4887-b1b8-a670449438bf	\N
611	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.632+00	172.20.0.1	Python-urllib/3.14	packages	ca04a086-3ed0-41eb-9a18-03b85618d8c2	\N
612	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.644+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	7bf181ea-02ae-4734-b539-e564b748ba9e	\N
613	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.656+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	d950fef8-efc5-42e3-b032-593496b31541	\N
614	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.667+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	74d69829-4900-4de9-9065-7e44d4eb2e85	\N
615	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.678+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	1704e9e2-e571-4d49-b08a-25f0d5979b9a	\N
616	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.689+00	172.20.0.1	Python-urllib/3.14	packages	f8deba71-0bfa-4065-849f-2f5fe7d3e6bf	\N
617	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.701+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	ed05ee5b-05b5-43d5-8bd3-fe4903671375	\N
618	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.711+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	36debfee-e72f-4d69-a986-5d6cd6fa3a64	\N
619	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.723+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	263a31a4-ef31-4505-a4f9-07ca96ef88dc	\N
620	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.736+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	2e0c63a6-6dc9-4585-a9c8-07fba3c8e5a7	\N
621	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.749+00	172.20.0.1	Python-urllib/3.14	packages	ddb007c9-8e02-44a3-8277-65170df52d28	\N
622	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.76+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	f693d253-224e-4aa7-b3a2-aedb833ac763	\N
623	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.772+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	ac3543a8-0986-4a5a-965f-c3875aff11d5	\N
624	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.785+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	6ab134f5-1b06-4996-bafe-195acd274f7e	\N
625	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.797+00	172.20.0.1	Python-urllib/3.14	packages	7275cb27-3f9f-492d-b759-cddb9df91b15	\N
626	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.809+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	1c7a677e-fe91-4f44-b7db-9735d4059305	\N
627	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.82+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	45cf7932-8503-42cf-921c-7763d755b28a	\N
628	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.831+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	94f0f253-d54f-4a97-a44b-66cc51fb6ccd	\N
629	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.843+00	172.20.0.1	Python-urllib/3.14	packages	2b4724d0-0a1f-49e4-9cdf-ee3f00666ecd	\N
630	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.855+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	4bc59d06-082a-44c2-bbd5-3b59092de610	\N
631	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.869+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	78c4578d-52a9-411c-b1e1-c3adaff5d5ea	\N
632	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.88+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	5cffc0f7-4068-4fb6-86be-0056da4082bc	\N
633	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.891+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	ab057e92-6f6b-41d7-8635-669abc779102	\N
634	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.903+00	172.20.0.1	Python-urllib/3.14	packages	75c4cb07-e6af-4021-9384-4b45b5a0c0f9	\N
635	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.914+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	1312669d-5cf2-4511-af69-64d3f0eaf14e	\N
636	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.925+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	0fee5f30-c70b-4a46-adac-7d18c0aa5b32	\N
637	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.937+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	a71155d1-ac23-4bcf-a499-2e3125b93289	\N
638	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.95+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	35818cdf-0ab1-47e5-a5de-4d009551c1f0	\N
639	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:28.961+00	172.20.0.1	Python-urllib/3.14	packages_activity_types	32c6756b-5e6e-4500-8da6-05d426ded2e1	\N
640	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:04:48.799+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
641	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:10:10.037+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	40e833b4-4ed9-4200-be76-9c177d0dd992	http://localhost:8055
642	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:10:51.656+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	40e833b4-4ed9-4200-be76-9c177d0dd992	http://localhost:8055
643	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:10:51.696+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	40e833b4-4ed9-4200-be76-9c177d0dd992	http://localhost:8055
644	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:11:00.851+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	2dfda479-6830-4483-8bc7-4b37bc99017b	http://localhost:8055
645	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:11:27.845+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	7607935a-feaa-4a17-a49e-381b0e03ecc1	http://localhost:8055
646	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:14:40.928+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	5ba000aa-eed9-4d49-a454-a49580cf8c31	http://localhost:8055
647	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:14:44.771+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	4dad15db-1ad3-4bae-8304-1274800a84c4	http://localhost:8055
648	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:16:06.751+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	469b271b-120d-4cae-8528-92de7d389c5a	http://localhost:8055
649	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:16:11.843+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	75359e6a-68ec-4057-b461-33114ec4b0e5	http://localhost:8055
650	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:17:36.94+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	049e1a62-a485-48b1-8e1f-e8986e495d5d	http://localhost:8055
651	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:17:55.711+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	b28b63cc-fdcf-4cf0-a422-6222a2af6d09	http://localhost:8055
652	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.948+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	0571e371-671c-4ca2-b74f-2f29243e2807	http://localhost:8055
653	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.95+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	0c59b676-5777-4c59-9420-43929bf4bfc8	http://localhost:8055
654	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.951+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	0cffdba8-85de-472a-8214-c64095a200d1	http://localhost:8055
655	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.951+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	0e4683b9-d2f4-48bc-9df1-42e0c18265df	http://localhost:8055
656	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.952+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	0fee5f30-c70b-4a46-adac-7d18c0aa5b32	http://localhost:8055
657	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.952+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	1312669d-5cf2-4511-af69-64d3f0eaf14e	http://localhost:8055
658	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.953+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	166d2be9-76ea-4b05-aa21-7611f90572dc	http://localhost:8055
659	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.954+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	16b79d72-09a2-46e3-9de9-5ecd81865d2e	http://localhost:8055
786	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.449+00	172.20.0.1	Python-urllib/3.14	destinations	0ef85b59-2544-45aa-a524-cbdf05110a4c	\N
660	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.954+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	1704e9e2-e571-4d49-b08a-25f0d5979b9a	http://localhost:8055
661	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.955+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	1c7a677e-fe91-4f44-b7db-9735d4059305	http://localhost:8055
662	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.955+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	1db82dc1-02c9-4809-b253-cb61e839c19c	http://localhost:8055
663	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.956+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	21b1b57f-f098-4b78-8804-cf7af803a223	http://localhost:8055
664	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.956+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	263a31a4-ef31-4505-a4f9-07ca96ef88dc	http://localhost:8055
665	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.957+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	2e0c63a6-6dc9-4585-a9c8-07fba3c8e5a7	http://localhost:8055
666	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.957+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	32c6756b-5e6e-4500-8da6-05d426ded2e1	http://localhost:8055
667	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.958+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	32d3f7d7-08f3-4762-9e2d-3937cebc148d	http://localhost:8055
668	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.959+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	33dbe184-ba71-4ffc-8836-bc31e7359a01	http://localhost:8055
669	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.96+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	35818cdf-0ab1-47e5-a5de-4d009551c1f0	http://localhost:8055
670	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.961+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	36debfee-e72f-4d69-a986-5d6cd6fa3a64	http://localhost:8055
671	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.961+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	36ff8e04-14fa-4c89-8094-57a4538fa5f6	http://localhost:8055
672	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.963+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	3786c9b0-cc80-4509-b119-de544840a0a0	http://localhost:8055
673	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.963+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	3a6ee389-c48c-43c8-8647-87facf07eb9b	http://localhost:8055
674	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.964+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	3e950f50-d3ae-41e3-9193-67ea6517252b	http://localhost:8055
675	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.965+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	4124317a-34a3-48df-95bb-9f7fd5247efe	http://localhost:8055
676	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:02.966+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	45cf7932-8503-42cf-921c-7763d755b28a	http://localhost:8055
677	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.7+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	4bc59d06-082a-44c2-bbd5-3b59092de610	http://localhost:8055
678	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.701+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	5cffc0f7-4068-4fb6-86be-0056da4082bc	http://localhost:8055
679	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.702+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	5f6e42c4-5ca9-4a32-a2f1-ad57c183a90e	http://localhost:8055
680	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.703+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	61cf14aa-c165-4596-b5ca-ceeaa3984166	http://localhost:8055
681	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.703+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	6ab134f5-1b06-4996-bafe-195acd274f7e	http://localhost:8055
682	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.704+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	6d107ceb-b260-4f2c-b0fb-8211aefb698e	http://localhost:8055
683	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.704+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	6d5fa3ac-8637-4e7f-8b47-fa4c0103c1b7	http://localhost:8055
684	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.705+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	6fa77e56-c225-4c93-9a5b-c5ad3a82a5f2	http://localhost:8055
685	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.706+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	74d69829-4900-4de9-9065-7e44d4eb2e85	http://localhost:8055
686	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.706+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	78c4578d-52a9-411c-b1e1-c3adaff5d5ea	http://localhost:8055
687	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.707+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	7ab75c73-fb22-436b-869e-5a371a8102b6	http://localhost:8055
787	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.461+00	172.20.0.1	Python-urllib/3.14	destinations	84019506-5144-4239-8054-0df777fdc25f	\N
688	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.709+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	7bf181ea-02ae-4734-b539-e564b748ba9e	http://localhost:8055
689	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.71+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	7ebb60c4-31df-423c-ae16-f6de13a891a0	http://localhost:8055
690	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.71+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	7fcf676c-0936-4255-a3a2-493dc77365fc	http://localhost:8055
691	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.711+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	94f0f253-d54f-4a97-a44b-66cc51fb6ccd	http://localhost:8055
692	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.712+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	9b6dcd70-2590-4887-b1b8-a670449438bf	http://localhost:8055
693	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.713+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	a1022371-b983-456c-99b5-93e145a8f63d	http://localhost:8055
694	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.714+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	a62ed89e-5395-4280-8248-7e1b01b3f58c	http://localhost:8055
695	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.716+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	a71155d1-ac23-4bcf-a499-2e3125b93289	http://localhost:8055
696	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.717+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	ab057e92-6f6b-41d7-8635-669abc779102	http://localhost:8055
697	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.718+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	ac3543a8-0986-4a5a-965f-c3875aff11d5	http://localhost:8055
698	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.721+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	ade7685d-ab53-4b14-9ea3-edf56fedee1e	http://localhost:8055
699	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.722+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	d0c5ff5c-2e4a-4eab-90f8-d19d03295b78	http://localhost:8055
700	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.723+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	d0c6ed08-78ac-4185-8fb8-300b9535e403	http://localhost:8055
701	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:05.724+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	d4fe6af9-b92e-4e42-a477-7ae2e55414bf	http://localhost:8055
702	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.421+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	d62c3e31-b178-4eeb-88f3-3d678353b828	http://localhost:8055
703	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.422+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	d950fef8-efc5-42e3-b032-593496b31541	http://localhost:8055
704	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.423+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	d9d4650a-2dc1-40e3-a5c3-32e675bf744f	http://localhost:8055
705	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.423+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	dae0c239-e7c2-40ec-9442-a980453591d5	http://localhost:8055
706	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.424+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	dc3a7480-6e64-40c3-8fc1-f7fe3a143550	http://localhost:8055
707	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.425+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	e3ff42b5-8b8e-4365-9333-b018918765ba	http://localhost:8055
708	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.426+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	ebea9bf3-9999-4e77-8a1c-82cde1da2d73	http://localhost:8055
709	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.427+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	ed05ee5b-05b5-43d5-8bd3-fe4903671375	http://localhost:8055
710	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.427+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	efa8736b-84c9-46f0-bce0-d1df5824aef6	http://localhost:8055
711	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.428+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	efdbbfb0-f628-4125-ab75-41b2ac7030e9	http://localhost:8055
712	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.428+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	f0498db9-eb28-4b91-ad9b-143e20f69099	http://localhost:8055
713	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.429+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	f2e06230-d081-4a36-8825-fc54411aa140	http://localhost:8055
714	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:08.43+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	f693d253-224e-4aa7-b3a2-aedb833ac763	http://localhost:8055
715	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.847+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	22e68179-0f7c-40f0-9b67-01b939302387	http://localhost:8055
716	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.849+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	24855a16-6ce9-4b6f-9996-d24cba57c52b	http://localhost:8055
717	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.849+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	2b4724d0-0a1f-49e4-9cdf-ee3f00666ecd	http://localhost:8055
718	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.85+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	636ccecc-7f35-4e56-bdf1-2525c3a9f14d	http://localhost:8055
719	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.851+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	7275cb27-3f9f-492d-b759-cddb9df91b15	http://localhost:8055
720	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.851+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	75c4cb07-e6af-4021-9384-4b45b5a0c0f9	http://localhost:8055
721	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.852+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	82f987ec-652c-4467-9573-7ca3087a30a3	http://localhost:8055
722	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.852+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	9bb6eab0-21c4-4bcf-b8c9-23d1e91258b8	http://localhost:8055
723	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.853+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	9e7ea98a-057f-4d87-8cb9-1d3c90fc8059	http://localhost:8055
724	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.856+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	ac5a1994-faad-4d3d-95ff-9600dca0f757	http://localhost:8055
725	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.857+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	ad41fa23-9c4e-4ad8-a174-7e13083bd8e9	http://localhost:8055
726	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.859+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	ca04a086-3ed0-41eb-9a18-03b85618d8c2	http://localhost:8055
727	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.86+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	ddb007c9-8e02-44a3-8277-65170df52d28	http://localhost:8055
728	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.862+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	de809aa6-80af-4e58-bb6a-280db9df6894	http://localhost:8055
729	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.863+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	e6e3a104-0626-4acb-8aac-328b49d0dfb6	http://localhost:8055
730	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:16.864+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	f8deba71-0bfa-4065-849f-2f5fe7d3e6bf	http://localhost:8055
731	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.781+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	0d2e4be4-ec44-4d4d-a222-f0718a188e7c	http://localhost:8055
732	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.782+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	1b096fc1-4467-4d70-b45a-2295860f42f8	http://localhost:8055
733	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.782+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	240f8811-9cf5-47e4-a184-7e3aca8caabd	http://localhost:8055
734	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.783+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	2c0ae5a6-4da4-44ae-b369-a8ad4bc2c318	http://localhost:8055
735	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.783+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	3027302d-aaae-4c8f-ac5e-220cad95472c	http://localhost:8055
736	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.784+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	36ce8c0f-8826-4c88-93fb-b9e98740e6c8	http://localhost:8055
737	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.784+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	52067f06-39de-44ce-9ab7-5bf13d124037	http://localhost:8055
738	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.785+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	5b25b0bb-b579-4803-87ad-511402239021	http://localhost:8055
739	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.785+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	5e1e009e-724d-4199-a06b-06e7f15fcd6f	http://localhost:8055
740	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.786+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	601c7361-6557-4fa3-9a1f-e25f5983b0e1	http://localhost:8055
741	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.786+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	75347490-a06e-4694-9aeb-040c6434a3c2	http://localhost:8055
1154	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:26:08.295+00	172.20.0.1	Python-urllib/3.14	directus_operations	69515475-2a33-4b04-a09c-86e491b20e0a	\N
742	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.787+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	76ed31ce-c17f-4fa9-809e-4c7cac35420d	http://localhost:8055
743	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.787+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	80af48c1-0ae5-4aa3-8b0b-5179ba3360e7	http://localhost:8055
744	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.788+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	97a6dbb8-f4bf-4944-8482-b02000cacfb0	http://localhost:8055
745	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.788+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	9963b299-a397-4a88-98fc-56beb9457b33	http://localhost:8055
746	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.789+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	9a40c0bd-1f09-4b16-8c2a-1438810e8cd9	http://localhost:8055
747	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.79+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	9cc0d9ec-8564-4f73-a10a-73b5f9e7494d	http://localhost:8055
748	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.79+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	9f7eafc4-3ead-48fc-9fec-dcebd2e70392	http://localhost:8055
749	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.791+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	bcb418ab-dfa8-4315-b719-69be3b33383b	http://localhost:8055
750	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.792+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	c3fb1f20-dd99-4ad2-927f-441f612914df	http://localhost:8055
751	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.793+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	c47613f1-4ece-4763-bf82-f1838b71d174	http://localhost:8055
752	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.794+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	c7a08815-baf0-43dd-b3c2-2fd2a0d9a0a3	http://localhost:8055
753	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.795+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	d01cbf02-0d25-4e45-a94c-836d861176c4	http://localhost:8055
754	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.796+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	d3040ee2-357e-4993-a425-4c7573377eb9	http://localhost:8055
755	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:21.797+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	dddcf318-008f-4e42-a958-b22ac19431ea	http://localhost:8055
756	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:24.988+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	ea044597-5d2c-4a94-9018-9f627ce83335	http://localhost:8055
757	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:19:24.989+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	eb420955-f41f-4205-bf70-7460d2ec7ccb	http://localhost:8055
758	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:25:55.311+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	fb28d20c-bd40-4cb6-b4c5-9bc3e34a1e55	http://localhost:8055
759	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:13.071+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
760	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:32.666+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
761	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.119+00	172.20.0.1	Python-urllib/3.14	regions	d8da88e3-b0c8-4167-ad44-82baddda2c47	\N
762	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.136+00	172.20.0.1	Python-urllib/3.14	regions	d3eb9365-e929-413f-a770-e0f491bbeb35	\N
763	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.15+00	172.20.0.1	Python-urllib/3.14	regions	c4b01a33-9919-4dba-b839-c7177bdba873	\N
764	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.164+00	172.20.0.1	Python-urllib/3.14	destinations	df99c778-0f0f-44ad-80c3-294fb96ea64d	\N
765	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.178+00	172.20.0.1	Python-urllib/3.14	destinations	231cbb58-8271-4c93-9b46-ba03c0d832a3	\N
766	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.19+00	172.20.0.1	Python-urllib/3.14	destinations	19ef6acd-c355-487e-91a3-6fded9e1dc69	\N
767	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.203+00	172.20.0.1	Python-urllib/3.14	destinations	0147b105-1e9b-42c8-8c23-6151802df6aa	\N
768	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.214+00	172.20.0.1	Python-urllib/3.14	destinations	c55f04b5-3634-431d-ad5c-38630f15ecfc	\N
769	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.229+00	172.20.0.1	Python-urllib/3.14	destinations	5ee96e0d-1462-4f72-b176-efad4bef9391	\N
770	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.244+00	172.20.0.1	Python-urllib/3.14	destinations	c595bb75-5e74-41a5-b791-a222e4a39865	\N
771	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.265+00	172.20.0.1	Python-urllib/3.14	destinations	b544a207-499b-49ed-abdb-a0db3521e3d2	\N
772	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.278+00	172.20.0.1	Python-urllib/3.14	destinations	8936e20d-e259-48da-a7d0-bcfcc266c948	\N
773	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.288+00	172.20.0.1	Python-urllib/3.14	destinations	8d9a8a63-df62-45aa-9412-d4162429f9c7	\N
774	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.303+00	172.20.0.1	Python-urllib/3.14	destinations	7363992d-f728-43b5-a9e4-8a66b2dd2b22	\N
775	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.316+00	172.20.0.1	Python-urllib/3.14	destinations	b60db3b4-b676-4eaf-b8ae-99ffcc1f318a	\N
776	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.329+00	172.20.0.1	Python-urllib/3.14	destinations	fef30e82-71f9-4f0c-9a40-f075dc31e149	\N
777	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.34+00	172.20.0.1	Python-urllib/3.14	destinations	1afd1492-7784-403e-9114-f21ec411db9a	\N
778	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.353+00	172.20.0.1	Python-urllib/3.14	destinations	f8feeeee-3064-4a45-bb7f-c217b53cc500	\N
779	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.366+00	172.20.0.1	Python-urllib/3.14	destinations	adaae5b7-cb12-4fdf-9db8-5911a7a3b5fa	\N
780	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.377+00	172.20.0.1	Python-urllib/3.14	destinations	a0040269-2db6-491f-a252-3adf243d9c77	\N
781	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.388+00	172.20.0.1	Python-urllib/3.14	destinations	847cb845-1913-46a0-b5c5-6729d50aa9af	\N
782	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.4+00	172.20.0.1	Python-urllib/3.14	destinations	61f016a1-f859-46cf-8ecd-4a6c6039e497	\N
783	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.412+00	172.20.0.1	Python-urllib/3.14	destinations	c8d1188c-9af9-46b9-90b1-5c6148ea706b	\N
784	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.423+00	172.20.0.1	Python-urllib/3.14	destinations	ee9d815f-01f8-4162-84be-f22b255f2b16	\N
785	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.435+00	172.20.0.1	Python-urllib/3.14	destinations	dba9e42c-d64d-47b6-9364-049836be2f3f	\N
788	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.471+00	172.20.0.1	Python-urllib/3.14	destinations	2c8caa3f-e00b-449f-8d65-e11d37926e6d	\N
789	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.482+00	172.20.0.1	Python-urllib/3.14	destinations	dded4cf3-3636-431d-bc06-8c503a553d68	\N
790	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.494+00	172.20.0.1	Python-urllib/3.14	destinations	b09b4ccd-4ef7-4717-8b2a-b083889020b2	\N
791	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:49.284+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
792	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:49.739+00	172.20.0.1	Python-urllib/3.14	regions	4dad15db-1ad3-4bae-8304-1274800a84c4	\N
793	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:28:02.968+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
794	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:28:03.408+00	172.20.0.1	Python-urllib/3.14	regions	75359e6a-68ec-4057-b461-33114ec4b0e5	\N
795	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:28:03.424+00	172.20.0.1	Python-urllib/3.14	regions	7607935a-feaa-4a17-a49e-381b0e03ecc1	\N
796	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:28:16.967+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
797	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:30:24.6+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
798	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:30:25.035+00	172.20.0.1	Python-urllib/3.14	regions	b28b63cc-fdcf-4cf0-a422-6222a2af6d09	\N
799	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:30:25.053+00	172.20.0.1	Python-urllib/3.14	regions	c4b01a33-9919-4dba-b839-c7177bdba873	\N
800	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:30:25.068+00	172.20.0.1	Python-urllib/3.14	regions	d3eb9365-e929-413f-a770-e0f491bbeb35	\N
801	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:30:25.084+00	172.20.0.1	Python-urllib/3.14	regions	d8da88e3-b0c8-4167-ad44-82baddda2c47	\N
802	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:30:48.577+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	e460c166-783d-468c-a72b-fa57019fe90e	http://localhost:8055
803	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:30:52.125+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	c4b01a33-9919-4dba-b839-c7177bdba873	http://localhost:8055
804	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:31:06.352+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	a45ff57c-32ed-4fec-8c2c-9fe05b59cd4a	http://localhost:8055
805	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:31:14.774+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	d3eb9365-e929-413f-a770-e0f491bbeb35	http://localhost:8055
806	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:31:28.246+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	0de66444-4238-49ae-a548-4148b5a0c347	http://localhost:8055
807	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:31:31.541+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	d8da88e3-b0c8-4167-ad44-82baddda2c47	http://localhost:8055
808	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.19+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	0147b105-1e9b-42c8-8c23-6151802df6aa	http://localhost:8055
809	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.191+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	0ef85b59-2544-45aa-a524-cbdf05110a4c	http://localhost:8055
810	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.192+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	19ef6acd-c355-487e-91a3-6fded9e1dc69	http://localhost:8055
811	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.193+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	1afd1492-7784-403e-9114-f21ec411db9a	http://localhost:8055
812	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.193+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	231cbb58-8271-4c93-9b46-ba03c0d832a3	http://localhost:8055
813	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.194+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	2c8caa3f-e00b-449f-8d65-e11d37926e6d	http://localhost:8055
814	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.195+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	5ee96e0d-1462-4f72-b176-efad4bef9391	http://localhost:8055
815	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.195+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	61f016a1-f859-46cf-8ecd-4a6c6039e497	http://localhost:8055
816	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.196+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	7363992d-f728-43b5-a9e4-8a66b2dd2b22	http://localhost:8055
817	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.197+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	84019506-5144-4239-8054-0df777fdc25f	http://localhost:8055
818	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.198+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	847cb845-1913-46a0-b5c5-6729d50aa9af	http://localhost:8055
819	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.199+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	8936e20d-e259-48da-a7d0-bcfcc266c948	http://localhost:8055
820	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.2+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	8d9a8a63-df62-45aa-9412-d4162429f9c7	http://localhost:8055
1066	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 07:58:13.297+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
821	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.201+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	a0040269-2db6-491f-a252-3adf243d9c77	http://localhost:8055
822	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.201+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	adaae5b7-cb12-4fdf-9db8-5911a7a3b5fa	http://localhost:8055
861	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:39.002+00	172.20.0.1	Python-urllib/3.14	directus_fields	127	\N
823	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.202+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	b09b4ccd-4ef7-4717-8b2a-b083889020b2	http://localhost:8055
824	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.203+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	b544a207-499b-49ed-abdb-a0db3521e3d2	http://localhost:8055
825	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.204+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	b60db3b4-b676-4eaf-b8ae-99ffcc1f318a	http://localhost:8055
826	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.205+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	c55f04b5-3634-431d-ad5c-38630f15ecfc	http://localhost:8055
827	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.205+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	c595bb75-5e74-41a5-b791-a222e4a39865	http://localhost:8055
828	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.206+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	c8d1188c-9af9-46b9-90b1-5c6148ea706b	http://localhost:8055
829	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.207+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	dba9e42c-d64d-47b6-9364-049836be2f3f	http://localhost:8055
830	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.207+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	dded4cf3-3636-431d-bc06-8c503a553d68	http://localhost:8055
831	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.208+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	df99c778-0f0f-44ad-80c3-294fb96ea64d	http://localhost:8055
832	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:10.209+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	ee9d815f-01f8-4162-84be-f22b255f2b16	http://localhost:8055
833	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:14.827+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	f8feeeee-3064-4a45-bb7f-c217b53cc500	http://localhost:8055
834	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:36:14.828+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	fef30e82-71f9-4f0c-9a40-f075dc31e149	http://localhost:8055
835	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:38:23.518+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	b28b63cc-fdcf-4cf0-a422-6222a2af6d09	http://localhost:8055
836	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:38:23.52+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	c4b01a33-9919-4dba-b839-c7177bdba873	http://localhost:8055
837	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:38:23.521+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	d8da88e3-b0c8-4167-ad44-82baddda2c47	http://localhost:8055
838	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:39:14.969+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	0d22a213-d42d-4c87-bc2c-555d972ed4b4	http://localhost:8055
839	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:56:44.974+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	d3eb9365-e929-413f-a770-e0f491bbeb35	http://localhost:8055
840	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:58:59.1+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	40ae6b39-86a0-4814-a1e1-85f147754ae7	http://localhost:8055
841	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:59:04.556+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	5ec5476a-aad9-4b36-a20e-23b5f8dc7347	http://localhost:8055
842	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 05:02:33.628+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
843	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 05:02:45.84+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
844	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 05:02:49.97+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
845	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 05:03:03.856+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
846	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 05:03:17.041+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
847	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 05:03:17.474+00	172.20.0.1	Python-urllib/3.14	directus_fields	72	\N
848	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 05:03:25.495+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
849	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:09.005+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
850	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:09.448+00	172.20.0.1	Python-urllib/3.14	directus_fields	74	\N
851	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:09.51+00	172.20.0.1	Python-urllib/3.14	directus_fields	110	\N
852	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:28.912+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
853	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:29.388+00	172.20.0.1	Python-urllib/3.14	directus_fields	124	\N
854	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:29.393+00	172.20.0.1	Python-urllib/3.14	directus_collections	test_collection_123	\N
855	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:29.438+00	172.20.0.1	Python-urllib/3.14	directus_collections	test_collection_123	\N
856	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:29.441+00	172.20.0.1	Python-urllib/3.14	directus_fields	124	\N
857	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:38.372+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
858	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:38.898+00	172.20.0.1	Python-urllib/3.14	directus_fields	125	\N
859	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:38.902+00	172.20.0.1	Python-urllib/3.14	directus_collections	destinations_gallery_images	\N
860	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:38.941+00	172.20.0.1	Python-urllib/3.14	directus_fields	126	\N
864	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:39.28+00	172.20.0.1	Python-urllib/3.14	directus_fields	130	\N
865	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:39.285+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages_gallery_images	\N
866	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:39.321+00	172.20.0.1	Python-urllib/3.14	directus_fields	131	\N
867	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:39.366+00	172.20.0.1	Python-urllib/3.14	directus_fields	132	\N
868	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:39.409+00	172.20.0.1	Python-urllib/3.14	directus_fields	133	\N
869	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:39.525+00	172.20.0.1	Python-urllib/3.14	directus_fields	134	\N
870	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:04:58.248+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
871	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:06:59.094+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
872	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:07:17.016+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
873	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:07:31.122+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
874	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:07:43.696+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
875	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:08:04.162+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
876	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:08:04.61+00	172.20.0.1	Python-urllib/3.14	directus_roles	67f28eff-0807-43ec-abd6-c8c9da586552	\N
877	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:08:17.477+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
878	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:08:31.837+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
879	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:08:45.032+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
880	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:08:45.468+00	172.20.0.1	Python-urllib/3.14	directus_fields	129	\N
881	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:08:45.503+00	172.20.0.1	Python-urllib/3.14	directus_fields	135	\N
882	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:08:45.577+00	172.20.0.1	Python-urllib/3.14	directus_fields	134	\N
883	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:08:45.629+00	172.20.0.1	Python-urllib/3.14	directus_fields	136	\N
884	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:11:44.371+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
885	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:12:05.724+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
886	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:12:58.227+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
887	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:13:58.41+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
888	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:15:16.974+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
889	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:15:17.431+00	172.20.0.1	Python-urllib/3.14	directus_fields	126	\N
890	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:15:17.535+00	172.20.0.1	Python-urllib/3.14	directus_fields	131	\N
891	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:15:34.68+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
892	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:15:35.122+00	172.20.0.1	Python-urllib/3.14	directus_fields	135	\N
893	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:15:35.128+00	172.20.0.1	Python-urllib/3.14	directus_fields	126	\N
894	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:15:35.166+00	172.20.0.1	Python-urllib/3.14	directus_fields	136	\N
895	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:15:35.171+00	172.20.0.1	Python-urllib/3.14	directus_fields	131	\N
896	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:15:35.205+00	172.20.0.1	Python-urllib/3.14	directus_fields	137	\N
897	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:15:35.253+00	172.20.0.1	Python-urllib/3.14	directus_fields	138	\N
898	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:16:17.009+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
899	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:16:31.034+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
900	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:16:42.423+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
901	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:16:57.827+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
902	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:16:58.344+00	172.20.0.1	Python-urllib/3.14	directus_fields	139	\N
903	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:16:58.397+00	172.20.0.1	Python-urllib/3.14	directus_fields	140	\N
904	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:17:12.97+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
905	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:17:41.926+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
906	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:17:42.362+00	172.20.0.1	Python-urllib/3.14	directus_fields	139	\N
907	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:17:42.394+00	172.20.0.1	Python-urllib/3.14	directus_fields	141	\N
908	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:17:42.444+00	172.20.0.1	Python-urllib/3.14	directus_fields	140	\N
909	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:17:42.477+00	172.20.0.1	Python-urllib/3.14	directus_fields	142	\N
910	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:18:29.966+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
911	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:18:41.712+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
912	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:20:22.522+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
913	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:20:40.864+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
914	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:20:41.302+00	172.20.0.1	Python-urllib/3.14	directus_fields	141	\N
915	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:20:41.389+00	172.20.0.1	Python-urllib/3.14	directus_fields	142	\N
916	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:23:12.888+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
917	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:24:04.743+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
918	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:24:42.383+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
924	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:25:07.185+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages_gallery_images	\N
925	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:25:07.192+00	172.20.0.1	Python-urllib/3.14	directus_fields	130	\N
926	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:25:07.193+00	172.20.0.1	Python-urllib/3.14	directus_fields	132	\N
927	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:25:07.193+00	172.20.0.1	Python-urllib/3.14	directus_fields	133	\N
928	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:25:07.194+00	172.20.0.1	Python-urllib/3.14	directus_fields	138	\N
929	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:40.056+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
930	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:40.743+00	172.20.0.1	Python-urllib/3.14	directus_fields	143	\N
931	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:40.748+00	172.20.0.1	Python-urllib/3.14	directus_collections	destinations_gallery_images	\N
932	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:40.796+00	172.20.0.1	Python-urllib/3.14	directus_fields	144	\N
933	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:40.799+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages_gallery_images	\N
934	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:40.866+00	172.20.0.1	Python-urllib/3.14	directus_fields	145	\N
935	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:40.927+00	172.20.0.1	Python-urllib/3.14	directus_fields	146	\N
936	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:40.987+00	172.20.0.1	Python-urllib/3.14	directus_fields	147	\N
937	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:41.069+00	172.20.0.1	Python-urllib/3.14	directus_fields	148	\N
938	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:41.126+00	172.20.0.1	Python-urllib/3.14	directus_fields	149	\N
939	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:41.174+00	172.20.0.1	Python-urllib/3.14	directus_fields	150	\N
940	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:41.218+00	172.20.0.1	Python-urllib/3.14	directus_fields	151	\N
941	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:26:41.258+00	172.20.0.1	Python-urllib/3.14	directus_fields	152	\N
942	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:27:31.146+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
943	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:28:01.55+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
944	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:28:03.763+00	172.20.0.1	Python-urllib/3.14	directus_fields	153	\N
945	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:28:03.769+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages_gallery_images	\N
946	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:28:04.069+00	172.20.0.1	Python-urllib/3.14	directus_fields	153	\N
947	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:28:04.365+00	172.20.0.1	Python-urllib/3.14	directus_fields	154	\N
948	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:28:04.425+00	172.20.0.1	Python-urllib/3.14	directus_fields	155	\N
949	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:32:03.421+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
950	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:32:16.617+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
951	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:32:44.783+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
952	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:32:45.236+00	172.20.0.1	Python-urllib/3.14	directus_fields	174	\N
953	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:32:45.319+00	172.20.0.1	Python-urllib/3.14	directus_fields	175	\N
954	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:33:01.999+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
955	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:33:42.181+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
956	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:33:44.254+00	172.20.0.1	Python-urllib/3.14	directus_fields	176	\N
957	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:33:44.258+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages_gallery_images	\N
958	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:33:44.329+00	172.20.0.1	Python-urllib/3.14	directus_fields	176	\N
959	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:33:44.379+00	172.20.0.1	Python-urllib/3.14	directus_fields	177	\N
960	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:33:44.433+00	172.20.0.1	Python-urllib/3.14	directus_fields	178	\N
961	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:35:09.555+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
962	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:35:30.037+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
963	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:35:31.608+00	172.20.0.1	Python-urllib/3.14	directus_fields	180	\N
964	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:35:31.616+00	172.20.0.1	Python-urllib/3.14	directus_fields	187	\N
965	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:35:31.668+00	172.20.0.1	Python-urllib/3.14	directus_fields	188	\N
966	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:36:04.275+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
967	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:36:04.773+00	172.20.0.1	Python-urllib/3.14	directus_fields	189	\N
968	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:36:04.865+00	172.20.0.1	Python-urllib/3.14	directus_fields	190	\N
969	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:39:34.901+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
970	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:39:35.335+00	172.20.0.1	Python-urllib/3.14	directus_fields	189	\N
971	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:39:35.421+00	172.20.0.1	Python-urllib/3.14	directus_fields	190	\N
972	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:46:25.043+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	96c0bc18-ba54-4173-b78c-2910338c56e2	http://localhost:8055
973	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:46:38.978+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	9e57cb99-472b-4605-bc3d-952a1e0a75ba	http://localhost:8055
974	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:47:01.56+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	9e57cb99-472b-4605-bc3d-952a1e0a75ba	http://localhost:8055
975	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:49:54.622+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	7af52fd4-e747-4133-8b4a-2522506f8c2f	http://localhost:8055
976	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:53:30.447+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
977	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:53:30.798+00	172.20.0.1	Python-urllib/3.14	directus_fields	114	\N
978	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:54:17.479+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	777316e5-1db9-4ed7-abb2-3686dc8435ba	http://localhost:8055
979	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:54:49.05+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	4c59c05b-81cc-4c0d-975d-287c85af1817	http://localhost:8055
980	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:03:35.848+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	1af7d43f-492c-4301-975b-6a4e2e7bb0b6	http://localhost:8055
981	create	\N	2026-07-14 07:07:40.23+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	30	http://localhost:4321
982	create	\N	2026-07-14 07:07:43.978+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	31	http://localhost:4321
983	create	\N	2026-07-14 07:07:48.497+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	32	http://localhost:4321
984	create	\N	2026-07-14 07:07:53.449+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	33	http://localhost:4321
985	create	\N	2026-07-14 07:08:07.318+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	34	http://localhost:4321
986	create	\N	2026-07-14 07:08:18.33+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	35	http://localhost:4321
987	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:09:19.069+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	30	http://localhost:8055
988	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:09:19.071+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	31	http://localhost:8055
989	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:09:19.072+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	32	http://localhost:8055
990	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:09:19.074+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	33	http://localhost:8055
991	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:09:19.075+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	34	http://localhost:8055
992	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:09:19.076+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	35	http://localhost:8055
993	create	\N	2026-07-14 07:52:45.962+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	36	http://localhost:4321
994	create	\N	2026-07-14 07:52:57.586+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	37	http://localhost:4321
995	create	\N	2026-07-14 07:55:29.432+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	38	http://localhost:4321
996	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:57:07.355+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
997	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:57:07.702+00	172.20.0.1	Python-urllib/3.14	directus_fields	191	\N
998	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:57:22.496+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
999	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:57:22.921+00	172.20.0.1	Python-urllib/3.14	directus_fields	191	\N
1000	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:57:22.959+00	172.20.0.1	Python-urllib/3.14	directus_fields	192	\N
1001	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:57:38.442+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1002	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:57:38.866+00	172.20.0.1	Python-urllib/3.14	directus_fields	192	\N
1003	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:57:38.937+00	172.20.0.1	Python-urllib/3.14	directus_fields	193	\N
1004	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:58:26.178+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1005	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 07:58:26.595+00	172.20.0.1	Python-urllib/3.14	directus_fields	193	\N
1006	create	\N	2026-07-14 07:58:54.452+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	39	http://localhost:4321
1007	create	\N	2026-07-14 08:47:23.83+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	40	http://localhost:4321
1008	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 02:01:32.393+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	112	http://localhost:8055
1009	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 02:02:25.181+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	777316e5-1db9-4ed7-abb2-3686dc8435ba	http://localhost:8055
1010	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 02:02:59.032+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	777316e5-1db9-4ed7-abb2-3686dc8435ba	http://localhost:8055
1011	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 02:08:01.601+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	114	http://localhost:8055
1012	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 02:27:48.262+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	113	http://localhost:8055
1013	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 02:51:09.321+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	113	http://localhost:8055
1014	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:34:11.683+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_dashboards	4524bb1d-338e-4720-989a-7d28fa193ef6	http://localhost:8055
1015	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:34:44.931+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_dashboards	4524bb1d-338e-4720-989a-7d28fa193ef6	http://localhost:8055
1016	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:36:02.241+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_dashboards	1e1f96f4-9ff4-4ce5-987b-379796c2a11c	http://localhost:8055
1017	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:39:06.988+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	http://localhost:8055
1018	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:39:42.796+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	http://localhost:8055
1019	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:40:12.329+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	http://localhost:8055
1020	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:40:41.583+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	http://localhost:8055
1021	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:41:37.036+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	http://localhost:8055
1022	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:41:42.592+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	http://localhost:8055
1023	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:41:48.704+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	http://localhost:8055
1024	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:16.575+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1025	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:17.003+00	172.20.0.1	Python-urllib/3.14	directus_dashboards	aa7204de-fda7-4cbf-a6ad-8552f2169c3d	\N
1026	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:17.02+00	172.20.0.1	Python-urllib/3.14	directus_dashboards	2c3afa5a-7b28-4a2b-8a21-f9804e99375a	\N
1027	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:35.662+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1028	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:36.091+00	172.20.0.1	Python-urllib/3.14	directus_panels	8665d8ba-8be5-4d7a-937d-93bcb8a16c14	\N
1029	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:36.107+00	172.20.0.1	Python-urllib/3.14	directus_panels	6e945b45-0c44-478f-803c-285c1a918677	\N
1030	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:36.121+00	172.20.0.1	Python-urllib/3.14	directus_panels	57b325d7-569c-4919-9692-ee9eb1a82938	\N
1031	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:36.135+00	172.20.0.1	Python-urllib/3.14	directus_panels	680f934f-fc6d-4518-bb4d-70bc4d1a9b52	\N
1032	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:36.151+00	172.20.0.1	Python-urllib/3.14	directus_panels	d3e495f3-8892-438a-bb1c-ecc3ff84da0c	\N
1033	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:36.165+00	172.20.0.1	Python-urllib/3.14	directus_panels	4e852818-ee4b-42fc-b575-a82f17e804e0	\N
1034	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:36.178+00	172.20.0.1	Python-urllib/3.14	directus_panels	57fc17a6-f156-4748-af27-5a57655a7279	\N
1035	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:46:36.191+00	172.20.0.1	Python-urllib/3.14	directus_panels	1ad9dd66-c143-48a8-9d96-90af26cf0b4a	\N
1036	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:51:07.662+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	57b325d7-569c-4919-9692-ee9eb1a82938	http://localhost:8055
1037	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:51:07.67+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	8665d8ba-8be5-4d7a-937d-93bcb8a16c14	http://localhost:8055
1038	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:51:07.674+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	6e945b45-0c44-478f-803c-285c1a918677	http://localhost:8055
1039	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:51:07.679+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	d3e495f3-8892-438a-bb1c-ecc3ff84da0c	http://localhost:8055
1040	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:51:46.779+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	1ad9dd66-c143-48a8-9d96-90af26cf0b4a	http://localhost:8055
1041	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:51:46.784+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	57fc17a6-f156-4748-af27-5a57655a7279	http://localhost:8055
1042	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:51:46.79+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_panels	4e852818-ee4b-42fc-b575-a82f17e804e0	http://localhost:8055
1043	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:52:00.249+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_dashboards	aa7204de-fda7-4cbf-a6ad-8552f2169c3d	http://localhost:8055
1044	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:52:00.25+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_dashboards	2c3afa5a-7b28-4a2b-8a21-f9804e99375a	http://localhost:8055
1045	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 03:52:00.251+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_dashboards	1e1f96f4-9ff4-4ce5-987b-379796c2a11c	http://localhost:8055
1046	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:09:03.257+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	0e113d05-2450-4eb6-bfc3-5f47a891dc7c	http://localhost:8055
1047	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:22:45.855+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	113	http://localhost:8055
1048	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:23:57.293+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	0e113d05-2450-4eb6-bfc3-5f47a891dc7c	http://localhost:8055
1049	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:32:07.365+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	1af7d43f-492c-4301-975b-6a4e2e7bb0b6	http://localhost:8055
1050	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:32:07.368+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	4c59c05b-81cc-4c0d-975d-287c85af1817	http://localhost:8055
1051	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:32:12.378+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	777316e5-1db9-4ed7-abb2-3686dc8435ba	http://localhost:8055
1052	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:36:01.827+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	71d0c1b6-83be-4473-b73d-efc034075eda	http://localhost:8055
1053	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:42:20.507+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	1fdbcdba-d886-443f-864b-6a1b65967c7e	http://localhost:8055
1054	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:49:16.746+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	e2c9f388-06bd-4a3c-8713-efc97ce59124	http://localhost:8055
1055	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:55:48.133+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	6fe7ac8a-f231-4949-b2b2-77b9b309c74a	http://localhost:8055
1056	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 04:58:35.24+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	4e215743-3f94-4328-a631-92597e4ee300	http://localhost:8055
1057	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 06:16:08.834+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	4e215743-3f94-4328-a631-92597e4ee300	http://localhost:8055
1058	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 06:18:56.436+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	d7d315e7-a26c-42aa-8e93-fe5a23b10036	http://localhost:8055
1059	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 06:19:21.66+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	f7d36bbb-1da9-41b1-ba39-1b3f1ffe229a	http://localhost:8055
1060	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 06:19:41.182+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	8fca081e-d37c-4cbb-b4e4-64be8446bf91	http://localhost:8055
1061	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 06:20:28.38+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	3f70db38-0bd0-4d59-9841-75e4a23d31d8	http://localhost:8055
1062	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 06:20:35.454+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	43f73151-16ad-46b3-959a-713be9ff480f	http://localhost:8055
1063	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 06:20:54.446+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	7608e659-9c1e-41bb-b66b-331fac00c408	http://localhost:8055
1064	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 06:21:09.589+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages_activity_types	8f2ab01b-b2eb-4020-a93c-37f3ba1527bd	http://localhost:8055
1067	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 07:58:55.259+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
1092	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.786+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	104	http://localhost:8055
1093	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.8+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	105	http://localhost:8055
1094	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.808+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	106	http://localhost:8055
1095	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.816+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	107	http://localhost:8055
1096	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.824+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	108	http://localhost:8055
1097	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.832+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	109	http://localhost:8055
1098	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.84+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	111	http://localhost:8055
1099	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.847+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	112	http://localhost:8055
1100	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.856+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	114	http://localhost:8055
1101	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.864+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	113	http://localhost:8055
1102	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.873+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	122	http://localhost:8055
1103	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.881+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	194	http://localhost:8055
1104	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:53.889+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	190	http://localhost:8055
1157	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:26:22.861+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1068	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 07:59:15.909+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_files	04b20e66-94f5-4784-9f42-f43f3c8551fa	http://localhost:8055
1069	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 07:59:19.459+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
1070	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 07:59:34.163+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
1075	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 08:01:48.049+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	116	http://localhost:8055
1077	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 08:02:26.77+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	ef4be35a-a6c5-4e79-9c5c-2a5f7752e586	http://localhost:8055
1080	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 08:02:51.255+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	116	http://localhost:8055
1105	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:05:44.095+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	1fdbcdba-d886-443f-864b-6a1b65967c7e	http://localhost:8055
1158	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:26:23.313+00	172.20.0.1	Python-urllib/3.14	directus_operations	a50f40e2-1d80-4c5f-80d0-e63ec5bbf7ee	\N
1159	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:26:23.323+00	172.20.0.1	Python-urllib/3.14	directus_operations	69515475-2a33-4b04-a09c-86e491b20e0a	\N
1161	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:26:32.346+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1162	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:27:01.668+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1163	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:27:12.821+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1164	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:27:13.272+00	172.20.0.1	Python-urllib/3.14	directus_operations	d96f8f25-4262-4562-b849-0ca30534d242	\N
1165	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:27:13.305+00	172.20.0.1	Python-urllib/3.14	directus_operations	d96f8f25-4262-4562-b849-0ca30534d242	\N
1166	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:27:13.318+00	172.20.0.1	Python-urllib/3.14	directus_operations	69515475-2a33-4b04-a09c-86e491b20e0a	\N
1220	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:12.947+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1221	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.392+00	172.20.0.1	Python-urllib/3.14	directus_collections	articles	\N
1222	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.396+00	172.20.0.1	Python-urllib/3.14	directus_fields	204	\N
1223	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.398+00	172.20.0.1	Python-urllib/3.14	directus_fields	205	\N
1224	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.399+00	172.20.0.1	Python-urllib/3.14	directus_fields	206	\N
1225	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.4+00	172.20.0.1	Python-urllib/3.14	directus_fields	207	\N
1226	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.401+00	172.20.0.1	Python-urllib/3.14	directus_fields	208	\N
1227	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.402+00	172.20.0.1	Python-urllib/3.14	directus_fields	209	\N
1228	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.403+00	172.20.0.1	Python-urllib/3.14	directus_fields	210	\N
1229	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.405+00	172.20.0.1	Python-urllib/3.14	directus_fields	211	\N
1230	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.407+00	172.20.0.1	Python-urllib/3.14	directus_fields	212	\N
1231	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.506+00	172.20.0.1	Python-urllib/3.14	directus_fields	213	\N
1232	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.509+00	172.20.0.1	Python-urllib/3.14	directus_fields	214	\N
1233	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.512+00	172.20.0.1	Python-urllib/3.14	directus_fields	215	\N
1234	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.515+00	172.20.0.1	Python-urllib/3.14	directus_fields	216	\N
1235	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.518+00	172.20.0.1	Python-urllib/3.14	directus_fields	217	\N
1236	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.523+00	172.20.0.1	Python-urllib/3.14	directus_fields	218	\N
1237	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.526+00	172.20.0.1	Python-urllib/3.14	directus_fields	219	\N
1238	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.53+00	172.20.0.1	Python-urllib/3.14	directus_fields	220	\N
1239	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.535+00	172.20.0.1	Python-urllib/3.14	directus_fields	221	\N
1240	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.538+00	172.20.0.1	Python-urllib/3.14	directus_collections	articles	\N
1241	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:13.577+00	172.20.0.1	Python-urllib/3.14	directus_permissions	11	\N
1242	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:31:32.677+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1265	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:12:09.944+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	222	http://localhost:8055
1274	logout	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:48:35.971+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
1275	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:48:47.077+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
1071	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 07:59:58.396+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
1072	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 08:00:42.89+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
1074	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 08:01:04.522+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
1106	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:20:59.917+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	113	http://localhost:8055
1107	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:25:29.487+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	113	http://localhost:8055
1170	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:28:23.361+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1171	run	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:28:23.802+00	172.20.0.1	Python-urllib/3.14	directus_flows	2f2e9681-7f89-4d83-a388-8565a696a502	\N
1172	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:28:23.811+00	172.20.0.1	Python-urllib/3.14	packages	875d00c0-86da-4cf9-a2d7-87b61a4ac671	\N
1173	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:28:23.824+00	172.20.0.1	Python-urllib/3.14	packages	875d00c0-86da-4cf9-a2d7-87b61a4ac671	\N
1174	run	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:28:23.836+00	172.20.0.1	Python-urllib/3.14	directus_flows	2f2e9681-7f89-4d83-a388-8565a696a502	\N
1175	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:28:23.842+00	172.20.0.1	Python-urllib/3.14	packages	3302f909-8a68-4e4d-921d-03df9728758b	\N
1176	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:28:23.854+00	172.20.0.1	Python-urllib/3.14	packages	3302f909-8a68-4e4d-921d-03df9728758b	\N
1177	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:05.389+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1178	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:05.864+00	172.20.0.1	Python-urllib/3.14	directus_flows	2f2e9681-7f89-4d83-a388-8565a696a502	\N
1179	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:05.886+00	172.20.0.1	Python-urllib/3.14	directus_flows	02d22919-356c-4ccb-9405-42d13a35fdbc	\N
1181	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:05.936+00	172.20.0.1	Python-urllib/3.14	directus_operations	3c6f9900-7a31-4da1-a48b-823c9633cfed	\N
1184	run	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:06.004+00	172.20.0.1	Python-urllib/3.14	directus_flows	02d22919-356c-4ccb-9405-42d13a35fdbc	\N
1185	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:06.011+00	172.20.0.1	Python-urllib/3.14	packages	e837e5d1-90ce-4d57-96ff-07aa10b38c4b	\N
1186	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:06.026+00	172.20.0.1	Python-urllib/3.14	packages	e837e5d1-90ce-4d57-96ff-07aa10b38c4b	\N
1187	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:32.165+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1188	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:32.612+00	172.20.0.1	Python-urllib/3.14	directus_flows	02d22919-356c-4ccb-9405-42d13a35fdbc	\N
1189	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:32.629+00	172.20.0.1	Python-urllib/3.14	directus_flows	bc154261-1232-4c56-a826-02a808a3e959	\N
1191	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:32.667+00	172.20.0.1	Python-urllib/3.14	directus_flows	bc154261-1232-4c56-a826-02a808a3e959	\N
1243	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:42:02.648+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	217	http://localhost:8055
1244	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:42:37.104+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	222	http://localhost:8055
1245	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:42:44.435+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	213	http://localhost:8055
1246	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:42:44.444+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	214	http://localhost:8055
1247	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:42:44.451+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	215	http://localhost:8055
1248	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:42:44.463+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	216	http://localhost:8055
1249	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:42:44.472+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	222	http://localhost:8055
1250	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:42:44.481+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	218	http://localhost:8055
1251	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:42:44.491+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	219	http://localhost:8055
1252	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:42:44.498+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	220	http://localhost:8055
1253	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:42:44.506+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	221	http://localhost:8055
1266	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:13:58.081+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	222	http://localhost:8055
1073	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 08:00:51.65+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
1108	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:29:12.221+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
1180	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:05.91+00	172.20.0.1	Python-urllib/3.14	directus_operations	cfb637cd-e34c-4506-aca3-f69085cdeae9	\N
1182	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:05.96+00	172.20.0.1	Python-urllib/3.14	directus_operations	3c6f9900-7a31-4da1-a48b-823c9633cfed	\N
1183	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:05.971+00	172.20.0.1	Python-urllib/3.14	directus_operations	cfb637cd-e34c-4506-aca3-f69085cdeae9	\N
1190	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:32.649+00	172.20.0.1	Python-urllib/3.14	directus_operations	07a7e5a9-1695-4cc2-9382-12ea25aa8145	\N
1192	run	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:32.712+00	172.20.0.1	Python-urllib/3.14	directus_flows	bc154261-1232-4c56-a826-02a808a3e959	\N
1193	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:32.715+00	172.20.0.1	Python-urllib/3.14	packages	d7dfa9ca-235a-4b12-bd87-f0fcc6b21e67	\N
1194	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:29:32.728+00	172.20.0.1	Python-urllib/3.14	packages	d7dfa9ca-235a-4b12-bd87-f0fcc6b21e67	\N
1254	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:49:24.057+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	222	http://localhost:8055
1267	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:14:40.014+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	222	http://localhost:8055
1076	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 08:02:20.963+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	ef4be35a-a6c5-4e79-9c5c-2a5f7752e586	http://localhost:8055
1082	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 08:48:47.519+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://api.vodaevent.id
1083	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 01:41:18.057+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://vodaevent.id
1084	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 07:02:31.817+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	530d69bc-b315-499f-a9f5-4876cd13ddcc	http://localhost:8055
1085	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 07:03:09.775+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	regions	530d69bc-b315-499f-a9f5-4876cd13ddcc	http://localhost:8055
1109	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:21:28.045+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1110	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:23:11.265+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1111	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:23:11.697+00	172.20.0.1	Python-urllib/3.14	directus_fields	195	\N
1112	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:23:11.708+00	172.20.0.1	Python-urllib/3.14	directus_collections	package_price_tables	\N
1113	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:23:11.805+00	172.20.0.1	Python-urllib/3.14	directus_fields	196	\N
1143	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:01:57.295+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
1195	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:57:23.555+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	0e113d05-2450-4eb6-bfc3-5f47a891dc7c	http://localhost:8055
1255	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:50:19.394+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	222	http://localhost:8055
1268	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:18:32.87+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	articles	3def676a-3b03-44aa-82a7-08edf7717d4e	http://localhost:8055
1276	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 02:35:45.157+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
1078	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 08:02:32.587+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	ef4be35a-a6c5-4e79-9c5c-2a5f7752e586	http://localhost:8055
1079	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 08:02:43.653+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	activity_types	ef4be35a-a6c5-4e79-9c5c-2a5f7752e586	http://localhost:8055
1086	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 07:03:55.388+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	destinations	393287c3-c166-4522-99d2-a27ab0f62dfa	http://localhost:8055
1114	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:23:11.884+00	172.20.0.1	Python-urllib/3.14	directus_fields	197	\N
1115	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:23:11.973+00	172.20.0.1	Python-urllib/3.14	directus_fields	198	\N
1116	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:23:12.042+00	172.20.0.1	Python-urllib/3.14	directus_fields	199	\N
1117	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:23:12.093+00	172.20.0.1	Python-urllib/3.14	directus_fields	200	\N
1118	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:23:12.15+00	172.20.0.1	Python-urllib/3.14	directus_fields	201	\N
1119	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:23:12.195+00	172.20.0.1	Python-urllib/3.14	directus_fields	202	\N
1120	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:23:12.238+00	172.20.0.1	Python-urllib/3.14	directus_fields	203	\N
1144	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:02:09.529+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
1196	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 03:16:30.202+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	0e113d05-2450-4eb6-bfc3-5f47a891dc7c	http://localhost:8055
1256	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:53:02.22+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	articles	3def676a-3b03-44aa-82a7-08edf7717d4e	http://localhost:8055
1269	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:23:04.923+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	220	http://localhost:8055
1277	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:03:15.719+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
1081	create	\N	2026-07-15 08:08:49.898+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	searches	41	http://localhost:4321
1087	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 07:06:54.278+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	6d63b96b-d000-4d17-a7db-4969bd8983ec	http://localhost:8055
1121	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:24:51.279+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1122	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:25:04.758+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1123	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:25:14.785+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1124	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:25:57.167+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1125	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:25:57.597+00	172.20.0.1	Python-urllib/3.14	directus_fields	203	\N
1145	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:07:08.016+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1146	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:07:08.466+00	172.20.0.1	Python-urllib/3.14	directus_fields	113	\N
1197	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 03:17:16.981+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	packages	0e113d05-2450-4eb6-bfc3-5f47a891dc7c	http://localhost:8055
1257	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:55:13.843+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	articles	3def676a-3b03-44aa-82a7-08edf7717d4e	http://localhost:8055
1270	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:25:04.317+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	articles	http://localhost:8055
1278	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:23:40.012+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
1088	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 07:15:40.987+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	settings	6	http://localhost:8055
1126	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:26:51.812+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1127	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:27:11.76+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1128	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:27:37.891+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1147	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:16:49.948+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1148	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:16:50.379+00	172.20.0.1	Python-urllib/3.14	directus_fields	113	\N
1198	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 06:16:52.959+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	settings	3	http://localhost:8055
1202	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:27:15.068+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1203	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:27:38.462+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1204	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:27:38.928+00	172.20.0.1	Python-urllib/3.14	directus_fields	204	\N
1205	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:27:38.938+00	172.20.0.1	Python-urllib/3.14	directus_collections	articles	\N
1206	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:08.595+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1207	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:09.05+00	172.20.0.1	Python-urllib/3.14	directus_fields	205	\N
1258	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:01:23.222+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1259	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:01:48.729+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1271	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:25:27.152+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_collections	articles	http://localhost:8055
1279	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:27:35.99+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_extensions	6d5e25af-4c3e-4c81-8a42-d7b6f66c9703	http://localhost:8055
1280	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:27:36.006+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_extensions	f0d96c04-7385-4b39-8e80-186e045f9bed	http://localhost:8055
1281	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:27:36.009+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_extensions	88060c13-f7ba-4edd-89fb-3f2e353f5350	http://localhost:8055
1089	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 07:16:31.888+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	settings	3	http://localhost:8055
1129	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:36:57.06+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1130	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:17.152+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1131	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:17.587+00	172.20.0.1	Python-urllib/3.14	directus_fields	203	\N
1132	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:30.465+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1133	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:30.95+00	172.20.0.1	Python-urllib/3.14	directus_collections	package_price_tables	\N
1134	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:30.954+00	172.20.0.1	Python-urllib/3.14	directus_fields	195	\N
1135	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:30.955+00	172.20.0.1	Python-urllib/3.14	directus_fields	196	\N
1136	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:30.956+00	172.20.0.1	Python-urllib/3.14	directus_fields	197	\N
1137	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:30.957+00	172.20.0.1	Python-urllib/3.14	directus_fields	198	\N
1138	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:30.96+00	172.20.0.1	Python-urllib/3.14	directus_fields	199	\N
1139	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:30.961+00	172.20.0.1	Python-urllib/3.14	directus_fields	200	\N
1140	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:30.962+00	172.20.0.1	Python-urllib/3.14	directus_fields	201	\N
1141	delete	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:30.962+00	172.20.0.1	Python-urllib/3.14	directus_fields	202	\N
1149	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:19:33.337+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1150	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:19:33.789+00	172.20.0.1	Python-urllib/3.14	directus_collections	packages	\N
1199	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 06:17:23.72+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	settings	3	http://localhost:8055
1260	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:03:56.22+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1261	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:04:07.995+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1262	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:04:08.437+00	172.20.0.1	Python-urllib/3.14	directus_fields	222	\N
1272	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:42:16.912+00	172.20.0.1	Python-urllib/3.14	directus_fields	221	\N
1282	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:36:30.215+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_extensions	6d5e25af-4c3e-4c81-8a42-d7b6f66c9703	http://localhost:8055
1283	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:36:30.231+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_extensions	ad7d7b2d-e460-4473-851e-e6a2b82c98b3	http://localhost:8055
1284	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:36:30.238+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_extensions	7189f4ad-f45a-42d7-9d21-6a0e534253ba	http://localhost:8055
1090	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:03:02.875+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	194	http://localhost:8055
1091	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-16 08:04:03.331+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_fields	194	http://localhost:8055
1142	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 01:37:31.057+00	172.20.0.1	Python-urllib/3.14	directus_fields	113	\N
1151	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:24:44.121+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1152	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:24:44.552+00	172.20.0.1	Python-urllib/3.14	directus_flows	2f2e9681-7f89-4d83-a388-8565a696a502	\N
1155	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:26:08.314+00	172.20.0.1	Python-urllib/3.14	directus_operations	a50f40e2-1d80-4c5f-80d0-e63ec5bbf7ee	\N
1156	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:26:08.333+00	172.20.0.1	Python-urllib/3.14	directus_operations	69515475-2a33-4b04-a09c-86e491b20e0a	\N
1160	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:26:23.343+00	172.20.0.1	Python-urllib/3.14	directus_flows	2f2e9681-7f89-4d83-a388-8565a696a502	\N
1167	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:27:22.717+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1168	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:27:37.024+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1169	update	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 02:27:37.464+00	172.20.0.1	Python-urllib/3.14	directus_operations	69515475-2a33-4b04-a09c-86e491b20e0a	\N
1200	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:26:37.289+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1201	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:26:48.886+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1208	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:09.173+00	172.20.0.1	Python-urllib/3.14	directus_fields	206	\N
1209	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:09.267+00	172.20.0.1	Python-urllib/3.14	directus_fields	207	\N
1210	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:09.382+00	172.20.0.1	Python-urllib/3.14	directus_fields	208	\N
1211	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:09.481+00	172.20.0.1	Python-urllib/3.14	directus_fields	209	\N
1212	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:09.566+00	172.20.0.1	Python-urllib/3.14	directus_fields	210	\N
1213	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:09.615+00	172.20.0.1	Python-urllib/3.14	directus_fields	211	\N
1214	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:09.679+00	172.20.0.1	Python-urllib/3.14	directus_permissions	10	\N
1215	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:23.141+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1216	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:34.736+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1217	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:35.162+00	172.20.0.1	Python-urllib/3.14	directus_fields	212	\N
1218	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:28:48.347+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1219	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 07:29:03.652+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1263	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:07:54.253+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1264	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:08:05.715+00	172.20.0.1	Python-urllib/3.14	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	\N
1273	login	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-17 08:47:28.998+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_users	bb454258-7d81-40f6-af80-ad85011fa204	http://localhost:8055
1285	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:42:07.874+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_extensions	6d5e25af-4c3e-4c81-8a42-d7b6f66c9703	http://localhost:8055
1286	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:42:07.888+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_extensions	698faa29-4765-4c6b-931c-4c0633ef27a9	http://localhost:8055
1287	create	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:42:07.893+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	directus_extensions	adb374ac-c95c-4024-af4a-d9938e8cd2b2	http://localhost:8055
\.


--
-- Data for Name: directus_collections; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_collections (collection, icon, note, display_template, hidden, singleton, translations, archive_field, archive_app_filter, archive_value, unarchive_value, sort_field, accountability, color, item_duplication_fields, sort, "group", collapse, preview_url, versioning, status, autosave_revision_interval) FROM stdin;
regions	\N	\N	\N	f	f	\N	status	t	archived	draft	\N	all	\N	\N	\N	\N	open	\N	f	active	\N
destinations	\N	\N	\N	f	f	\N	status	t	archived	draft	\N	all	\N	\N	\N	\N	open	\N	f	active	\N
settings	\N	Site-wide key-value settings	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f	active	\N
searches	\N	Visitor search history	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f	active	\N
packages	\N	Paket wisata/travel packages	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f	active	\N
activity_types	\N	Jenis kegiatan (Private Trip, Corporate Gathering, etc)	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f	active	\N
packages_activity_types	\N	Junction: packages ←→ activity_types (M2M)	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f	active	\N
articles	article	Artikel blog untuk SEO & content marketing	\N	f	f	\N	status	t	archived	draft	publish_date	all	\N	[]	\N	\N	open	\N	f	active	\N
\.


--
-- Data for Name: directus_comments; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_comments (id, collection, item, comment, date_created, date_updated, user_created, user_updated) FROM stdin;
\.


--
-- Data for Name: directus_dashboards; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_dashboards (id, name, icon, note, date_created, user_created, color) FROM stdin;
\.


--
-- Data for Name: directus_deployment_projects; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_deployment_projects (id, deployment, external_id, name, date_created, user_created, url, framework, deployable) FROM stdin;
\.


--
-- Data for Name: directus_deployment_runs; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_deployment_runs (id, project, external_id, target, date_created, user_created, status, url, started_at, completed_at) FROM stdin;
\.


--
-- Data for Name: directus_deployments; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_deployments (id, provider, credentials, options, date_created, user_created, webhook_ids, webhook_secret, last_synced_at) FROM stdin;
\.


--
-- Data for Name: directus_extensions; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_extensions (enabled, id, folder, source, bundle) FROM stdin;
t	1fa77c25-ab33-4a1c-b880-7f10617c18e7	tiptap	local	\N
t	24fbc75e-9e91-4f56-8d33-c4b31dff6f84	directus-extension-tiptap-interface	local	1fa77c25-ab33-4a1c-b880-7f10617c18e7
t	e32e30f2-4c90-4a7a-bcfe-690042b5adc6	directus-extension-tiptap-display	local	1fa77c25-ab33-4a1c-b880-7f10617c18e7
t	7a1e888c-a1d6-4e4c-8d31-77d9feadcfaa	article-editor	local	\N
t	4bbe03af-ee93-4aaf-9e0b-41fdeb036f4c	article-editor	local	7a1e888c-a1d6-4e4c-8d31-77d9feadcfaa
t	72c71bf5-2c32-4543-a6b4-1c0ed99e16ae	article-editor	local	4bbe03af-ee93-4aaf-9e0b-41fdeb036f4c
t	6d5e25af-4c3e-4c81-8a42-d7b6f66c9703	4b646e9f-e187-45ac-b9dc-f3e71245687a	registry	\N
t	698faa29-4765-4c6b-931c-4c0633ef27a9	seo-display	registry	6d5e25af-4c3e-4c81-8a42-d7b6f66c9703
t	adb374ac-c95c-4024-af4a-d9938e8cd2b2	seo-interface	registry	6d5e25af-4c3e-4c81-8a42-d7b6f66c9703
\.


--
-- Data for Name: directus_fields; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_fields (id, collection, field, special, interface, options, display, display_options, readonly, hidden, sort, width, translations, note, conditions, required, "group", validation, validation_message, searchable) FROM stdin;
115	activity_types	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N	t
117	activity_types	slug	\N	input	\N	\N	\N	f	f	3	full	\N	\N	\N	t	\N	\N	\N	t
118	activity_types	description	\N	input-multiline	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N	t
119	packages_activity_types	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N	t
120	packages_activity_types	package_id	m2o	select-dropdown-m2o	\N	\N	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N	t
121	packages_activity_types	activity_type_id	m2o	select-dropdown-m2o	\N	\N	\N	f	f	3	full	\N	\N	\N	t	\N	\N	\N	t
58	regions	slug	\N	\N	\N	\N	\N	f	f	8	full	\N	\N	\N	t	\N	\N	\N	t
51	regions	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N	t
52	regions	status	\N	select-dropdown	{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]}	labels	{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]}	f	f	2	full	\N	\N	\N	f	\N	\N	\N	t
53	regions	user_created	user-created	select-dropdown-m2o	{"template":"{{avatar}} {{first_name}} {{last_name}}"}	user	\N	t	t	3	half	\N	\N	\N	f	\N	\N	\N	t
54	regions	date_created	date-created	datetime	\N	datetime	{"relative":true}	t	t	4	half	\N	\N	\N	f	\N	\N	\N	t
55	regions	user_updated	user-updated	select-dropdown-m2o	{"template":"{{avatar}} {{first_name}} {{last_name}}"}	user	\N	t	t	5	half	\N	\N	\N	f	\N	\N	\N	t
56	regions	date_updated	date-updated	datetime	\N	datetime	{"relative":true}	t	t	6	half	\N	\N	\N	f	\N	\N	\N	t
57	regions	name	\N	input	{"placeholder":"Nama region (Bandung, Bali)"}	\N	\N	f	f	7	full	\N	\N	\N	t	\N	\N	\N	t
59	regions	description	\N	input-multiline	{"placeholder":"Deskripsi region"}	\N	\N	f	f	9	full	\N	\N	\N	t	\N	\N	\N	t
60	regions	image	file	file-image	{"allowedMimeTypes":["image/jpeg","image/png","image/webp","image/svg+xml","image/avif","image/tiff"]}	\N	\N	f	f	10	full	\N	\N	\N	t	\N	\N	\N	t
61	destinations	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N	t
62	destinations	status	\N	select-dropdown	{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]}	labels	{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]}	f	f	2	full	\N	\N	\N	f	\N	\N	\N	t
63	destinations	user_created	user-created	select-dropdown-m2o	{"template":"{{avatar}} {{first_name}} {{last_name}}"}	user	\N	t	t	3	half	\N	\N	\N	f	\N	\N	\N	t
64	destinations	date_created	date-created	datetime	\N	datetime	{"relative":true}	t	t	4	half	\N	\N	\N	f	\N	\N	\N	t
65	destinations	user_updated	user-updated	select-dropdown-m2o	{"template":"{{avatar}} {{first_name}} {{last_name}}"}	user	\N	t	t	5	half	\N	\N	\N	f	\N	\N	\N	t
66	destinations	date_updated	date-updated	datetime	\N	datetime	{"relative":true}	t	t	6	half	\N	\N	\N	f	\N	\N	\N	t
67	destinations	name	\N	input	{"placeholder":"Nama destinasi (Lembang)"}	\N	\N	f	f	7	full	\N	\N	\N	t	\N	\N	\N	t
69	destinations	description	\N	input-multiline	{"placeholder":"Deskripsi destinasi"}	\N	\N	f	f	9	full	\N	\N	\N	t	\N	\N	\N	t
73	regions	destinations	o2m	list-o2m	\N	\N	\N	f	f	11	full	\N	\N	\N	f	\N	\N	\N	t
68	destinations	slug	\N	\N	\N	\N	\N	f	f	8	full	\N	\N	\N	t	\N	\N	\N	t
189	destinations	gallery	json	json	\N	\N	\N	f	f	20	full	\N	\N	\N	f	\N	\N	\N	t
123	activity_types	status	\N	select-dropdown	{"choices":[{"text":"Published","value":"published"},{"text":"Draft","value":"draft"},{"text":"Archived","value":"archived"}]}	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N	t
104	packages	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N	t
105	packages	name	\N	input	\N	\N	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N	t
106	packages	slug	\N	input	\N	\N	\N	f	f	3	full	\N	\N	\N	t	\N	\N	\N	t
107	packages	description	\N	input-multiline	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N	t
108	packages	destination_id	m2o	select-dropdown-m2o	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N	t
109	packages	image	file-image	file-image	\N	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N	t
111	packages	duration	\N	input	\N	\N	\N	f	f	7	full	\N	\N	\N	f	\N	\N	\N	t
114	packages	facilities	cast-json	tags	{"placeholder":"Isi dengan Fasilitas yang disediakan","whitespace":null,"capitalization":"auto-format"}	\N	\N	f	f	9	full	\N	\N	\N	f	\N	\N	\N	t
122	packages	status	\N	select-dropdown	{"choices":[{"text":"Published","value":"published"},{"text":"Draft","value":"draft"},{"text":"Archived","value":"archived"}]}	\N	\N	f	f	11	full	\N	\N	\N	f	\N	\N	\N	t
190	packages	gallery	json	json	\N	\N	\N	f	f	13	full	\N	\N	\N	f	\N	\N	\N	t
71	destinations	image	file	file-image	{"accept":"image/*"}	\N	\N	f	f	10	full	\N	Foto utama destinasi	\N	t	\N	\N	\N	t
72	destinations	region_id	m2o	select-dropdown-m2o	{"template":"{{name}}","enableCreate":false}	related-values	{"template":"{{name}}"}	f	f	11	full	\N	\N	\N	f	\N	\N	\N	t
93	settings	id	\N	numeric	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N	t
94	settings	key	\N	input	\N	\N	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N	t
95	settings	value	\N	input-multiline	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N	t
96	settings	description	\N	input-multiline	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N	t
97	searches	id	\N	numeric	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N	t
98	searches	destination_name	\N	input	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N	t
99	searches	region_name	\N	input	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N	t
100	searches	activity_type_name	\N	input	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N	t
101	searches	pax_count	\N	input	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N	t
102	searches	travel_date	\N	date	\N	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N	t
103	searches	visitor_ip	\N	input	\N	\N	\N	f	f	7	full	\N	\N	\N	f	\N	\N	\N	t
116	activity_types	name	\N	input	\N	\N	{}	f	f	2	full	\N	\N	\N	t	\N	\N	\N	t
112	packages	itinerary	cast-json	list	{"fields":[{"field":"day","name":"day","type":"integer","meta":{"field":"day","width":"half","type":"integer","required":true,"note":"Angka hari ke sekian contoh \\"1\\"","interface":"input","options":{"placeholder":"Hari (Contoh : 1)"}}},{"field":"title","name":"title","type":"string","meta":{"field":"title","width":"half","type":"string","note":null,"interface":"input","options":{"placeholder":"Judul Hari (Contoh : Arrival & Island Adventure)"}}},{"field":"activities","name":"activities","type":"json","meta":{"field":"activities","width":"full","type":"json","required":true,"interface":"tags","options":{"presets":[],"placeholder":"Isi dengan kegiatan (Contoh : Check-in homestay)"}}}],"template":"Day {{ day }}: {{ title }}","sort":"day"}	\N	\N	f	f	8	full	\N	\N	\N	f	\N	\N	\N	t
194	packages	addons	cast-json	list	{"fields":[{"field":"addon_name","name":"addon_name","type":"string","meta":{"field":"addon_name","width":"half","type":"string","required":true,"interface":"input","options":{"placeholder":"Nama Additional ( Layanan Tambahan )"}}},{"field":"price","name":"price","type":"integer","meta":{"field":"price","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Harga Additional (Layanan Tambahan)"}}},{"field":"description","name":"description","type":"text","meta":{"field":"description","width":"full","type":"text","interface":"input","options":{"placeholder":"Deskripsi / Note Singkat"}}}],"template":"{{ addon_name }} — Rp {{ price }}","sort":"addon_name"}	\N	\N	f	f	12	full	\N	\N	\N	f	\N	\N	\N	t
113	packages	price_tiers	cast-json	list	{"template":"{{table_title}} ({{tiers.length}} tier)","fields":[{"field":"table_title","type":"string","name":"Judul Tabel","meta":{"width":"full","interface":"input","required":true,"options":{"placeholder":"Contoh: Paket Speedboat, Paket Ferry"}}},{"field":"tiers","type":"json","name":"Daftar Harga","meta":{"width":"full","interface":"list","options":{"template":"{{min_pax}}-{{max_pax}} pax: Rp {{price_per_pax}}","fields":[{"field":"min_pax","type":"integer","name":"Min Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Min","min":1}}},{"field":"max_pax","type":"integer","name":"Max Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Max (kosongi = unlimited)"}}},{"field":"price_per_pax","type":"integer","name":"Harga per Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Harga (Rp)","prefix":"Rp"}}},{"field":"description","type":"text","name":"Keterangan","meta":{"width":"full","interface":"input-multiline","options":{"placeholder":"Ket. tambahan (opsional)"}}}]}}}]}	\N	\N	f	f	10	full	\N	\N	\N	f	\N	{"_and":[{"price_tiers":{"_length":{"_lte":3}}}]}	Maksimal 3 tabel harga per paket. Hapus salah satu atau gabungkan ke tabel yang sudah ada.	t
213	articles	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N	t
214	articles	status	\N	select-dropdown	{"choices":[{"text":"Draft","value":"draft"},{"text":"Published","value":"published"},{"text":"Archived","value":"archived"}]}	\N	\N	f	f	2	half	\N	\N	\N	t	\N	\N	\N	t
215	articles	title	\N	input	\N	\N	\N	f	f	3	full	\N	\N	\N	t	\N	\N	\N	t
216	articles	slug	\N	input	\N	\N	\N	f	f	4	half	\N	Auto-generate dari title	\N	f	\N	\N	\N	t
222	articles	content	\N	input-rich-text-html	{"toolbar":["undo","redo","bold","italic","underline","h1","h2","h3","h4","h5","h6","alignleft","aligncenter","alignright","alignjustify","alignnone","indent","outdent","numlist","bullist","removeformat","blockquote","customLink","strike","heading","bulletList","orderedList","link","image","textAlign","horizontalRule","unlink","customImage","customMedia","table","fullscreen","code"],"placeholder":"Mulai menulis artikel..."}	\N	\N	f	f	4	fill	\N	\N	\N	t	\N	\N	\N	t
218	articles	featured_image	\N	file-image	\N	\N	\N	f	f	6	half	\N	\N	\N	t	\N	\N	\N	t
219	articles	publish_date	\N	datetime	{"includeSeconds":true}	\N	\N	f	f	7	half	\N	\N	\N	f	\N	\N	\N	t
220	articles	ads	cast-json	list	{"fields":[{"field":"gambar_iklan","name":"gambar_iklan","meta":{"interface":"file-image","width":"half","required":true,"options":{"allowedMimeTypes":["image/jpeg","image/png","image/gif","image/webp","image/svg+xml","image/avif","image/tiff"]},"field":"gambar_iklan"}},{"meta":{"interface":"input","width":"half","required":true}}],"limit":10}	\N	\N	f	f	8	full	\N	Maksimal 10 iklan per artikel	\N	f	\N	\N	\N	t
221	articles	seo	cast-json	seo-analyzer	\N	\N	\N	f	f	9	full	\N	SEO Analyzer (Rank Math Clone)	\N	f	\N	\N	\N	t
\.


--
-- Data for Name: directus_files; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_files (id, storage, filename_disk, filename_download, title, type, folder, uploaded_by, created_on, modified_by, modified_on, charset, filesize, width, height, duration, embed, description, location, tags, metadata, focal_point_x, focal_point_y, tus_id, tus_data, uploaded_on) FROM stdin;
535393f3-444f-4c68-8c6b-5fbbbd55624d	local	535393f3-444f-4c68-8c6b-5fbbbd55624d.jpg	alfiano-sutianto-exFdOWkYBQw-unsplash.jpg	Alfiano Sutianto Ex Fd O Wk Yb Qw Unsplash	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 03:28:42.72+00	\N	2026-07-13 03:28:42.843+00	\N	5359879	6000	4000	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 03:28:42.841+00
755848b6-cb80-490d-a0e6-9be9c70f658b	local	755848b6-cb80-490d-a0e6-9be9c70f658b.jpg	harry-kessell-eE2trMn-6a0-unsplash.jpg	Harry Kessell E E2tr Mn 6a0 Unsplash	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 03:29:19.058+00	\N	2026-07-13 03:29:19.083+00	\N	1219649	3456	2304	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 03:29:19.082+00
534fc352-5e04-4f09-9af3-7ca9643fd5bd	local	534fc352-5e04-4f09-9af3-7ca9643fd5bd.avif	photo-1478827387698-1527781a4887.avif	Photo 1478827387698 1527781a4887	image/avif	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.715+00	\N	2026-07-13 08:47:16.821+00	\N	39049	500	333	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:16.818+00
fd07dd90-9805-445b-bee9-9bdb1ca6f4c7	local	fd07dd90-9805-445b-bee9-9bdb1ca6f4c7.avif	photo-1543964198-d54e4f0e44e3.avif	Photo 1543964198 D54e4f0e44e3	image/avif	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.698+00	\N	2026-07-13 08:47:16.822+00	\N	44794	500	334	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:16.82+00
51524283-d867-4686-977c-7d4001d788b8	local	51524283-d867-4686-977c-7d4001d788b8.avif	premium_photo-1676218966210-298056b2b978.avif	Premium Photo 1676218966210 298056b2b978	image/avif	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.748+00	\N	2026-07-13 08:47:16.823+00	\N	24765	500	314	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:16.82+00
eb9b84b6-4cb2-4d2a-8896-45a2df9d57c2	local	eb9b84b6-4cb2-4d2a-8896-45a2df9d57c2.avif	photo-1448375240586-882707db888b.avif	Photo 1448375240586 882707db888b	image/avif	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.743+00	\N	2026-07-13 08:47:16.824+00	\N	31302	500	333	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:16.821+00
31639889-3b56-4b07-b37f-0bd0951dbfbf	local	31639889-3b56-4b07-b37f-0bd0951dbfbf.avif	photo-1418065460487-3e41a6c84dc5.avif	Photo 1418065460487 3e41a6c84dc5	image/avif	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.879+00	\N	2026-07-13 08:47:16.917+00	\N	42800	500	333	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:16.915+00
b4369210-3088-40bb-8506-bb8049e14bb5	local	b4369210-3088-40bb-8506-bb8049e14bb5.avif	photo-1462651567147-aa679fd1cfaf.avif	Photo 1462651567147 Aa679fd1cfaf	image/avif	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.881+00	\N	2026-07-13 08:47:16.922+00	\N	36536	500	334	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:16.916+00
3e059818-0378-4270-b737-4aa3f563faac	local	3e059818-0378-4270-b737-4aa3f563faac.avif	photo-1468413253725-0d5181091126.avif	Photo 1468413253725 0d5181091126	image/avif	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.882+00	\N	2026-07-13 08:47:16.927+00	\N	35167	500	333	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:16.925+00
bcfdac07-ed2f-48a8-a1aa-25dd9df45b2d	local	bcfdac07-ed2f-48a8-a1aa-25dd9df45b2d.jpg	harry-kessell-eE2trMn-6a0-unsplash.jpg	Harry Kessell E E2tr Mn 6a0 Unsplash	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.774+00	\N	2026-07-13 08:47:16.969+00	\N	1219649	3456	2304	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:16.961+00
794bfde6-a082-4ea6-8cfc-438e14ddb651	local	794bfde6-a082-4ea6-8cfc-438e14ddb651.jpg	simon-aZjw7xI3QAA-unsplash.jpg	Simon a Zjw7x I3 Qaa Unsplash	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.76+00	\N	2026-07-13 08:47:16.992+00	\N	1541225	3169	1584	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:16.984+00
48652f44-6b17-4d85-b4db-475f539626b0	local	48652f44-6b17-4d85-b4db-475f539626b0.avif	bOvf94dPRxWu0u3QsPjF_tree.avif	B Ovf94d P Rx Wu0u3 Qs Pj F Tree	image/avif	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.968+00	\N	2026-07-13 08:47:17.016+00	\N	30697	500	331	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:17.015+00
088c8736-3301-4a7f-b0d8-84434409638c	local	088c8736-3301-4a7f-b0d8-84434409638c.avif	photo-1498550744921-75f79806b8a7.avif	Photo 1498550744921 75f79806b8a7	image/avif	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.982+00	\N	2026-07-13 08:47:17.023+00	\N	11611	500	333	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:17.021+00
ebcb498f-0a85-419f-b340-787ce26d4800	local	ebcb498f-0a85-419f-b340-787ce26d4800.avif	photo-1500622944204-b135684e99fd.avif	Photo 1500622944204 B135684e99fd	image/avif	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.989+00	\N	2026-07-13 08:47:17.025+00	\N	34277	500	250	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:17.022+00
d198bd7d-ff2f-46bd-be0a-8032857dacea	local	d198bd7d-ff2f-46bd-be0a-8032857dacea.jpg	alfiano-sutianto-exFdOWkYBQw-unsplash.jpg	Alfiano Sutianto Ex Fd O Wk Yb Qw Unsplash	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-13 08:47:16.866+00	\N	2026-07-13 08:47:17.06+00	\N	5359879	6000	4000	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-13 08:47:17.06+00
2dfda479-6830-4483-8bc7-4b37bc99017b	local	2dfda479-6830-4483-8bc7-4b37bc99017b.jpg	bandung-region.jpg	Bandung Region	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:11:00.848+00	\N	2026-07-14 04:11:00.912+00	\N	2186820	5472	3648	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 04:11:00.911+00
40e833b4-4ed9-4200-be76-9c177d0dd992	local	40e833b4-4ed9-4200-be76-9c177d0dd992.jpg	bandung-region.jpg	Bandung Region	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:10:10.034+00	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:10:51.693+00	\N	2186820	5472	3648	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 04:10:51.686+00
5ba000aa-eed9-4d49-a454-a49580cf8c31	local	5ba000aa-eed9-4d49-a454-a49580cf8c31.jpg	kepseribu-region.jpg	Kepseribu Region	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:14:40.925+00	\N	2026-07-14 04:14:40.968+00	\N	286588	1680	1050	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 04:14:40.968+00
469b271b-120d-4cae-8528-92de7d389c5a	local	469b271b-120d-4cae-8528-92de7d389c5a.jpg	yogyakarta-region.jpg	Yogyakarta Region	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:16:06.749+00	\N	2026-07-14 04:16:06.765+00	\N	630037	2560	1600	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 04:16:06.764+00
049e1a62-a485-48b1-8e1f-e8986e495d5d	local	049e1a62-a485-48b1-8e1f-e8986e495d5d.jpg	bali-region.jpg	Bali Region	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:17:36.938+00	\N	2026-07-14 04:17:36.954+00	\N	475131	2048	1356	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 04:17:36.953+00
fb28d20c-bd40-4cb6-b4c5-9bc3e34a1e55	local	fb28d20c-bd40-4cb6-b4c5-9bc3e34a1e55.jpg	lembang.jpg	Lembang	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:25:55.307+00	\N	2026-07-14 04:25:55.422+00	\N	10801333	5984	3366	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 04:25:55.421+00
e460c166-783d-468c-a72b-fa57019fe90e	local	e460c166-783d-468c-a72b-fa57019fe90e.jpg	yogyakarta-region.jpg	Yogyakarta Region	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:30:48.575+00	\N	2026-07-14 04:30:48.596+00	\N	630037	2560	1600	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 04:30:48.595+00
a45ff57c-32ed-4fec-8c2c-9fe05b59cd4a	local	a45ff57c-32ed-4fec-8c2c-9fe05b59cd4a.jpg	kepseribu-region.jpg	Kepseribu Region	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:31:06.351+00	\N	2026-07-14 04:31:06.391+00	\N	286588	1680	1050	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 04:31:06.389+00
0de66444-4238-49ae-a548-4148b5a0c347	local	0de66444-4238-49ae-a548-4148b5a0c347.jpg	bandung-region.jpg	Bandung Region	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:31:28.244+00	\N	2026-07-14 04:31:28.276+00	\N	2186820	5472	3648	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 04:31:28.275+00
40ae6b39-86a0-4814-a1e1-85f147754ae7	local	40ae6b39-86a0-4814-a1e1-85f147754ae7.jpg	kepseribu-region.jpg	Kepseribu Region	image/jpeg	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:58:59.098+00	\N	2026-07-14 04:58:59.141+00	\N	286588	1680	1050	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 04:58:59.14+00
96c0bc18-ba54-4173-b78c-2910338c56e2	local	96c0bc18-ba54-4173-b78c-2910338c56e2.png	pulau harapan.png	Pulau Harapan	image/png	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:46:25.039+00	\N	2026-07-14 06:46:25.096+00	\N	1673589	1446	736	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 06:46:25.093+00
7af52fd4-e747-4133-8b4a-2522506f8c2f	local	7af52fd4-e747-4133-8b4a-2522506f8c2f.png	pulau harapan.png	Pulau Harapan	image/png	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 06:49:54.619+00	\N	2026-07-14 06:49:54.648+00	\N	1673589	1446	736	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-14 06:49:54.647+00
04b20e66-94f5-4784-9f42-f43f3c8551fa	local	04b20e66-94f5-4784-9f42-f43f3c8551fa.webp	VodaTravelIcon.webp	Voda Travel Icon	image/webp	\N	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-15 07:59:15.905+00	\N	2026-07-15 07:59:15.944+00	\N	79676	1536	1024	\N	\N	\N	\N	\N	{}	\N	\N	\N	\N	2026-07-15 07:59:15.943+00
\.


--
-- Data for Name: directus_flows; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_flows (id, name, icon, color, description, status, trigger, accountability, options, operation, date_created, user_created) FROM stdin;
bc154261-1232-4c56-a826-02a808a3e959	Test Filter Simple	block	#E53935	Test: always reject	active	event	all	{"type":"filter","scope":["items.create"],"collections":["packages"]}	07a7e5a9-1695-4cc2-9382-12ea25aa8145	2026-07-17 02:29:32.628+00	bb454258-7d81-40f6-af80-ad85011fa204
\.


--
-- Data for Name: directus_folders; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_folders (id, name, parent) FROM stdin;
\.


--
-- Data for Name: directus_migrations; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_migrations (version, name, "timestamp") FROM stdin;
20201028A	Remove Collection Foreign Keys	2026-07-10 03:08:58.551844+00
20201029A	Remove System Relations	2026-07-10 03:08:58.560724+00
20201029B	Remove System Collections	2026-07-10 03:08:58.567306+00
20201029C	Remove System Fields	2026-07-10 03:08:58.576081+00
20201105A	Add Cascade System Relations	2026-07-10 03:08:58.678173+00
20201105B	Change Webhook URL Type	2026-07-10 03:08:58.691498+00
20210225A	Add Relations Sort Field	2026-07-10 03:08:58.700068+00
20210304A	Remove Locked Fields	2026-07-10 03:08:58.706344+00
20210312A	Webhooks Collections Text	2026-07-10 03:08:58.716991+00
20210331A	Add Refresh Interval	2026-07-10 03:08:58.723367+00
20210415A	Make Filesize Nullable	2026-07-10 03:08:58.74177+00
20210416A	Add Collections Accountability	2026-07-10 03:08:58.749839+00
20210422A	Remove Files Interface	2026-07-10 03:08:58.754005+00
20210506A	Rename Interfaces	2026-07-10 03:08:58.77897+00
20210510A	Restructure Relations	2026-07-10 03:08:58.809835+00
20210518A	Add Foreign Key Constraints	2026-07-10 03:08:58.826815+00
20210519A	Add System Fk Triggers	2026-07-10 03:08:58.889042+00
20210521A	Add Collections Icon Color	2026-07-10 03:08:58.894273+00
20210525A	Add Insights	2026-07-10 03:08:58.933957+00
20210608A	Add Deep Clone Config	2026-07-10 03:08:58.939309+00
20210626A	Change Filesize Bigint	2026-07-10 03:08:58.964867+00
20210716A	Add Conditions to Fields	2026-07-10 03:08:58.970569+00
20210721A	Add Default Folder	2026-07-10 03:08:58.980713+00
20210802A	Replace Groups	2026-07-10 03:08:58.987851+00
20210803A	Add Required to Fields	2026-07-10 03:08:58.994234+00
20210805A	Update Groups	2026-07-10 03:08:59.000274+00
20210805B	Change Image Metadata Structure	2026-07-10 03:08:59.006114+00
20210811A	Add Geometry Config	2026-07-10 03:08:59.011237+00
20210831A	Remove Limit Column	2026-07-10 03:08:59.017107+00
20210903A	Add Auth Provider	2026-07-10 03:08:59.05212+00
20210907A	Webhooks Collections Not Null	2026-07-10 03:08:59.065494+00
20210910A	Move Module Setup	2026-07-10 03:08:59.073543+00
20210920A	Webhooks URL Not Null	2026-07-10 03:08:59.0848+00
20210924A	Add Collection Organization	2026-07-10 03:08:59.096824+00
20210927A	Replace Fields Group	2026-07-10 03:08:59.11146+00
20210927B	Replace M2M Interface	2026-07-10 03:08:59.115178+00
20210929A	Rename Login Action	2026-07-10 03:08:59.118558+00
20211007A	Update Presets	2026-07-10 03:08:59.130424+00
20211009A	Add Auth Data	2026-07-10 03:08:59.137714+00
20211016A	Add Webhook Headers	2026-07-10 03:08:59.143347+00
20211103A	Set Unique to User Token	2026-07-10 03:08:59.153562+00
20211103B	Update Special Geometry	2026-07-10 03:08:59.157732+00
20211104A	Remove Collections Listing	2026-07-10 03:08:59.163166+00
20211118A	Add Notifications	2026-07-10 03:08:59.190209+00
20211211A	Add Shares	2026-07-10 03:08:59.226347+00
20211230A	Add Project Descriptor	2026-07-10 03:08:59.23254+00
20220303A	Remove Default Project Color	2026-07-10 03:08:59.244921+00
20220308A	Add Bookmark Icon and Color	2026-07-10 03:08:59.250686+00
20220314A	Add Translation Strings	2026-07-10 03:08:59.255644+00
20220322A	Rename Field Typecast Flags	2026-07-10 03:08:59.261019+00
20220323A	Add Field Validation	2026-07-10 03:08:59.266253+00
20220325A	Fix Typecast Flags	2026-07-10 03:08:59.271768+00
20220325B	Add Default Language	2026-07-10 03:08:59.285985+00
20220402A	Remove Default Value Panel Icon	2026-07-10 03:08:59.299134+00
20220429A	Add Flows	2026-07-10 03:08:59.367091+00
20220429B	Add Color to Insights Icon	2026-07-10 03:08:59.372462+00
20220429C	Drop Non Null From IP of Activity	2026-07-10 03:08:59.376724+00
20220429D	Drop Non Null From Sender of Notifications	2026-07-10 03:08:59.381189+00
20220614A	Rename Hook Trigger to Event	2026-07-10 03:08:59.384588+00
20220801A	Update Notifications Timestamp Column	2026-07-10 03:08:59.396619+00
20220802A	Add Custom Aspect Ratios	2026-07-10 03:08:59.400843+00
20220826A	Add Origin to Accountability	2026-07-10 03:08:59.407632+00
20230401A	Update Material Icons	2026-07-10 03:08:59.421989+00
20230525A	Add Preview Settings	2026-07-10 03:08:59.427185+00
20230526A	Migrate Translation Strings	2026-07-10 03:08:59.445932+00
20230721A	Require Shares Fields	2026-07-10 03:08:59.453739+00
20230823A	Add Content Versioning	2026-07-10 03:08:59.48773+00
20230927A	Themes	2026-07-10 03:08:59.518681+00
20231009A	Update CSV Fields to Text	2026-07-10 03:08:59.523761+00
20231009B	Update Panel Options	2026-07-10 03:08:59.527838+00
20231010A	Add Extensions	2026-07-10 03:08:59.539302+00
20231215A	Add Focalpoints	2026-07-10 03:08:59.54491+00
20240122A	Add Report URL Fields	2026-07-10 03:08:59.551147+00
20240204A	Marketplace	2026-07-10 03:08:59.598501+00
20240305A	Change Useragent Type	2026-07-10 03:08:59.617253+00
20240311A	Deprecate Webhooks	2026-07-10 03:08:59.631432+00
20240422A	Public Registration	2026-07-10 03:08:59.643817+00
20240515A	Add Session Window	2026-07-10 03:08:59.649604+00
20240701A	Add Tus Data	2026-07-10 03:08:59.655171+00
20240716A	Update Files Date Fields	2026-07-10 03:08:59.664802+00
20240806A	Permissions Policies	2026-07-10 03:08:59.74515+00
20240817A	Update Icon Fields Length	2026-07-10 03:08:59.79914+00
20240909A	Separate Comments	2026-07-10 03:08:59.823977+00
20240909B	Consolidate Content Versioning	2026-07-10 03:08:59.830468+00
20240924A	Migrate Legacy Comments	2026-07-10 03:08:59.839872+00
20240924B	Populate Versioning Deltas	2026-07-10 03:08:59.84573+00
20250224A	Visual Editor	2026-07-10 03:08:59.853017+00
20250609A	License Banner	2026-07-10 03:08:59.861032+00
20250613A	Add Project ID	2026-07-10 03:08:59.876852+00
20250718A	Add Direction	2026-07-10 03:08:59.882925+00
20250813A	Add MCP	2026-07-10 03:08:59.892264+00
20251012A	Add Field Searchable	2026-07-10 03:08:59.898023+00
20251014A	Add Project Owner	2026-07-10 03:08:59.946388+00
20251028A	Add Retention Indexes	2026-07-10 03:09:00.009766+00
20251103A	Add AI Settings	2026-07-10 03:09:00.017224+00
20251224A	Remove Webhooks	2026-07-10 03:09:00.028647+00
20260110A	Add AI Provider Settings	2026-07-10 03:09:00.041656+00
20260113A	Add Revisions Index	2026-07-10 03:09:00.064752+00
20260128A	Add Collaborative Editing	2026-07-10 03:09:00.070925+00
20260204A	Add Deployment	2026-07-10 03:09:00.145001+00
20260211A	Add Deployment Webhooks	2026-07-10 03:09:00.157771+00
20260217A	Null Item Versions	2026-07-17 01:36:41.908375+00
20260312A	Add AI Translation Settings	2026-07-17 01:36:41.918255+00
20260507A	Add Licensing	2026-07-17 01:36:41.928689+00
20260512A	Add Autosave Revision Interval	2026-07-17 01:36:41.934575+00
20260512B	Add MCP Oauth	2026-07-17 01:36:42.089095+00
\.


--
-- Data for Name: directus_notifications; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_notifications (id, "timestamp", status, recipient, sender, subject, message, collection, item) FROM stdin;
\.


--
-- Data for Name: directus_oauth_clients; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_oauth_clients (client_id, client_name, redirect_uris, grant_types, token_endpoint_auth_method, client_secret_hash, registration_type, client_uri, logo_uri, tos_uri, policy_uri, metadata_fetched_at, metadata_expires_at, metadata_etag, date_created) FROM stdin;
\.


--
-- Data for Name: directus_oauth_codes; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_oauth_codes (id, code_hash, client, "user", redirect_uri, resource, code_challenge, code_challenge_method, scope, expires_at, used_at) FROM stdin;
\.


--
-- Data for Name: directus_oauth_consents; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_oauth_consents (id, "user", client, redirect_uri, scope, date_created, date_updated) FROM stdin;
\.


--
-- Data for Name: directus_oauth_tokens; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_oauth_tokens (id, client, "user", session, previous_session, resource, code_hash, scope, expires_at, date_created) FROM stdin;
\.


--
-- Data for Name: directus_operations; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_operations (id, name, key, type, position_x, position_y, options, resolve, reject, flow, date_created, user_created) FROM stdin;
07a7e5a9-1695-4cc2-9382-12ea25aa8145	Always Reject	always_reject	script	20	20	{"body":"module.exports = async function(data) {\\n    return null;\\n}"}	\N	\N	bc154261-1232-4c56-a826-02a808a3e959	2026-07-17 02:29:32.648+00	bb454258-7d81-40f6-af80-ad85011fa204
\.


--
-- Data for Name: directus_panels; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_panels (id, dashboard, name, icon, color, show_header, note, type, position_x, position_y, width, height, options, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_permissions; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_permissions (id, collection, action, permissions, validation, presets, fields, policy) FROM stdin;
8	searches	create	{}	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
1	regions	read	{}	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
2	destinations	read	{}	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
3	packages	read	{}	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
4	activity_types	read	{}	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
5	packages_activity_types	read	{}	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
6	settings	read	{}	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
7	searches	read	{}	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
9	directus_files	read	{}	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
11	articles	read	{}	\N	\N	*	abf8a154-5b1c-4a46-ac9c-7300570f4f17
\.


--
-- Data for Name: directus_policies; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_policies (id, name, icon, description, ip_access, enforce_tfa, admin_access, app_access) FROM stdin;
abf8a154-5b1c-4a46-ac9c-7300570f4f17	$t:public_label	public	$t:public_description	\N	f	f	f
92538bb3-48ab-475e-8239-72531899ad43	Administrator	verified	$t:admin_description	\N	f	t	t
\.


--
-- Data for Name: directus_presets; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_presets (id, bookmark, "user", role, collection, search, layout, layout_query, layout_options, refresh_interval, filter, icon, color) FROM stdin;
7	\N	bb454258-7d81-40f6-af80-ad85011fa204	\N	directus_files	\N	cards	{"cards":{"sort":["-uploaded_on"],"page":1}}	{"cards":{"icon":"insert_drive_file","title":"{{ title }}","subtitle":"{{ type }} • {{ filesize }}","size":4,"imageFit":"crop"}}	\N	\N	bookmark	\N
8	\N	bb454258-7d81-40f6-af80-ad85011fa204	\N	settings	\N	\N	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
1	\N	bb454258-7d81-40f6-af80-ad85011fa204	\N	activity_types	\N	tabular	{"tabular":{"page":1},"map":{"limit":1000}}	{"kanban":{"groupOrder":{"groupField":"status","sortMap":{"published":0,"draft":1,"archived":2}}},"map":{"cameraOptions":{"center":{"lng":-178.86089862406533,"lat":-57.89653783382668},"zoom":2.9504017730177265,"bearing":0,"pitch":0,"bbox":[-224.5706830339954,-70.97452850279674,-133.1511142141349,-37.41892083360109]}}}	\N	\N	bookmark	\N
6	\N	bb454258-7d81-40f6-af80-ad85011fa204	\N	searches	\N	\N	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
3	\N	bb454258-7d81-40f6-af80-ad85011fa204	\N	packages_activity_types	\N	\N	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
5	\N	bb454258-7d81-40f6-af80-ad85011fa204	\N	regions	\N	\N	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
4	\N	bb454258-7d81-40f6-af80-ad85011fa204	\N	packages	\N	\N	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
2	\N	bb454258-7d81-40f6-af80-ad85011fa204	\N	destinations	\N	tabular	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
10	\N	bb454258-7d81-40f6-af80-ad85011fa204	\N	articles	\N	\N	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
\.


--
-- Data for Name: directus_relations; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_relations (id, many_collection, many_field, one_collection, one_field, one_collection_field, one_allowed_collections, junction_field, sort_field, one_deselect_action) FROM stdin;
15	regions	user_created	directus_users	\N	\N	\N	\N	\N	nullify
16	regions	user_updated	directus_users	\N	\N	\N	\N	\N	nullify
17	regions	image	directus_files	\N	\N	\N	\N	\N	nullify
18	destinations	user_updated	directus_users	\N	\N	\N	\N	\N	nullify
19	destinations	user_created	directus_users	\N	\N	\N	\N	\N	nullify
21	destinations	image	directus_files	\N	\N	\N	\N	\N	nullify
22	destinations	region_id	regions	destinations	\N	\N	\N	\N	nullify
25	packages	destination_id	destinations	\N	\N	\N	\N	\N	nullify
26	packages	image	directus_files	\N	\N	\N	\N	\N	nullify
27	packages_activity_types	package_id	packages	\N	\N	\N	\N	\N	nullify
28	packages_activity_types	activity_type_id	activity_types	\N	\N	\N	\N	\N	nullify
68	articles	featured_image	directus_files	\N	\N	\N	\N	\N	nullify
\.


--
-- Data for Name: directus_revisions; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_revisions (id, activity, collection, item, data, delta, parent, version) FROM stdin;
1	3	directus_fields	1	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
2	4	directus_fields	2	{"sort":2,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	{"sort":2,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	\N	\N
3	5	directus_fields	3	{"sort":3,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	{"sort":3,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	\N	\N
4	6	directus_fields	4	{"sort":4,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	{"sort":4,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	\N	\N
5	7	directus_fields	5	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	{"sort":5,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	\N	\N
6	8	directus_collections	regions	{"singleton":false,"collection":"regions"}	{"singleton":false,"collection":"regions"}	\N	\N
7	9	directus_fields	6	{"sort":6,"interface":"input","special":null,"options":{"placeholder":"Nama Daerah"},"required":true,"field":"name"}	{"sort":6,"interface":"input","special":null,"options":{"placeholder":"Nama Daerah"},"required":true,"field":"name"}	\N	\N
8	17	directus_fields	7	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
9	18	directus_fields	8	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	\N	\N
10	19	directus_fields	9	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	\N	\N
11	20	directus_fields	10	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	\N	\N
12	21	directus_fields	11	{"sort":5,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	{"sort":5,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	\N	\N
13	22	directus_fields	12	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	\N	\N
14	23	directus_collections	regions	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"regions"}	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"regions"}	\N	\N
15	24	directus_fields	13	{"sort":7,"interface":"input","special":null,"required":true,"options":{"placeholder":"Nama Daerah"},"field":"name"}	{"sort":7,"interface":"input","special":null,"required":true,"options":{"placeholder":"Nama Daerah"},"field":"name"}	\N	\N
16	25	directus_fields	14	{"sort":8,"interface":"input","special":null,"options":{"placeholder":"Slug Daerah"},"required":true,"field":"slug"}	{"sort":8,"interface":"input","special":null,"options":{"placeholder":"Slug Daerah"},"required":true,"field":"slug"}	\N	\N
17	26	directus_fields	15	{"sort":9,"interface":"input-multiline","special":null,"required":true,"field":"description"}	{"sort":9,"interface":"input-multiline","special":null,"required":true,"field":"description"}	\N	\N
18	27	directus_fields	16	{"sort":10,"interface":"file","special":["file"],"required":true,"options":{"allowedMimeTypes":["image/*"]},"field":"image"}	{"sort":10,"interface":"file","special":["file"],"required":true,"options":{"allowedMimeTypes":["image/*"]},"field":"image"}	\N	\N
19	28	directus_fields	17	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
20	29	directus_fields	18	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	\N	\N
21	30	directus_fields	19	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	\N	\N
22	31	directus_fields	20	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	\N	\N
23	32	directus_fields	21	{"sort":5,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	{"sort":5,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	\N	\N
24	33	directus_fields	22	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	\N	\N
25	34	directus_collections	destinations	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"destinations"}	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"destinations"}	\N	\N
26	35	directus_fields	23	{"sort":7,"special":["m2o"],"validation":null,"field":"region_id"}	{"sort":7,"special":["m2o"],"validation":null,"field":"region_id"}	\N	\N
27	36	directus_fields	24	{"sort":11,"special":["o2m"],"interface":"list-o2m","field":"destinations"}	{"sort":11,"special":["o2m"],"interface":"list-o2m","field":"destinations"}	\N	\N
28	37	directus_fields	17	{"id":17,"field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"id","sort":1,"group":null}	\N	\N
29	38	directus_fields	18	{"id":18,"field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"status","sort":2,"group":null}	\N	\N
30	39	directus_fields	23	{"id":23,"field":"region_id","special":["m2o"],"interface":null,"options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"region_id","sort":3,"group":null}	\N	\N
31	40	directus_fields	19	{"id":19,"field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"user_created","sort":4,"group":null}	\N	\N
32	41	directus_fields	20	{"id":20,"field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"date_created","sort":5,"group":null}	\N	\N
89	121	directus_collections	destinations	{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"destinations"}	{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"destinations"}	\N	\N
33	42	directus_fields	21	{"id":21,"field":"user_updated","special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"user_updated","sort":6,"group":null}	\N	\N
34	43	directus_fields	22	{"id":22,"field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"date_updated","sort":7,"group":null}	\N	\N
35	44	directus_fields	17	{"id":17,"field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"id","sort":1,"group":null}	\N	\N
36	45	directus_fields	23	{"id":23,"field":"region_id","special":["m2o"],"interface":null,"options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"region_id","sort":2,"group":null}	\N	\N
37	46	directus_fields	18	{"id":18,"field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"status","sort":3,"group":null}	\N	\N
38	47	directus_fields	19	{"id":19,"field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":4,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"user_created","sort":4,"group":null}	\N	\N
39	48	directus_fields	20	{"id":20,"field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"date_created","sort":5,"group":null}	\N	\N
40	49	directus_fields	21	{"id":21,"field":"user_updated","special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"user_updated","sort":6,"group":null}	\N	\N
41	50	directus_fields	22	{"id":22,"field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"date_updated","sort":7,"group":null}	\N	\N
42	51	directus_fields	25	{"sort":8,"interface":"input","special":null,"required":true,"options":{"placeholder":"Nama Destinasi"},"field":"name"}	{"sort":8,"interface":"input","special":null,"required":true,"options":{"placeholder":"Nama Destinasi"},"field":"name"}	\N	\N
43	52	directus_fields	17	{"id":17,"field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"id","sort":1,"group":null}	\N	\N
44	53	directus_fields	23	{"id":23,"field":"region_id","special":["m2o"],"interface":null,"options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"region_id","sort":2,"group":null}	\N	\N
45	54	directus_fields	25	{"id":25,"field":"name","special":null,"interface":"input","options":{"placeholder":"Nama Destinasi"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"name","sort":3,"group":null}	\N	\N
46	55	directus_fields	18	{"id":18,"field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"status","sort":4,"group":null}	\N	\N
137	203	directus_fields	79	{"sort":5,"required":false,"interface":"select-dropdown-m2o","special":["m2o"],"field":"destination_id"}	{"sort":5,"required":false,"interface":"select-dropdown-m2o","special":["m2o"],"field":"destination_id"}	\N	\N
47	56	directus_fields	19	{"id":19,"field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":5,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"user_created","sort":5,"group":null}	\N	\N
48	57	directus_fields	20	{"id":20,"field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"date_created","sort":6,"group":null}	\N	\N
49	58	directus_fields	21	{"id":21,"field":"user_updated","special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"user_updated","sort":7,"group":null}	\N	\N
50	59	directus_fields	22	{"id":22,"field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":8,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"date_updated","sort":8,"group":null}	\N	\N
51	60	directus_fields	26	{"sort":9,"interface":"input","special":null,"required":true,"options":{"placeholder":"Slug Destinasi"},"field":"slug"}	{"sort":9,"interface":"input","special":null,"required":true,"options":{"placeholder":"Slug Destinasi"},"field":"slug"}	\N	\N
52	61	directus_fields	23	{"id":23,"field":"region_id","special":["m2o"],"interface":null,"options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"region_id","required":true}	\N	\N
53	62	directus_fields	17	{"id":17,"field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"id","sort":1,"group":null}	\N	\N
54	63	directus_fields	23	{"id":23,"field":"region_id","special":["m2o"],"interface":null,"options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"region_id","sort":2,"group":null}	\N	\N
55	64	directus_fields	25	{"id":25,"field":"name","special":null,"interface":"input","options":{"placeholder":"Nama Destinasi"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"name","sort":3,"group":null}	\N	\N
56	65	directus_fields	26	{"id":26,"field":"slug","special":null,"interface":"input","options":{"placeholder":"Slug Destinasi"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"slug","sort":4,"group":null}	\N	\N
57	66	directus_fields	18	{"id":18,"field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"status","sort":5,"group":null}	\N	\N
58	67	directus_fields	19	{"id":19,"field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"user_created","sort":6,"group":null}	\N	\N
59	68	directus_fields	20	{"id":20,"field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"date_created","sort":7,"group":null}	\N	\N
60	69	directus_fields	21	{"id":21,"field":"user_updated","special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":8,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"user_updated","sort":8,"group":null}	\N	\N
61	70	directus_fields	22	{"id":22,"field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":9,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"date_updated","sort":9,"group":null}	\N	\N
62	71	directus_fields	27	{"sort":10,"interface":"input-multiline","special":null,"required":true,"options":{"placeholder":"Deskripsi destinasi"},"field":"description"}	{"sort":10,"interface":"input-multiline","special":null,"required":true,"options":{"placeholder":"Deskripsi destinasi"},"field":"description"}	\N	\N
63	72	directus_fields	25	{"id":25,"field":"name","special":null,"interface":"input","options":{"placeholder":"Nama destinasi (Lembang)"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"name","options":{"placeholder":"Nama destinasi (Lembang)"}}	\N	\N
64	73	directus_fields	27	{"id":27,"field":"description","special":null,"interface":"input-multiline","options":{"placeholder":"Deskripsi destinasi"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"description","required":false}	\N	\N
65	74	directus_fields	17	{"id":17,"field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"id","sort":1,"group":null}	\N	\N
66	75	directus_fields	23	{"id":23,"field":"region_id","special":["m2o"],"interface":null,"options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"region_id","sort":2,"group":null}	\N	\N
67	76	directus_fields	25	{"id":25,"field":"name","special":null,"interface":"input","options":{"placeholder":"Nama destinasi (Lembang)"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"name","sort":3,"group":null}	\N	\N
68	77	directus_fields	26	{"id":26,"field":"slug","special":null,"interface":"input","options":{"placeholder":"Slug Destinasi"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"slug","sort":4,"group":null}	\N	\N
69	78	directus_fields	27	{"id":27,"field":"description","special":null,"interface":"input-multiline","options":{"placeholder":"Deskripsi destinasi"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"description","sort":5,"group":null}	\N	\N
70	79	directus_fields	18	{"id":18,"field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"status","sort":6,"group":null}	\N	\N
71	80	directus_fields	19	{"id":19,"field":"user_created","special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"user_created","sort":7,"group":null}	\N	\N
72	81	directus_fields	20	{"id":20,"field":"date_created","special":["date-created"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":8,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"date_created","sort":8,"group":null}	\N	\N
73	82	directus_fields	21	{"id":21,"field":"user_updated","special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","display_options":null,"readonly":true,"hidden":true,"sort":9,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"user_updated","sort":9,"group":null}	\N	\N
74	83	directus_fields	22	{"id":22,"field":"date_updated","special":["date-updated"],"interface":"datetime","options":null,"display":"datetime","display_options":{"relative":true},"readonly":true,"hidden":true,"sort":10,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"date_updated","sort":10,"group":null}	\N	\N
75	107	directus_fields	28	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
112	176	directus_fields	58	{"id":58,"field":"slug","special":null,"interface":null,"options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"regions","field":"slug","required":true}	\N	\N
113	177	directus_fields	59	{"sort":9,"interface":"input-multiline","special":null,"required":true,"options":{"placeholder":"Deskripsi region"},"field":"description"}	{"sort":9,"interface":"input-multiline","special":null,"required":true,"options":{"placeholder":"Deskripsi region"},"field":"description"}	\N	\N
114	178	directus_fields	60	{"sort":10,"interface":"file-image","special":["file"],"required":true,"options":{"allowedMimeTypes":["image/jpeg","image/png","image/webp","image/svg+xml","image/avif","image/tiff"]},"field":"image"}	{"sort":10,"interface":"file-image","special":["file"],"required":true,"options":{"allowedMimeTypes":["image/jpeg","image/png","image/webp","image/svg+xml","image/avif","image/tiff"]},"field":"image"}	\N	\N
115	179	directus_fields	61	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
76	108	directus_fields	29	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	\N	\N
77	109	directus_fields	30	{"sort":3,"interface":"input","hidden":true,"field":"sort"}	{"sort":3,"interface":"input","hidden":true,"field":"sort"}	\N	\N
78	110	directus_fields	31	{"sort":4,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	{"sort":4,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	\N	\N
79	111	directus_fields	32	{"sort":5,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	{"sort":5,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	\N	\N
80	112	directus_fields	33	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	\N	\N
81	113	directus_collections	regions	{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"regions"}	{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"regions"}	\N	\N
82	114	directus_fields	34	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
83	115	directus_fields	35	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	\N	\N
84	116	directus_fields	36	{"sort":3,"interface":"input","hidden":true,"field":"sort"}	{"sort":3,"interface":"input","hidden":true,"field":"sort"}	\N	\N
85	117	directus_fields	37	{"sort":4,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	{"sort":4,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	\N	\N
86	118	directus_fields	38	{"sort":5,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	{"sort":5,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	\N	\N
87	119	directus_fields	39	{"sort":6,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	{"sort":6,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	\N	\N
88	120	directus_fields	40	{"sort":7,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	{"sort":7,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	\N	\N
90	122	directus_fields	41	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
91	123	directus_fields	42	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	\N	\N
92	124	directus_fields	43	{"sort":3,"interface":"input","hidden":true,"field":"sort"}	{"sort":3,"interface":"input","hidden":true,"field":"sort"}	\N	\N
93	125	directus_fields	44	{"sort":4,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	{"sort":4,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	\N	\N
94	126	directus_fields	45	{"sort":5,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	{"sort":5,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	\N	\N
95	127	directus_fields	46	{"sort":6,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	{"sort":6,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	\N	\N
96	128	directus_fields	47	{"sort":7,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	{"sort":7,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	\N	\N
97	129	directus_collections	packages	{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"packages"}	{"sort_field":"sort","archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"packages"}	\N	\N
98	136	directus_settings	1	{"id":1,"project_name":"Directus","project_url":null,"project_color":"#6644FF","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":null,"org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false}	{"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204"}	\N	\N
99	137	directus_fields	48	{"sort":7,"interface":"input","special":null,"options":{"placeholder":"Nama region (Bandung, Bali)"},"required":true,"field":"name"}	{"sort":7,"interface":"input","special":null,"options":{"placeholder":"Nama region (Bandung, Bali)"},"required":true,"field":"name"}	\N	\N
100	138	directus_fields	49	{"sort":8,"special":null,"field":"slug"}	{"sort":8,"special":null,"field":"slug"}	\N	\N
101	139	directus_fields	49	{"id":49,"field":"slug","special":null,"interface":null,"options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"regions","field":"slug","required":true}	\N	\N
102	140	directus_fields	50	{"sort":9,"interface":"file","special":["file"],"required":true,"options":{"allowedMimeTypes":["image/*"]},"field":"image"}	{"sort":9,"interface":"file","special":["file"],"required":true,"options":{"allowedMimeTypes":["image/*"]},"field":"image"}	\N	\N
103	167	directus_fields	51	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
110	174	directus_fields	57	{"sort":7,"interface":"input","special":null,"required":true,"options":{"placeholder":"Nama region (Bandung, Bali)"},"field":"name"}	{"sort":7,"interface":"input","special":null,"required":true,"options":{"placeholder":"Nama region (Bandung, Bali)"},"field":"name"}	\N	\N
111	175	directus_fields	58	{"sort":8,"special":null,"field":"slug"}	{"sort":8,"special":null,"field":"slug"}	\N	\N
138	204	directus_fields	80	{"sort":6,"required":false,"interface":"file-image","special":["file-image"],"field":"image"}	{"sort":6,"required":false,"interface":"file-image","special":["file-image"],"field":"image"}	\N	\N
104	168	directus_fields	52	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	\N	\N
105	169	directus_fields	53	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	\N	\N
106	170	directus_fields	54	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	\N	\N
107	171	directus_fields	55	{"sort":5,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	{"sort":5,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	\N	\N
108	172	directus_fields	56	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	\N	\N
109	173	directus_collections	regions	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"regions"}	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"regions"}	\N	\N
116	180	directus_fields	62	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	{"sort":2,"width":"full","options":{"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)"}]},"interface":"select-dropdown","display":"labels","display_options":{"showAsDot":true,"choices":[{"text":"$t:published","value":"published","color":"var(--theme--primary)","foreground":"var(--theme--primary)","background":"var(--theme--primary-background)"},{"text":"$t:draft","value":"draft","color":"var(--theme--foreground)","foreground":"var(--theme--foreground)","background":"var(--theme--background-normal)"},{"text":"$t:archived","value":"archived","color":"var(--theme--warning)","foreground":"var(--theme--warning)","background":"var(--theme--warning-background)"}]},"field":"status"}	\N	\N
117	181	directus_fields	63	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	{"sort":3,"special":["user-created"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_created"}	\N	\N
118	182	directus_fields	64	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	{"sort":4,"special":["date-created"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_created"}	\N	\N
119	183	directus_fields	65	{"sort":5,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	{"sort":5,"special":["user-updated"],"interface":"select-dropdown-m2o","options":{"template":"{{avatar}} {{first_name}} {{last_name}}"},"display":"user","readonly":true,"hidden":true,"width":"half","field":"user_updated"}	\N	\N
120	184	directus_fields	66	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	{"sort":6,"special":["date-updated"],"interface":"datetime","readonly":true,"hidden":true,"width":"half","display":"datetime","display_options":{"relative":true},"field":"date_updated"}	\N	\N
121	185	directus_collections	destinations	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"destinations"}	{"archive_field":"status","archive_value":"archived","unarchive_value":"draft","singleton":false,"collection":"destinations"}	\N	\N
122	186	directus_fields	67	{"sort":7,"interface":"input","special":null,"required":true,"options":{"placeholder":"Nama destinasi (Lembang)"},"field":"name"}	{"sort":7,"interface":"input","special":null,"required":true,"options":{"placeholder":"Nama destinasi (Lembang)"},"field":"name"}	\N	\N
123	187	directus_fields	68	{"sort":8,"special":null,"required":true,"field":"slug"}	{"sort":8,"special":null,"required":true,"field":"slug"}	\N	\N
124	188	directus_fields	69	{"sort":9,"interface":"input-multiline","special":null,"required":true,"options":{"placeholder":"Deskripsi destinasi"},"field":"description"}	{"sort":9,"interface":"input-multiline","special":null,"required":true,"options":{"placeholder":"Deskripsi destinasi"},"field":"description"}	\N	\N
125	189	directus_fields	70	{"sort":10,"interface":"file-image","special":["file"],"field":"image"}	{"sort":10,"interface":"file-image","special":["file"],"field":"image"}	\N	\N
126	191	directus_fields	71	{"sort":10,"interface":"file-image","special":["file"],"required":true,"options":{"allowedMimeTypes":["image/jpeg","image/png","image/webp","image/svg+xml","image/avif","image/tiff"]},"field":"image"}	{"sort":10,"interface":"file-image","special":["file"],"required":true,"options":{"allowedMimeTypes":["image/jpeg","image/png","image/webp","image/svg+xml","image/avif","image/tiff"]},"field":"image"}	\N	\N
127	192	directus_fields	72	{"sort":11,"special":["m2o"],"field":"region_id"}	{"sort":11,"special":["m2o"],"field":"region_id"}	\N	\N
128	193	directus_fields	73	{"sort":11,"special":["o2m"],"interface":"list-o2m","field":"destinations"}	{"sort":11,"special":["o2m"],"interface":"list-o2m","field":"destinations"}	\N	\N
129	195	directus_fields	58	{"id":58,"field":"slug","special":null,"interface":null,"options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"regions","field":"slug"}	\N	\N
130	196	directus_fields	68	{"id":68,"field":"slug","special":null,"interface":null,"options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"slug"}	\N	\N
131	197	directus_fields	74	{"sort":12,"field":"gallery","type":"json","interface":"json","options":{},"required":false,"note":"Array UUID file gambar","special":["cast-json"]}	{"sort":12,"field":"gallery","type":"json","interface":"json","options":{},"required":false,"note":"Array UUID file gambar","special":["cast-json"]}	\N	\N
132	198	directus_fields	75	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
133	199	directus_collections	packages	{"note":"Paket wisata/travel packages","singleton":false,"collection":"packages"}	{"note":"Paket wisata/travel packages","singleton":false,"collection":"packages"}	\N	\N
134	200	directus_fields	76	{"sort":2,"required":true,"interface":"input","field":"name"}	{"sort":2,"required":true,"interface":"input","field":"name"}	\N	\N
135	201	directus_fields	77	{"sort":3,"required":true,"unique":true,"interface":"input","field":"slug"}	{"sort":3,"required":true,"unique":true,"interface":"input","field":"slug"}	\N	\N
136	202	directus_fields	78	{"sort":4,"required":false,"interface":"input-multiline","field":"description"}	{"sort":4,"required":false,"interface":"input-multiline","field":"description"}	\N	\N
139	205	directus_fields	81	{"sort":7,"required":false,"interface":"json","special":["cast-json"],"field":"gallery"}	{"sort":7,"required":false,"interface":"json","special":["cast-json"],"field":"gallery"}	\N	\N
140	206	directus_fields	82	{"sort":8,"required":false,"interface":"input","field":"duration"}	{"sort":8,"required":false,"interface":"input","field":"duration"}	\N	\N
141	207	directus_fields	83	{"sort":9,"required":false,"interface":"json","special":["cast-json"],"field":"itinerary"}	{"sort":9,"required":false,"interface":"json","special":["cast-json"],"field":"itinerary"}	\N	\N
142	208	directus_fields	84	{"sort":10,"required":false,"interface":"json","special":["cast-json"],"field":"price_tiers"}	{"sort":10,"required":false,"interface":"json","special":["cast-json"],"field":"price_tiers"}	\N	\N
143	209	directus_fields	85	{"sort":11,"required":false,"interface":"json","special":["cast-json"],"field":"facilities"}	{"sort":11,"required":false,"interface":"json","special":["cast-json"],"field":"facilities"}	\N	\N
144	210	directus_fields	86	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
145	211	directus_collections	activity_types	{"note":"Jenis kegiatan (Private Trip, Corporate Gathering, etc)","singleton":false,"collection":"activity_types"}	{"note":"Jenis kegiatan (Private Trip, Corporate Gathering, etc)","singleton":false,"collection":"activity_types"}	\N	\N
146	212	directus_fields	87	{"sort":2,"required":true,"interface":"input","field":"name"}	{"sort":2,"required":true,"interface":"input","field":"name"}	\N	\N
147	213	directus_fields	88	{"sort":3,"required":true,"unique":true,"interface":"input","field":"slug"}	{"sort":3,"required":true,"unique":true,"interface":"input","field":"slug"}	\N	\N
148	214	directus_fields	89	{"sort":4,"required":false,"interface":"input-multiline","field":"description"}	{"sort":4,"required":false,"interface":"input-multiline","field":"description"}	\N	\N
149	215	directus_fields	90	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
150	216	directus_collections	packages_activity_types	{"note":"Junction: packages ←→ activity_types (M2M)","singleton":false,"collection":"packages_activity_types"}	{"note":"Junction: packages ←→ activity_types (M2M)","singleton":false,"collection":"packages_activity_types"}	\N	\N
151	217	directus_fields	91	{"sort":2,"required":true,"interface":"select-dropdown-m2o","special":["m2o"],"field":"package_id"}	{"sort":2,"required":true,"interface":"select-dropdown-m2o","special":["m2o"],"field":"package_id"}	\N	\N
152	218	directus_fields	92	{"sort":3,"required":true,"interface":"select-dropdown-m2o","special":["m2o"],"field":"activity_type_id"}	{"sort":3,"required":true,"interface":"select-dropdown-m2o","special":["m2o"],"field":"activity_type_id"}	\N	\N
153	219	directus_fields	93	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
154	220	directus_collections	settings	{"note":"Site-wide key-value settings","singleton":false,"collection":"settings"}	{"note":"Site-wide key-value settings","singleton":false,"collection":"settings"}	\N	\N
155	221	directus_fields	94	{"sort":2,"required":true,"unique":true,"interface":"input","field":"key"}	{"sort":2,"required":true,"unique":true,"interface":"input","field":"key"}	\N	\N
156	222	directus_fields	95	{"sort":3,"required":false,"interface":"input-multiline","field":"value"}	{"sort":3,"required":false,"interface":"input-multiline","field":"value"}	\N	\N
157	223	directus_fields	96	{"sort":4,"required":false,"interface":"input-multiline","field":"description"}	{"sort":4,"required":false,"interface":"input-multiline","field":"description"}	\N	\N
158	224	directus_fields	97	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
159	225	directus_collections	searches	{"note":"Visitor search history","singleton":false,"collection":"searches"}	{"note":"Visitor search history","singleton":false,"collection":"searches"}	\N	\N
160	226	directus_fields	98	{"sort":2,"required":false,"interface":"input","field":"destination_name"}	{"sort":2,"required":false,"interface":"input","field":"destination_name"}	\N	\N
161	227	directus_fields	99	{"sort":3,"required":false,"interface":"input","field":"region_name"}	{"sort":3,"required":false,"interface":"input","field":"region_name"}	\N	\N
162	228	directus_fields	100	{"sort":4,"required":false,"interface":"input","field":"activity_type_name"}	{"sort":4,"required":false,"interface":"input","field":"activity_type_name"}	\N	\N
163	229	directus_fields	101	{"sort":5,"required":false,"interface":"input","field":"pax_count"}	{"sort":5,"required":false,"interface":"input","field":"pax_count"}	\N	\N
164	230	directus_fields	102	{"sort":6,"required":false,"interface":"date","field":"travel_date"}	{"sort":6,"required":false,"interface":"date","field":"travel_date"}	\N	\N
165	231	directus_fields	103	{"sort":7,"required":false,"interface":"input","field":"visitor_ip"}	{"sort":7,"required":false,"interface":"input","field":"visitor_ip"}	\N	\N
166	253	directus_fields	104	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
167	254	directus_fields	105	{"sort":2,"required":true,"interface":"input","field":"name"}	{"sort":2,"required":true,"interface":"input","field":"name"}	\N	\N
168	255	directus_fields	106	{"sort":3,"required":true,"unique":true,"interface":"input","field":"slug"}	{"sort":3,"required":true,"unique":true,"interface":"input","field":"slug"}	\N	\N
169	256	directus_fields	107	{"sort":4,"required":false,"interface":"input-multiline","field":"description"}	{"sort":4,"required":false,"interface":"input-multiline","field":"description"}	\N	\N
170	257	directus_fields	108	{"sort":5,"required":false,"interface":"select-dropdown-m2o","special":["m2o"],"field":"destination_id"}	{"sort":5,"required":false,"interface":"select-dropdown-m2o","special":["m2o"],"field":"destination_id"}	\N	\N
171	258	directus_fields	109	{"sort":6,"required":false,"interface":"file-image","special":["file-image"],"field":"image"}	{"sort":6,"required":false,"interface":"file-image","special":["file-image"],"field":"image"}	\N	\N
172	259	directus_fields	110	{"sort":7,"required":false,"interface":"json","field":"gallery","special":["cast-json"]}	{"sort":7,"required":false,"interface":"json","field":"gallery","special":["cast-json"]}	\N	\N
173	260	directus_fields	111	{"sort":8,"required":false,"interface":"input","field":"duration"}	{"sort":8,"required":false,"interface":"input","field":"duration"}	\N	\N
174	261	directus_fields	112	{"sort":9,"required":false,"interface":"json","field":"itinerary","special":["cast-json"]}	{"sort":9,"required":false,"interface":"json","field":"itinerary","special":["cast-json"]}	\N	\N
175	262	directus_fields	113	{"sort":10,"required":false,"interface":"json","field":"price_tiers","special":["cast-json"]}	{"sort":10,"required":false,"interface":"json","field":"price_tiers","special":["cast-json"]}	\N	\N
176	263	directus_fields	114	{"sort":11,"required":false,"interface":"json","field":"facilities","special":["cast-json"]}	{"sort":11,"required":false,"interface":"json","field":"facilities","special":["cast-json"]}	\N	\N
177	264	directus_collections	packages	{"note":"Paket wisata/travel packages","singleton":false,"collection":"packages"}	{"note":"Paket wisata/travel packages","singleton":false,"collection":"packages"}	\N	\N
178	265	directus_fields	115	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
179	266	directus_fields	116	{"sort":2,"required":true,"interface":"input","field":"name"}	{"sort":2,"required":true,"interface":"input","field":"name"}	\N	\N
180	267	directus_fields	117	{"sort":3,"required":true,"unique":true,"interface":"input","field":"slug"}	{"sort":3,"required":true,"unique":true,"interface":"input","field":"slug"}	\N	\N
181	268	directus_fields	118	{"sort":4,"required":false,"interface":"input-multiline","field":"description"}	{"sort":4,"required":false,"interface":"input-multiline","field":"description"}	\N	\N
182	269	directus_collections	activity_types	{"note":"Jenis kegiatan (Private Trip, Corporate Gathering, etc)","singleton":false,"collection":"activity_types"}	{"note":"Jenis kegiatan (Private Trip, Corporate Gathering, etc)","singleton":false,"collection":"activity_types"}	\N	\N
183	270	directus_fields	119	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
184	271	directus_fields	120	{"sort":2,"required":true,"interface":"select-dropdown-m2o","special":["m2o"],"field":"package_id"}	{"sort":2,"required":true,"interface":"select-dropdown-m2o","special":["m2o"],"field":"package_id"}	\N	\N
185	272	directus_fields	121	{"sort":3,"required":true,"interface":"select-dropdown-m2o","special":["m2o"],"field":"activity_type_id"}	{"sort":3,"required":true,"interface":"select-dropdown-m2o","special":["m2o"],"field":"activity_type_id"}	\N	\N
186	273	directus_collections	packages_activity_types	{"note":"Junction: packages ←→ activity_types (M2M)","singleton":false,"collection":"packages_activity_types"}	{"note":"Junction: packages ←→ activity_types (M2M)","singleton":false,"collection":"packages_activity_types"}	\N	\N
187	274	directus_permissions	1	{"collection":"regions","action":"read","permissions":{},"fields":["*"]}	{"collection":"regions","action":"read","permissions":{},"fields":["*"]}	\N	\N
188	275	directus_permissions	2	{"collection":"destinations","action":"read","permissions":{},"fields":["*"]}	{"collection":"destinations","action":"read","permissions":{},"fields":["*"]}	\N	\N
189	276	directus_permissions	3	{"collection":"packages","action":"read","permissions":{},"fields":["*"]}	{"collection":"packages","action":"read","permissions":{},"fields":["*"]}	\N	\N
190	277	directus_permissions	4	{"collection":"activity_types","action":"read","permissions":{},"fields":["*"]}	{"collection":"activity_types","action":"read","permissions":{},"fields":["*"]}	\N	\N
191	278	directus_permissions	5	{"collection":"packages_activity_types","action":"read","permissions":{},"fields":["*"]}	{"collection":"packages_activity_types","action":"read","permissions":{},"fields":["*"]}	\N	\N
192	279	directus_permissions	6	{"collection":"settings","action":"read","permissions":{},"fields":["*"]}	{"collection":"settings","action":"read","permissions":{},"fields":["*"]}	\N	\N
193	280	directus_permissions	7	{"collection":"searches","action":"read","permissions":{},"fields":["*"]}	{"collection":"searches","action":"read","permissions":{},"fields":["*"]}	\N	\N
194	281	directus_permissions	8	{"collection":"searches","action":"create","permissions":{},"fields":["*"]}	{"collection":"searches","action":"create","permissions":{},"fields":["*"]}	\N	\N
195	282	regions	ec6a1937-1fea-467b-ad67-b5cac3b7021d	{"name":"Bandung","slug":"bandung","description":"Kota kembang dengan udara sejuk, pegunungan, dan kuliner terkenal. Destinasi favorit untuk liburan keluarga dan gathering perusahaan.","status":"published"}	{"name":"Bandung","slug":"bandung","description":"Kota kembang dengan udara sejuk, pegunungan, dan kuliner terkenal. Destinasi favorit untuk liburan keluarga dan gathering perusahaan.","status":"published"}	\N	\N
196	283	regions	863d7681-4753-4694-a4e3-97f7a643000f	{"name":"Bali","slug":"bali","description":"Pulau Dewata dengan pantai eksotis, budaya kaya, dan resor mewah. Cocok untuk private trip dan corporate event.","status":"published"}	{"name":"Bali","slug":"bali","description":"Pulau Dewata dengan pantai eksotis, budaya kaya, dan resor mewah. Cocok untuk private trip dan corporate event.","status":"published"}	\N	\N
197	284	regions	9c2fddf3-c0e6-4d1a-a0a9-03628e22dbb9	{"name":"Yogyakarta","slug":"yogyakarta","description":"Kota budaya dengan candi megah, keraton, dan panorama alam yang memukau. Destinasi edukatif dan rekreatif.","status":"published"}	{"name":"Yogyakarta","slug":"yogyakarta","description":"Kota budaya dengan candi megah, keraton, dan panorama alam yang memukau. Destinasi edukatif dan rekreatif.","status":"published"}	\N	\N
198	285	regions	a11bb172-5658-4e98-8879-2dd3ce41dd9f	{"name":"Kepulauan Seribu","slug":"kepulauan-seribu","description":"Gugusan pulau eksotis di utara Jakarta. Surga snorkeling, diving, dan island camping.","status":"published"}	{"name":"Kepulauan Seribu","slug":"kepulauan-seribu","description":"Gugusan pulau eksotis di utara Jakarta. Surga snorkeling, diving, dan island camping.","status":"published"}	\N	\N
199	286	regions	8c84e8ef-34e2-4ff9-976f-e58f73b2a564	{"name":"Lombok","slug":"lombok","description":"Pantai pasir putih, Gunung Rinjani, dan budaya Sasak yang autentik. Alternatif tenang selain Bali.","status":"published"}	{"name":"Lombok","slug":"lombok","description":"Pantai pasir putih, Gunung Rinjani, dan budaya Sasak yang autentik. Alternatif tenang selain Bali.","status":"published"}	\N	\N
200	287	destinations	2c0e6233-0a08-44f9-b0dc-3b55c28479e1	{"name":"Lembang","slug":"lembang","description":"Kawasan wisata pegunungan di utara Bandung dengan udaranya yang sejuk, perkebunan stroberi, dan berbagai destinasi foto instagramable. Cocok untuk family gathering dan outbound.","status":"published"}	{"name":"Lembang","slug":"lembang","description":"Kawasan wisata pegunungan di utara Bandung dengan udaranya yang sejuk, perkebunan stroberi, dan berbagai destinasi foto instagramable. Cocok untuk family gathering dan outbound.","status":"published"}	\N	\N
217	304	activity_types	49a970e3-a0a8-40be-890a-df45f8867f0b	{"name":"Family Vacation","slug":"family-vacation","description":"Liburan keluarga dengan aktivitas ramah anak dan orang tua. Momen kebersamaan yang berharga.","status":"published"}	{"name":"Family Vacation","slug":"family-vacation","description":"Liburan keluarga dengan aktivitas ramah anak dan orang tua. Momen kebersamaan yang berharga.","status":"published"}	\N	\N
201	288	destinations	91219cf5-7174-4582-a66d-1d7058424dec	{"name":"Kawah Putih Ciwidey","slug":"kawah-putih","description":"Danau kawah belerang dengan pemandangan surreal di ketinggian 2.400 mdpl. Spot foto favorit dan destinasi wisata alam utama di Bandung Selatan.","status":"published"}	{"name":"Kawah Putih Ciwidey","slug":"kawah-putih","description":"Danau kawah belerang dengan pemandangan surreal di ketinggian 2.400 mdpl. Spot foto favorit dan destinasi wisata alam utama di Bandung Selatan.","status":"published"}	\N	\N
202	289	destinations	18e279f9-4aa0-4de4-a486-e815af63eb23	{"name":"Tangkuban Perahu","slug":"tangkuban-perahu","description":"Gunung api aktif dengan kawah raksasa yang bisa dikunjungi. Legenda Sangkuriang melekat erat dengan destinasi ikonik ini.","status":"published"}	{"name":"Tangkuban Perahu","slug":"tangkuban-perahu","description":"Gunung api aktif dengan kawah raksasa yang bisa dikunjungi. Legenda Sangkuriang melekat erat dengan destinasi ikonik ini.","status":"published"}	\N	\N
203	290	destinations	f0969a63-c1b6-46c9-9f7c-3badaaa9379d	{"name":"Ubud","slug":"ubud","description":"Pusat seni dan budaya Bali dengan sawah terasering, hutan monyet, dan galeri seni. Surga untuk retreat dan creative gathering.","status":"published"}	{"name":"Ubud","slug":"ubud","description":"Pusat seni dan budaya Bali dengan sawah terasering, hutan monyet, dan galeri seni. Surga untuk retreat dan creative gathering.","status":"published"}	\N	\N
204	291	destinations	e16c72f3-778c-482f-b000-9f084b1c8883	{"name":"Seminyak","slug":"seminyak","description":"Kawasan pantai barat Bali dengan sunset spektakuler, beach club, dan restoran mewah. Cocok untuk corporate event dan private trip.","status":"published"}	{"name":"Seminyak","slug":"seminyak","description":"Kawasan pantai barat Bali dengan sunset spektakuler, beach club, dan restoran mewah. Cocok untuk corporate event dan private trip.","status":"published"}	\N	\N
205	292	destinations	adfb7643-e49a-4280-8708-31150dce740f	{"name":"Nusa Dua","slug":"nusa-dua","description":"Kawasan resor tepi pantai dengan fasilitas meeting room lengkap dan pantai pribadi. Ideal untuk konferensi dan gathering eksklusif.","status":"published"}	{"name":"Nusa Dua","slug":"nusa-dua","description":"Kawasan resor tepi pantai dengan fasilitas meeting room lengkap dan pantai pribadi. Ideal untuk konferensi dan gathering eksklusif.","status":"published"}	\N	\N
206	293	destinations	d714b370-eff9-400f-9765-672ce05b7aa5	{"name":"Candi Borobudur","slug":"borobudur","description":"Candi Buddha terbesar di dunia, warisan UNESCO. Destinasi spiritual dan edukatif dengan panorama sunrise yang legendaris.","status":"published"}	{"name":"Candi Borobudur","slug":"borobudur","description":"Candi Buddha terbesar di dunia, warisan UNESCO. Destinasi spiritual dan edukatif dengan panorama sunrise yang legendaris.","status":"published"}	\N	\N
207	294	destinations	14ee958e-d602-41fd-93dc-2e125ca45719	{"name":"Pantai Parangtritis","slug":"parangtritis","description":"Pantai selatan yang legendaris dengan pasir hitam, gumuk pasir, dan sunset memukau. Cocok untuk outbound dan gathering.","status":"published"}	{"name":"Pantai Parangtritis","slug":"parangtritis","description":"Pantai selatan yang legendaris dengan pasir hitam, gumuk pasir, dan sunset memukau. Cocok untuk outbound dan gathering.","status":"published"}	\N	\N
208	295	destinations	539e7cd6-32a0-4c42-91d9-05dd4b58ac4d	{"name":"Kota Gede","slug":"kota-gede","description":"Kawasan sejarah dengan arsitektur kolonial dan pengrajin perak. Destinasi wisata heritage dan belanja oleh-oleh.","status":"published"}	{"name":"Kota Gede","slug":"kota-gede","description":"Kawasan sejarah dengan arsitektur kolonial dan pengrajin perak. Destinasi wisata heritage dan belanja oleh-oleh.","status":"published"}	\N	\N
209	296	destinations	f999881b-2066-4539-b648-ac81546ad0af	{"name":"Pulau Macan","slug":"pulau-macan","description":"Resor eko-trendy dengan villa terapung, snorkeling, dan yoga retreat. Destinasi favorit untuk private trip dan team building.","status":"published"}	{"name":"Pulau Macan","slug":"pulau-macan","description":"Resor eko-trendy dengan villa terapung, snorkeling, dan yoga retreat. Destinasi favorit untuk private trip dan team building.","status":"published"}	\N	\N
210	297	destinations	09e35c4a-2012-467c-b5a2-e49e29cd2f22	{"name":"Pulau Pari","slug":"pulau-pari","description":"Pulau dengan pasir putih, laguna biru, dan spot snorkeling terbaik. Cocok untuk budget trip dan gathering santai.","status":"published"}	{"name":"Pulau Pari","slug":"pulau-pari","description":"Pulau dengan pasir putih, laguna biru, dan spot snorkeling terbaik. Cocok untuk budget trip dan gathering santai.","status":"published"}	\N	\N
211	298	destinations	6f8366b1-eda3-451a-b240-984fe41158d5	{"name":"Pulau Ayer","slug":"pulau-ayer","description":"Pulau resor dengan water sports lengkap dan akomodasi nyaman. Ideal untuk weekend getaway dan family gathering.","status":"published"}	{"name":"Pulau Ayer","slug":"pulau-ayer","description":"Pulau resor dengan water sports lengkap dan akomodasi nyaman. Ideal untuk weekend getaway dan family gathering.","status":"published"}	\N	\N
212	299	destinations	c876b951-6217-4a30-80af-2973f34e31f6	{"name":"Senggigi","slug":"senggigi","description":"Kawasan wisata pantai utama Lombok dengan sunset indah, pasir putih, dan fasilitas lengkap. Pilihan tepat untuk relaksasi.","status":"published"}	{"name":"Senggigi","slug":"senggigi","description":"Kawasan wisata pantai utama Lombok dengan sunset indah, pasir putih, dan fasilitas lengkap. Pilihan tepat untuk relaksasi.","status":"published"}	\N	\N
213	300	destinations	89862e81-f3f3-4311-9aff-9e8d9a21016c	{"name":"Gili Trawangan","slug":"gili-trawangan","description":"Pulau tropis tanpa kendaraan bermotor dengan kehidupan malam, snorkeling, dan diving kelas dunia.","status":"published"}	{"name":"Gili Trawangan","slug":"gili-trawangan","description":"Pulau tropis tanpa kendaraan bermotor dengan kehidupan malam, snorkeling, dan diving kelas dunia.","status":"published"}	\N	\N
214	301	activity_types	2592b822-c30b-4d26-92fd-a0f806a8c51e	{"name":"Private Trip","slug":"private-trip","description":"Perjalanan pribadi untuk individu, pasangan, atau kelompok kecil dengan itinerary fleksibel.","status":"published"}	{"name":"Private Trip","slug":"private-trip","description":"Perjalanan pribadi untuk individu, pasangan, atau kelompok kecil dengan itinerary fleksibel.","status":"published"}	\N	\N
215	302	activity_types	bad6232c-9f00-41a8-a699-535245ec3e13	{"name":"Corporate Gathering","slug":"corporate-gathering","description":"Acara perusahaan, gathering tahunan, outing, dan perayaan kantor dengan konsep terpadu.","status":"published"}	{"name":"Corporate Gathering","slug":"corporate-gathering","description":"Acara perusahaan, gathering tahunan, outing, dan perayaan kantor dengan konsep terpadu.","status":"published"}	\N	\N
216	303	activity_types	07885ce8-eeef-4d96-8bc6-799199bfb187	{"name":"Team Building","slug":"team-building","description":"Program seru untuk memperkuat kerjasama tim, kepemimpinan, dan komunikasi antar karyawan.","status":"published"}	{"name":"Team Building","slug":"team-building","description":"Program seru untuk memperkuat kerjasama tim, kepemimpinan, dan komunikasi antar karyawan.","status":"published"}	\N	\N
247	337	directus_permissions	1	{"id":1,"collection":"regions","action":"read","permissions":{},"validation":null,"presets":null,"fields":["*"]}	{"fields":["*"]}	\N	\N
218	305	activity_types	4cc0b3a2-0c22-4506-a639-76a294c66e06	{"name":"Outbound","slug":"outbound","description":"Aktivitas outdoor menantang untuk kelompok: flying fox, rafting, paintball, dan games seru.","status":"published"}	{"name":"Outbound","slug":"outbound","description":"Aktivitas outdoor menantang untuk kelompok: flying fox, rafting, paintball, dan games seru.","status":"published"}	\N	\N
219	306	packages	6afe21c3-5c89-405e-ae6b-0d7cf8b19478	{"name":"Bandung Family Getaway","slug":"bandung-family-getaway","duration":"3 Hari 2 Malam","description":"Liburan keluarga seru di Lembang, Bandung. Kunjungi Farmhouse, Floating Market, dan Observatory. Nikmati udara sejuk dan kuliner khas Bandung.","itinerary":[{"day":1,"title":"Perjalanan ke Bandung","activities":["Berangkat dari Jakarta pagi hari","Check-in hotel di Lembang","Makan siang di rumah makan khas Sunda","Kunjungan ke Farmhouse Lembang","Malam bebas di area hotel"]},{"day":2,"title":"Wisata Alam","activities":["Sarapan di hotel","Kunjungan ke Floating Market Lembang","Makan siang","Observatorium Bosscha","Belanja oleh-oleh di factory outlet"]},{"day":3,"title":"Pulang","activities":["Sarapan dan check-out","Mampir ke kawah putih (opsional)","Perjalanan kembali ke Jakarta"]}],"price_tiers":[{"min_pax":10,"max_pax":15,"price_per_pax":1250000,"description":"Minimal 10 orang"},{"min_pax":16,"max_pax":25,"price_per_pax":1050000,"description":"Untuk grup sedang"},{"min_pax":26,"max_pax":40,"price_per_pax":850000,"description":"Untuk grup besar"}],"facilities":["Hotel bintang 3 (twin share)","Transportasi AC","Makan 3 kali sehari","Tour guide profesional","Dokumentasi","Asuransi perjalanan"],"status":"published"}	{"name":"Bandung Family Getaway","slug":"bandung-family-getaway","duration":"3 Hari 2 Malam","description":"Liburan keluarga seru di Lembang, Bandung. Kunjungi Farmhouse, Floating Market, dan Observatory. Nikmati udara sejuk dan kuliner khas Bandung.","itinerary":[{"day":1,"title":"Perjalanan ke Bandung","activities":["Berangkat dari Jakarta pagi hari","Check-in hotel di Lembang","Makan siang di rumah makan khas Sunda","Kunjungan ke Farmhouse Lembang","Malam bebas di area hotel"]},{"day":2,"title":"Wisata Alam","activities":["Sarapan di hotel","Kunjungan ke Floating Market Lembang","Makan siang","Observatorium Bosscha","Belanja oleh-oleh di factory outlet"]},{"day":3,"title":"Pulang","activities":["Sarapan dan check-out","Mampir ke kawah putih (opsional)","Perjalanan kembali ke Jakarta"]}],"price_tiers":[{"min_pax":10,"max_pax":15,"price_per_pax":1250000,"description":"Minimal 10 orang"},{"min_pax":16,"max_pax":25,"price_per_pax":1050000,"description":"Untuk grup sedang"},{"min_pax":26,"max_pax":40,"price_per_pax":850000,"description":"Untuk grup besar"}],"facilities":["Hotel bintang 3 (twin share)","Transportasi AC","Makan 3 kali sehari","Tour guide profesional","Dokumentasi","Asuransi perjalanan"],"status":"published"}	\N	\N
220	307	packages_activity_types	3d90a7bf-9826-421f-b151-89f1080c9f47	\N	\N	\N	\N
221	308	packages_activity_types	f01f768a-1758-4004-9140-78b9ed203473	\N	\N	\N	\N
652	1084	regions	530d69bc-b315-499f-a9f5-4876cd13ddcc	{"status":"published","name":"Pulau Pari","slug":"pulau-pari","description":"deskripsi pulau pari"}	{"status":"published","name":"Pulau Pari","slug":"pulau-pari","description":"deskripsi pulau pari"}	\N	\N
222	309	packages	e581ce95-939d-4d18-a35e-2a01f8aae58f	{"name":"Bali Corporate Retreat","slug":"bali-corporate-retreat","duration":"4 Hari 3 Malam","description":"Corporate retreat eksklusif di kawasan Nusa Dua Bali. Fasilitas meeting lengkap, team building di pantai, dan networking dinner yang berkesan.","itinerary":[{"day":1,"title":"Arrival & Welcome Dinner","activities":["Sambutan di bandara","Check-in resor Nusa Dua","Welcome dinner di tepi pantai","Ice breaking session"]},{"day":2,"title":"Meeting & Team Building","activities":["Sarapan","Morning meeting session","Makan siang","Team building games di pantai","Gala dinner"]},{"day":3,"title":"Outbound & Relax","activities":["Sarapan","Outbound activities","Makan siang","Free time / spa","Sunset cruise opsional"]},{"day":4,"title":"Check-out","activities":["Sarapan","Check-out","City tour Singaraja (opsional)","Transfer ke bandara"]}],"price_tiers":[{"min_pax":20,"max_pax":30,"price_per_pax":3500000,"description":"Paket standard"},{"min_pax":31,"max_pax":50,"price_per_pax":2900000,"description":"Paket medium"},{"min_pax":51,"max_pax":100,"price_per_pax":2500000,"description":"Paket besar"}],"facilities":["Resor bintang 4","Meeting room full set","Transportasi bus AC","Makan prasmanan","Dokumentasi tim","Souvenir","Asuransi"],"status":"published"}	{"name":"Bali Corporate Retreat","slug":"bali-corporate-retreat","duration":"4 Hari 3 Malam","description":"Corporate retreat eksklusif di kawasan Nusa Dua Bali. Fasilitas meeting lengkap, team building di pantai, dan networking dinner yang berkesan.","itinerary":[{"day":1,"title":"Arrival & Welcome Dinner","activities":["Sambutan di bandara","Check-in resor Nusa Dua","Welcome dinner di tepi pantai","Ice breaking session"]},{"day":2,"title":"Meeting & Team Building","activities":["Sarapan","Morning meeting session","Makan siang","Team building games di pantai","Gala dinner"]},{"day":3,"title":"Outbound & Relax","activities":["Sarapan","Outbound activities","Makan siang","Free time / spa","Sunset cruise opsional"]},{"day":4,"title":"Check-out","activities":["Sarapan","Check-out","City tour Singaraja (opsional)","Transfer ke bandara"]}],"price_tiers":[{"min_pax":20,"max_pax":30,"price_per_pax":3500000,"description":"Paket standard"},{"min_pax":31,"max_pax":50,"price_per_pax":2900000,"description":"Paket medium"},{"min_pax":51,"max_pax":100,"price_per_pax":2500000,"description":"Paket besar"}],"facilities":["Resor bintang 4","Meeting room full set","Transportasi bus AC","Makan prasmanan","Dokumentasi tim","Souvenir","Asuransi"],"status":"published"}	\N	\N
223	310	packages_activity_types	65730318-7bb2-4f19-af61-0201070b1efb	\N	\N	\N	\N
224	311	packages_activity_types	6d8e0bc2-87a9-4e4d-9ffb-1f2638799cf0	\N	\N	\N	\N
225	312	packages	886d1fea-720d-4114-88bc-bf37f137aa1e	{"name":"Yogyakarta Heritage Explorer","slug":"yogya-heritage-explorer","duration":"3 Hari 2 Malam","description":"Jelajahi keajaiban Candi Borobudur dan destinasi budaya Yogyakarta. Cocok untuk private trip dan family vacation dengan nuansa edukatif.","itinerary":[{"day":1,"title":"Arrival & Malioboro","activities":["Tiba di Yogyakarta","Check-in hotel","Makan siang gudeg","Jalan-jalan Malioboro","Malam bebas"]},{"day":2,"title":"Borobudur Sunrise","activities":["Sunrise di Candi Borobudur","Sarapan","Kunjungan Candi Mendut & Pawon","Makan siang","Keraton Yogyakarta","Ramayana ballet opsional"]},{"day":3,"title":"Goa & Pulang","activities":["Sarapan","Kunjungan Goa Jomblang","Makan siang","Belanja batik","Perjalanan pulang"]}],"price_tiers":[{"min_pax":4,"max_pax":8,"price_per_pax":1850000,"description":"Small group"},{"min_pax":9,"max_pax":15,"price_per_pax":1550000,"description":"Medium group"},{"min_pax":16,"max_pax":30,"price_per_pax":1200000,"description":"Large group"}],"facilities":["Hotel bintang 3","Transportasi + driver","Makan 3 kali sehari","Tiket masuk candi","Tour guide heritage","Dokumentasi"],"status":"published"}	{"name":"Yogyakarta Heritage Explorer","slug":"yogya-heritage-explorer","duration":"3 Hari 2 Malam","description":"Jelajahi keajaiban Candi Borobudur dan destinasi budaya Yogyakarta. Cocok untuk private trip dan family vacation dengan nuansa edukatif.","itinerary":[{"day":1,"title":"Arrival & Malioboro","activities":["Tiba di Yogyakarta","Check-in hotel","Makan siang gudeg","Jalan-jalan Malioboro","Malam bebas"]},{"day":2,"title":"Borobudur Sunrise","activities":["Sunrise di Candi Borobudur","Sarapan","Kunjungan Candi Mendut & Pawon","Makan siang","Keraton Yogyakarta","Ramayana ballet opsional"]},{"day":3,"title":"Goa & Pulang","activities":["Sarapan","Kunjungan Goa Jomblang","Makan siang","Belanja batik","Perjalanan pulang"]}],"price_tiers":[{"min_pax":4,"max_pax":8,"price_per_pax":1850000,"description":"Small group"},{"min_pax":9,"max_pax":15,"price_per_pax":1550000,"description":"Medium group"},{"min_pax":16,"max_pax":30,"price_per_pax":1200000,"description":"Large group"}],"facilities":["Hotel bintang 3","Transportasi + driver","Makan 3 kali sehari","Tiket masuk candi","Tour guide heritage","Dokumentasi"],"status":"published"}	\N	\N
226	313	packages_activity_types	c9ba4325-8f48-4884-abcd-80962031d367	\N	\N	\N	\N
227	314	packages_activity_types	c21e172b-517d-4e5e-ae80-c7c43068d0e7	\N	\N	\N	\N
244	331	settings	7	{"key":"instagram","value":"https://instagram.com/vodatour.event","description":"Akun Instagram"}	{"key":"instagram","value":"https://instagram.com/vodatour.event","description":"Akun Instagram"}	\N	\N
245	332	settings	8	{"key":"facebook","value":"https://facebook.com/vodatour.event","description":"Akun Facebook"}	{"key":"facebook","value":"https://facebook.com/vodatour.event","description":"Akun Facebook"}	\N	\N
246	333	settings	9	{"key":"youtube","value":"https://youtube.com/@vodatour.event","description":"Akun YouTube"}	{"key":"youtube","value":"https://youtube.com/@vodatour.event","description":"Akun YouTube"}	\N	\N
248	338	directus_permissions	2	{"id":2,"collection":"destinations","action":"read","permissions":{},"validation":null,"presets":null,"fields":["*"]}	{"fields":["*"]}	\N	\N
249	339	directus_permissions	3	{"id":3,"collection":"packages","action":"read","permissions":{},"validation":null,"presets":null,"fields":["*"]}	{"fields":["*"]}	\N	\N
250	340	directus_permissions	4	{"id":4,"collection":"activity_types","action":"read","permissions":{},"validation":null,"presets":null,"fields":["*"]}	{"fields":["*"]}	\N	\N
251	341	directus_permissions	5	{"id":5,"collection":"packages_activity_types","action":"read","permissions":{},"validation":null,"presets":null,"fields":["*"]}	{"fields":["*"]}	\N	\N
252	342	directus_permissions	6	{"id":6,"collection":"settings","action":"read","permissions":{},"validation":null,"presets":null,"fields":["*"]}	{"fields":["*"]}	\N	\N
228	315	packages	5d886186-397c-45bc-bd9c-d559cc1c2678	{"name":"Pulau Seribu Island Camp","slug":"pulau-seribu-island-camp","duration":"2 Hari 1 Malam","description":"Pengalaman island camping di Pulau Macan, Kepulauan Seribu. Snorkeling, kayaking, dan barbecue di tepi pantai. Cocok untuk team building seru!","itinerary":[{"day":1,"title":"Island Adventure","activities":["Berangkat dari Marina Ancol","Snorkeling di spot terbaik","Makan siang seafood","Check-in villa/apung","Kayaking & banana boat","BBQ dinner & api unggun"]},{"day":2,"title":"Relax & Pulang","activities":["Sarapan di pulau","Snorkeling lagi","Makan siang","Check-out","Kembali ke Jakarta"]}],"price_tiers":[{"min_pax":10,"max_pax":20,"price_per_pax":950000,"description":"Weekday"},{"min_pax":10,"max_pax":20,"price_per_pax":1250000,"description":"Weekend"}],"facilities":["Transportasi speedboat","Akomodasi villa apung","Makan 3 kali + BBQ","Peralatan snorkeling","Dokumentasi","Guide lokal"],"status":"published"}	{"name":"Pulau Seribu Island Camp","slug":"pulau-seribu-island-camp","duration":"2 Hari 1 Malam","description":"Pengalaman island camping di Pulau Macan, Kepulauan Seribu. Snorkeling, kayaking, dan barbecue di tepi pantai. Cocok untuk team building seru!","itinerary":[{"day":1,"title":"Island Adventure","activities":["Berangkat dari Marina Ancol","Snorkeling di spot terbaik","Makan siang seafood","Check-in villa/apung","Kayaking & banana boat","BBQ dinner & api unggun"]},{"day":2,"title":"Relax & Pulang","activities":["Sarapan di pulau","Snorkeling lagi","Makan siang","Check-out","Kembali ke Jakarta"]}],"price_tiers":[{"min_pax":10,"max_pax":20,"price_per_pax":950000,"description":"Weekday"},{"min_pax":10,"max_pax":20,"price_per_pax":1250000,"description":"Weekend"}],"facilities":["Transportasi speedboat","Akomodasi villa apung","Makan 3 kali + BBQ","Peralatan snorkeling","Dokumentasi","Guide lokal"],"status":"published"}	\N	\N
229	316	packages_activity_types	b73b8fa4-8d30-4706-8cbc-172c6d31ba59	\N	\N	\N	\N
230	317	packages_activity_types	8146b7e6-062e-433e-8b92-150743308a8f	\N	\N	\N	\N
231	318	packages	a331cb51-c5ea-42e8-a45d-9b5beed1a3db	{"name":"Lombok Sunset Bliss","slug":"lombok-sunset-bliss","duration":"4 Hari 3 Malam","description":"Nikmati keindahan Lombok dari Senggigi hingga Gili Trawangan. Pasir putih, sunset spektakuler, dan kehidupan bawah laut memukau.","itinerary":[{"day":1,"title":"Arrival Senggigi","activities":["Tiba di Lombok","Check-in hotel Senggigi","Makan siang","Santai di pantai","Sunset dinner"]},{"day":2,"title":"Gili Trawangan","activities":["Sarapan","Speedboat ke Gili T","Snorkeling & diving","Makan siang di pulau","Cycling keliling pulau","Kembali ke Senggigi"]},{"day":3,"title":"Eksplorasi Lombok","activities":["Sarapan","Kunjungan Desa Sade (Sasak)","Makan siang","Pura Lingsar","Belanja kerajinan lokal"]},{"day":4,"title":"Check-out","activities":["Sarapan","Check-out","Mataram city tour","Transfer ke bandara"]}],"price_tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":2750000,"description":"Small group"},{"min_pax":11,"max_pax":20,"price_per_pax":2250000,"description":"Medium group"},{"min_pax":21,"max_pax":35,"price_per_pax":1850000,"description":"Large group"}],"facilities":["Hotel bintang 4","Transportasi + speedboat","Makan 3 kali","Peralatan snorkeling","Tour guide","Dokumentasi"],"status":"published"}	{"name":"Lombok Sunset Bliss","slug":"lombok-sunset-bliss","duration":"4 Hari 3 Malam","description":"Nikmati keindahan Lombok dari Senggigi hingga Gili Trawangan. Pasir putih, sunset spektakuler, dan kehidupan bawah laut memukau.","itinerary":[{"day":1,"title":"Arrival Senggigi","activities":["Tiba di Lombok","Check-in hotel Senggigi","Makan siang","Santai di pantai","Sunset dinner"]},{"day":2,"title":"Gili Trawangan","activities":["Sarapan","Speedboat ke Gili T","Snorkeling & diving","Makan siang di pulau","Cycling keliling pulau","Kembali ke Senggigi"]},{"day":3,"title":"Eksplorasi Lombok","activities":["Sarapan","Kunjungan Desa Sade (Sasak)","Makan siang","Pura Lingsar","Belanja kerajinan lokal"]},{"day":4,"title":"Check-out","activities":["Sarapan","Check-out","Mataram city tour","Transfer ke bandara"]}],"price_tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":2750000,"description":"Small group"},{"min_pax":11,"max_pax":20,"price_per_pax":2250000,"description":"Medium group"},{"min_pax":21,"max_pax":35,"price_per_pax":1850000,"description":"Large group"}],"facilities":["Hotel bintang 4","Transportasi + speedboat","Makan 3 kali","Peralatan snorkeling","Tour guide","Dokumentasi"],"status":"published"}	\N	\N
232	319	packages_activity_types	e00d88ad-f798-4c3c-926a-123ae111959e	\N	\N	\N	\N
233	320	packages_activity_types	4a00b60e-6e35-4ea1-ad2e-014ef278f3b6	\N	\N	\N	\N
234	321	packages	83d9941a-0672-45e6-b319-7205bb9e24b0	{"name":"Team Building Bandung Outbound","slug":"bandung-outbound-team","duration":"2 Hari 1 Malam","description":"Program team building seru di Lembang dengan berbagai aktivitas outbound: flying fox, paintball, rafting, dan games kolaboratif.","itinerary":[{"day":1,"title":"Arrival & Outbound","activities":["Tiba di lokasi outbound","Ice breaking & team formation","Flying fox & high rope","Makan siang","Paintball tournament","Makan malam & api unggun"]},{"day":2,"title":"Rafting & Pulang","activities":["Sarapan","Rafting di sungai Citari","Makan siang","Penutupan & awarding","Perjalanan pulang"]}],"price_tiers":[{"min_pax":20,"max_pax":35,"price_per_pax":650000,"description":"Paket standard"},{"min_pax":36,"max_pax":50,"price_per_pax":550000,"description":"Paket medium"}],"facilities":["Lokasi outbound profesional","Instruktur berpengalaman","Makan 3 kali","Peralatan outbound lengkap","Dokumentasi","Sertifikat"],"status":"published"}	{"name":"Team Building Bandung Outbound","slug":"bandung-outbound-team","duration":"2 Hari 1 Malam","description":"Program team building seru di Lembang dengan berbagai aktivitas outbound: flying fox, paintball, rafting, dan games kolaboratif.","itinerary":[{"day":1,"title":"Arrival & Outbound","activities":["Tiba di lokasi outbound","Ice breaking & team formation","Flying fox & high rope","Makan siang","Paintball tournament","Makan malam & api unggun"]},{"day":2,"title":"Rafting & Pulang","activities":["Sarapan","Rafting di sungai Citari","Makan siang","Penutupan & awarding","Perjalanan pulang"]}],"price_tiers":[{"min_pax":20,"max_pax":35,"price_per_pax":650000,"description":"Paket standard"},{"min_pax":36,"max_pax":50,"price_per_pax":550000,"description":"Paket medium"}],"facilities":["Lokasi outbound profesional","Instruktur berpengalaman","Makan 3 kali","Peralatan outbound lengkap","Dokumentasi","Sertifikat"],"status":"published"}	\N	\N
235	322	packages_activity_types	4612b7ce-b23e-4aee-8602-47f5137d3b78	\N	\N	\N	\N
236	323	packages_activity_types	0bb4321b-bbca-4104-82ad-89fde8408ca4	\N	\N	\N	\N
237	324	packages_activity_types	5be26ef8-f2e9-4342-baa3-a8206ddd937a	\N	\N	\N	\N
238	325	settings	1	{"key":"site_name","value":"Voda Tour & Event","description":"Nama situs"}	{"key":"site_name","value":"Voda Tour & Event","description":"Nama situs"}	\N	\N
239	326	settings	2	{"key":"site_description","value":"Perjalanan Berkesan, Momen Tak Terlupakan — Voda Tour & Event adalah mitra perjalanan wisata, gathering, dan event organizer terpercaya di Indonesia.","description":"Deskripsi situs untuk SEO"}	{"key":"site_description","value":"Perjalanan Berkesan, Momen Tak Terlupakan — Voda Tour & Event adalah mitra perjalanan wisata, gathering, dan event organizer terpercaya di Indonesia.","description":"Deskripsi situs untuk SEO"}	\N	\N
240	327	settings	3	{"key":"wa_number","value":"6281234567890","description":"Nomor WhatsApp bisnis"}	{"key":"wa_number","value":"6281234567890","description":"Nomor WhatsApp bisnis"}	\N	\N
241	328	settings	4	{"key":"email","value":"info@vodaevent.id","description":"Email kontak"}	{"key":"email","value":"info@vodaevent.id","description":"Email kontak"}	\N	\N
242	329	settings	5	{"key":"phone","value":"(021) 1234-5678","description":"Nomor telepon kantor"}	{"key":"phone","value":"(021) 1234-5678","description":"Nomor telepon kantor"}	\N	\N
243	330	settings	6	{"key":"address","value":"Jl. Contoh No. 123, Jakarta Selatan, Indonesia","description":"Alamat kantor"}	{"key":"address","value":"Jl. Contoh No. 123, Jakarta Selatan, Indonesia","description":"Alamat kantor"}	\N	\N
253	343	directus_permissions	7	{"id":7,"collection":"searches","action":"read","permissions":{},"validation":null,"presets":null,"fields":["*"]}	{"fields":["*"]}	\N	\N
254	344	directus_fields	122	{"sort":12,"interface":"select-dropdown","options":{"choices":[{"text":"Published","value":"published"},{"text":"Draft","value":"draft"},{"text":"Archived","value":"archived"}]},"default_value":"draft","required":false,"field":"status"}	{"sort":12,"interface":"select-dropdown","options":{"choices":[{"text":"Published","value":"published"},{"text":"Draft","value":"draft"},{"text":"Archived","value":"archived"}]},"default_value":"draft","required":false,"field":"status"}	\N	\N
255	345	directus_fields	123	{"sort":5,"interface":"select-dropdown","options":{"choices":[{"text":"Published","value":"published"},{"text":"Draft","value":"draft"},{"text":"Archived","value":"archived"}]},"default_value":"draft","required":false,"field":"status"}	{"sort":5,"interface":"select-dropdown","options":{"choices":[{"text":"Published","value":"published"},{"text":"Draft","value":"draft"},{"text":"Archived","value":"archived"}]},"default_value":"draft","required":false,"field":"status"}	\N	\N
653	1086	destinations	393287c3-c166-4522-99d2-a27ab0f62dfa	{"status":"published","name":"Pulau Pari","slug":"pulau-pari","description":"pulau-pari pulau-pari pulau-pari pulau-pari"}	{"status":"published","name":"Pulau Pari","slug":"pulau-pari","description":"pulau-pari pulau-pari pulau-pari pulau-pari"}	\N	\N
256	346	packages	5d886186-397c-45bc-bd9c-d559cc1c2678	{"id":"5d886186-397c-45bc-bd9c-d559cc1c2678","name":"Pulau Seribu Island Camp","slug":"pulau-seribu-island-camp","description":"Pengalaman island camping di Pulau Macan, Kepulauan Seribu. Snorkeling, kayaking, dan barbecue di tepi pantai. Cocok untuk team building seru!","gallery":null,"duration":"2 Hari 1 Malam","itinerary":[{"day":1,"title":"Island Adventure","activities":["Berangkat dari Marina Ancol","Snorkeling di spot terbaik","Makan siang seafood","Check-in villa/apung","Kayaking & banana boat","BBQ dinner & api unggun"]},{"day":2,"title":"Relax & Pulang","activities":["Sarapan di pulau","Snorkeling lagi","Makan siang","Check-out","Kembali ke Jakarta"]}],"price_tiers":[{"min_pax":10,"max_pax":20,"price_per_pax":950000,"description":"Weekday"},{"min_pax":10,"max_pax":20,"price_per_pax":1250000,"description":"Weekend"}],"facilities":["Transportasi speedboat","Akomodasi villa apung","Makan 3 kali + BBQ","Peralatan snorkeling","Dokumentasi","Guide lokal"],"status":"published"}	{"status":"published"}	\N	\N
257	347	packages	6afe21c3-5c89-405e-ae6b-0d7cf8b19478	{"id":"6afe21c3-5c89-405e-ae6b-0d7cf8b19478","name":"Bandung Family Getaway","slug":"bandung-family-getaway","description":"Liburan keluarga seru di Lembang, Bandung. Kunjungi Farmhouse, Floating Market, dan Observatory. Nikmati udara sejuk dan kuliner khas Bandung.","gallery":null,"duration":"3 Hari 2 Malam","itinerary":[{"day":1,"title":"Perjalanan ke Bandung","activities":["Berangkat dari Jakarta pagi hari","Check-in hotel di Lembang","Makan siang di rumah makan khas Sunda","Kunjungan ke Farmhouse Lembang","Malam bebas di area hotel"]},{"day":2,"title":"Wisata Alam","activities":["Sarapan di hotel","Kunjungan ke Floating Market Lembang","Makan siang","Observatorium Bosscha","Belanja oleh-oleh di factory outlet"]},{"day":3,"title":"Pulang","activities":["Sarapan dan check-out","Mampir ke kawah putih (opsional)","Perjalanan kembali ke Jakarta"]}],"price_tiers":[{"min_pax":10,"max_pax":15,"price_per_pax":1250000,"description":"Minimal 10 orang"},{"min_pax":16,"max_pax":25,"price_per_pax":1050000,"description":"Untuk grup sedang"},{"min_pax":26,"max_pax":40,"price_per_pax":850000,"description":"Untuk grup besar"}],"facilities":["Hotel bintang 3 (twin share)","Transportasi AC","Makan 3 kali sehari","Tour guide profesional","Dokumentasi","Asuransi perjalanan"],"status":"published"}	{"status":"published"}	\N	\N
258	348	packages	83d9941a-0672-45e6-b319-7205bb9e24b0	{"id":"83d9941a-0672-45e6-b319-7205bb9e24b0","name":"Team Building Bandung Outbound","slug":"bandung-outbound-team","description":"Program team building seru di Lembang dengan berbagai aktivitas outbound: flying fox, paintball, rafting, dan games kolaboratif.","gallery":null,"duration":"2 Hari 1 Malam","itinerary":[{"day":1,"title":"Arrival & Outbound","activities":["Tiba di lokasi outbound","Ice breaking & team formation","Flying fox & high rope","Makan siang","Paintball tournament","Makan malam & api unggun"]},{"day":2,"title":"Rafting & Pulang","activities":["Sarapan","Rafting di sungai Citari","Makan siang","Penutupan & awarding","Perjalanan pulang"]}],"price_tiers":[{"min_pax":20,"max_pax":35,"price_per_pax":650000,"description":"Paket standard"},{"min_pax":36,"max_pax":50,"price_per_pax":550000,"description":"Paket medium"}],"facilities":["Lokasi outbound profesional","Instruktur berpengalaman","Makan 3 kali","Peralatan outbound lengkap","Dokumentasi","Sertifikat"],"status":"published"}	{"status":"published"}	\N	\N
259	349	packages	886d1fea-720d-4114-88bc-bf37f137aa1e	{"id":"886d1fea-720d-4114-88bc-bf37f137aa1e","name":"Yogyakarta Heritage Explorer","slug":"yogya-heritage-explorer","description":"Jelajahi keajaiban Candi Borobudur dan destinasi budaya Yogyakarta. Cocok untuk private trip dan family vacation dengan nuansa edukatif.","gallery":null,"duration":"3 Hari 2 Malam","itinerary":[{"day":1,"title":"Arrival & Malioboro","activities":["Tiba di Yogyakarta","Check-in hotel","Makan siang gudeg","Jalan-jalan Malioboro","Malam bebas"]},{"day":2,"title":"Borobudur Sunrise","activities":["Sunrise di Candi Borobudur","Sarapan","Kunjungan Candi Mendut & Pawon","Makan siang","Keraton Yogyakarta","Ramayana ballet opsional"]},{"day":3,"title":"Goa & Pulang","activities":["Sarapan","Kunjungan Goa Jomblang","Makan siang","Belanja batik","Perjalanan pulang"]}],"price_tiers":[{"min_pax":4,"max_pax":8,"price_per_pax":1850000,"description":"Small group"},{"min_pax":9,"max_pax":15,"price_per_pax":1550000,"description":"Medium group"},{"min_pax":16,"max_pax":30,"price_per_pax":1200000,"description":"Large group"}],"facilities":["Hotel bintang 3","Transportasi + driver","Makan 3 kali sehari","Tiket masuk candi","Tour guide heritage","Dokumentasi"],"status":"published"}	{"status":"published"}	\N	\N
260	350	packages	a331cb51-c5ea-42e8-a45d-9b5beed1a3db	{"id":"a331cb51-c5ea-42e8-a45d-9b5beed1a3db","name":"Lombok Sunset Bliss","slug":"lombok-sunset-bliss","description":"Nikmati keindahan Lombok dari Senggigi hingga Gili Trawangan. Pasir putih, sunset spektakuler, dan kehidupan bawah laut memukau.","gallery":null,"duration":"4 Hari 3 Malam","itinerary":[{"day":1,"title":"Arrival Senggigi","activities":["Tiba di Lombok","Check-in hotel Senggigi","Makan siang","Santai di pantai","Sunset dinner"]},{"day":2,"title":"Gili Trawangan","activities":["Sarapan","Speedboat ke Gili T","Snorkeling & diving","Makan siang di pulau","Cycling keliling pulau","Kembali ke Senggigi"]},{"day":3,"title":"Eksplorasi Lombok","activities":["Sarapan","Kunjungan Desa Sade (Sasak)","Makan siang","Pura Lingsar","Belanja kerajinan lokal"]},{"day":4,"title":"Check-out","activities":["Sarapan","Check-out","Mataram city tour","Transfer ke bandara"]}],"price_tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":2750000,"description":"Small group"},{"min_pax":11,"max_pax":20,"price_per_pax":2250000,"description":"Medium group"},{"min_pax":21,"max_pax":35,"price_per_pax":1850000,"description":"Large group"}],"facilities":["Hotel bintang 4","Transportasi + speedboat","Makan 3 kali","Peralatan snorkeling","Tour guide","Dokumentasi"],"status":"published"}	{"status":"published"}	\N	\N
278	370	searches	7	{"activity_type_name":"family-vacation","pax_count":10,"destination_name":"Yogyakarta Heritage Explorer","query":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"family-vacation","pax_count":10,"destination_name":"Yogyakarta Heritage Explorer","query":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	\N	\N
320	431	packages	5d886186-397c-45bc-bd9c-d559cc1c2678	{"id":"5d886186-397c-45bc-bd9c-d559cc1c2678","name":"Pulau Seribu Island Camp","slug":"pulau-seribu-island-camp","description":"Pengalaman island camping di Pulau Macan, Kepulauan Seribu. Snorkeling, kayaking, dan barbecue di tepi pantai. Cocok untuk team building seru!","gallery":["3e059818-0378-4270-b737-4aa3f563faac","ebcb498f-0a85-419f-b340-787ce26d4800"],"duration":"2 Hari 1 Malam","itinerary":[{"day":1,"title":"Island Adventure","activities":["Berangkat dari Marina Ancol","Snorkeling di spot terbaik","Makan siang seafood","Check-in villa/apung","Kayaking & banana boat","BBQ dinner & api unggun"]},{"day":2,"title":"Relax & Pulang","activities":["Sarapan di pulau","Snorkeling lagi","Makan siang","Check-out","Kembali ke Jakarta"]}],"price_tiers":[{"min_pax":10,"max_pax":20,"price_per_pax":950000,"description":"Weekday"},{"min_pax":10,"max_pax":20,"price_per_pax":1250000,"description":"Weekend"}],"facilities":["Transportasi speedboat","Akomodasi villa apung","Makan 3 kali + BBQ","Peralatan snorkeling","Dokumentasi","Guide lokal"],"status":"published"}	{"gallery":["3e059818-0378-4270-b737-4aa3f563faac","ebcb498f-0a85-419f-b340-787ce26d4800"]}	\N	\N
261	351	packages	e581ce95-939d-4d18-a35e-2a01f8aae58f	{"id":"e581ce95-939d-4d18-a35e-2a01f8aae58f","name":"Bali Corporate Retreat","slug":"bali-corporate-retreat","description":"Corporate retreat eksklusif di kawasan Nusa Dua Bali. Fasilitas meeting lengkap, team building di pantai, dan networking dinner yang berkesan.","gallery":null,"duration":"4 Hari 3 Malam","itinerary":[{"day":1,"title":"Arrival & Welcome Dinner","activities":["Sambutan di bandara","Check-in resor Nusa Dua","Welcome dinner di tepi pantai","Ice breaking session"]},{"day":2,"title":"Meeting & Team Building","activities":["Sarapan","Morning meeting session","Makan siang","Team building games di pantai","Gala dinner"]},{"day":3,"title":"Outbound & Relax","activities":["Sarapan","Outbound activities","Makan siang","Free time / spa","Sunset cruise opsional"]},{"day":4,"title":"Check-out","activities":["Sarapan","Check-out","City tour Singaraja (opsional)","Transfer ke bandara"]}],"price_tiers":[{"min_pax":20,"max_pax":30,"price_per_pax":3500000,"description":"Paket standard"},{"min_pax":31,"max_pax":50,"price_per_pax":2900000,"description":"Paket medium"},{"min_pax":51,"max_pax":100,"price_per_pax":2500000,"description":"Paket besar"}],"facilities":["Resor bintang 4","Meeting room full set","Transportasi bus AC","Makan prasmanan","Dokumentasi tim","Souvenir","Asuransi"],"status":"published"}	{"status":"published"}	\N	\N
262	352	activity_types	07885ce8-eeef-4d96-8bc6-799199bfb187	{"id":"07885ce8-eeef-4d96-8bc6-799199bfb187","name":"Team Building","slug":"team-building","description":"Program seru untuk memperkuat kerjasama tim, kepemimpinan, dan komunikasi antar karyawan.","status":"published"}	{"status":"published"}	\N	\N
263	353	activity_types	2592b822-c30b-4d26-92fd-a0f806a8c51e	{"id":"2592b822-c30b-4d26-92fd-a0f806a8c51e","name":"Private Trip","slug":"private-trip","description":"Perjalanan pribadi untuk individu, pasangan, atau kelompok kecil dengan itinerary fleksibel.","status":"published"}	{"status":"published"}	\N	\N
264	354	activity_types	49a970e3-a0a8-40be-890a-df45f8867f0b	{"id":"49a970e3-a0a8-40be-890a-df45f8867f0b","name":"Family Vacation","slug":"family-vacation","description":"Liburan keluarga dengan aktivitas ramah anak dan orang tua. Momen kebersamaan yang berharga.","status":"published"}	{"status":"published"}	\N	\N
265	355	activity_types	4cc0b3a2-0c22-4506-a639-76a294c66e06	{"id":"4cc0b3a2-0c22-4506-a639-76a294c66e06","name":"Outbound","slug":"outbound","description":"Aktivitas outdoor menantang untuk kelompok: flying fox, rafting, paintball, dan games seru.","status":"published"}	{"status":"published"}	\N	\N
266	356	activity_types	bad6232c-9f00-41a8-a699-535245ec3e13	{"id":"bad6232c-9f00-41a8-a699-535245ec3e13","name":"Corporate Gathering","slug":"corporate-gathering","description":"Acara perusahaan, gathering tahunan, outing, dan perayaan kantor dengan konsep terpadu.","status":"published"}	{"status":"published"}	\N	\N
267	358	directus_files	535393f3-444f-4c68-8c6b-5fbbbd55624d	{"storage":"local","title":"Alfiano Sutianto Ex Fd O Wk Yb Qw Unsplash","filename_download":"alfiano-sutianto-exFdOWkYBQw-unsplash.jpg","type":"image/jpeg"}	{"storage":"local","title":"Alfiano Sutianto Ex Fd O Wk Yb Qw Unsplash","filename_download":"alfiano-sutianto-exFdOWkYBQw-unsplash.jpg","type":"image/jpeg"}	\N	\N
268	359	regions	863d7681-4753-4694-a4e3-97f7a643000f	{"id":"863d7681-4753-4694-a4e3-97f7a643000f","status":"published","date_created":"2026-07-13T02:26:47.377Z","date_updated":"2026-07-13T03:28:48.537Z","name":"Bali","slug":"bali","description":"Pulau Dewata dengan pantai eksotis, budaya kaya, dan resor mewah. Cocok untuk private trip dan corporate event."}	{"image":"535393f3-444f-4c68-8c6b-5fbbbd55624d","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-13T03:28:48.537Z"}	\N	\N
269	360	directus_files	755848b6-cb80-490d-a0e6-9be9c70f658b	{"storage":"local","title":"Harry Kessell E E2tr Mn 6a0 Unsplash","filename_download":"harry-kessell-eE2trMn-6a0-unsplash.jpg","type":"image/jpeg"}	{"storage":"local","title":"Harry Kessell E E2tr Mn 6a0 Unsplash","filename_download":"harry-kessell-eE2trMn-6a0-unsplash.jpg","type":"image/jpeg"}	\N	\N
270	361	packages	e581ce95-939d-4d18-a35e-2a01f8aae58f	{"id":"e581ce95-939d-4d18-a35e-2a01f8aae58f","name":"Bali Corporate Retreat","slug":"bali-corporate-retreat","description":"Corporate retreat eksklusif di kawasan Nusa Dua Bali. Fasilitas meeting lengkap, team building di pantai, dan networking dinner yang berkesan.","gallery":null,"duration":"4 Hari 3 Malam","itinerary":[{"day":1,"title":"Arrival & Welcome Dinner","activities":["Sambutan di bandara","Check-in resor Nusa Dua","Welcome dinner di tepi pantai","Ice breaking session"]},{"day":2,"title":"Meeting & Team Building","activities":["Sarapan","Morning meeting session","Makan siang","Team building games di pantai","Gala dinner"]},{"day":3,"title":"Outbound & Relax","activities":["Sarapan","Outbound activities","Makan siang","Free time / spa","Sunset cruise opsional"]},{"day":4,"title":"Check-out","activities":["Sarapan","Check-out","City tour Singaraja (opsional)","Transfer ke bandara"]}],"price_tiers":[{"min_pax":20,"max_pax":30,"price_per_pax":3500000,"description":"Paket standard"},{"min_pax":31,"max_pax":50,"price_per_pax":2900000,"description":"Paket medium"},{"min_pax":51,"max_pax":100,"price_per_pax":2500000,"description":"Paket besar"}],"facilities":["Resor bintang 4","Meeting room full set","Transportasi bus AC","Makan prasmanan","Dokumentasi tim","Souvenir","Asuransi"],"status":"published"}	{"image":"755848b6-cb80-490d-a0e6-9be9c70f658b"}	\N	\N
271	363	directus_permissions	9	{"collection":"directus_files","action":"read","permissions":{},"fields":["*"]}	{"collection":"directus_files","action":"read","permissions":{},"fields":["*"]}	\N	\N
272	364	searches	1	{"activity_type_name":"outbound","pax_count":10,"travel_date":"2026-07-18","destination_name":"Yogyakarta Heritage Explorer","query":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"outbound","pax_count":10,"travel_date":"2026-07-18","destination_name":"Yogyakarta Heritage Explorer","query":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	\N	\N
273	365	searches	2	{"destination_name":"Team Building Bandung Outbound","query":"Team Building Bandung Outbound","ip_hash":"vmritrtl14oew"}	{"destination_name":"Team Building Bandung Outbound","query":"Team Building Bandung Outbound","ip_hash":"vmritrtl14oew"}	\N	\N
274	366	searches	3	{"ip_hash":"vmritrtl14oew"}	{"ip_hash":"vmritrtl14oew"}	\N	\N
275	367	searches	4	{"destination_name":"Tangkuban Perahu","query":"Tangkuban Perahu","ip_hash":"vmritrtl14oew"}	{"destination_name":"Tangkuban Perahu","query":"Tangkuban Perahu","ip_hash":"vmritrtl14oew"}	\N	\N
276	368	searches	5	{"activity_type_name":"family-vacation","pax_count":10,"travel_date":"2026-07-07","destination_name":"Yogyakarta Heritage Explorer","query":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"family-vacation","pax_count":10,"travel_date":"2026-07-07","destination_name":"Yogyakarta Heritage Explorer","query":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	\N	\N
277	369	searches	6	{"activity_type_name":"family-vacation","pax_count":10,"destination_name":"Yogyakarta Heritage Explorer","query":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"family-vacation","pax_count":10,"destination_name":"Yogyakarta Heritage Explorer","query":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	\N	\N
279	371	searches	8	{"activity_type_name":"family-vacation","pax_count":10,"travel_date":"2026-07-07","destination_name":"Yogyakarta Heritage Explorer","query":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"family-vacation","pax_count":10,"travel_date":"2026-07-07","destination_name":"Yogyakarta Heritage Explorer","query":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	\N	\N
280	380	searches	9	{"activity_type_name":"outbound","pax_count":5,"travel_date":"2026-07-08","destination_name":"Tangkuban Perahu","query":"Tangkuban Perahu","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"outbound","pax_count":5,"travel_date":"2026-07-08","destination_name":"Tangkuban Perahu","query":"Tangkuban Perahu","ip_hash":"vmritrtl14oew"}	\N	\N
281	381	searches	10	{"activity_type_name":"family-vacation","pax_count":5,"travel_date":"2026-07-23","destination_name":"Team Building Bandung Outbound","query":"Team Building Bandung Outbound","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"family-vacation","pax_count":5,"travel_date":"2026-07-23","destination_name":"Team Building Bandung Outbound","query":"Team Building Bandung Outbound","ip_hash":"vmritrtl14oew"}	\N	\N
282	382	searches	11	{"activity_type_name":"outbound","pax_count":5,"travel_date":"2026-07-14","query":"Bandung Family Getaway","destination_name":"Bandung Family Getaway","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"outbound","pax_count":5,"travel_date":"2026-07-14","query":"Bandung Family Getaway","destination_name":"Bandung Family Getaway","ip_hash":"vmritrtl14oew"}	\N	\N
283	383	searches	12	{"activity_type_name":"outbound","pax_count":5,"query":"Bandung Family Getaway","destination_name":"Bandung Family Getaway","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"outbound","pax_count":5,"query":"Bandung Family Getaway","destination_name":"Bandung Family Getaway","ip_hash":"vmritrtl14oew"}	\N	\N
284	384	searches	13	{"activity_type_name":"outbound","pax_count":5,"travel_date":"2026-07-17","query":"Bandung Family Getaway","destination_name":"Bandung Family Getaway","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"outbound","pax_count":5,"travel_date":"2026-07-17","query":"Bandung Family Getaway","destination_name":"Bandung Family Getaway","ip_hash":"vmritrtl14oew"}	\N	\N
285	385	searches	14	{"activity_type_name":"family-vacation","pax_count":5,"travel_date":"2026-07-07","query":"Team Building Bandung Outbound","destination_name":"Team Building Bandung Outbound","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"family-vacation","pax_count":5,"travel_date":"2026-07-07","query":"Team Building Bandung Outbound","destination_name":"Team Building Bandung Outbound","ip_hash":"vmritrtl14oew"}	\N	\N
286	386	searches	15	{"activity_type_name":"family-vacation","pax_count":5,"query":"Team Building Bandung Outbound","destination_name":"Team Building Bandung Outbound","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"family-vacation","pax_count":5,"query":"Team Building Bandung Outbound","destination_name":"Team Building Bandung Outbound","ip_hash":"vmritrtl14oew"}	\N	\N
287	387	searches	16	{"pax_count":5,"travel_date":"2026-07-07","query":"Bandung Family Getaway","destination_name":"Bandung Family Getaway","ip_hash":"vmritrtl14oew"}	{"pax_count":5,"travel_date":"2026-07-07","query":"Bandung Family Getaway","destination_name":"Bandung Family Getaway","ip_hash":"vmritrtl14oew"}	\N	\N
288	388	searches	17	{"pax_count":1,"travel_date":"2026-07-15","query":"Yogyakarta Heritage Explorer","destination_name":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	{"pax_count":1,"travel_date":"2026-07-15","query":"Yogyakarta Heritage Explorer","destination_name":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	\N	\N
289	389	searches	18	{"query":"Yogyakarta Heritage Explorer","destination_name":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	{"query":"Yogyakarta Heritage Explorer","destination_name":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	\N	\N
290	390	searches	19	{"activity_type_name":"outbound","query":"Yogyakarta Heritage Explorer","destination_name":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"outbound","query":"Yogyakarta Heritage Explorer","destination_name":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	\N	\N
291	391	searches	20	{"query":"Yogyakarta Heritage Explorer","destination_name":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	{"query":"Yogyakarta Heritage Explorer","destination_name":"Yogyakarta Heritage Explorer","ip_hash":"vmritrtl14oew"}	\N	\N
292	392	searches	21	{"activity_type_name":"team-building","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"team-building","ip_hash":"vmritrtl14oew"}	\N	\N
293	393	searches	22	{"activity_type_name":"team-building","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"team-building","ip_hash":"vmritrtl14oew"}	\N	\N
294	394	searches	23	{"ip_hash":"vmritrtl14oew"}	{"ip_hash":"vmritrtl14oew"}	\N	\N
295	395	searches	24	{"activity_type_name":"corporate-gathering","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"corporate-gathering","ip_hash":"vmritrtl14oew"}	\N	\N
296	396	searches	25	{"activity_type_name":"family-vacation","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"family-vacation","ip_hash":"vmritrtl14oew"}	\N	\N
297	397	searches	26	{"activity_type_name":"outbound","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"outbound","ip_hash":"vmritrtl14oew"}	\N	\N
298	398	searches	27	{"activity_type_name":"outbound","query":"bandung","destination_name":"bandung","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"outbound","query":"bandung","destination_name":"bandung","ip_hash":"vmritrtl14oew"}	\N	\N
299	399	searches	28	{"query":"bandung","destination_name":"bandung","ip_hash":"vmritrtl14oew"}	{"query":"bandung","destination_name":"bandung","ip_hash":"vmritrtl14oew"}	\N	\N
300	400	searches	29	{"activity_type_name":"team-building","query":"bandung","destination_name":"bandung","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"team-building","query":"bandung","destination_name":"bandung","ip_hash":"vmritrtl14oew"}	\N	\N
301	403	directus_fields	110	{"id":110,"field":"gallery","special":["cast-json"],"interface":"files","options":{"accept":"image/*"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":"Foto-foto paket (upload langsung dari sini)","conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"gallery","special":["cast-json"],"interface":"files","options":{"accept":"image/*"},"note":"Foto-foto paket (upload langsung dari sini)"}	\N	\N
302	404	directus_fields	71	{"id":71,"field":"image","special":["file"],"interface":"file-image","options":{"accept":"image/*"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":"Foto utama destinasi","conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"image","special":["file"],"interface":"file-image","options":{"accept":"image/*"},"note":"Foto utama destinasi"}	\N	\N
303	406	directus_fields	110	{"id":110,"field":"gallery","special":["json","files"],"interface":"files","options":{"accept":"image/*"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":"Foto-foto paket (upload langsung dari sini)","conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"gallery","special":["json","files"],"interface":"files","options":{"accept":"image/*"}}	\N	\N
304	409	directus_fields	110	{"id":110,"field":"gallery","special":["json"],"interface":"list","options":{"template":"{{uuid}}","fields":{"uuid":{"interface":"input","placeholder":"Upload file dulu → paste UUID"}}},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":"Upload gambar via Content > Files, lalu paste UUID di sini","conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"gallery","special":["json"],"interface":"list","options":{"template":"{{uuid}}","fields":{"uuid":{"interface":"input","placeholder":"Upload file dulu → paste UUID"}}},"note":"Upload gambar via Content > Files, lalu paste UUID di sini"}	\N	\N
305	411	directus_fields	110	{"id":110,"field":"gallery","special":["json"],"interface":"list","options":{"placeholder":"Paste file UUID..."},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":"Upload via Files (menu kiri) → copy UUID → paste di sini","conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"gallery","special":["json"],"interface":"list","options":{"placeholder":"Paste file UUID..."},"note":"Upload via Files (menu kiri) → copy UUID → paste di sini"}	\N	\N
306	413	directus_fields	110	{"id":110,"field":"gallery","special":["cast-json"],"interface":"json","options":{},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":"📸 Upload dulu via menu Files (kiri) → copy UUID → paste array:\\n[\\"uuid-gambar-1\\", \\"uuid-gambar-2\\"]","conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"gallery","special":["cast-json"],"interface":"json","options":{},"note":"📸 Upload dulu via menu Files (kiri) → copy UUID → paste array:\\n[\\"uuid-gambar-1\\", \\"uuid-gambar-2\\"]"}	\N	\N
307	414	directus_files	fd07dd90-9805-445b-bee9-9bdb1ca6f4c7	{"storage":"local","title":"Photo 1543964198 D54e4f0e44e3","filename_download":"photo-1543964198-d54e4f0e44e3.avif","type":"image/avif"}	{"storage":"local","title":"Photo 1543964198 D54e4f0e44e3","filename_download":"photo-1543964198-d54e4f0e44e3.avif","type":"image/avif"}	\N	\N
308	415	directus_files	534fc352-5e04-4f09-9af3-7ca9643fd5bd	{"storage":"local","title":"Photo 1478827387698 1527781a4887","filename_download":"photo-1478827387698-1527781a4887.avif","type":"image/avif"}	{"storage":"local","title":"Photo 1478827387698 1527781a4887","filename_download":"photo-1478827387698-1527781a4887.avif","type":"image/avif"}	\N	\N
309	416	directus_files	eb9b84b6-4cb2-4d2a-8896-45a2df9d57c2	{"storage":"local","title":"Photo 1448375240586 882707db888b","filename_download":"photo-1448375240586-882707db888b.avif","type":"image/avif"}	{"storage":"local","title":"Photo 1448375240586 882707db888b","filename_download":"photo-1448375240586-882707db888b.avif","type":"image/avif"}	\N	\N
310	417	directus_files	51524283-d867-4686-977c-7d4001d788b8	{"storage":"local","title":"Premium Photo 1676218966210 298056b2b978","filename_download":"premium_photo-1676218966210-298056b2b978.avif","type":"image/avif"}	{"storage":"local","title":"Premium Photo 1676218966210 298056b2b978","filename_download":"premium_photo-1676218966210-298056b2b978.avif","type":"image/avif"}	\N	\N
311	418	directus_files	794bfde6-a082-4ea6-8cfc-438e14ddb651	{"storage":"local","title":"Simon a Zjw7x I3 Qaa Unsplash","filename_download":"simon-aZjw7xI3QAA-unsplash.jpg","type":"image/jpeg"}	{"storage":"local","title":"Simon a Zjw7x I3 Qaa Unsplash","filename_download":"simon-aZjw7xI3QAA-unsplash.jpg","type":"image/jpeg"}	\N	\N
312	419	directus_files	bcfdac07-ed2f-48a8-a1aa-25dd9df45b2d	{"storage":"local","title":"Harry Kessell E E2tr Mn 6a0 Unsplash","filename_download":"harry-kessell-eE2trMn-6a0-unsplash.jpg","type":"image/jpeg"}	{"storage":"local","title":"Harry Kessell E E2tr Mn 6a0 Unsplash","filename_download":"harry-kessell-eE2trMn-6a0-unsplash.jpg","type":"image/jpeg"}	\N	\N
313	420	directus_files	d198bd7d-ff2f-46bd-be0a-8032857dacea	{"storage":"local","title":"Alfiano Sutianto Ex Fd O Wk Yb Qw Unsplash","filename_download":"alfiano-sutianto-exFdOWkYBQw-unsplash.jpg","type":"image/jpeg"}	{"storage":"local","title":"Alfiano Sutianto Ex Fd O Wk Yb Qw Unsplash","filename_download":"alfiano-sutianto-exFdOWkYBQw-unsplash.jpg","type":"image/jpeg"}	\N	\N
314	421	directus_files	31639889-3b56-4b07-b37f-0bd0951dbfbf	{"storage":"local","title":"Photo 1418065460487 3e41a6c84dc5","filename_download":"photo-1418065460487-3e41a6c84dc5.avif","type":"image/avif"}	{"storage":"local","title":"Photo 1418065460487 3e41a6c84dc5","filename_download":"photo-1418065460487-3e41a6c84dc5.avif","type":"image/avif"}	\N	\N
315	422	directus_files	b4369210-3088-40bb-8506-bb8049e14bb5	{"storage":"local","title":"Photo 1462651567147 Aa679fd1cfaf","filename_download":"photo-1462651567147-aa679fd1cfaf.avif","type":"image/avif"}	{"storage":"local","title":"Photo 1462651567147 Aa679fd1cfaf","filename_download":"photo-1462651567147-aa679fd1cfaf.avif","type":"image/avif"}	\N	\N
316	423	directus_files	3e059818-0378-4270-b737-4aa3f563faac	{"storage":"local","title":"Photo 1468413253725 0d5181091126","filename_download":"photo-1468413253725-0d5181091126.avif","type":"image/avif"}	{"storage":"local","title":"Photo 1468413253725 0d5181091126","filename_download":"photo-1468413253725-0d5181091126.avif","type":"image/avif"}	\N	\N
317	424	directus_files	48652f44-6b17-4d85-b4db-475f539626b0	{"storage":"local","title":"B Ovf94d P Rx Wu0u3 Qs Pj F Tree","filename_download":"bOvf94dPRxWu0u3QsPjF_tree.avif","type":"image/avif"}	{"storage":"local","title":"B Ovf94d P Rx Wu0u3 Qs Pj F Tree","filename_download":"bOvf94dPRxWu0u3QsPjF_tree.avif","type":"image/avif"}	\N	\N
318	425	directus_files	088c8736-3301-4a7f-b0d8-84434409638c	{"storage":"local","title":"Photo 1498550744921 75f79806b8a7","filename_download":"photo-1498550744921-75f79806b8a7.avif","type":"image/avif"}	{"storage":"local","title":"Photo 1498550744921 75f79806b8a7","filename_download":"photo-1498550744921-75f79806b8a7.avif","type":"image/avif"}	\N	\N
319	426	directus_files	ebcb498f-0a85-419f-b340-787ce26d4800	{"storage":"local","title":"Photo 1500622944204 B135684e99fd","filename_download":"photo-1500622944204-b135684e99fd.avif","type":"image/avif"}	{"storage":"local","title":"Photo 1500622944204 B135684e99fd","filename_download":"photo-1500622944204-b135684e99fd.avif","type":"image/avif"}	\N	\N
348	530	regions	7607935a-feaa-4a17-a49e-381b0e03ecc1	{"name":"Bandung & Sekitarnya (Lembang, Ciwidey)","slug":"bandung-sekitarnya-lembang-ciwidey","status":"published"}	{"name":"Bandung & Sekitarnya (Lembang, Ciwidey)","slug":"bandung-sekitarnya-lembang-ciwidey","status":"published"}	\N	\N
321	432	packages	6afe21c3-5c89-405e-ae6b-0d7cf8b19478	{"id":"6afe21c3-5c89-405e-ae6b-0d7cf8b19478","name":"Bandung Family Getaway","slug":"bandung-family-getaway","description":"Liburan keluarga seru di Lembang, Bandung. Kunjungi Farmhouse, Floating Market, dan Observatory. Nikmati udara sejuk dan kuliner khas Bandung.","gallery":["fd07dd90-9805-445b-bee9-9bdb1ca6f4c7","534fc352-5e04-4f09-9af3-7ca9643fd5bd"],"duration":"3 Hari 2 Malam","itinerary":[{"day":1,"title":"Perjalanan ke Bandung","activities":["Berangkat dari Jakarta pagi hari","Check-in hotel di Lembang","Makan siang di rumah makan khas Sunda","Kunjungan ke Farmhouse Lembang","Malam bebas di area hotel"]},{"day":2,"title":"Wisata Alam","activities":["Sarapan di hotel","Kunjungan ke Floating Market Lembang","Makan siang","Observatorium Bosscha","Belanja oleh-oleh di factory outlet"]},{"day":3,"title":"Pulang","activities":["Sarapan dan check-out","Mampir ke kawah putih (opsional)","Perjalanan kembali ke Jakarta"]}],"price_tiers":[{"min_pax":10,"max_pax":15,"price_per_pax":1250000,"description":"Minimal 10 orang"},{"min_pax":16,"max_pax":25,"price_per_pax":1050000,"description":"Untuk grup sedang"},{"min_pax":26,"max_pax":40,"price_per_pax":850000,"description":"Untuk grup besar"}],"facilities":["Hotel bintang 3 (twin share)","Transportasi AC","Makan 3 kali sehari","Tour guide profesional","Dokumentasi","Asuransi perjalanan"],"status":"published"}	{"gallery":["fd07dd90-9805-445b-bee9-9bdb1ca6f4c7","534fc352-5e04-4f09-9af3-7ca9643fd5bd"]}	\N	\N
322	433	packages	83d9941a-0672-45e6-b319-7205bb9e24b0	{"id":"83d9941a-0672-45e6-b319-7205bb9e24b0","name":"Team Building Bandung Outbound","slug":"bandung-outbound-team","description":"Program team building seru di Lembang dengan berbagai aktivitas outbound: flying fox, paintball, rafting, dan games kolaboratif.","gallery":["088c8736-3301-4a7f-b0d8-84434409638c"],"duration":"2 Hari 1 Malam","itinerary":[{"day":1,"title":"Arrival & Outbound","activities":["Tiba di lokasi outbound","Ice breaking & team formation","Flying fox & high rope","Makan siang","Paintball tournament","Makan malam & api unggun"]},{"day":2,"title":"Rafting & Pulang","activities":["Sarapan","Rafting di sungai Citari","Makan siang","Penutupan & awarding","Perjalanan pulang"]}],"price_tiers":[{"min_pax":20,"max_pax":35,"price_per_pax":650000,"description":"Paket standard"},{"min_pax":36,"max_pax":50,"price_per_pax":550000,"description":"Paket medium"}],"facilities":["Lokasi outbound profesional","Instruktur berpengalaman","Makan 3 kali","Peralatan outbound lengkap","Dokumentasi","Sertifikat"],"status":"published"}	{"gallery":["088c8736-3301-4a7f-b0d8-84434409638c"]}	\N	\N
323	434	packages	886d1fea-720d-4114-88bc-bf37f137aa1e	{"id":"886d1fea-720d-4114-88bc-bf37f137aa1e","name":"Yogyakarta Heritage Explorer","slug":"yogya-heritage-explorer","description":"Jelajahi keajaiban Candi Borobudur dan destinasi budaya Yogyakarta. Cocok untuk private trip dan family vacation dengan nuansa edukatif.","gallery":["755848b6-cb80-490d-a0e6-9be9c70f658b"],"duration":"3 Hari 2 Malam","itinerary":[{"day":1,"title":"Arrival & Malioboro","activities":["Tiba di Yogyakarta","Check-in hotel","Makan siang gudeg","Jalan-jalan Malioboro","Malam bebas"]},{"day":2,"title":"Borobudur Sunrise","activities":["Sunrise di Candi Borobudur","Sarapan","Kunjungan Candi Mendut & Pawon","Makan siang","Keraton Yogyakarta","Ramayana ballet opsional"]},{"day":3,"title":"Goa & Pulang","activities":["Sarapan","Kunjungan Goa Jomblang","Makan siang","Belanja batik","Perjalanan pulang"]}],"price_tiers":[{"min_pax":4,"max_pax":8,"price_per_pax":1850000,"description":"Small group"},{"min_pax":9,"max_pax":15,"price_per_pax":1550000,"description":"Medium group"},{"min_pax":16,"max_pax":30,"price_per_pax":1200000,"description":"Large group"}],"facilities":["Hotel bintang 3","Transportasi + driver","Makan 3 kali sehari","Tiket masuk candi","Tour guide heritage","Dokumentasi"],"status":"published"}	{"gallery":["755848b6-cb80-490d-a0e6-9be9c70f658b"]}	\N	\N
324	435	packages	a331cb51-c5ea-42e8-a45d-9b5beed1a3db	{"id":"a331cb51-c5ea-42e8-a45d-9b5beed1a3db","name":"Lombok Sunset Bliss","slug":"lombok-sunset-bliss","description":"Nikmati keindahan Lombok dari Senggigi hingga Gili Trawangan. Pasir putih, sunset spektakuler, dan kehidupan bawah laut memukau.","gallery":["eb9b84b6-4cb2-4d2a-8896-45a2df9d57c2"],"duration":"4 Hari 3 Malam","itinerary":[{"day":1,"title":"Arrival Senggigi","activities":["Tiba di Lombok","Check-in hotel Senggigi","Makan siang","Santai di pantai","Sunset dinner"]},{"day":2,"title":"Gili Trawangan","activities":["Sarapan","Speedboat ke Gili T","Snorkeling & diving","Makan siang di pulau","Cycling keliling pulau","Kembali ke Senggigi"]},{"day":3,"title":"Eksplorasi Lombok","activities":["Sarapan","Kunjungan Desa Sade (Sasak)","Makan siang","Pura Lingsar","Belanja kerajinan lokal"]},{"day":4,"title":"Check-out","activities":["Sarapan","Check-out","Mataram city tour","Transfer ke bandara"]}],"price_tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":2750000,"description":"Small group"},{"min_pax":11,"max_pax":20,"price_per_pax":2250000,"description":"Medium group"},{"min_pax":21,"max_pax":35,"price_per_pax":1850000,"description":"Large group"}],"facilities":["Hotel bintang 4","Transportasi + speedboat","Makan 3 kali","Peralatan snorkeling","Tour guide","Dokumentasi"],"status":"published"}	{"gallery":["eb9b84b6-4cb2-4d2a-8896-45a2df9d57c2"]}	\N	\N
349	531	regions	4dad15db-1ad3-4bae-8304-1274800a84c4	{"name":"Kepulauan Seribu (Pulau Tidung, Pulau Pari, Pulau Payung)","slug":"kepulauan-seribu-pulau-tidung-pulau-pari-pulau-payung","status":"published"}	{"name":"Kepulauan Seribu (Pulau Tidung, Pulau Pari, Pulau Payung)","slug":"kepulauan-seribu-pulau-tidung-pulau-pari-pulau-payung","status":"published"}	\N	\N
350	532	regions	75359e6a-68ec-4057-b461-33114ec4b0e5	{"name":"Yogyakarta - Candi Borobudur & Prambanan","slug":"yogyakarta-candi-borobudur-prambanan","status":"published"}	{"name":"Yogyakarta - Candi Borobudur & Prambanan","slug":"yogyakarta-candi-borobudur-prambanan","status":"published"}	\N	\N
351	533	regions	b28b63cc-fdcf-4cf0-a422-6222a2af6d09	{"name":"Bali","slug":"bali","status":"published"}	{"name":"Bali","slug":"bali","status":"published"}	\N	\N
352	534	destinations	5e1e009e-724d-4199-a06b-06e7f15fcd6f	{"name":"Tangkuban Perahu","slug":"tangkuban-perahu","status":"published"}	{"name":"Tangkuban Perahu","slug":"tangkuban-perahu","status":"published"}	\N	\N
654	1087	packages	6d63b96b-d000-4d17-a7db-4969bd8983ec	{"name":"Paket 1 Hari Pulau Pari","slug":"paket-pulau-pari-1","description":"Paket 1 Hari Pulau Pari Paket 1 Hari Pulau Pari Paket 1 Hari Pulau Pari Paket 1 Hari Pulau Pari","duration":"1 Hari","itinerary":[{"day":1,"title":"Hari pertama bermain","activities":["07.00 - 09.00 : Kumpul"]}],"facilities":["Perahu","Makan Siang","Kudapan"],"price_tiers":[{"min_pax":1,"max_pax":5,"price_per_pax":900000},{"min_pax":6,"max_pax":10,"price_per_pax":500000}],"status":"published"}	{"name":"Paket 1 Hari Pulau Pari","slug":"paket-pulau-pari-1","description":"Paket 1 Hari Pulau Pari Paket 1 Hari Pulau Pari Paket 1 Hari Pulau Pari Paket 1 Hari Pulau Pari","duration":"1 Hari","itinerary":[{"day":1,"title":"Hari pertama bermain","activities":["07.00 - 09.00 : Kumpul"]}],"facilities":["Perahu","Makan Siang","Kudapan"],"price_tiers":[{"min_pax":1,"max_pax":5,"price_per_pax":900000},{"min_pax":6,"max_pax":10,"price_per_pax":500000}],"status":"published"}	\N	\N
325	436	packages	e581ce95-939d-4d18-a35e-2a01f8aae58f	{"id":"e581ce95-939d-4d18-a35e-2a01f8aae58f","name":"Bali Corporate Retreat","slug":"bali-corporate-retreat","description":"Corporate retreat eksklusif di kawasan Nusa Dua Bali. Fasilitas meeting lengkap, team building di pantai, dan networking dinner yang berkesan.","gallery":["bcfdac07-ed2f-48a8-a1aa-25dd9df45b2d"],"duration":"4 Hari 3 Malam","itinerary":[{"day":1,"title":"Arrival & Welcome Dinner","activities":["Sambutan di bandara","Check-in resor Nusa Dua","Welcome dinner di tepi pantai","Ice breaking session"]},{"day":2,"title":"Meeting & Team Building","activities":["Sarapan","Morning meeting session","Makan siang","Team building games di pantai","Gala dinner"]},{"day":3,"title":"Outbound & Relax","activities":["Sarapan","Outbound activities","Makan siang","Free time / spa","Sunset cruise opsional"]},{"day":4,"title":"Check-out","activities":["Sarapan","Check-out","City tour Singaraja (opsional)","Transfer ke bandara"]}],"price_tiers":[{"min_pax":20,"max_pax":30,"price_per_pax":3500000,"description":"Paket standard"},{"min_pax":31,"max_pax":50,"price_per_pax":2900000,"description":"Paket medium"},{"min_pax":51,"max_pax":100,"price_per_pax":2500000,"description":"Paket besar"}],"facilities":["Resor bintang 4","Meeting room full set","Transportasi bus AC","Makan prasmanan","Dokumentasi tim","Souvenir","Asuransi"],"status":"published"}	{"gallery":["bcfdac07-ed2f-48a8-a1aa-25dd9df45b2d"]}	\N	\N
326	437	destinations	09e35c4a-2012-467c-b5a2-e49e29cd2f22	{"id":"09e35c4a-2012-467c-b5a2-e49e29cd2f22","status":"published","date_created":"2026-07-13T02:26:48.334Z","date_updated":"2026-07-13T08:54:29.166Z","name":"Pulau Pari","slug":"pulau-pari","description":"Pulau dengan pasir putih, laguna biru, dan spot snorkeling terbaik. Cocok untuk budget trip dan gathering santai.","gallery":null}	{"image":"51524283-d867-4686-977c-7d4001d788b8","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-13T08:54:29.166Z"}	\N	\N
327	438	destinations	14ee958e-d602-41fd-93dc-2e125ca45719	{"id":"14ee958e-d602-41fd-93dc-2e125ca45719","status":"published","date_created":"2026-07-13T02:26:48.242Z","date_updated":"2026-07-13T08:54:29.180Z","name":"Pantai Parangtritis","slug":"parangtritis","description":"Pantai selatan yang legendaris dengan pasir hitam, gumuk pasir, dan sunset memukau. Cocok untuk outbound dan gathering.","gallery":null}	{"image":"535393f3-444f-4c68-8c6b-5fbbbd55624d","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-13T08:54:29.180Z"}	\N	\N
328	439	destinations	18e279f9-4aa0-4de4-a486-e815af63eb23	{"id":"18e279f9-4aa0-4de4-a486-e815af63eb23","status":"published","date_created":"2026-07-13T02:26:48.073Z","date_updated":"2026-07-13T08:54:29.193Z","name":"Tangkuban Perahu","slug":"tangkuban-perahu","description":"Gunung api aktif dengan kawah raksasa yang bisa dikunjungi. Legenda Sangkuriang melekat erat dengan destinasi ikonik ini.","gallery":null}	{"image":"d198bd7d-ff2f-46bd-be0a-8032857dacea","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-13T08:54:29.193Z"}	\N	\N
329	440	destinations	2c0e6233-0a08-44f9-b0dc-3b55c28479e1	{"id":"2c0e6233-0a08-44f9-b0dc-3b55c28479e1","status":"published","date_created":"2026-07-13T02:26:48.009Z","date_updated":"2026-07-13T08:54:29.207Z","name":"Lembang","slug":"lembang","description":"Kawasan wisata pegunungan di utara Bandung dengan udaranya yang sejuk, perkebunan stroberi, dan berbagai destinasi foto instagramable. Cocok untuk family gathering dan outbound.","gallery":null}	{"image":"48652f44-6b17-4d85-b4db-475f539626b0","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-13T08:54:29.207Z"}	\N	\N
330	441	destinations	539e7cd6-32a0-4c42-91d9-05dd4b58ac4d	{"id":"539e7cd6-32a0-4c42-91d9-05dd4b58ac4d","status":"published","date_created":"2026-07-13T02:26:48.273Z","date_updated":"2026-07-13T08:54:29.221Z","name":"Kota Gede","slug":"kota-gede","description":"Kawasan sejarah dengan arsitektur kolonial dan pengrajin perak. Destinasi wisata heritage dan belanja oleh-oleh.","gallery":null}	{"image":"31639889-3b56-4b07-b37f-0bd0951dbfbf","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-13T08:54:29.221Z"}	\N	\N
331	442	destinations	6f8366b1-eda3-451a-b240-984fe41158d5	{"id":"6f8366b1-eda3-451a-b240-984fe41158d5","status":"published","date_created":"2026-07-13T02:26:48.366Z","date_updated":"2026-07-13T08:54:29.236Z","name":"Pulau Ayer","slug":"pulau-ayer","description":"Pulau resor dengan water sports lengkap dan akomodasi nyaman. Ideal untuk weekend getaway dan family gathering.","gallery":null}	{"image":"794bfde6-a082-4ea6-8cfc-438e14ddb651","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-13T08:54:29.236Z"}	\N	\N
332	443	destinations	89862e81-f3f3-4311-9aff-9e8d9a21016c	{"id":"89862e81-f3f3-4311-9aff-9e8d9a21016c","status":"published","date_created":"2026-07-13T02:26:48.432Z","date_updated":"2026-07-13T08:54:29.250Z","name":"Gili Trawangan","slug":"gili-trawangan","description":"Pulau tropis tanpa kendaraan bermotor dengan kehidupan malam, snorkeling, dan diving kelas dunia.","gallery":null}	{"image":"b4369210-3088-40bb-8506-bb8049e14bb5","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-13T08:54:29.250Z"}	\N	\N
333	444	directus_settings	1	{"id":1,"project_name":"Directus","project_url":null,"project_color":"#6644FF","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"light","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":null,"org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false}	{"default_appearance":"light"}	\N	\N
353	535	destinations	9963b299-a397-4a88-98fc-56beb9457b33	{"name":"Kawah Putih","slug":"kawah-putih","status":"published"}	{"name":"Kawah Putih","slug":"kawah-putih","status":"published"}	\N	\N
354	536	destinations	c7a08815-baf0-43dd-b3c2-2fd2a0d9a0a3	{"name":"Farmhouse Lembang","slug":"farmhouse-lembang","status":"published"}	{"name":"Farmhouse Lembang","slug":"farmhouse-lembang","status":"published"}	\N	\N
355	537	destinations	240f8811-9cf5-47e4-a184-7e3aca8caabd	{"name":"The Lodge Maribaya","slug":"the-lodge-maribaya","status":"published"}	{"name":"The Lodge Maribaya","slug":"the-lodge-maribaya","status":"published"}	\N	\N
334	445	directus_settings	1	{"id":1,"project_name":"Directus","project_url":null,"project_color":"#6644FF","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"dark","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":null,"org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false}	{"default_appearance":"dark"}	\N	\N
335	510	activity_types	2039cf88-bd53-45e8-a822-63d50cf8c52d	{"name":"Private Trip","slug":"private-trip","description":"Rombongan sendiri (keluarga/teman/kolega), jadwal & itinerary bisa custom, tidak digabung peserta lain.","status":"published"}	{"name":"Private Trip","slug":"private-trip","description":"Rombongan sendiri (keluarga/teman/kolega), jadwal & itinerary bisa custom, tidak digabung peserta lain.","status":"published"}	\N	\N
336	511	activity_types	0b89c9cd-3cf1-49be-a6d6-544e116782da	{"name":"Open Trip","slug":"open-trip","description":"Digabung dengan peserta lain yang tidak saling kenal, jadwal fixed (biasanya weekend), harga per orang lebih murah.","status":"published"}	{"name":"Open Trip","slug":"open-trip","description":"Digabung dengan peserta lain yang tidak saling kenal, jadwal fixed (biasanya weekend), harga per orang lebih murah.","status":"published"}	\N	\N
337	519	activity_types	e0506893-412e-4824-8d8b-ae019a08b904	{"name":"Private Trip","slug":"private-trip","description":"Rombongan sendiri (keluarga/teman/kolega), jadwal & itinerary bisa custom, tidak digabung peserta lain.","status":"published"}	{"name":"Private Trip","slug":"private-trip","description":"Rombongan sendiri (keluarga/teman/kolega), jadwal & itinerary bisa custom, tidak digabung peserta lain.","status":"published"}	\N	\N
338	520	activity_types	b909dcf6-2837-4369-a6c6-fbfd5b2b5134	{"name":"Open Trip","slug":"open-trip","description":"Digabung dengan peserta lain yang tidak saling kenal, jadwal fixed (biasanya weekend), harga per orang lebih murah.","status":"published"}	{"name":"Open Trip","slug":"open-trip","description":"Digabung dengan peserta lain yang tidak saling kenal, jadwal fixed (biasanya weekend), harga per orang lebih murah.","status":"published"}	\N	\N
339	521	activity_types	02e09c30-728c-412c-9058-89df82c61c47	{"name":"Family Trip","slug":"family-trip","description":"Trip untuk liburan keluarga, ramah anak dan orang tua, ritme santai, destinasi kid-friendly.","status":"published"}	{"name":"Family Trip","slug":"family-trip","description":"Trip untuk liburan keluarga, ramah anak dan orang tua, ritme santai, destinasi kid-friendly.","status":"published"}	\N	\N
340	522	activity_types	e6a14e35-f137-4bf5-a445-21bbff7e2955	{"name":"Corporate Gathering","slug":"corporate-gathering","description":"Acara kantor/perusahaan untuk mempererat kebersamaan tim, biasanya termasuk makan bersama & venue acara.","status":"published"}	{"name":"Corporate Gathering","slug":"corporate-gathering","description":"Acara kantor/perusahaan untuk mempererat kebersamaan tim, biasanya termasuk makan bersama & venue acara.","status":"published"}	\N	\N
341	523	activity_types	ef4be35a-a6c5-4e79-9c5c-2a5f7752e586	{"name":"Team Building","slug":"team-building","description":"Fokus pada aktivitas kerja sama tim, biasanya dikombinasikan dengan games/outbound terstruktur dan fasilitator.","status":"published"}	{"name":"Team Building","slug":"team-building","description":"Fokus pada aktivitas kerja sama tim, biasanya dikombinasikan dengan games/outbound terstruktur dan fasilitator.","status":"published"}	\N	\N
342	524	activity_types	e011abf2-00b4-4dc9-bc4e-60c7bccf290b	{"name":"Outbound","slug":"outbound","description":"Aktivitas fisik luar ruangan berbasis games/tantangan kelompok (flying fox, war game, dsb), biasa untuk sekolah atau kantor.","status":"published"}	{"name":"Outbound","slug":"outbound","description":"Aktivitas fisik luar ruangan berbasis games/tantangan kelompok (flying fox, war game, dsb), biasa untuk sekolah atau kantor.","status":"published"}	\N	\N
343	525	activity_types	3081b30f-b4d9-4395-b070-336e2d58e9c0	{"name":"Honeymoon / Pasangan","slug":"honeymoon-pasangan","description":"Trip romantis untuk pasangan/bulan madu, biasanya private dan destinasi lebih personal/santai.","status":"published"}	{"name":"Honeymoon / Pasangan","slug":"honeymoon-pasangan","description":"Trip romantis untuk pasangan/bulan madu, biasanya private dan destinasi lebih personal/santai.","status":"published"}	\N	\N
344	526	activity_types	3e451ca1-7ebd-4f3b-929c-6bd523774f1d	{"name":"Study Tour / Wisata Edukasi","slug":"study-tour-wisata-edukasi","description":"Kunjungan wisata untuk pelajar/mahasiswa dengan muatan edukasi sejarah/budaya/sains.","status":"published"}	{"name":"Study Tour / Wisata Edukasi","slug":"study-tour-wisata-edukasi","description":"Kunjungan wisata untuk pelajar/mahasiswa dengan muatan edukasi sejarah/budaya/sains.","status":"published"}	\N	\N
345	527	activity_types	0d22a213-d42d-4c87-bc2c-555d972ed4b4	{"name":"Backpacker / Solo Traveler","slug":"backpacker-solo-traveler","description":"Trip hemat untuk traveler individu yang ingin gabung open trip, budget minim, cocok untuk kenalan baru.","status":"published"}	{"name":"Backpacker / Solo Traveler","slug":"backpacker-solo-traveler","description":"Trip hemat untuk traveler individu yang ingin gabung open trip, budget minim, cocok untuk kenalan baru.","status":"published"}	\N	\N
346	528	activity_types	7813e47f-0459-4124-acf2-16fce015f275	{"name":"Reuni / Komunitas","slug":"reuni-komunitas","description":"Trip untuk kelompok alumni, komunitas hobi, atau kumpulan teman lama.","status":"published"}	{"name":"Reuni / Komunitas","slug":"reuni-komunitas","description":"Trip untuk kelompok alumni, komunitas hobi, atau kumpulan teman lama.","status":"published"}	\N	\N
347	529	activity_types	447f5da1-837e-4e0f-94c3-3d1c63c1706f	{"name":"Religi / Ziarah","slug":"religi-ziarah","description":"Kunjungan ke situs bersejarah/keagamaan seperti candi, pura, atau tempat ziarah.","status":"published"}	{"name":"Religi / Ziarah","slug":"religi-ziarah","description":"Kunjungan ke situs bersejarah/keagamaan seperti candi, pura, atau tempat ziarah.","status":"published"}	\N	\N
356	538	destinations	d01cbf02-0d25-4e45-a94c-836d861176c4	{"name":"Dusun Bambu","slug":"dusun-bambu","status":"published"}	{"name":"Dusun Bambu","slug":"dusun-bambu","status":"published"}	\N	\N
357	539	destinations	dddcf318-008f-4e42-a958-b22ac19431ea	{"name":"Situ Patenggang","slug":"situ-patenggang","status":"published"}	{"name":"Situ Patenggang","slug":"situ-patenggang","status":"published"}	\N	\N
358	540	destinations	eb420955-f41f-4205-bf70-7460d2ec7ccb	{"name":"Jalan Braga","slug":"jalan-braga","status":"published"}	{"name":"Jalan Braga","slug":"jalan-braga","status":"published"}	\N	\N
359	541	destinations	c3fb1f20-dd99-4ad2-927f-441f612914df	{"name":"Trans Studio Bandung","slug":"trans-studio-bandung","status":"published"}	{"name":"Trans Studio Bandung","slug":"trans-studio-bandung","status":"published"}	\N	\N
360	542	destinations	52067f06-39de-44ce-9ab7-5bf13d124037	{"name":"Pulau Tidung (Jembatan Cinta)","slug":"pulau-tidung-jembatan-cinta","status":"published"}	{"name":"Pulau Tidung (Jembatan Cinta)","slug":"pulau-tidung-jembatan-cinta","status":"published"}	\N	\N
361	543	destinations	ea044597-5d2c-4a94-9018-9f627ce83335	{"name":"Pulau Pari (Pantai Pasir Perawan)","slug":"pulau-pari-pantai-pasir-perawan","status":"published"}	{"name":"Pulau Pari (Pantai Pasir Perawan)","slug":"pulau-pari-pantai-pasir-perawan","status":"published"}	\N	\N
362	544	destinations	75347490-a06e-4694-9aeb-040c6434a3c2	{"name":"Pulau Payung","slug":"pulau-payung","status":"published"}	{"name":"Pulau Payung","slug":"pulau-payung","status":"published"}	\N	\N
363	545	destinations	3027302d-aaae-4c8f-ac5e-220cad95472c	{"name":"Pulau Harapan","slug":"pulau-harapan","status":"published"}	{"name":"Pulau Harapan","slug":"pulau-harapan","status":"published"}	\N	\N
364	546	destinations	5b25b0bb-b579-4803-87ad-511402239021	{"name":"Candi Borobudur","slug":"candi-borobudur","status":"published"}	{"name":"Candi Borobudur","slug":"candi-borobudur","status":"published"}	\N	\N
365	547	destinations	80af48c1-0ae5-4aa3-8b0b-5179ba3360e7	{"name":"Candi Prambanan","slug":"candi-prambanan","status":"published"}	{"name":"Candi Prambanan","slug":"candi-prambanan","status":"published"}	\N	\N
366	548	destinations	36ce8c0f-8826-4c88-93fb-b9e98740e6c8	{"name":"Ratu Boko","slug":"ratu-boko","status":"published"}	{"name":"Ratu Boko","slug":"ratu-boko","status":"published"}	\N	\N
367	549	destinations	bcb418ab-dfa8-4315-b719-69be3b33383b	{"name":"Malioboro","slug":"malioboro","status":"published"}	{"name":"Malioboro","slug":"malioboro","status":"published"}	\N	\N
368	550	destinations	76ed31ce-c17f-4fa9-809e-4c7cac35420d	{"name":"Keraton Yogyakarta","slug":"keraton-yogyakarta","status":"published"}	{"name":"Keraton Yogyakarta","slug":"keraton-yogyakarta","status":"published"}	\N	\N
369	551	destinations	2c0ae5a6-4da4-44ae-b369-a8ad4bc2c318	{"name":"Tebing Breksi","slug":"tebing-breksi","status":"published"}	{"name":"Tebing Breksi","slug":"tebing-breksi","status":"published"}	\N	\N
370	552	destinations	1b096fc1-4467-4d70-b45a-2295860f42f8	{"name":"Gereja Ayam","slug":"gereja-ayam","status":"published"}	{"name":"Gereja Ayam","slug":"gereja-ayam","status":"published"}	\N	\N
371	553	destinations	9f7eafc4-3ead-48fc-9fec-dcebd2e70392	{"name":"Tanah Lot","slug":"tanah-lot","status":"published"}	{"name":"Tanah Lot","slug":"tanah-lot","status":"published"}	\N	\N
372	554	destinations	d3040ee2-357e-4993-a425-4c7573377eb9	{"name":"Kintamani","slug":"kintamani","status":"published"}	{"name":"Kintamani","slug":"kintamani","status":"published"}	\N	\N
373	555	destinations	601c7361-6557-4fa3-9a1f-e25f5983b0e1	{"name":"Ubud","slug":"ubud","status":"published"}	{"name":"Ubud","slug":"ubud","status":"published"}	\N	\N
374	556	destinations	97a6dbb8-f4bf-4944-8482-b02000cacfb0	{"name":"Tanjung Benoa","slug":"tanjung-benoa","status":"published"}	{"name":"Tanjung Benoa","slug":"tanjung-benoa","status":"published"}	\N	\N
375	557	destinations	9a40c0bd-1f09-4b16-8c2a-1438810e8cd9	{"name":"GWK","slug":"gwk","status":"published"}	{"name":"GWK","slug":"gwk","status":"published"}	\N	\N
376	558	destinations	c47613f1-4ece-4763-bf82-f1838b71d174	{"name":"Nusa Penida (opsional tambahan)","slug":"nusa-penida-opsional-tambahan","status":"published"}	{"name":"Nusa Penida (opsional tambahan)","slug":"nusa-penida-opsional-tambahan","status":"published"}	\N	\N
377	559	destinations	9cc0d9ec-8564-4f73-a10a-73b5f9e7494d	{"name":"Bedugul","slug":"bedugul","status":"published"}	{"name":"Bedugul","slug":"bedugul","status":"published"}	\N	\N
378	560	destinations	0d2e4be4-ec44-4d4d-a222-f0718a188e7c	{"name":"Uluwatu","slug":"uluwatu","status":"published"}	{"name":"Uluwatu","slug":"uluwatu","status":"published"}	\N	\N
379	561	packages	636ccecc-7f35-4e56-bdf1-2525c3a9f14d	{"name":"Paket Wisata Bandung 1 Hari (Lembang City Tour)","slug":"paket-wisata-bandung-1-hari-lembang-city-tour","description":"Penjemputan di Stasiun Bandung / Bandara Husein Sastranegara / hotel area Bandung; Menuju kawasan Lembang: Farmhouse Lembang; The Lodge Maribaya / Orchid Forest...","duration":"1 Hari (± 10-12 jam)","itinerary":["Penjemputan di Stasiun Bandung / Bandara Husein Sastranegara / hotel area Bandung","Menuju kawasan Lembang: Farmhouse Lembang","The Lodge Maribaya / Orchid Forest","Makan siang di resto area Lembang","Tangkuban Perahu (opsional)","Wisata belanja oleh-oleh khas Bandung","Pengantaran kembali ke stasiun/bandara"],"facilities":{"termasuk":["Mobil ber-AC (Avanza/Innova, tergantung jumlah peserta)","Driver + BBM + parkir + tol","Tiket masuk lokasi wisata (kecuali disebutkan tidak termasuk)","Air mineral selama perjalanan"],"tidak_termasuk":["Makan siang/malam (jika tidak disebutkan include)","Tiket masuk wahana tambahan (contoh: wahana di Farmhouse)","Pengeluaran pribadi & tip driver"]},"price_tiers":[{"label":"2-5 orang (mobil Avanza/APV)","price_per_pax":300000,"max_participants":5,"description":"Rp 300.000 - Rp 450.000"},{"label":"6-9 orang (mobil Elf/Pregio)","price_per_pax":250000,"max_participants":9,"description":"Rp 250.000 - Rp 350.000"},{"label":"10-20 orang (Elf Long/Bus kecil)","price_per_pax":200000,"max_participants":20,"description":"Rp 200.000 - Rp 280.000"},{"label":">20 orang (Bus/rombongan)","price_per_pax":0,"max_participants":20,"description":"Hubungi CS untuk penawaran grup"}],"status":"published"}	{"name":"Paket Wisata Bandung 1 Hari (Lembang City Tour)","slug":"paket-wisata-bandung-1-hari-lembang-city-tour","description":"Penjemputan di Stasiun Bandung / Bandara Husein Sastranegara / hotel area Bandung; Menuju kawasan Lembang: Farmhouse Lembang; The Lodge Maribaya / Orchid Forest...","duration":"1 Hari (± 10-12 jam)","itinerary":["Penjemputan di Stasiun Bandung / Bandara Husein Sastranegara / hotel area Bandung","Menuju kawasan Lembang: Farmhouse Lembang","The Lodge Maribaya / Orchid Forest","Makan siang di resto area Lembang","Tangkuban Perahu (opsional)","Wisata belanja oleh-oleh khas Bandung","Pengantaran kembali ke stasiun/bandara"],"facilities":{"termasuk":["Mobil ber-AC (Avanza/Innova, tergantung jumlah peserta)","Driver + BBM + parkir + tol","Tiket masuk lokasi wisata (kecuali disebutkan tidak termasuk)","Air mineral selama perjalanan"],"tidak_termasuk":["Makan siang/malam (jika tidak disebutkan include)","Tiket masuk wahana tambahan (contoh: wahana di Farmhouse)","Pengeluaran pribadi & tip driver"]},"price_tiers":[{"label":"2-5 orang (mobil Avanza/APV)","price_per_pax":300000,"max_participants":5,"description":"Rp 300.000 - Rp 450.000"},{"label":"6-9 orang (mobil Elf/Pregio)","price_per_pax":250000,"max_participants":9,"description":"Rp 250.000 - Rp 350.000"},{"label":"10-20 orang (Elf Long/Bus kecil)","price_per_pax":200000,"max_participants":20,"description":"Rp 200.000 - Rp 280.000"},{"label":">20 orang (Bus/rombongan)","price_per_pax":0,"max_participants":20,"description":"Hubungi CS untuk penawaran grup"}],"status":"published"}	\N	\N
380	562	packages_activity_types	33dbe184-ba71-4ffc-8836-bc31e7359a01	\N	\N	\N	\N
381	563	packages_activity_types	efdbbfb0-f628-4125-ab75-41b2ac7030e9	\N	\N	\N	\N
382	564	packages_activity_types	3a6ee389-c48c-43c8-8647-87facf07eb9b	\N	\N	\N	\N
383	565	packages_activity_types	32d3f7d7-08f3-4762-9e2d-3937cebc148d	\N	\N	\N	\N
439	621	packages	ddb007c9-8e02-44a3-8277-65170df52d28	{"name":"Open Trip Bali 4 Hari 3 Malam","slug":"open-trip-bali-4-hari-3-malam","description":"Hari 1: Penjemputan di Bandara Bali - Transfer & check in hotel - Free program; Hari 2: Kuta - Tour Bali Utara/Tengah - Celuk (kerajinan perak) - Kintamani (pemandangan Gunung & Danau Batur) - Pura Tirta Empul; Hari 3: Tour Bali Selatan - Tanjung Benoa (water sport/banana boat) - GWK / Tanah Lot (sunset)...","duration":"4 Hari 3 Malam","itinerary":["Hari 1: Penjemputan di Bandara Bali - Transfer & check in hotel - Free program","Hari 2: Kuta - Tour Bali Utara/Tengah - Celuk (kerajinan perak) - Kintamani (pemandangan Gunung & Danau Batur) - Pura Tirta Empul","Hari 3: Tour Bali Selatan - Tanjung Benoa (water sport/banana boat) - GWK / Tanah Lot (sunset)","Hari 4: Free program pagi - Check out - Transfer ke bandara"],"facilities":{"termasuk":["Hotel sesuai pilihan (3 malam)","Transportasi bus/mobil ber-AC selama di Bali","Makan 7 kali (sesuai program)","Air mineral","Tour guide","Dokumentasi","Penjemputan & pengantaran bandara"],"tidak_termasuk":["Tiket pesawat menuju Bali","Makan di luar program","Pengeluaran pribadi","Tip guide (sukarela)","Tiket masuk objek wisata premium (tergantung paket)"]},"price_tiers":[{"label":"1 (gabung open trip, quad/twin share)","price_per_pax":2100000,"max_participants":1,"description":"Rp 2.100.000 - Rp 2.999.000"},{"label":"Minimal pendaftaran 2 orang (private trip alternatif)","price_per_pax":0,"max_participants":2,"description":"Custom, hubungi CS"}],"status":"published"}	{"name":"Open Trip Bali 4 Hari 3 Malam","slug":"open-trip-bali-4-hari-3-malam","description":"Hari 1: Penjemputan di Bandara Bali - Transfer & check in hotel - Free program; Hari 2: Kuta - Tour Bali Utara/Tengah - Celuk (kerajinan perak) - Kintamani (pemandangan Gunung & Danau Batur) - Pura Tirta Empul; Hari 3: Tour Bali Selatan - Tanjung Benoa (water sport/banana boat) - GWK / Tanah Lot (sunset)...","duration":"4 Hari 3 Malam","itinerary":["Hari 1: Penjemputan di Bandara Bali - Transfer & check in hotel - Free program","Hari 2: Kuta - Tour Bali Utara/Tengah - Celuk (kerajinan perak) - Kintamani (pemandangan Gunung & Danau Batur) - Pura Tirta Empul","Hari 3: Tour Bali Selatan - Tanjung Benoa (water sport/banana boat) - GWK / Tanah Lot (sunset)","Hari 4: Free program pagi - Check out - Transfer ke bandara"],"facilities":{"termasuk":["Hotel sesuai pilihan (3 malam)","Transportasi bus/mobil ber-AC selama di Bali","Makan 7 kali (sesuai program)","Air mineral","Tour guide","Dokumentasi","Penjemputan & pengantaran bandara"],"tidak_termasuk":["Tiket pesawat menuju Bali","Makan di luar program","Pengeluaran pribadi","Tip guide (sukarela)","Tiket masuk objek wisata premium (tergantung paket)"]},"price_tiers":[{"label":"1 (gabung open trip, quad/twin share)","price_per_pax":2100000,"max_participants":1,"description":"Rp 2.100.000 - Rp 2.999.000"},{"label":"Minimal pendaftaran 2 orang (private trip alternatif)","price_per_pax":0,"max_participants":2,"description":"Custom, hubungi CS"}],"status":"published"}	\N	\N
440	622	packages_activity_types	f693d253-224e-4aa7-b3a2-aedb833ac763	\N	\N	\N	\N
441	623	packages_activity_types	ac3543a8-0986-4a5a-965f-c3875aff11d5	\N	\N	\N	\N
442	624	packages_activity_types	6ab134f5-1b06-4996-bafe-195acd274f7e	\N	\N	\N	\N
384	566	packages	ad41fa23-9c4e-4ad8-a174-7e13083bd8e9	{"name":"Paket Wisata Bandung 2 Hari 1 Malam","slug":"paket-wisata-bandung-2-hari-1-malam","description":"Hari 1: Penjemputan - Lembang (Farmhouse, The Lodge Maribaya, Dusun Bambu) - Check in hotel - makan malam; Hari 2: Ciwidey (Kawah Putih, Situ Patenggang, kebun teh Rancabali) - kota Bandung (Braga, Alun-Alun) - pengantaran pulang...","duration":"2 Hari 1 Malam","itinerary":["Hari 1: Penjemputan - Lembang (Farmhouse, The Lodge Maribaya, Dusun Bambu) - Check in hotel - makan malam","Hari 2: Ciwidey (Kawah Putih, Situ Patenggang, kebun teh Rancabali) - kota Bandung (Braga, Alun-Alun) - pengantaran pulang"],"facilities":{"termasuk":["Mobil ber-AC + driver + BBM + parkir + tol","Hotel 1 malam (kamar sesuai jumlah peserta)","Tiket masuk objek wisata utama","Sarapan di hotel"],"tidak_termasuk":["Makan siang & malam","Tiket wahana tambahan","Keperluan pribadi"]},"price_tiers":[{"label":"2 orang","price_per_pax":900000,"max_participants":2,"description":"Rp 900.000 - Rp 1.100.000"},{"label":"4-6 orang","price_per_pax":720000,"max_participants":6,"description":"Rp 720.000 - Rp 850.000"},{"label":"7-10 orang","price_per_pax":600000,"max_participants":10,"description":"Rp 600.000 - Rp 750.000"},{"label":"11-20 orang","price_per_pax":500000,"max_participants":20,"description":"Rp 500.000 - Rp 650.000"}],"status":"published"}	{"name":"Paket Wisata Bandung 2 Hari 1 Malam","slug":"paket-wisata-bandung-2-hari-1-malam","description":"Hari 1: Penjemputan - Lembang (Farmhouse, The Lodge Maribaya, Dusun Bambu) - Check in hotel - makan malam; Hari 2: Ciwidey (Kawah Putih, Situ Patenggang, kebun teh Rancabali) - kota Bandung (Braga, Alun-Alun) - pengantaran pulang...","duration":"2 Hari 1 Malam","itinerary":["Hari 1: Penjemputan - Lembang (Farmhouse, The Lodge Maribaya, Dusun Bambu) - Check in hotel - makan malam","Hari 2: Ciwidey (Kawah Putih, Situ Patenggang, kebun teh Rancabali) - kota Bandung (Braga, Alun-Alun) - pengantaran pulang"],"facilities":{"termasuk":["Mobil ber-AC + driver + BBM + parkir + tol","Hotel 1 malam (kamar sesuai jumlah peserta)","Tiket masuk objek wisata utama","Sarapan di hotel"],"tidak_termasuk":["Makan siang & malam","Tiket wahana tambahan","Keperluan pribadi"]},"price_tiers":[{"label":"2 orang","price_per_pax":900000,"max_participants":2,"description":"Rp 900.000 - Rp 1.100.000"},{"label":"4-6 orang","price_per_pax":720000,"max_participants":6,"description":"Rp 720.000 - Rp 850.000"},{"label":"7-10 orang","price_per_pax":600000,"max_participants":10,"description":"Rp 600.000 - Rp 750.000"},{"label":"11-20 orang","price_per_pax":500000,"max_participants":20,"description":"Rp 500.000 - Rp 650.000"}],"status":"published"}	\N	\N
385	567	packages_activity_types	4124317a-34a3-48df-95bb-9f7fd5247efe	\N	\N	\N	\N
386	568	packages_activity_types	0571e371-671c-4ca2-b74f-2f29243e2807	\N	\N	\N	\N
387	569	packages_activity_types	d9d4650a-2dc1-40e3-a5c3-32e675bf744f	\N	\N	\N	\N
388	570	packages_activity_types	d4fe6af9-b92e-4e42-a477-7ae2e55414bf	\N	\N	\N	\N
389	571	packages	e6e3a104-0626-4acb-8aac-328b49d0dfb6	{"name":"Paket Wisata Bandung 3 Hari 2 Malam","slug":"paket-wisata-bandung-3-hari-2-malam","description":"Hari 1: Penjemputan - City tour Bandung (Gedung Sate, Jalan Braga) - Check in hotel; Hari 2: Lembang full day (Tangkuban Perahu, Farmhouse, The Lodge Maribaya, Dusun Bambu); Hari 3: Ciwidey (Kawah Putih, Situ Patenggang) - belanja oleh-oleh - pengantaran ke stasiun/bandara...","duration":"3 Hari 2 Malam","itinerary":["Hari 1: Penjemputan - City tour Bandung (Gedung Sate, Jalan Braga) - Check in hotel","Hari 2: Lembang full day (Tangkuban Perahu, Farmhouse, The Lodge Maribaya, Dusun Bambu)","Hari 3: Ciwidey (Kawah Putih, Situ Patenggang) - belanja oleh-oleh - pengantaran ke stasiun/bandara"],"facilities":{"termasuk":["Mobil ber-AC + driver + BBM + parkir + tol","Hotel 2 malam","Tiket masuk objek wisata sesuai itinerary","Sarapan 2x di hotel"],"tidak_termasuk":["Makan siang & malam","Wahana tambahan","Pengeluaran pribadi"]},"price_tiers":[{"label":"2 orang","price_per_pax":1800000,"max_participants":2,"description":"Rp 1.800.000 - Rp 2.250.000"},{"label":"4-6 orang","price_per_pax":1530000,"max_participants":6,"description":"Rp 1.530.000 - Rp 1.700.000"},{"label":"7-10 orang","price_per_pax":1230000,"max_participants":10,"description":"Rp 1.230.000 - Rp 1.450.000"},{"label":"11-20 orang","price_per_pax":1000000,"max_participants":20,"description":"Rp 1.000.000 - Rp 1.200.000"}],"status":"published"}	{"name":"Paket Wisata Bandung 3 Hari 2 Malam","slug":"paket-wisata-bandung-3-hari-2-malam","description":"Hari 1: Penjemputan - City tour Bandung (Gedung Sate, Jalan Braga) - Check in hotel; Hari 2: Lembang full day (Tangkuban Perahu, Farmhouse, The Lodge Maribaya, Dusun Bambu); Hari 3: Ciwidey (Kawah Putih, Situ Patenggang) - belanja oleh-oleh - pengantaran ke stasiun/bandara...","duration":"3 Hari 2 Malam","itinerary":["Hari 1: Penjemputan - City tour Bandung (Gedung Sate, Jalan Braga) - Check in hotel","Hari 2: Lembang full day (Tangkuban Perahu, Farmhouse, The Lodge Maribaya, Dusun Bambu)","Hari 3: Ciwidey (Kawah Putih, Situ Patenggang) - belanja oleh-oleh - pengantaran ke stasiun/bandara"],"facilities":{"termasuk":["Mobil ber-AC + driver + BBM + parkir + tol","Hotel 2 malam","Tiket masuk objek wisata sesuai itinerary","Sarapan 2x di hotel"],"tidak_termasuk":["Makan siang & malam","Wahana tambahan","Pengeluaran pribadi"]},"price_tiers":[{"label":"2 orang","price_per_pax":1800000,"max_participants":2,"description":"Rp 1.800.000 - Rp 2.250.000"},{"label":"4-6 orang","price_per_pax":1530000,"max_participants":6,"description":"Rp 1.530.000 - Rp 1.700.000"},{"label":"7-10 orang","price_per_pax":1230000,"max_participants":10,"description":"Rp 1.230.000 - Rp 1.450.000"},{"label":"11-20 orang","price_per_pax":1000000,"max_participants":20,"description":"Rp 1.000.000 - Rp 1.200.000"}],"status":"published"}	\N	\N
390	572	packages_activity_types	a1022371-b983-456c-99b5-93e145a8f63d	\N	\N	\N	\N
391	573	packages_activity_types	ebea9bf3-9999-4e77-8a1c-82cde1da2d73	\N	\N	\N	\N
392	574	packages_activity_types	7ebb60c4-31df-423c-ae16-f6de13a891a0	\N	\N	\N	\N
393	575	packages_activity_types	1db82dc1-02c9-4809-b253-cb61e839c19c	\N	\N	\N	\N
394	576	packages_activity_types	21b1b57f-f098-4b78-8804-cf7af803a223	\N	\N	\N	\N
395	577	packages	9e7ea98a-057f-4d87-8cb9-1d3c90fc8059	{"name":"Paket Outing/Gathering Perusahaan Bandung (Group Besar)","slug":"paket-outinggathering-perusahaan-bandung-group-besar","description":"Custom sesuai kebutuhan acara (family gathering, outbound, meeting); Bisa dikombinasikan dengan outbound, rafting, offroad...","duration":"1-2 Hari (fleksibel)","itinerary":["Custom sesuai kebutuhan acara (family gathering, outbound, meeting)","Bisa dikombinasikan dengan outbound, rafting, offroad"],"facilities":{"termasuk":["Bus pariwisata + driver + co-driver","Fasilitas outbound/games (opsional)","Makan sesuai paket","Venue/tempat acara (jika disewa)"],"tidak_termasuk":["Sewa alat outbound tambahan di luar paket","Dokumentasi profesional (opsional tambahan biaya)"]},"price_tiers":[{"label":"20-49 orang","price_per_pax":0,"max_participants":49,"description":"Hubungi CS (nego sesuai fasilitas)"},{"label":"50 orang ke atas","price_per_pax":0,"max_participants":50,"description":"Promo fantastis, hubungi CS untuk penawaran khusus"}],"status":"published"}	{"name":"Paket Outing/Gathering Perusahaan Bandung (Group Besar)","slug":"paket-outinggathering-perusahaan-bandung-group-besar","description":"Custom sesuai kebutuhan acara (family gathering, outbound, meeting); Bisa dikombinasikan dengan outbound, rafting, offroad...","duration":"1-2 Hari (fleksibel)","itinerary":["Custom sesuai kebutuhan acara (family gathering, outbound, meeting)","Bisa dikombinasikan dengan outbound, rafting, offroad"],"facilities":{"termasuk":["Bus pariwisata + driver + co-driver","Fasilitas outbound/games (opsional)","Makan sesuai paket","Venue/tempat acara (jika disewa)"],"tidak_termasuk":["Sewa alat outbound tambahan di luar paket","Dokumentasi profesional (opsional tambahan biaya)"]},"price_tiers":[{"label":"20-49 orang","price_per_pax":0,"max_participants":49,"description":"Hubungi CS (nego sesuai fasilitas)"},{"label":"50 orang ke atas","price_per_pax":0,"max_participants":50,"description":"Promo fantastis, hubungi CS untuk penawaran khusus"}],"status":"published"}	\N	\N
396	578	packages_activity_types	d62c3e31-b178-4eeb-88f3-3d678353b828	\N	\N	\N	\N
397	579	packages_activity_types	ade7685d-ab53-4b14-9ea3-edf56fedee1e	\N	\N	\N	\N
398	580	packages_activity_types	6fa77e56-c225-4c93-9a5b-c5ad3a82a5f2	\N	\N	\N	\N
399	581	packages_activity_types	0e4683b9-d2f4-48bc-9df1-42e0c18265df	\N	\N	\N	\N
400	582	packages	9bb6eab0-21c4-4bcf-b8c9-23d1e91258b8	{"name":"Open Trip Pulau Tidung 2 Hari 1 Malam","slug":"open-trip-pulau-tidung-2-hari-1-malam","description":"Hari 1: Kumpul di Pelabuhan Kali Adem Muara Angke / Marina Ancol (pagi) - Penyeberangan kapal ferry/kapal cepat (2,5-3 jam) - Check in homestay - Keliling pulau naik sepeda - Snorkeling - Makan siang & malam - BBQ malam (opsional); Hari 2: Sunrise di Jembatan Cinta - Sarapan - Island hopping (opsional) - Berkemas - Kembali ke pelabuhan asal...","duration":"2 Hari 1 Malam, berangkat Sabtu-Minggu","itinerary":["Hari 1: Kumpul di Pelabuhan Kali Adem Muara Angke / Marina Ancol (pagi) - Penyeberangan kapal ferry/kapal cepat (2,5-3 jam) - Check in homestay - Keliling pulau naik sepeda - Snorkeling - Makan siang & malam - BBQ malam (opsional)","Hari 2: Sunrise di Jembatan Cinta - Sarapan - Island hopping (opsional) - Berkemas - Kembali ke pelabuhan asal"],"facilities":{"termasuk":["Transportasi kapal PP (ferry/kapal cepat)","Homestay/penginapan AC (kamar isi 4-7 orang)","Makan 3x (sesuai program)","Alat snorkeling + perahu + foto underwater","Local guide","Sepeda keliling pulau"],"tidak_termasuk":["Transport menuju titik kumpul (pelabuhan)","Tiket masuk wahana tambahan (banana boat, dll)","Alat snorkeling tambahan/GoPro rental","Pengeluaran pribadi & tip guide"]},"price_tiers":[{"label":"1 (gabung open trip)","price_per_pax":325000,"max_participants":1,"description":"Rp 325.000 - Rp 495.000"},{"label":"2-10 orang (gabung open trip / grup kecil)","price_per_pax":350000,"max_participants":10,"description":"Rp 350.000 - Rp 420.000"},{"label":"11-20 orang (booking grup)","price_per_pax":300000,"max_participants":20,"description":"Rp 300.000 - Rp 380.000"},{"label":"25 orang ke atas (Group Package)","price_per_pax":760000,"max_participants":25,"description":"Rp 760.000 - Rp 820.000 (paket lengkap plus EO)"}],"status":"published"}	{"name":"Open Trip Pulau Tidung 2 Hari 1 Malam","slug":"open-trip-pulau-tidung-2-hari-1-malam","description":"Hari 1: Kumpul di Pelabuhan Kali Adem Muara Angke / Marina Ancol (pagi) - Penyeberangan kapal ferry/kapal cepat (2,5-3 jam) - Check in homestay - Keliling pulau naik sepeda - Snorkeling - Makan siang & malam - BBQ malam (opsional); Hari 2: Sunrise di Jembatan Cinta - Sarapan - Island hopping (opsional) - Berkemas - Kembali ke pelabuhan asal...","duration":"2 Hari 1 Malam, berangkat Sabtu-Minggu","itinerary":["Hari 1: Kumpul di Pelabuhan Kali Adem Muara Angke / Marina Ancol (pagi) - Penyeberangan kapal ferry/kapal cepat (2,5-3 jam) - Check in homestay - Keliling pulau naik sepeda - Snorkeling - Makan siang & malam - BBQ malam (opsional)","Hari 2: Sunrise di Jembatan Cinta - Sarapan - Island hopping (opsional) - Berkemas - Kembali ke pelabuhan asal"],"facilities":{"termasuk":["Transportasi kapal PP (ferry/kapal cepat)","Homestay/penginapan AC (kamar isi 4-7 orang)","Makan 3x (sesuai program)","Alat snorkeling + perahu + foto underwater","Local guide","Sepeda keliling pulau"],"tidak_termasuk":["Transport menuju titik kumpul (pelabuhan)","Tiket masuk wahana tambahan (banana boat, dll)","Alat snorkeling tambahan/GoPro rental","Pengeluaran pribadi & tip guide"]},"price_tiers":[{"label":"1 (gabung open trip)","price_per_pax":325000,"max_participants":1,"description":"Rp 325.000 - Rp 495.000"},{"label":"2-10 orang (gabung open trip / grup kecil)","price_per_pax":350000,"max_participants":10,"description":"Rp 350.000 - Rp 420.000"},{"label":"11-20 orang (booking grup)","price_per_pax":300000,"max_participants":20,"description":"Rp 300.000 - Rp 380.000"},{"label":"25 orang ke atas (Group Package)","price_per_pax":760000,"max_participants":25,"description":"Rp 760.000 - Rp 820.000 (paket lengkap plus EO)"}],"status":"published"}	\N	\N
401	583	packages_activity_types	166d2be9-76ea-4b05-aa21-7611f90572dc	\N	\N	\N	\N
402	584	packages_activity_types	6d107ceb-b260-4f2c-b0fb-8211aefb698e	\N	\N	\N	\N
403	585	packages_activity_types	3e950f50-d3ae-41e3-9193-67ea6517252b	\N	\N	\N	\N
404	586	packages	22e68179-0f7c-40f0-9b67-01b939302387	{"name":"Private Trip Pulau Tidung 2 Hari 1 Malam","slug":"private-trip-pulau-tidung-2-hari-1-malam","description":"Hari 1: Penjemputan/kumpul di pelabuhan - Penyeberangan - Check in homestay - Snorkeling - Keliling pulau - Sunset di Jembatan Cinta - BBQ malam; Hari 2: Sunrise - Island hopping ke pulau lain (opsional) - Sarapan - Check out - Kembali ke pelabuhan...","duration":"2 Hari 1 Malam, jadwal fleksibel (bisa hari kerja)","itinerary":["Hari 1: Penjemputan/kumpul di pelabuhan - Penyeberangan - Check in homestay - Snorkeling - Keliling pulau - Sunset di Jembatan Cinta - BBQ malam","Hari 2: Sunrise - Island hopping ke pulau lain (opsional) - Sarapan - Check out - Kembali ke pelabuhan"],"facilities":{"termasuk":["Transportasi kapal PP","Homestay eksklusif untuk rombongan sendiri","Makan sesuai program","Snorkeling set + perahu","Tour leader/local guide"],"tidak_termasuk":["Transport ke pelabuhan keberangkatan","Aktivitas water sport tambahan","Pengeluaran pribadi"]},"price_tiers":[{"label":"2-10 orang","price_per_pax":550000,"max_participants":10,"description":"Rp 550.000 - Rp 760.000"},{"label":"11-20 orang","price_per_pax":450000,"max_participants":20,"description":"Rp 450.000 - Rp 600.000"},{"label":"21 orang ke atas","price_per_pax":0,"max_participants":21,"description":"Hubungi CS untuk nego grup"}],"status":"published"}	{"name":"Private Trip Pulau Tidung 2 Hari 1 Malam","slug":"private-trip-pulau-tidung-2-hari-1-malam","description":"Hari 1: Penjemputan/kumpul di pelabuhan - Penyeberangan - Check in homestay - Snorkeling - Keliling pulau - Sunset di Jembatan Cinta - BBQ malam; Hari 2: Sunrise - Island hopping ke pulau lain (opsional) - Sarapan - Check out - Kembali ke pelabuhan...","duration":"2 Hari 1 Malam, jadwal fleksibel (bisa hari kerja)","itinerary":["Hari 1: Penjemputan/kumpul di pelabuhan - Penyeberangan - Check in homestay - Snorkeling - Keliling pulau - Sunset di Jembatan Cinta - BBQ malam","Hari 2: Sunrise - Island hopping ke pulau lain (opsional) - Sarapan - Check out - Kembali ke pelabuhan"],"facilities":{"termasuk":["Transportasi kapal PP","Homestay eksklusif untuk rombongan sendiri","Makan sesuai program","Snorkeling set + perahu","Tour leader/local guide"],"tidak_termasuk":["Transport ke pelabuhan keberangkatan","Aktivitas water sport tambahan","Pengeluaran pribadi"]},"price_tiers":[{"label":"2-10 orang","price_per_pax":550000,"max_participants":10,"description":"Rp 550.000 - Rp 760.000"},{"label":"11-20 orang","price_per_pax":450000,"max_participants":20,"description":"Rp 450.000 - Rp 600.000"},{"label":"21 orang ke atas","price_per_pax":0,"max_participants":21,"description":"Hubungi CS untuk nego grup"}],"status":"published"}	\N	\N
405	587	packages_activity_types	a62ed89e-5395-4280-8248-7e1b01b3f58c	\N	\N	\N	\N
406	588	packages_activity_types	f0498db9-eb28-4b91-ad9b-143e20f69099	\N	\N	\N	\N
407	589	packages_activity_types	efa8736b-84c9-46f0-bce0-d1df5824aef6	\N	\N	\N	\N
408	590	packages_activity_types	5f6e42c4-5ca9-4a32-a2f1-ad57c183a90e	\N	\N	\N	\N
409	591	packages	24855a16-6ce9-4b6f-9996-d24cba57c52b	{"name":"One Day Trip Pulau Tidung / Pulau Pari (Tanpa Menginap)","slug":"one-day-trip-pulau-tidung-pulau-pari-tanpa-menginap","description":"Kumpul pagi di pelabuhan - Penyeberangan - Snorkeling - Keliling pulau - Makan siang - Foto di Jembatan Cinta / Pantai Pasir Perawan - Sore kembali ke pelabuhan...","duration":"1 Hari (berangkat pagi, pulang sore)","itinerary":["Kumpul pagi di pelabuhan - Penyeberangan - Snorkeling - Keliling pulau - Makan siang - Foto di Jembatan Cinta / Pantai Pasir Perawan - Sore kembali ke pelabuhan"],"facilities":{"termasuk":["Transportasi kapal PP","Makan siang 1x","Alat snorkeling + perahu","Tur keliling pulau"],"tidak_termasuk":["Penginapan (karena tanpa menginap)","Wahana tambahan","Pengeluaran pribadi"]},"price_tiers":[{"label":"2-10 orang","price_per_pax":360000,"max_participants":10,"description":"Rp 360.000 - Rp 620.000"},{"label":"11-20 orang","price_per_pax":300000,"max_participants":20,"description":"Rp 300.000 - Rp 450.000"}],"status":"published"}	{"name":"One Day Trip Pulau Tidung / Pulau Pari (Tanpa Menginap)","slug":"one-day-trip-pulau-tidung-pulau-pari-tanpa-menginap","description":"Kumpul pagi di pelabuhan - Penyeberangan - Snorkeling - Keliling pulau - Makan siang - Foto di Jembatan Cinta / Pantai Pasir Perawan - Sore kembali ke pelabuhan...","duration":"1 Hari (berangkat pagi, pulang sore)","itinerary":["Kumpul pagi di pelabuhan - Penyeberangan - Snorkeling - Keliling pulau - Makan siang - Foto di Jembatan Cinta / Pantai Pasir Perawan - Sore kembali ke pelabuhan"],"facilities":{"termasuk":["Transportasi kapal PP","Makan siang 1x","Alat snorkeling + perahu","Tur keliling pulau"],"tidak_termasuk":["Penginapan (karena tanpa menginap)","Wahana tambahan","Pengeluaran pribadi"]},"price_tiers":[{"label":"2-10 orang","price_per_pax":360000,"max_participants":10,"description":"Rp 360.000 - Rp 620.000"},{"label":"11-20 orang","price_per_pax":300000,"max_participants":20,"description":"Rp 300.000 - Rp 450.000"}],"status":"published"}	\N	\N
410	592	packages_activity_types	3786c9b0-cc80-4509-b119-de544840a0a0	\N	\N	\N	\N
411	593	packages_activity_types	e3ff42b5-8b8e-4365-9333-b018918765ba	\N	\N	\N	\N
412	594	packages_activity_types	dae0c239-e7c2-40ec-9442-a980453591d5	\N	\N	\N	\N
413	595	packages_activity_types	d0c6ed08-78ac-4185-8fb8-300b9535e403	\N	\N	\N	\N
414	596	packages_activity_types	6d5fa3ac-8637-4e7f-8b47-fa4c0103c1b7	\N	\N	\N	\N
415	597	packages	ac5a1994-faad-4d3d-95ff-9600dca0f757	{"name":"Paket Outing Perusahaan Pulau Tidung (Rombongan Besar)","slug":"paket-outing-perusahaan-pulau-tidung-rombongan-besar","description":"Custom, biasanya termasuk games/outbound, makan bersama, dan snorkeling...","duration":"2 Hari 1 Malam","itinerary":["Custom, biasanya termasuk games/outbound, makan bersama, dan snorkeling"],"facilities":{"termasuk":["Jasa Event Organizer","Transportasi kapal","Penginapan","Makan bersama","Games/outbound kelompok"],"tidak_termasuk":["Dekorasi tambahan","Dokumentasi profesional (opsional)"]},"price_tiers":[{"label":"25 orang ke atas","price_per_pax":250000,"max_participants":25,"description":"Rp 250.000 - Rp 400.000 (tergantung fasilitas)"}],"status":"published"}	{"name":"Paket Outing Perusahaan Pulau Tidung (Rombongan Besar)","slug":"paket-outing-perusahaan-pulau-tidung-rombongan-besar","description":"Custom, biasanya termasuk games/outbound, makan bersama, dan snorkeling...","duration":"2 Hari 1 Malam","itinerary":["Custom, biasanya termasuk games/outbound, makan bersama, dan snorkeling"],"facilities":{"termasuk":["Jasa Event Organizer","Transportasi kapal","Penginapan","Makan bersama","Games/outbound kelompok"],"tidak_termasuk":["Dekorasi tambahan","Dokumentasi profesional (opsional)"]},"price_tiers":[{"label":"25 orang ke atas","price_per_pax":250000,"max_participants":25,"description":"Rp 250.000 - Rp 400.000 (tergantung fasilitas)"}],"status":"published"}	\N	\N
416	598	packages_activity_types	f2e06230-d081-4a36-8825-fc54411aa140	\N	\N	\N	\N
417	599	packages_activity_types	61cf14aa-c165-4596-b5ca-ceeaa3984166	\N	\N	\N	\N
418	600	packages_activity_types	36ff8e04-14fa-4c89-8094-57a4538fa5f6	\N	\N	\N	\N
434	616	packages	f8deba71-0bfa-4065-849f-2f5fe7d3e6bf	{"name":"Paket Wisata Jogja 3 Hari 2 Malam","slug":"paket-wisata-jogja-3-hari-2-malam","description":"Hari 1: Penjemputan - Candi Borobudur - Candi Mendut - Check in hotel; Hari 2: Ketep Pass - Jeep Volcano Tour Merapi - Candi Prambanan; Hari 3: Keraton Yogyakarta - Taman Sari - Malioboro & pusat oleh-oleh - Pengantaran pulang...","duration":"3 Hari 2 Malam","itinerary":["Hari 1: Penjemputan - Candi Borobudur - Candi Mendut - Check in hotel","Hari 2: Ketep Pass - Jeep Volcano Tour Merapi - Candi Prambanan","Hari 3: Keraton Yogyakarta - Taman Sari - Malioboro & pusat oleh-oleh - Pengantaran pulang"],"facilities":{"termasuk":["Mobil ber-AC + driver + BBM + tol + parkir","Hotel 2 malam","Sarapan 2x di hotel"],"tidak_termasuk":["Tiket masuk semua objek wisata & Jeep Merapi","Makan siang & malam","Pengeluaran pribadi"]},"price_tiers":[{"label":"2 orang","price_per_pax":1800000,"max_participants":2,"description":"Rp 1.800.000 - Rp 2.190.000"},{"label":"4-6 orang","price_per_pax":1200000,"max_participants":6,"description":"Rp 1.200.000 - Rp 1.500.000"},{"label":"7-10 orang","price_per_pax":950000,"max_participants":10,"description":"Rp 950.000 - Rp 1.200.000"},{"label":"11-20 orang","price_per_pax":750000,"max_participants":20,"description":"Rp 750.000 - Rp 950.000"}],"status":"published"}	{"name":"Paket Wisata Jogja 3 Hari 2 Malam","slug":"paket-wisata-jogja-3-hari-2-malam","description":"Hari 1: Penjemputan - Candi Borobudur - Candi Mendut - Check in hotel; Hari 2: Ketep Pass - Jeep Volcano Tour Merapi - Candi Prambanan; Hari 3: Keraton Yogyakarta - Taman Sari - Malioboro & pusat oleh-oleh - Pengantaran pulang...","duration":"3 Hari 2 Malam","itinerary":["Hari 1: Penjemputan - Candi Borobudur - Candi Mendut - Check in hotel","Hari 2: Ketep Pass - Jeep Volcano Tour Merapi - Candi Prambanan","Hari 3: Keraton Yogyakarta - Taman Sari - Malioboro & pusat oleh-oleh - Pengantaran pulang"],"facilities":{"termasuk":["Mobil ber-AC + driver + BBM + tol + parkir","Hotel 2 malam","Sarapan 2x di hotel"],"tidak_termasuk":["Tiket masuk semua objek wisata & Jeep Merapi","Makan siang & malam","Pengeluaran pribadi"]},"price_tiers":[{"label":"2 orang","price_per_pax":1800000,"max_participants":2,"description":"Rp 1.800.000 - Rp 2.190.000"},{"label":"4-6 orang","price_per_pax":1200000,"max_participants":6,"description":"Rp 1.200.000 - Rp 1.500.000"},{"label":"7-10 orang","price_per_pax":950000,"max_participants":10,"description":"Rp 950.000 - Rp 1.200.000"},{"label":"11-20 orang","price_per_pax":750000,"max_participants":20,"description":"Rp 750.000 - Rp 950.000"}],"status":"published"}	\N	\N
435	617	packages_activity_types	ed05ee5b-05b5-43d5-8bd3-fe4903671375	\N	\N	\N	\N
436	618	packages_activity_types	36debfee-e72f-4d69-a986-5d6cd6fa3a64	\N	\N	\N	\N
419	601	packages	82f987ec-652c-4467-9573-7ca3087a30a3	{"name":"Paket Wisata Jogja 1 Hari - Candi Borobudur, Prambanan & Ratu Boko","slug":"paket-wisata-jogja-1-hari-candi-borobudur-prambanan-ratu-boko","description":"Penjemputan di hotel/bandara/stasiun area Yogyakarta; Menuju Candi Borobudur - eksplorasi candi Buddha terbesar di dunia; Makan siang...","duration":"1 Hari (± 10-12 jam)","itinerary":["Penjemputan di hotel/bandara/stasiun area Yogyakarta","Menuju Candi Borobudur - eksplorasi candi Buddha terbesar di dunia","Makan siang","Menuju Candi Prambanan - eksplorasi candi Hindu terbesar","Ratu Boko (opsional, terutama untuk sunset)","Pengantaran kembali ke hotel/bandara/stasiun"],"facilities":{"termasuk":["Mobil ber-AC + driver","BBM + parkir + tol","Penjemputan & pengantaran gratis dalam radius kota Yogyakarta","Air mineral botol"],"tidak_termasuk":["Tiket masuk candi (Borobudur Rp 50.000/orang domestik, Prambanan terpisah)","Makan siang/malam","Pemandu wisata (kecuali paket premium)","Tip driver (sukarela)"]},"price_tiers":[{"label":"2-6 orang","price_per_pax":290000,"max_participants":6,"description":"Rp 290.000 - Rp 490.000"},{"label":"7-10 orang","price_per_pax":250000,"max_participants":10,"description":"Rp 250.000 - Rp 350.000"},{"label":"11-20 orang (Elf/Hiace)","price_per_pax":200000,"max_participants":20,"description":"Rp 200.000 - Rp 300.000"},{"label":">20 orang (Bus)","price_per_pax":0,"max_participants":20,"description":"Hubungi CS untuk penawaran grup"}],"status":"published"}	{"name":"Paket Wisata Jogja 1 Hari - Candi Borobudur, Prambanan & Ratu Boko","slug":"paket-wisata-jogja-1-hari-candi-borobudur-prambanan-ratu-boko","description":"Penjemputan di hotel/bandara/stasiun area Yogyakarta; Menuju Candi Borobudur - eksplorasi candi Buddha terbesar di dunia; Makan siang...","duration":"1 Hari (± 10-12 jam)","itinerary":["Penjemputan di hotel/bandara/stasiun area Yogyakarta","Menuju Candi Borobudur - eksplorasi candi Buddha terbesar di dunia","Makan siang","Menuju Candi Prambanan - eksplorasi candi Hindu terbesar","Ratu Boko (opsional, terutama untuk sunset)","Pengantaran kembali ke hotel/bandara/stasiun"],"facilities":{"termasuk":["Mobil ber-AC + driver","BBM + parkir + tol","Penjemputan & pengantaran gratis dalam radius kota Yogyakarta","Air mineral botol"],"tidak_termasuk":["Tiket masuk candi (Borobudur Rp 50.000/orang domestik, Prambanan terpisah)","Makan siang/malam","Pemandu wisata (kecuali paket premium)","Tip driver (sukarela)"]},"price_tiers":[{"label":"2-6 orang","price_per_pax":290000,"max_participants":6,"description":"Rp 290.000 - Rp 490.000"},{"label":"7-10 orang","price_per_pax":250000,"max_participants":10,"description":"Rp 250.000 - Rp 350.000"},{"label":"11-20 orang (Elf/Hiace)","price_per_pax":200000,"max_participants":20,"description":"Rp 200.000 - Rp 300.000"},{"label":">20 orang (Bus)","price_per_pax":0,"max_participants":20,"description":"Hubungi CS untuk penawaran grup"}],"status":"published"}	\N	\N
420	602	packages_activity_types	d0c5ff5c-2e4a-4eab-90f8-d19d03295b78	\N	\N	\N	\N
421	603	packages_activity_types	7ab75c73-fb22-436b-869e-5a371a8102b6	\N	\N	\N	\N
422	604	packages_activity_types	dc3a7480-6e64-40c3-8fc1-f7fe3a143550	\N	\N	\N	\N
423	605	packages_activity_types	16b79d72-09a2-46e3-9de9-5ecd81865d2e	\N	\N	\N	\N
424	606	packages_activity_types	0cffdba8-85de-472a-8214-c64095a200d1	\N	\N	\N	\N
425	607	packages	de809aa6-80af-4e58-bb6a-280db9df6894	{"name":"Paket Sunrise Borobudur + Prambanan","slug":"paket-sunrise-borobudur-prambanan","description":"Penjemputan dini hari (± jam 03.30-04.00); Sunrise di kawasan Candi Borobudur (via Punthuk Setumbu atau tiket sunrise resmi); Tur mobil VW klasik keliling area Borobudur (opsional tambahan)...","duration":"1 Hari (mulai dini hari)","itinerary":["Penjemputan dini hari (± jam 03.30-04.00)","Sunrise di kawasan Candi Borobudur (via Punthuk Setumbu atau tiket sunrise resmi)","Tur mobil VW klasik keliling area Borobudur (opsional tambahan)","Sarapan pagi","Menuju Yogyakarta - kunjungan Candi Prambanan","Pengantaran kembali ke hotel"],"facilities":{"termasuk":["Mobil ber-AC + driver","BBM + parkir + tol","Air mineral"],"tidak_termasuk":["Tiket sunrise Borobudur (terpisah, harga lebih tinggi dari tiket reguler)","Tiket Prambanan","Makan (kecuali disebutkan include)","Tur VW (biaya tambahan jika diambil)"]},"price_tiers":[{"label":"Reguler (gabung open trip, dari Yogyakarta)","price_per_pax":250000,"max_participants":10,"description":"Rp 250.000 - Rp 350.000"},{"label":"Reguler (dari Solo)","price_per_pax":1140000,"max_participants":10,"description":"Sekitar Rp 1.140.000"},{"label":"Private 2-10 orang","price_per_pax":1350000,"max_participants":10,"description":"Rp 1.350.000 - Rp 1.500.000 per kendaraan (dibagi jumlah peserta)"}],"status":"published"}	{"name":"Paket Sunrise Borobudur + Prambanan","slug":"paket-sunrise-borobudur-prambanan","description":"Penjemputan dini hari (± jam 03.30-04.00); Sunrise di kawasan Candi Borobudur (via Punthuk Setumbu atau tiket sunrise resmi); Tur mobil VW klasik keliling area Borobudur (opsional tambahan)...","duration":"1 Hari (mulai dini hari)","itinerary":["Penjemputan dini hari (± jam 03.30-04.00)","Sunrise di kawasan Candi Borobudur (via Punthuk Setumbu atau tiket sunrise resmi)","Tur mobil VW klasik keliling area Borobudur (opsional tambahan)","Sarapan pagi","Menuju Yogyakarta - kunjungan Candi Prambanan","Pengantaran kembali ke hotel"],"facilities":{"termasuk":["Mobil ber-AC + driver","BBM + parkir + tol","Air mineral"],"tidak_termasuk":["Tiket sunrise Borobudur (terpisah, harga lebih tinggi dari tiket reguler)","Tiket Prambanan","Makan (kecuali disebutkan include)","Tur VW (biaya tambahan jika diambil)"]},"price_tiers":[{"label":"Reguler (gabung open trip, dari Yogyakarta)","price_per_pax":250000,"max_participants":10,"description":"Rp 250.000 - Rp 350.000"},{"label":"Reguler (dari Solo)","price_per_pax":1140000,"max_participants":10,"description":"Sekitar Rp 1.140.000"},{"label":"Private 2-10 orang","price_per_pax":1350000,"max_participants":10,"description":"Rp 1.350.000 - Rp 1.500.000 per kendaraan (dibagi jumlah peserta)"}],"status":"published"}	\N	\N
426	608	packages_activity_types	7fcf676c-0936-4255-a3a2-493dc77365fc	\N	\N	\N	\N
427	609	packages_activity_types	0c59b676-5777-4c59-9420-43929bf4bfc8	\N	\N	\N	\N
428	610	packages_activity_types	9b6dcd70-2590-4887-b1b8-a670449438bf	\N	\N	\N	\N
429	611	packages	ca04a086-3ed0-41eb-9a18-03b85618d8c2	{"name":"Paket Wisata Jogja 2 Hari 1 Malam","slug":"paket-wisata-jogja-2-hari-1-malam","description":"Hari 1: Penjemputan - Candi Borobudur - Punthuk Setumbu/Gereja Ayam - Check in hotel - Malioboro malam hari; Hari 2: Candi Prambanan - Tebing Breksi - Keraton Yogyakarta/Taman Sari - Pengantaran pulang...","duration":"2 Hari 1 Malam","itinerary":["Hari 1: Penjemputan - Candi Borobudur - Punthuk Setumbu/Gereja Ayam - Check in hotel - Malioboro malam hari","Hari 2: Candi Prambanan - Tebing Breksi - Keraton Yogyakarta/Taman Sari - Pengantaran pulang"],"facilities":{"termasuk":["Mobil ber-AC + driver + BBM + tol + parkir","Hotel 1 malam","Sarapan di hotel"],"tidak_termasuk":["Tiket masuk objek wisata","Makan siang & malam","Pengeluaran pribadi"]},"price_tiers":[{"label":"2-6 orang","price_per_pax":750000,"max_participants":6,"description":"Rp 750.000 - Rp 1.000.000"},{"label":"7-10 orang","price_per_pax":600000,"max_participants":10,"description":"Rp 600.000 - Rp 800.000"},{"label":"11-20 orang","price_per_pax":500000,"max_participants":20,"description":"Rp 500.000 - Rp 650.000"}],"status":"published"}	{"name":"Paket Wisata Jogja 2 Hari 1 Malam","slug":"paket-wisata-jogja-2-hari-1-malam","description":"Hari 1: Penjemputan - Candi Borobudur - Punthuk Setumbu/Gereja Ayam - Check in hotel - Malioboro malam hari; Hari 2: Candi Prambanan - Tebing Breksi - Keraton Yogyakarta/Taman Sari - Pengantaran pulang...","duration":"2 Hari 1 Malam","itinerary":["Hari 1: Penjemputan - Candi Borobudur - Punthuk Setumbu/Gereja Ayam - Check in hotel - Malioboro malam hari","Hari 2: Candi Prambanan - Tebing Breksi - Keraton Yogyakarta/Taman Sari - Pengantaran pulang"],"facilities":{"termasuk":["Mobil ber-AC + driver + BBM + tol + parkir","Hotel 1 malam","Sarapan di hotel"],"tidak_termasuk":["Tiket masuk objek wisata","Makan siang & malam","Pengeluaran pribadi"]},"price_tiers":[{"label":"2-6 orang","price_per_pax":750000,"max_participants":6,"description":"Rp 750.000 - Rp 1.000.000"},{"label":"7-10 orang","price_per_pax":600000,"max_participants":10,"description":"Rp 600.000 - Rp 800.000"},{"label":"11-20 orang","price_per_pax":500000,"max_participants":20,"description":"Rp 500.000 - Rp 650.000"}],"status":"published"}	\N	\N
430	612	packages_activity_types	7bf181ea-02ae-4734-b539-e564b748ba9e	\N	\N	\N	\N
431	613	packages_activity_types	d950fef8-efc5-42e3-b032-593496b31541	\N	\N	\N	\N
432	614	packages_activity_types	74d69829-4900-4de9-9065-7e44d4eb2e85	\N	\N	\N	\N
433	615	packages_activity_types	1704e9e2-e571-4d49-b08a-25f0d5979b9a	\N	\N	\N	\N
437	619	packages_activity_types	263a31a4-ef31-4505-a4f9-07ca96ef88dc	\N	\N	\N	\N
438	620	packages_activity_types	2e0c63a6-6dc9-4585-a9c8-07fba3c8e5a7	\N	\N	\N	\N
460	643	directus_files	40e833b4-4ed9-4200-be76-9c177d0dd992	{"id":"40e833b4-4ed9-4200-be76-9c177d0dd992","storage":"local","filename_disk":"40e833b4-4ed9-4200-be76-9c177d0dd992.jpg","filename_download":"bandung-region.jpg","title":"Bandung Region","type":"image/jpeg","created_on":"2026-07-14T04:10:10.034Z","modified_on":"2026-07-14T04:10:51.693Z","charset":null,"filesize":"2186820","width":5472,"height":3648,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":{},"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2026-07-14T04:10:51.686Z"}	{"modified_by":"bb454258-7d81-40f6-af80-ad85011fa204","modified_on":"2026-07-14T04:10:51.693Z"}	\N	\N
461	644	directus_files	2dfda479-6830-4483-8bc7-4b37bc99017b	{"storage":"local","title":"Bandung Region","filename_download":"bandung-region.jpg","type":"image/jpeg"}	{"storage":"local","title":"Bandung Region","filename_download":"bandung-region.jpg","type":"image/jpeg"}	\N	\N
443	625	packages	7275cb27-3f9f-492d-b759-cddb9df91b15	{"name":"Paket Tour Bali 3 Hari 2 Malam + Tiket Pesawat","slug":"paket-tour-bali-3-hari-2-malam-tiket-pesawat","description":"Hari 1: Penjemputan Bandara Ngurah Rai - City tour singkat - Check in hotel; Hari 2: Tour Bali (Kintamani/Ubud/Tanah Lot sesuai paket) - Water sport Tanjung Benoa / GWK; Hari 3: Free program pagi - Check out - Antar ke bandara...","duration":"3 Hari 2 Malam","itinerary":["Hari 1: Penjemputan Bandara Ngurah Rai - City tour singkat - Check in hotel","Hari 2: Tour Bali (Kintamani/Ubud/Tanah Lot sesuai paket) - Water sport Tanjung Benoa / GWK","Hari 3: Free program pagi - Check out - Antar ke bandara"],"facilities":{"termasuk":["Tiket pesawat PP","Hotel bintang 3 (2/3 malam sesuai paket)","Mobil ber-AC + BBM + driver as guide","Antar jemput bandara","Tiket parkir & tiket masuk objek wisata","Makan pagi 3x, makan siang 2x, makan malam 2x","Air mineral selama perjalanan","Free Banana Boat / Tiket GWK"],"tidak_termasuk":["Uang tipping","Keperluan pribadi","Trip tambahan ke Nusa Penida (+Rp 325.000/orang jika diambil)"]},"price_tiers":[{"label":"2 orang","price_per_pax":0,"max_participants":2,"description":"Hubungi CS (harga dasar, sebelum diskon grup)"},{"label":"Lebih dari 2 orang","price_per_pax":0,"max_participants":2,"description":"Dapat harga spesial/diskon (nego by CS)"}],"status":"published"}	{"name":"Paket Tour Bali 3 Hari 2 Malam + Tiket Pesawat","slug":"paket-tour-bali-3-hari-2-malam-tiket-pesawat","description":"Hari 1: Penjemputan Bandara Ngurah Rai - City tour singkat - Check in hotel; Hari 2: Tour Bali (Kintamani/Ubud/Tanah Lot sesuai paket) - Water sport Tanjung Benoa / GWK; Hari 3: Free program pagi - Check out - Antar ke bandara...","duration":"3 Hari 2 Malam","itinerary":["Hari 1: Penjemputan Bandara Ngurah Rai - City tour singkat - Check in hotel","Hari 2: Tour Bali (Kintamani/Ubud/Tanah Lot sesuai paket) - Water sport Tanjung Benoa / GWK","Hari 3: Free program pagi - Check out - Antar ke bandara"],"facilities":{"termasuk":["Tiket pesawat PP","Hotel bintang 3 (2/3 malam sesuai paket)","Mobil ber-AC + BBM + driver as guide","Antar jemput bandara","Tiket parkir & tiket masuk objek wisata","Makan pagi 3x, makan siang 2x, makan malam 2x","Air mineral selama perjalanan","Free Banana Boat / Tiket GWK"],"tidak_termasuk":["Uang tipping","Keperluan pribadi","Trip tambahan ke Nusa Penida (+Rp 325.000/orang jika diambil)"]},"price_tiers":[{"label":"2 orang","price_per_pax":0,"max_participants":2,"description":"Hubungi CS (harga dasar, sebelum diskon grup)"},{"label":"Lebih dari 2 orang","price_per_pax":0,"max_participants":2,"description":"Dapat harga spesial/diskon (nego by CS)"}],"status":"published"}	\N	\N
444	626	packages_activity_types	1c7a677e-fe91-4f44-b7db-9735d4059305	\N	\N	\N	\N
445	627	packages_activity_types	45cf7932-8503-42cf-921c-7763d755b28a	\N	\N	\N	\N
446	628	packages_activity_types	94f0f253-d54f-4a97-a44b-66cc51fb6ccd	\N	\N	\N	\N
447	629	packages	2b4724d0-0a1f-49e4-9cdf-ee3f00666ecd	{"name":"Paket Tour Bali Group 3 Hari 2 Malam (Silver)","slug":"paket-tour-bali-group-3-hari-2-malam-silver","description":"Hari 1: Penjemputan - Pilihan Kintamani Tour ATAU Bedugul Tour; Hari 2: Melasti Tour (Pura Tanah Lot, makan malam seafood di Jimbaran); Hari 3: Check out - Antar ke bandara...","duration":"3 Hari 2 Malam","itinerary":["Hari 1: Penjemputan - Pilihan Kintamani Tour ATAU Bedugul Tour","Hari 2: Melasti Tour (Pura Tanah Lot, makan malam seafood di Jimbaran)","Hari 3: Check out - Antar ke bandara"],"facilities":{"termasuk":["Hotel (Euphoria Legian / Siesta Legian bintang 3, atau setara)","Transportasi bus ber-AC + driver","Tiket masuk objek wisata sesuai itinerary","Makan malam seafood di Jimbaran"],"tidak_termasuk":["Tiket pesawat","Makan siang (tergantung paket)","Pengeluaran pribadi"]},"price_tiers":[{"label":"10-15 orang","price_per_pax":1550000,"max_participants":15,"description":"Rp 1.550.000"},{"label":"16-25 orang","price_per_pax":1450000,"max_participants":25,"description":"Rp 1.450.000"},{"label":"26-35 orang","price_per_pax":1370000,"max_participants":35,"description":"Rp 1.370.000"},{"label":"36-45 orang","price_per_pax":1285000,"max_participants":45,"description":"Rp 1.285.000"},{"label":">45 orang","price_per_pax":0,"max_participants":45,"description":"Konsultasi dengan admin"}],"status":"published"}	{"name":"Paket Tour Bali Group 3 Hari 2 Malam (Silver)","slug":"paket-tour-bali-group-3-hari-2-malam-silver","description":"Hari 1: Penjemputan - Pilihan Kintamani Tour ATAU Bedugul Tour; Hari 2: Melasti Tour (Pura Tanah Lot, makan malam seafood di Jimbaran); Hari 3: Check out - Antar ke bandara...","duration":"3 Hari 2 Malam","itinerary":["Hari 1: Penjemputan - Pilihan Kintamani Tour ATAU Bedugul Tour","Hari 2: Melasti Tour (Pura Tanah Lot, makan malam seafood di Jimbaran)","Hari 3: Check out - Antar ke bandara"],"facilities":{"termasuk":["Hotel (Euphoria Legian / Siesta Legian bintang 3, atau setara)","Transportasi bus ber-AC + driver","Tiket masuk objek wisata sesuai itinerary","Makan malam seafood di Jimbaran"],"tidak_termasuk":["Tiket pesawat","Makan siang (tergantung paket)","Pengeluaran pribadi"]},"price_tiers":[{"label":"10-15 orang","price_per_pax":1550000,"max_participants":15,"description":"Rp 1.550.000"},{"label":"16-25 orang","price_per_pax":1450000,"max_participants":25,"description":"Rp 1.450.000"},{"label":"26-35 orang","price_per_pax":1370000,"max_participants":35,"description":"Rp 1.370.000"},{"label":"36-45 orang","price_per_pax":1285000,"max_participants":45,"description":"Rp 1.285.000"},{"label":">45 orang","price_per_pax":0,"max_participants":45,"description":"Konsultasi dengan admin"}],"status":"published"}	\N	\N
448	630	packages_activity_types	4bc59d06-082a-44c2-bbd5-3b59092de610	\N	\N	\N	\N
449	631	packages_activity_types	78c4578d-52a9-411c-b1e1-c3adaff5d5ea	\N	\N	\N	\N
450	632	packages_activity_types	5cffc0f7-4068-4fb6-86be-0056da4082bc	\N	\N	\N	\N
451	633	packages_activity_types	ab057e92-6f6b-41d7-8635-669abc779102	\N	\N	\N	\N
452	634	packages	75c4cb07-e6af-4021-9384-4b45b5a0c0f9	{"name":"Paket Tour Bali Group 5 Hari 4 Malam (Company Gathering)","slug":"paket-tour-bali-group-5-hari-4-malam-company-gathering","description":"Itinerary lengkap mencakup wisata alam, budaya, dan destinasi ikonik Bali (Kintamani, Ubud, Tanah Lot, GWK, Uluwatu, dll - dapat disesuaikan)...","duration":"5 Hari 4 Malam","itinerary":["Itinerary lengkap mencakup wisata alam, budaya, dan destinasi ikonik Bali (Kintamani, Ubud, Tanah Lot, GWK, Uluwatu, dll - dapat disesuaikan)"],"facilities":{"termasuk":["Hotel 4 malam","Transportasi bus/mobil ber-AC + driver","Tiket masuk objek wisata utama","Makan sesuai program"],"tidak_termasuk":["Tiket pesawat","Pengeluaran pribadi","Tip driver/guide"]},"price_tiers":[{"label":"2 orang (per couple)","price_per_pax":2121000,"max_participants":2,"description":"Mulai Rp 2.121.000"},{"label":"Minimal 10 orang","price_per_pax":2121000,"max_participants":10,"description":"Mulai Rp 2.121.000 (harga grup, cenderung lebih murah untuk peserta lebih banyak)"}],"status":"published"}	{"name":"Paket Tour Bali Group 5 Hari 4 Malam (Company Gathering)","slug":"paket-tour-bali-group-5-hari-4-malam-company-gathering","description":"Itinerary lengkap mencakup wisata alam, budaya, dan destinasi ikonik Bali (Kintamani, Ubud, Tanah Lot, GWK, Uluwatu, dll - dapat disesuaikan)...","duration":"5 Hari 4 Malam","itinerary":["Itinerary lengkap mencakup wisata alam, budaya, dan destinasi ikonik Bali (Kintamani, Ubud, Tanah Lot, GWK, Uluwatu, dll - dapat disesuaikan)"],"facilities":{"termasuk":["Hotel 4 malam","Transportasi bus/mobil ber-AC + driver","Tiket masuk objek wisata utama","Makan sesuai program"],"tidak_termasuk":["Tiket pesawat","Pengeluaran pribadi","Tip driver/guide"]},"price_tiers":[{"label":"2 orang (per couple)","price_per_pax":2121000,"max_participants":2,"description":"Mulai Rp 2.121.000"},{"label":"Minimal 10 orang","price_per_pax":2121000,"max_participants":10,"description":"Mulai Rp 2.121.000 (harga grup, cenderung lebih murah untuk peserta lebih banyak)"}],"status":"published"}	\N	\N
453	635	packages_activity_types	1312669d-5cf2-4511-af69-64d3f0eaf14e	\N	\N	\N	\N
454	636	packages_activity_types	0fee5f30-c70b-4a46-adac-7d18c0aa5b32	\N	\N	\N	\N
455	637	packages_activity_types	a71155d1-ac23-4bcf-a499-2e3125b93289	\N	\N	\N	\N
456	638	packages_activity_types	35818cdf-0ab1-47e5-a5de-4d009551c1f0	\N	\N	\N	\N
457	639	packages_activity_types	32c6756b-5e6e-4500-8da6-05d426ded2e1	\N	\N	\N	\N
458	641	directus_files	40e833b4-4ed9-4200-be76-9c177d0dd992	{"storage":"local","title":"Bandung Region","filename_download":"bandung-region.jpg","type":"image/jpeg"}	{"storage":"local","title":"Bandung Region","filename_download":"bandung-region.jpg","type":"image/jpeg"}	\N	\N
459	642	directus_files	40e833b4-4ed9-4200-be76-9c177d0dd992	{"id":"40e833b4-4ed9-4200-be76-9c177d0dd992","storage":"local","filename_disk":"40e833b4-4ed9-4200-be76-9c177d0dd992.jpg","filename_download":"bandung-region.jpg","title":"Bandung Region","type":"image/jpeg","created_on":"2026-07-14T04:10:10.034Z","modified_on":"2026-07-14T04:10:51.653Z","charset":null,"filesize":"3164575","width":4160,"height":3120,"duration":null,"embed":null,"description":null,"location":null,"tags":null,"metadata":{},"focal_point_x":null,"focal_point_y":null,"tus_id":null,"tus_data":null,"uploaded_on":"2026-07-14T04:10:10.090Z"}	{"storage":"local","filename_disk":"40e833b4-4ed9-4200-be76-9c177d0dd992.jpg","filename_download":"bandung-region.jpg","title":"Bandung Region","type":"image/jpeg","folder":null,"description":null,"metadata":{},"modified_by":"bb454258-7d81-40f6-af80-ad85011fa204","modified_on":"2026-07-14T04:10:51.653Z"}	\N	\N
655	1088	settings	6	{"id":6,"key":"address","value":"Jl. Budi No 83, Bandung, Jawa Barat","description":"Alamat kantor"}	{"value":"Jl. Budi No 83, Bandung, Jawa Barat"}	\N	\N
462	645	regions	7607935a-feaa-4a17-a49e-381b0e03ecc1	{"id":"7607935a-feaa-4a17-a49e-381b0e03ecc1","status":"published","date_created":"2026-07-14T04:04:27.647Z","date_updated":"2026-07-14T04:11:27.844Z","name":"Bandung","slug":"bandung","description":"Nikmati pesona Jawa Barat dengan udara sejuk pegunungan, pemandian air panas alami, dan panorama perkebunan teh hijau yang memikat. Destinasi favorit untuk liburan keluarga dan gathering perusahaan dengan beragam pilihan wisata alam, kuliner khas, dan pusat oleh-oleh. Hanya 2-3 jam perjalanan dari Jakarta, Bandung menawarkan liburan yang sempurna untuk semua kalangan."}	{"name":"Bandung","slug":"bandung","description":"Nikmati pesona Jawa Barat dengan udara sejuk pegunungan, pemandian air panas alami, dan panorama perkebunan teh hijau yang memikat. Destinasi favorit untuk liburan keluarga dan gathering perusahaan dengan beragam pilihan wisata alam, kuliner khas, dan pusat oleh-oleh. Hanya 2-3 jam perjalanan dari Jakarta, Bandung menawarkan liburan yang sempurna untuk semua kalangan.","image":"2dfda479-6830-4483-8bc7-4b37bc99017b","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:11:27.844Z"}	\N	\N
463	646	directus_files	5ba000aa-eed9-4d49-a454-a49580cf8c31	{"storage":"local","title":"Kepseribu Region","filename_download":"kepseribu-region.jpg","type":"image/jpeg"}	{"storage":"local","title":"Kepseribu Region","filename_download":"kepseribu-region.jpg","type":"image/jpeg"}	\N	\N
464	647	regions	4dad15db-1ad3-4bae-8304-1274800a84c4	{"id":"4dad15db-1ad3-4bae-8304-1274800a84c4","status":"published","date_created":"2026-07-14T04:04:27.663Z","date_updated":"2026-07-14T04:14:44.769Z","name":"Kepulauan Seribu","slug":"kepulauan-seribu","description":"Surga tropis di utara Jakarta yang menawarkan pasir putih, air laut jernih, dan panorama matahari terbenam yang memukau. Cocok untuk pelarian akhir pekan dari hiruk-pikuk kota — nikmati snorkeling, bersepeda keliling pulau, makan seafood segar, dan bermalam di penginapan tepi pantai dengan suasana yang tenang dan damai."}	{"name":"Kepulauan Seribu","slug":"kepulauan-seribu","description":"Surga tropis di utara Jakarta yang menawarkan pasir putih, air laut jernih, dan panorama matahari terbenam yang memukau. Cocok untuk pelarian akhir pekan dari hiruk-pikuk kota — nikmati snorkeling, bersepeda keliling pulau, makan seafood segar, dan bermalam di penginapan tepi pantai dengan suasana yang tenang dan damai.","image":"5ba000aa-eed9-4d49-a454-a49580cf8c31","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:14:44.769Z"}	\N	\N
465	648	directus_files	469b271b-120d-4cae-8528-92de7d389c5a	{"storage":"local","title":"Yogyakarta Region","filename_download":"yogyakarta-region.jpg","type":"image/jpeg"}	{"storage":"local","title":"Yogyakarta Region","filename_download":"yogyakarta-region.jpg","type":"image/jpeg"}	\N	\N
466	649	regions	75359e6a-68ec-4057-b461-33114ec4b0e5	{"id":"75359e6a-68ec-4057-b461-33114ec4b0e5","status":"published","date_created":"2026-07-14T04:04:27.675Z","date_updated":"2026-07-14T04:16:11.841Z","name":"Yogyakarta","slug":"yogyakarta","description":"Jelajahi keajaiban budaya dan sejarah Jawa di kota istimewa Yogyakarta. Saksikan megahnya Candi Borobudur saat matahari terbit, kagumi keanggunan Candi Prambanan, dan nikmati kehangatan budaya, kuliner malam Malioboro, serta kerajinan batik dan perak yang mendunia. Pengalaman tak terlupakan bagi pencinta sejarah, fotografer, dan keluarga."}	{"name":"Yogyakarta","slug":"yogyakarta","description":"Jelajahi keajaiban budaya dan sejarah Jawa di kota istimewa Yogyakarta. Saksikan megahnya Candi Borobudur saat matahari terbit, kagumi keanggunan Candi Prambanan, dan nikmati kehangatan budaya, kuliner malam Malioboro, serta kerajinan batik dan perak yang mendunia. Pengalaman tak terlupakan bagi pencinta sejarah, fotografer, dan keluarga.","image":"469b271b-120d-4cae-8528-92de7d389c5a","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:16:11.841Z"}	\N	\N
467	650	directus_files	049e1a62-a485-48b1-8e1f-e8986e495d5d	{"storage":"local","title":"Bali Region","filename_download":"bali-region.jpg","type":"image/jpeg"}	{"storage":"local","title":"Bali Region","filename_download":"bali-region.jpg","type":"image/jpeg"}	\N	\N
468	651	regions	b28b63cc-fdcf-4cf0-a422-6222a2af6d09	{"id":"b28b63cc-fdcf-4cf0-a422-6222a2af6d09","status":"published","date_created":"2026-07-14T04:04:27.690Z","date_updated":"2026-07-14T04:17:55.708Z","name":"Bali","slug":"bali","description":"Pulau Dewata yang mendunia dengan keindahan alam, budaya, dan keramahtamahan yang tiada duanya. Dari terasering sawah di Ubud, sunset di Pantai Seminyak, hingga kehidupan malam di Kuta Bali memiliki segalanya. Destinasi utama untuk corporate retreat, team building, honeymoon, dan liburan keluarga dengan akomodasi kelas dunia."}	{"description":"Pulau Dewata yang mendunia dengan keindahan alam, budaya, dan keramahtamahan yang tiada duanya. Dari terasering sawah di Ubud, sunset di Pantai Seminyak, hingga kehidupan malam di Kuta Bali memiliki segalanya. Destinasi utama untuk corporate retreat, team building, honeymoon, dan liburan keluarga dengan akomodasi kelas dunia.","image":"049e1a62-a485-48b1-8e1f-e8986e495d5d","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:17:55.708Z"}	\N	\N
469	758	directus_files	fb28d20c-bd40-4cb6-b4c5-9bc3e34a1e55	{"storage":"local","title":"Lembang","filename_download":"lembang.jpg","type":"image/jpeg"}	{"storage":"local","title":"Lembang","filename_download":"lembang.jpg","type":"image/jpeg"}	\N	\N
470	761	regions	d8da88e3-b0c8-4167-ad44-82baddda2c47	{"name":"Bandung & Sekitarnya (Lembang, Ciwidey)","slug":"bandung-sekitarnya-lembang-ciwidey","status":"published"}	{"name":"Bandung & Sekitarnya (Lembang, Ciwidey)","slug":"bandung-sekitarnya-lembang-ciwidey","status":"published"}	\N	\N
471	762	regions	d3eb9365-e929-413f-a770-e0f491bbeb35	{"name":"Kepulauan Seribu (Pulau Tidung, Pulau Pari, Pulau Payung)","slug":"kepulauan-seribu-pulau-tidung-pulau-pari-pulau-payung","status":"published"}	{"name":"Kepulauan Seribu (Pulau Tidung, Pulau Pari, Pulau Payung)","slug":"kepulauan-seribu-pulau-tidung-pulau-pari-pulau-payung","status":"published"}	\N	\N
472	763	regions	c4b01a33-9919-4dba-b839-c7177bdba873	{"name":"Yogyakarta - Candi Borobudur & Prambanan","slug":"yogyakarta-candi-borobudur-prambanan","status":"published"}	{"name":"Yogyakarta - Candi Borobudur & Prambanan","slug":"yogyakarta-candi-borobudur-prambanan","status":"published"}	\N	\N
473	764	destinations	df99c778-0f0f-44ad-80c3-294fb96ea64d	{"name":"Tangkuban Perahu","slug":"tangkuban-perahu","status":"published"}	{"name":"Tangkuban Perahu","slug":"tangkuban-perahu","status":"published"}	\N	\N
474	765	destinations	231cbb58-8271-4c93-9b46-ba03c0d832a3	{"name":"Kawah Putih","slug":"kawah-putih","status":"published"}	{"name":"Kawah Putih","slug":"kawah-putih","status":"published"}	\N	\N
475	766	destinations	19ef6acd-c355-487e-91a3-6fded9e1dc69	{"name":"Farmhouse Lembang","slug":"farmhouse-lembang","status":"published"}	{"name":"Farmhouse Lembang","slug":"farmhouse-lembang","status":"published"}	\N	\N
476	767	destinations	0147b105-1e9b-42c8-8c23-6151802df6aa	{"name":"The Lodge Maribaya","slug":"the-lodge-maribaya","status":"published"}	{"name":"The Lodge Maribaya","slug":"the-lodge-maribaya","status":"published"}	\N	\N
477	768	destinations	c55f04b5-3634-431d-ad5c-38630f15ecfc	{"name":"Dusun Bambu","slug":"dusun-bambu","status":"published"}	{"name":"Dusun Bambu","slug":"dusun-bambu","status":"published"}	\N	\N
478	769	destinations	5ee96e0d-1462-4f72-b176-efad4bef9391	{"name":"Situ Patenggang","slug":"situ-patenggang","status":"published"}	{"name":"Situ Patenggang","slug":"situ-patenggang","status":"published"}	\N	\N
479	770	destinations	c595bb75-5e74-41a5-b791-a222e4a39865	{"name":"Jalan Braga","slug":"jalan-braga","status":"published"}	{"name":"Jalan Braga","slug":"jalan-braga","status":"published"}	\N	\N
480	771	destinations	b544a207-499b-49ed-abdb-a0db3521e3d2	{"name":"Trans Studio Bandung","slug":"trans-studio-bandung","status":"published"}	{"name":"Trans Studio Bandung","slug":"trans-studio-bandung","status":"published"}	\N	\N
481	772	destinations	8936e20d-e259-48da-a7d0-bcfcc266c948	{"name":"Pulau Tidung (Jembatan Cinta)","slug":"pulau-tidung-jembatan-cinta","status":"published"}	{"name":"Pulau Tidung (Jembatan Cinta)","slug":"pulau-tidung-jembatan-cinta","status":"published"}	\N	\N
482	773	destinations	8d9a8a63-df62-45aa-9412-d4162429f9c7	{"name":"Pulau Pari (Pantai Pasir Perawan)","slug":"pulau-pari-pantai-pasir-perawan","status":"published"}	{"name":"Pulau Pari (Pantai Pasir Perawan)","slug":"pulau-pari-pantai-pasir-perawan","status":"published"}	\N	\N
483	774	destinations	7363992d-f728-43b5-a9e4-8a66b2dd2b22	{"name":"Pulau Payung","slug":"pulau-payung","status":"published"}	{"name":"Pulau Payung","slug":"pulau-payung","status":"published"}	\N	\N
484	775	destinations	b60db3b4-b676-4eaf-b8ae-99ffcc1f318a	{"name":"Pulau Harapan","slug":"pulau-harapan","status":"published"}	{"name":"Pulau Harapan","slug":"pulau-harapan","status":"published"}	\N	\N
485	776	destinations	fef30e82-71f9-4f0c-9a40-f075dc31e149	{"name":"Candi Borobudur","slug":"candi-borobudur","status":"published"}	{"name":"Candi Borobudur","slug":"candi-borobudur","status":"published"}	\N	\N
486	777	destinations	1afd1492-7784-403e-9114-f21ec411db9a	{"name":"Candi Prambanan","slug":"candi-prambanan","status":"published"}	{"name":"Candi Prambanan","slug":"candi-prambanan","status":"published"}	\N	\N
487	778	destinations	f8feeeee-3064-4a45-bb7f-c217b53cc500	{"name":"Ratu Boko","slug":"ratu-boko","status":"published"}	{"name":"Ratu Boko","slug":"ratu-boko","status":"published"}	\N	\N
488	779	destinations	adaae5b7-cb12-4fdf-9db8-5911a7a3b5fa	{"name":"Malioboro","slug":"malioboro","status":"published"}	{"name":"Malioboro","slug":"malioboro","status":"published"}	\N	\N
489	780	destinations	a0040269-2db6-491f-a252-3adf243d9c77	{"name":"Keraton Yogyakarta","slug":"keraton-yogyakarta","status":"published"}	{"name":"Keraton Yogyakarta","slug":"keraton-yogyakarta","status":"published"}	\N	\N
490	781	destinations	847cb845-1913-46a0-b5c5-6729d50aa9af	{"name":"Tebing Breksi","slug":"tebing-breksi","status":"published"}	{"name":"Tebing Breksi","slug":"tebing-breksi","status":"published"}	\N	\N
491	782	destinations	61f016a1-f859-46cf-8ecd-4a6c6039e497	{"name":"Gereja Ayam","slug":"gereja-ayam","status":"published"}	{"name":"Gereja Ayam","slug":"gereja-ayam","status":"published"}	\N	\N
492	783	destinations	c8d1188c-9af9-46b9-90b1-5c6148ea706b	{"name":"Tanah Lot","slug":"tanah-lot","status":"published"}	{"name":"Tanah Lot","slug":"tanah-lot","status":"published"}	\N	\N
493	784	destinations	ee9d815f-01f8-4162-84be-f22b255f2b16	{"name":"Kintamani","slug":"kintamani","status":"published"}	{"name":"Kintamani","slug":"kintamani","status":"published"}	\N	\N
494	785	destinations	dba9e42c-d64d-47b6-9364-049836be2f3f	{"name":"Ubud","slug":"ubud","status":"published"}	{"name":"Ubud","slug":"ubud","status":"published"}	\N	\N
495	786	destinations	0ef85b59-2544-45aa-a524-cbdf05110a4c	{"name":"Tanjung Benoa","slug":"tanjung-benoa","status":"published"}	{"name":"Tanjung Benoa","slug":"tanjung-benoa","status":"published"}	\N	\N
496	787	destinations	84019506-5144-4239-8054-0df777fdc25f	{"name":"GWK","slug":"gwk","status":"published"}	{"name":"GWK","slug":"gwk","status":"published"}	\N	\N
497	788	destinations	2c8caa3f-e00b-449f-8d65-e11d37926e6d	{"name":"Nusa Penida (opsional tambahan)","slug":"nusa-penida-opsional-tambahan","status":"published"}	{"name":"Nusa Penida (opsional tambahan)","slug":"nusa-penida-opsional-tambahan","status":"published"}	\N	\N
498	789	destinations	dded4cf3-3636-431d-bc06-8c503a553d68	{"name":"Bedugul","slug":"bedugul","status":"published"}	{"name":"Bedugul","slug":"bedugul","status":"published"}	\N	\N
499	790	destinations	b09b4ccd-4ef7-4717-8b2a-b083889020b2	{"name":"Uluwatu","slug":"uluwatu","status":"published"}	{"name":"Uluwatu","slug":"uluwatu","status":"published"}	\N	\N
500	798	regions	b28b63cc-fdcf-4cf0-a422-6222a2af6d09	{"id":"b28b63cc-fdcf-4cf0-a422-6222a2af6d09","status":"published","date_created":"2026-07-14T04:04:27.690Z","date_updated":"2026-07-14T04:30:25.034Z","name":"Bali","slug":"bali","description":"Pulau Dewata yang mendunia dengan keindahan alam, budaya, dan keramahtamahan yang tiada duanya. Dari terasering sawah di Ubud, sunset di Pantai Seminyak, hingga kehidupan malam di Kuta — Bali memiliki segalanya. Destinasi utama untuk corporate retreat, team building, honeymoon, dan liburan keluarga dengan akomodasi kelas dunia."}	{"name":"Bali","description":"Pulau Dewata yang mendunia dengan keindahan alam, budaya, dan keramahtamahan yang tiada duanya. Dari terasering sawah di Ubud, sunset di Pantai Seminyak, hingga kehidupan malam di Kuta — Bali memiliki segalanya. Destinasi utama untuk corporate retreat, team building, honeymoon, dan liburan keluarga dengan akomodasi kelas dunia.","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:30:25.034Z"}	\N	\N
501	799	regions	c4b01a33-9919-4dba-b839-c7177bdba873	{"id":"c4b01a33-9919-4dba-b839-c7177bdba873","status":"published","date_created":"2026-07-14T04:27:33.149Z","date_updated":"2026-07-14T04:30:25.052Z","name":"Yogyakarta","slug":"yogyakarta-candi-borobudur-prambanan","description":"Jelajahi keajaiban budaya dan sejarah Jawa di kota istimewa Yogyakarta. Saksikan megahnya Candi Borobudur saat matahari terbit, kagumi keanggunan Candi Prambanan, dan nikmati kehangatan budaya, kuliner malam Malioboro, serta kerajinan batik dan perak yang mendunia. Pengalaman tak terlupakan bagi pencinta sejarah, fotografer, dan keluarga."}	{"name":"Yogyakarta","description":"Jelajahi keajaiban budaya dan sejarah Jawa di kota istimewa Yogyakarta. Saksikan megahnya Candi Borobudur saat matahari terbit, kagumi keanggunan Candi Prambanan, dan nikmati kehangatan budaya, kuliner malam Malioboro, serta kerajinan batik dan perak yang mendunia. Pengalaman tak terlupakan bagi pencinta sejarah, fotografer, dan keluarga.","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:30:25.052Z"}	\N	\N
536	907	directus_fields	141	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
537	909	directus_fields	142	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
656	1089	settings	3	{"id":3,"key":"wa_number","value":"628771002233","description":"Nomor WhatsApp bisnis"}	{"value":"628771002233"}	\N	\N
502	800	regions	d3eb9365-e929-413f-a770-e0f491bbeb35	{"id":"d3eb9365-e929-413f-a770-e0f491bbeb35","status":"published","date_created":"2026-07-14T04:27:33.135Z","date_updated":"2026-07-14T04:30:25.066Z","name":"Kepulauan Seribu","slug":"kepulauan-seribu-pulau-tidung-pulau-pari-pulau-payung","description":"Surga tropis di utara Jakarta yang menawarkan pasir putih, air laut jernih, dan panorama matahari terbenam yang memukau. Cocok untuk pelarian akhir pekan dari hiruk-pikuk kota — nikmati snorkeling, bersepeda keliling pulau, makan seafood segar, dan bermalam di penginapan tepi pantai dengan suasana yang tenang dan damai."}	{"name":"Kepulauan Seribu","description":"Surga tropis di utara Jakarta yang menawarkan pasir putih, air laut jernih, dan panorama matahari terbenam yang memukau. Cocok untuk pelarian akhir pekan dari hiruk-pikuk kota — nikmati snorkeling, bersepeda keliling pulau, makan seafood segar, dan bermalam di penginapan tepi pantai dengan suasana yang tenang dan damai.","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:30:25.066Z"}	\N	\N
503	801	regions	d8da88e3-b0c8-4167-ad44-82baddda2c47	{"id":"d8da88e3-b0c8-4167-ad44-82baddda2c47","status":"published","date_created":"2026-07-14T04:27:33.118Z","date_updated":"2026-07-14T04:30:25.082Z","name":"Bandung","slug":"bandung-sekitarnya-lembang-ciwidey","description":"Nikmati pesona Jawa Barat dengan udara sejuk pegunungan, pemandian air panas alami, dan panorama perkebunan teh hijau yang memikat. Destinasi favorit untuk liburan keluarga dan gathering perusahaan dengan beragam pilihan wisata alam, kuliner khas, dan pusat oleh-oleh. Hanya 2-3 jam perjalanan dari Jakarta, Bandung menawarkan liburan yang sempurna untuk semua kalangan."}	{"name":"Bandung","description":"Nikmati pesona Jawa Barat dengan udara sejuk pegunungan, pemandian air panas alami, dan panorama perkebunan teh hijau yang memikat. Destinasi favorit untuk liburan keluarga dan gathering perusahaan dengan beragam pilihan wisata alam, kuliner khas, dan pusat oleh-oleh. Hanya 2-3 jam perjalanan dari Jakarta, Bandung menawarkan liburan yang sempurna untuk semua kalangan.","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:30:25.082Z"}	\N	\N
504	802	directus_files	e460c166-783d-468c-a72b-fa57019fe90e	{"storage":"local","title":"Yogyakarta Region","filename_download":"yogyakarta-region.jpg","type":"image/jpeg"}	{"storage":"local","title":"Yogyakarta Region","filename_download":"yogyakarta-region.jpg","type":"image/jpeg"}	\N	\N
505	803	regions	c4b01a33-9919-4dba-b839-c7177bdba873	{"id":"c4b01a33-9919-4dba-b839-c7177bdba873","status":"published","date_created":"2026-07-14T04:27:33.149Z","date_updated":"2026-07-14T04:30:52.123Z","name":"Yogyakarta","slug":"yogyakarta","description":"Jelajahi keajaiban budaya dan sejarah Jawa di kota istimewa Yogyakarta. Saksikan megahnya Candi Borobudur saat matahari terbit, kagumi keanggunan Candi Prambanan, dan nikmati kehangatan budaya, kuliner malam Malioboro, serta kerajinan batik dan perak yang mendunia. Pengalaman tak terlupakan bagi pencinta sejarah, fotografer, dan keluarga."}	{"slug":"yogyakarta","image":"e460c166-783d-468c-a72b-fa57019fe90e","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:30:52.123Z"}	\N	\N
506	804	directus_files	a45ff57c-32ed-4fec-8c2c-9fe05b59cd4a	{"storage":"local","title":"Kepseribu Region","filename_download":"kepseribu-region.jpg","type":"image/jpeg"}	{"storage":"local","title":"Kepseribu Region","filename_download":"kepseribu-region.jpg","type":"image/jpeg"}	\N	\N
507	805	regions	d3eb9365-e929-413f-a770-e0f491bbeb35	{"id":"d3eb9365-e929-413f-a770-e0f491bbeb35","status":"published","date_created":"2026-07-14T04:27:33.135Z","date_updated":"2026-07-14T04:31:14.772Z","name":"Kepulauan Seribu","slug":"kepulauan-seribu","description":"Surga tropis di utara Jakarta yang menawarkan pasir putih, air laut jernih, dan panorama matahari terbenam yang memukau. Cocok untuk pelarian akhir pekan dari hiruk-pikuk kota — nikmati snorkeling, bersepeda keliling pulau, makan seafood segar, dan bermalam di penginapan tepi pantai dengan suasana yang tenang dan damai."}	{"slug":"kepulauan-seribu","image":"a45ff57c-32ed-4fec-8c2c-9fe05b59cd4a","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:31:14.772Z"}	\N	\N
508	806	directus_files	0de66444-4238-49ae-a548-4148b5a0c347	{"storage":"local","title":"Bandung Region","filename_download":"bandung-region.jpg","type":"image/jpeg"}	{"storage":"local","title":"Bandung Region","filename_download":"bandung-region.jpg","type":"image/jpeg"}	\N	\N
509	807	regions	d8da88e3-b0c8-4167-ad44-82baddda2c47	{"id":"d8da88e3-b0c8-4167-ad44-82baddda2c47","status":"published","date_created":"2026-07-14T04:27:33.118Z","date_updated":"2026-07-14T04:31:31.539Z","name":"Bandung","slug":"bandung","description":"Nikmati pesona Jawa Barat dengan udara sejuk pegunungan, pemandian air panas alami, dan panorama perkebunan teh hijau yang memikat. Destinasi favorit untuk liburan keluarga dan gathering perusahaan dengan beragam pilihan wisata alam, kuliner khas, dan pusat oleh-oleh. Hanya 2-3 jam perjalanan dari Jakarta, Bandung menawarkan liburan yang sempurna untuk semua kalangan."}	{"slug":"bandung","image":"0de66444-4238-49ae-a548-4148b5a0c347","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:31:31.539Z"}	\N	\N
510	839	regions	d3eb9365-e929-413f-a770-e0f491bbeb35	{"id":"d3eb9365-e929-413f-a770-e0f491bbeb35","status":"published","date_created":"2026-07-14T04:27:33.135Z","date_updated":"2026-07-14T04:56:44.972Z","name":"Kepulauan Seribu (Pulau Penduduk)","slug":"kepulauan-seribu-penduduk","description":"Rasakan hangatnya petualangan otentik di Pulau Penduduk Kepulauan Seribu, di mana keindahan alam berpadu harmonis dengan kearifan lokal masyarakat pesisir. Destinasi ini menjadi pilihan sempurna bagi Anda yang ingin menikmati liburan seru namun ramah di kantong, lengkap dengan keseruan aktivitas water sport, snorkeling di terumbu karang yang indah, hingga berburu kuliner laut segar langsung dari nelayan setempat. Menjelajahi keramahan gang-gang kecil pulau dan menyaksikan matahari terbenam bersama warga lokal akan memberikan Anda pengalaman liburan yang hidup, hangat, dan tak terlupakan."}	{"name":"Kepulauan Seribu (Pulau Penduduk)","slug":"kepulauan-seribu-penduduk","description":"Rasakan hangatnya petualangan otentik di Pulau Penduduk Kepulauan Seribu, di mana keindahan alam berpadu harmonis dengan kearifan lokal masyarakat pesisir. Destinasi ini menjadi pilihan sempurna bagi Anda yang ingin menikmati liburan seru namun ramah di kantong, lengkap dengan keseruan aktivitas water sport, snorkeling di terumbu karang yang indah, hingga berburu kuliner laut segar langsung dari nelayan setempat. Menjelajahi keramahan gang-gang kecil pulau dan menyaksikan matahari terbenam bersama warga lokal akan memberikan Anda pengalaman liburan yang hidup, hangat, dan tak terlupakan.","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T04:56:44.972Z"}	\N	\N
511	840	directus_files	40ae6b39-86a0-4814-a1e1-85f147754ae7	{"storage":"local","title":"Kepseribu Region","filename_download":"kepseribu-region.jpg","type":"image/jpeg"}	{"storage":"local","title":"Kepseribu Region","filename_download":"kepseribu-region.jpg","type":"image/jpeg"}	\N	\N
566	972	directus_files	96c0bc18-ba54-4173-b78c-2910338c56e2	{"storage":"local","title":"Pulau Harapan","filename_download":"pulau harapan.png","type":"image/png"}	{"storage":"local","title":"Pulau Harapan","filename_download":"pulau harapan.png","type":"image/png"}	\N	\N
512	841	regions	5ec5476a-aad9-4b36-a20e-23b5f8dc7347	{"name":"Kepulauan Seribu (Pulau Resort)","slug":"kepulauan-seribu-resort","description":"Wujudkan pelarian mewah yang privat dan eksklusif di Pulau Resort Kepulauan Seribu, sebuah surga tersembunyi yang menawarkan ketenangan mutlak jauh dari hiruk-pikuk ibu kota. Manjakan diri Anda dengan fasilitas kelas dunia, mulai dari menginap di cottage apung yang estetik, menikmati layanan spa tepi pantai, hingga bersantai di pasir putih bersih yang dikelilingi laut jernih berkilau layaknya kristal. Sangat cocok untuk momen honeymoon, liburan keluarga premium, atau self-healing, pulau resort siap memberikan Anda privasi penuh dan kemewahan alami yang memulihkan raga dan jiwa.","status":"published"}	{"name":"Kepulauan Seribu (Pulau Resort)","slug":"kepulauan-seribu-resort","description":"Wujudkan pelarian mewah yang privat dan eksklusif di Pulau Resort Kepulauan Seribu, sebuah surga tersembunyi yang menawarkan ketenangan mutlak jauh dari hiruk-pikuk ibu kota. Manjakan diri Anda dengan fasilitas kelas dunia, mulai dari menginap di cottage apung yang estetik, menikmati layanan spa tepi pantai, hingga bersantai di pasir putih bersih yang dikelilingi laut jernih berkilau layaknya kristal. Sangat cocok untuk momen honeymoon, liburan keluarga premium, atau self-healing, pulau resort siap memberikan Anda privasi penuh dan kemewahan alami yang memulihkan raga dan jiwa.","status":"published"}	\N	\N
513	847	directus_fields	72	{"id":72,"field":"region_id","special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}","enableCreate":false},"display":"related-values","display_options":{"template":"{{name}}"},"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"region_id","interface":"select-dropdown-m2o","options":{"template":"{{name}}","enableCreate":false},"display":"related-values","display_options":{"template":"{{name}}"}}	\N	\N
514	853	directus_fields	124	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
515	854	directus_collections	test_collection_123	{"singleton":false,"collection":"test_collection_123"}	{"singleton":false,"collection":"test_collection_123"}	\N	\N
516	858	directus_fields	125	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
517	859	directus_collections	destinations_gallery_images	{"singleton":false,"sort":1,"collection":"destinations_gallery_images"}	{"singleton":false,"sort":1,"collection":"destinations_gallery_images"}	\N	\N
518	860	directus_fields	126	{"sort":2,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"},"field":"destination_id"}	{"sort":2,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"},"field":"destination_id"}	\N	\N
519	861	directus_fields	127	{"sort":3,"special":["m2o"],"interface":"file-image","field":"directus_files_id"}	{"sort":3,"special":["m2o"],"interface":"file-image","field":"directus_files_id"}	\N	\N
520	862	directus_fields	128	{"sort":4,"interface":"input","hidden":true,"field":"sort"}	{"sort":4,"interface":"input","hidden":true,"field":"sort"}	\N	\N
521	863	directus_fields	129	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
522	864	directus_fields	130	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
523	865	directus_collections	packages_gallery_images	{"singleton":false,"sort":1,"collection":"packages_gallery_images"}	{"singleton":false,"sort":1,"collection":"packages_gallery_images"}	\N	\N
524	866	directus_fields	131	{"sort":2,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"},"field":"package_id"}	{"sort":2,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"},"field":"package_id"}	\N	\N
525	867	directus_fields	132	{"sort":3,"special":["m2o"],"interface":"file-image","field":"directus_files_id"}	{"sort":3,"special":["m2o"],"interface":"file-image","field":"directus_files_id"}	\N	\N
526	868	directus_fields	133	{"sort":4,"interface":"input","hidden":true,"field":"sort"}	{"sort":4,"interface":"input","hidden":true,"field":"sort"}	\N	\N
527	869	directus_fields	134	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
528	881	directus_fields	135	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
529	883	directus_fields	136	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
530	889	directus_fields	126	{"id":126,"field":"destination_id","special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations_gallery_images","field":"destination_id","special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"}}	\N	\N
531	890	directus_fields	131	{"id":131,"field":"package_id","special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages_gallery_images","field":"package_id","special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"}}	\N	\N
532	896	directus_fields	137	{"sort":2,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"},"field":"destination_id"}	{"sort":2,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"},"field":"destination_id"}	\N	\N
533	897	directus_fields	138	{"sort":2,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"},"field":"package_id"}	{"sort":2,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{name}}"},"field":"package_id"}	\N	\N
534	902	directus_fields	139	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
535	903	directus_fields	140	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
538	914	directus_fields	141	{"id":141,"field":"gallery","special":["m2m"],"interface":"files","options":{},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":20,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"gallery","note":null}	\N	\N
539	915	directus_fields	142	{"id":142,"field":"gallery","special":["m2m"],"interface":"files","options":{},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":20,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"gallery","note":null}	\N	\N
540	930	directus_fields	143	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
541	931	directus_collections	destinations_gallery_images	{"singleton":false,"note":"Gallery junction table","collection":"destinations_gallery_images"}	{"singleton":false,"note":"Gallery junction table","collection":"destinations_gallery_images"}	\N	\N
542	932	directus_fields	144	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
543	933	directus_collections	packages_gallery_images	{"singleton":false,"note":"Gallery junction table","collection":"packages_gallery_images"}	{"singleton":false,"note":"Gallery junction table","collection":"packages_gallery_images"}	\N	\N
544	934	directus_fields	145	{"sort":1,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{id}}"},"field":"destination_id"}	{"sort":1,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{id}}"},"field":"destination_id"}	\N	\N
545	935	directus_fields	146	{"sort":2,"special":["m2o"],"interface":"file-image","field":"directus_files_id"}	{"sort":2,"special":["m2o"],"interface":"file-image","field":"directus_files_id"}	\N	\N
546	936	directus_fields	147	{"sort":3,"interface":"input","hidden":true,"field":"sort"}	{"sort":3,"interface":"input","hidden":true,"field":"sort"}	\N	\N
547	937	directus_fields	148	{"sort":1,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{id}}"},"field":"package_id"}	{"sort":1,"special":["m2o"],"interface":"select-dropdown-m2o","options":{"template":"{{id}}"},"field":"package_id"}	\N	\N
548	938	directus_fields	149	{"sort":2,"special":["m2o"],"interface":"file-image","field":"directus_files_id"}	{"sort":2,"special":["m2o"],"interface":"file-image","field":"directus_files_id"}	\N	\N
549	939	directus_fields	150	{"sort":3,"interface":"input","hidden":true,"field":"sort"}	{"sort":3,"interface":"input","hidden":true,"field":"sort"}	\N	\N
550	940	directus_fields	151	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
551	941	directus_fields	152	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
552	944	directus_fields	153	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
553	945	directus_collections	packages_gallery_images	{"singleton":false,"collection":"packages_gallery_images"}	{"singleton":false,"collection":"packages_gallery_images"}	\N	\N
554	947	directus_fields	154	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
555	948	directus_fields	155	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
556	952	directus_fields	174	{"id":174,"field":"gallery","special":["m2m"],"interface":"files","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":20,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"gallery","special":["m2m"],"interface":"files","sort":20,"width":"full"}	\N	\N
557	953	directus_fields	175	{"id":175,"field":"gallery","special":["m2m"],"interface":"files","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":20,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"gallery","special":["m2m"],"interface":"files","sort":20,"width":"full"}	\N	\N
558	956	directus_fields	176	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
559	957	directus_collections	packages_gallery_images	{"singleton":false,"collection":"packages_gallery_images"}	{"singleton":false,"collection":"packages_gallery_images"}	\N	\N
560	959	directus_fields	177	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
561	960	directus_fields	178	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	{"sort":20,"special":["m2m"],"interface":"files","options":{},"width":"full","field":"gallery"}	\N	\N
562	967	directus_fields	189	{"interface":"files","special":["json"],"width":"full","sort":20,"field":"gallery"}	{"interface":"files","special":["json"],"width":"full","sort":20,"field":"gallery"}	\N	\N
563	968	directus_fields	190	{"interface":"files","special":["json"],"width":"full","sort":20,"field":"gallery"}	{"interface":"files","special":["json"],"width":"full","sort":20,"field":"gallery"}	\N	\N
564	970	directus_fields	189	{"id":189,"field":"gallery","special":["json"],"interface":"json","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":20,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"destinations","field":"gallery","special":["json"],"interface":"json","sort":20,"width":"full"}	\N	\N
565	971	directus_fields	190	{"id":190,"field":"gallery","special":["json"],"interface":"json","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":20,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"gallery","special":["json"],"interface":"json","sort":20,"width":"full"}	\N	\N
567	973	destinations	9e57cb99-472b-4605-bc3d-952a1e0a75ba	{"status":"published","name":"Pulau Harapan","slug":"pulau-harapan","description":"Jelajahi pesona bawah laut yang menakjubkan di Pulau Harapan, surga bagi para pencinta snorkeling dan petualangan tropis di Kepulauan Seribu! Terkenal dengan akses mudah untuk island hopping ke pulau-pulau tak berpenghuni di sekitarnya, pulau ini menawarkan hamparan pasir putih yang lembut, air laut jernih sebiru kristal, serta terumbu karang yang masih sangat alami dan terjaga. Sangat cocok untuk Anda yang mendambakan liburan aktif nan seru—mulai dari berenang, berburu matahari terbenam yang magis, hingga melihat langsung penangkaran penyu—semuanya dikemas dalam suasana pulau yang hangat dan ramah di kantong."}	{"status":"published","name":"Pulau Harapan","slug":"pulau-harapan","description":"Jelajahi pesona bawah laut yang menakjubkan di Pulau Harapan, surga bagi para pencinta snorkeling dan petualangan tropis di Kepulauan Seribu! Terkenal dengan akses mudah untuk island hopping ke pulau-pulau tak berpenghuni di sekitarnya, pulau ini menawarkan hamparan pasir putih yang lembut, air laut jernih sebiru kristal, serta terumbu karang yang masih sangat alami dan terjaga. Sangat cocok untuk Anda yang mendambakan liburan aktif nan seru—mulai dari berenang, berburu matahari terbenam yang magis, hingga melihat langsung penangkaran penyu—semuanya dikemas dalam suasana pulau yang hangat dan ramah di kantong."}	\N	\N
568	974	destinations	9e57cb99-472b-4605-bc3d-952a1e0a75ba	{"id":"9e57cb99-472b-4605-bc3d-952a1e0a75ba","status":"published","date_created":"2026-07-14T06:46:38.975Z","date_updated":"2026-07-14T06:47:01.558Z","name":"Pulau Harapan","slug":"pulau-harapan","description":"Pulau Harapan merupakan salah satu pulau penduduk di Kepulauan Seribu yang terkenal dengan aktivitas snorkeling, island hopping, dan wisata bahari. Pulau ini memiliki suasana lokal yang lebih tenang dibanding beberapa pulau wisata populer lainnya, dengan pilihan homestay warga sebagai akomodasi utama. Pulau Harapan cocok untuk wisata keluarga, komunitas, pasangan, maupun rombongan yang ingin menikmati keindahan laut Kepulauan Seribu dengan harga lebih terjangkau.","gallery":null}	{"description":"Pulau Harapan merupakan salah satu pulau penduduk di Kepulauan Seribu yang terkenal dengan aktivitas snorkeling, island hopping, dan wisata bahari. Pulau ini memiliki suasana lokal yang lebih tenang dibanding beberapa pulau wisata populer lainnya, dengan pilihan homestay warga sebagai akomodasi utama. Pulau Harapan cocok untuk wisata keluarga, komunitas, pasangan, maupun rombongan yang ingin menikmati keindahan laut Kepulauan Seribu dengan harga lebih terjangkau.","user_updated":"bb454258-7d81-40f6-af80-ad85011fa204","date_updated":"2026-07-14T06:47:01.558Z"}	\N	\N
569	975	directus_files	7af52fd4-e747-4133-8b4a-2522506f8c2f	{"storage":"local","title":"Pulau Harapan","filename_download":"pulau harapan.png","type":"image/png"}	{"storage":"local","title":"Pulau Harapan","filename_download":"pulau harapan.png","type":"image/png"}	\N	\N
570	977	directus_fields	114	{"id":114,"field":"facilities","special":["cast-json"],"interface":"json","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"facilities","special":["cast-json"],"interface":"json","sort":9,"width":"full"}	\N	\N
571	978	packages	777316e5-1db9-4ed7-abb2-3686dc8435ba	{"name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","slug":"paket-wisata-pulau-harapan-dua-hari-satu-malam","description":"Paket wisata menginap selama 2 hari 1 malam yang dirancang untuk menikmati keindahan Pulau Harapan dan aktivitas wisata bahari. Paket meliputi penginapan homestay, snorkeling, island hopping, BBQ malam, serta kunjungan ke beberapa spot wisata di sekitar Pulau Harapan. Cocok untuk keluarga, rombongan teman, komunitas, maupun perusahaan yang menginginkan liburan santai dengan fasilitas lengkap.","duration":"2 Hari 1 Malam","itinerary":[{"day":1,"title":"Arrival & Island Adventure","activities":["Berkumpul di Marina Ancol atau Kali Adem","Berangkat menuju Pulau Harapan","Check-in homestay","Makan siang","Snorkeling","Island hopping","Menikmati sunset","BBQ dinner","Istirahat"]},{"day":2,"title":"Morning Escape","activities":["Sunrise","Sarapan","Aktivitas bebas","Foto-foto di Pulau Harapan","Check-out homestay","Kembali ke Jakarta"]}],"price_tiers":[{"min_pax":2,"max_pax":10,"price_per_pax":850000,"description":"Weekday"},{"min_pax":2,"max_pax":10,"price_per_pax":980000,"description":"Weekend"},{"min_pax":11,"max_pax":20,"price_per_pax":650000,"description":"Weekday"},{"min_pax":11,"max_pax":20,"price_per_pax":750000,"description":"Weekend"},{"min_pax":21,"max_pax":30,"price_per_pax":500000,"description":"Weekday"},{"min_pax":21,"max_pax":30,"price_per_pax":600000,"description":"Weekend"},{"min_pax":31,"max_pax":null,"price_per_pax":null,"description":"Hubungi CS"}],"facilities":["Transportasi kapal PP","Homestay","Makan sesuai program","BBQ","Guide","Peralatan snorkeling","Life jacket","Dokumentasi underwater"],"status":"published"}	{"name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","slug":"paket-wisata-pulau-harapan-dua-hari-satu-malam","description":"Paket wisata menginap selama 2 hari 1 malam yang dirancang untuk menikmati keindahan Pulau Harapan dan aktivitas wisata bahari. Paket meliputi penginapan homestay, snorkeling, island hopping, BBQ malam, serta kunjungan ke beberapa spot wisata di sekitar Pulau Harapan. Cocok untuk keluarga, rombongan teman, komunitas, maupun perusahaan yang menginginkan liburan santai dengan fasilitas lengkap.","duration":"2 Hari 1 Malam","itinerary":[{"day":1,"title":"Arrival & Island Adventure","activities":["Berkumpul di Marina Ancol atau Kali Adem","Berangkat menuju Pulau Harapan","Check-in homestay","Makan siang","Snorkeling","Island hopping","Menikmati sunset","BBQ dinner","Istirahat"]},{"day":2,"title":"Morning Escape","activities":["Sunrise","Sarapan","Aktivitas bebas","Foto-foto di Pulau Harapan","Check-out homestay","Kembali ke Jakarta"]}],"price_tiers":[{"min_pax":2,"max_pax":10,"price_per_pax":850000,"description":"Weekday"},{"min_pax":2,"max_pax":10,"price_per_pax":980000,"description":"Weekend"},{"min_pax":11,"max_pax":20,"price_per_pax":650000,"description":"Weekday"},{"min_pax":11,"max_pax":20,"price_per_pax":750000,"description":"Weekend"},{"min_pax":21,"max_pax":30,"price_per_pax":500000,"description":"Weekday"},{"min_pax":21,"max_pax":30,"price_per_pax":600000,"description":"Weekend"},{"min_pax":31,"max_pax":null,"price_per_pax":null,"description":"Hubungi CS"}],"facilities":["Transportasi kapal PP","Homestay","Makan sesuai program","BBQ","Guide","Peralatan snorkeling","Life jacket","Dokumentasi underwater"],"status":"published"}	\N	\N
572	979	packages_activity_types	4c59c05b-81cc-4c0d-975d-287c85af1817	\N	\N	\N	\N
573	980	packages_activity_types	1af7d43f-492c-4301-975b-6a4e2e7bb0b6	\N	\N	\N	\N
574	981	searches	30	{"ip_hash":"vmritrtl14oew"}	{"ip_hash":"vmritrtl14oew"}	\N	\N
575	982	searches	31	{"activity_type_name":"corporate-gathering","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"corporate-gathering","ip_hash":"vmritrtl14oew"}	\N	\N
576	983	searches	32	{"activity_type_name":"private-trip","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"private-trip","ip_hash":"vmritrtl14oew"}	\N	\N
577	984	searches	33	{"activity_type_name":"private-trip","query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"private-trip","query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	\N	\N
578	985	searches	34	{"activity_type_name":"open-trip","pax_count":5,"travel_date":"2026-07-15","query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"open-trip","pax_count":5,"travel_date":"2026-07-15","query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	\N	\N
579	986	searches	35	{"activity_type_name":"open-trip","pax_count":5,"query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"open-trip","pax_count":5,"query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	\N	\N
580	993	searches	36	{"activity_type_name":"open-trip","query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"open-trip","query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	\N	\N
581	994	searches	37	{"activity_type_name":"corporate-gathering","query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"corporate-gathering","query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	\N	\N
582	995	searches	38	{"activity_type_name":"corporate-gathering","query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"corporate-gathering","query":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","destination_name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","ip_hash":"vmritrtl14oew"}	\N	\N
583	997	directus_fields	191	{"sort":21,"special":["o2m"],"interface":"list-o2m","options":{"fields":["activity_type_id"],"template":"{{ activity_type_id.name }}"},"width":"full","field":"activity_types"}	{"sort":21,"special":["o2m"],"interface":"list-o2m","options":{"fields":["activity_type_id"],"template":"{{ activity_type_id.name }}"},"width":"full","field":"activity_types"}	\N	\N
584	1000	directus_fields	192	{"sort":21,"special":["o2m"],"interface":"list-o2m","options":{"fields":["activity_type_id"],"template":"{{ activity_type_id.name }}"},"width":"full","field":"activity_types"}	{"sort":21,"special":["o2m"],"interface":"list-o2m","options":{"fields":["activity_type_id"],"template":"{{ activity_type_id.name }}"},"width":"full","field":"activity_types"}	\N	\N
585	1003	directus_fields	193	{"sort":21,"special":["o2m"],"interface":"list-o2m","options":{"fields":["activity_type_id.activity_type_id.slug"],"template":"{{ activity_type_id.name }}"},"width":"full","field":"activity_types"}	{"sort":21,"special":["o2m"],"interface":"list-o2m","options":{"fields":["activity_type_id.activity_type_id.slug"],"template":"{{ activity_type_id.name }}"},"width":"full","field":"activity_types"}	\N	\N
586	1006	searches	39	{"activity_type_name":"corporate-gathering","query":"Pulau Harapan","destination_name":"Pulau Harapan","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"corporate-gathering","query":"Pulau Harapan","destination_name":"Pulau Harapan","ip_hash":"vmritrtl14oew"}	\N	\N
587	1007	searches	40	{"activity_type_name":"honeymoon-pasangan","query":"Pulau Harapan","destination_name":"Pulau Harapan","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"honeymoon-pasangan","query":"Pulau Harapan","destination_name":"Pulau Harapan","ip_hash":"vmritrtl14oew"}	\N	\N
588	1008	directus_fields	112	{"id":112,"field":"itinerary","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"day","name":"day","type":"integer","meta":{"field":"day","width":"half","type":"integer","required":true,"note":"Angka hari ke sekian contoh \\"1\\"","interface":"input","options":{"placeholder":"Hari (Contoh : 1)"}}},{"field":"title","name":"title","type":"string","meta":{"field":"title","width":"half","type":"string","note":null,"interface":"input","options":{"placeholder":"Judul Hari (Contoh : Arrival & Island Adventure)"}}},{"field":"activities","name":"activities","type":"json","meta":{"field":"activities","width":"full","type":"json","required":true,"interface":"tags","options":{"presets":[],"placeholder":"Isi dengan kegiatan (Contoh : Check-in homestay)"}}}],"template":"Day {{ day }}: {{ title }}","sort":"day"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"itinerary","interface":"list","options":{"fields":[{"field":"day","name":"day","type":"integer","meta":{"field":"day","width":"half","type":"integer","required":true,"note":"Angka hari ke sekian contoh \\"1\\"","interface":"input","options":{"placeholder":"Hari (Contoh : 1)"}}},{"field":"title","name":"title","type":"string","meta":{"field":"title","width":"half","type":"string","note":null,"interface":"input","options":{"placeholder":"Judul Hari (Contoh : Arrival & Island Adventure)"}}},{"field":"activities","name":"activities","type":"json","meta":{"field":"activities","width":"full","type":"json","required":true,"interface":"tags","options":{"presets":[],"placeholder":"Isi dengan kegiatan (Contoh : Check-in homestay)"}}}],"template":"Day {{ day }}: {{ title }}","sort":"day"}}	\N	\N
589	1009	packages	777316e5-1db9-4ed7-abb2-3686dc8435ba	{"id":"777316e5-1db9-4ed7-abb2-3686dc8435ba","name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","slug":"paket-wisata-pulau-harapan-dua-hari-satu-malam","description":"Paket wisata menginap selama 2 hari 1 malam yang dirancang untuk menikmati keindahan Pulau Harapan dan aktivitas wisata bahari. Paket meliputi penginapan homestay, snorkeling, island hopping, BBQ malam, serta kunjungan ke beberapa spot wisata di sekitar Pulau Harapan. Cocok untuk keluarga, rombongan teman, komunitas, maupun perusahaan yang menginginkan liburan santai dengan fasilitas lengkap.","duration":"2 Hari 1 Malam","itinerary":[{"day":1,"title":"Arrival & Island Adventure","activities":["Berkumpul di Marina Ancol atau Kali Adem","Berangkat menuju Pulau Harapan","Check-in homestay","Makan siang","Snorkeling","Island hopping","Menikmati sunset","BBQ dinner","Istirahat"]},{"day":2,"title":"Morning Escape","activities":["Sunrise","Sarapan","Aktivitas bebas","Foto-foto di Pulau Harapan","Check-out homestay","Kembali ke Jakarta"]},{"day":3,"title":"Bermain Gala Gala","activities":["Gala satu","gala dua","gala tiga","hahaha"]}],"price_tiers":[{"min_pax":2,"max_pax":10,"price_per_pax":850000,"description":"Weekday"},{"min_pax":2,"max_pax":10,"price_per_pax":980000,"description":"Weekend"},{"min_pax":11,"max_pax":20,"price_per_pax":650000,"description":"Weekday"},{"min_pax":11,"max_pax":20,"price_per_pax":750000,"description":"Weekend"},{"min_pax":21,"max_pax":30,"price_per_pax":500000,"description":"Weekday"},{"min_pax":21,"max_pax":30,"price_per_pax":600000,"description":"Weekend"},{"min_pax":31,"max_pax":null,"price_per_pax":null,"description":"Hubungi CS"}],"facilities":["Transportasi kapal PP","Homestay","Makan sesuai program","BBQ","Guide","Peralatan snorkeling","Life jacket","Dokumentasi underwater"],"status":"published","gallery":null}	{"itinerary":[{"day":1,"title":"Arrival & Island Adventure","activities":["Berkumpul di Marina Ancol atau Kali Adem","Berangkat menuju Pulau Harapan","Check-in homestay","Makan siang","Snorkeling","Island hopping","Menikmati sunset","BBQ dinner","Istirahat"]},{"day":2,"title":"Morning Escape","activities":["Sunrise","Sarapan","Aktivitas bebas","Foto-foto di Pulau Harapan","Check-out homestay","Kembali ke Jakarta"]},{"day":3,"title":"Bermain Gala Gala","activities":["Gala satu","gala dua","gala tiga","hahaha"]}]}	\N	\N
590	1010	packages	777316e5-1db9-4ed7-abb2-3686dc8435ba	{"id":"777316e5-1db9-4ed7-abb2-3686dc8435ba","name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","slug":"paket-wisata-pulau-harapan-dua-hari-satu-malam","description":"Paket wisata menginap selama 2 hari 1 malam yang dirancang untuk menikmati keindahan Pulau Harapan dan aktivitas wisata bahari. Paket meliputi penginapan homestay, snorkeling, island hopping, BBQ malam, serta kunjungan ke beberapa spot wisata di sekitar Pulau Harapan. Cocok untuk keluarga, rombongan teman, komunitas, maupun perusahaan yang menginginkan liburan santai dengan fasilitas lengkap.","duration":"2 Hari 1 Malam","itinerary":[{"day":1,"title":"Arrival & Island Adventure","activities":["Berkumpul di Marina Ancol atau Kali Adem","Berangkat menuju Pulau Harapan","Check-in homestay","Makan siang","Snorkeling","Island hopping","Menikmati sunset","BBQ dinner","Istirahat"]},{"day":2,"title":"Morning Escape","activities":["Sunrise","Sarapan","Aktivitas bebas","Foto-foto di Pulau Harapan","Check-out homestay","Kembali ke Jakarta"]}],"price_tiers":[{"min_pax":2,"max_pax":10,"price_per_pax":850000,"description":"Weekday"},{"min_pax":2,"max_pax":10,"price_per_pax":980000,"description":"Weekend"},{"min_pax":11,"max_pax":20,"price_per_pax":650000,"description":"Weekday"},{"min_pax":11,"max_pax":20,"price_per_pax":750000,"description":"Weekend"},{"min_pax":21,"max_pax":30,"price_per_pax":500000,"description":"Weekday"},{"min_pax":21,"max_pax":30,"price_per_pax":600000,"description":"Weekend"},{"min_pax":31,"max_pax":null,"price_per_pax":null,"description":"Hubungi CS"}],"facilities":["Transportasi kapal PP","Homestay","Makan sesuai program","BBQ","Guide","Peralatan snorkeling","Life jacket","Dokumentasi underwater"],"status":"published","gallery":null}	{"itinerary":[{"day":1,"title":"Arrival & Island Adventure","activities":["Berkumpul di Marina Ancol atau Kali Adem","Berangkat menuju Pulau Harapan","Check-in homestay","Makan siang","Snorkeling","Island hopping","Menikmati sunset","BBQ dinner","Istirahat"]},{"day":2,"title":"Morning Escape","activities":["Sunrise","Sarapan","Aktivitas bebas","Foto-foto di Pulau Harapan","Check-out homestay","Kembali ke Jakarta"]}]}	\N	\N
591	1011	directus_fields	114	{"id":114,"field":"facilities","special":["cast-json"],"interface":"tags","options":{"placeholder":"Isi dengan Fasilitas yang disediakan","whitespace":null,"capitalization":"auto-format"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"facilities","interface":"tags","options":{"placeholder":"Isi dengan Fasilitas yang disediakan","whitespace":null,"capitalization":"auto-format"}}	\N	\N
592	1012	directus_fields	113	{"id":113,"field":"price_tiers","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"min_pax","name":"min_pax","type":"integer","meta":{"field":"min_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Jumlah minimum peserta"}}},{"field":"max_pax","name":"max_pax","type":"integer","meta":{"field":"max_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Jumlah maksimum peserta"}}},{"field":"price_per_pax","name":"price_per_pax","type":"integer","meta":{"field":"price_per_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Harga paket"}}},{"field":"description","name":"description","type":"string","meta":{"field":"description","width":"half","type":"string","interface":"select-dropdown","options":{"choices":[{"text":"Weekend","value":"Weekend"},{"text":"Weekday","value":"Weekday"},{"text":"Hubungi CS","value":"Hubungi CS"}]}}}],"template":"{{ description }} ({{ min_pax }} - {{ max_pax }} Pax): Rp {{ price_per_pax }}","sort":"min_pax"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"price_tiers","interface":"list","options":{"fields":[{"field":"min_pax","name":"min_pax","type":"integer","meta":{"field":"min_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Jumlah minimum peserta"}}},{"field":"max_pax","name":"max_pax","type":"integer","meta":{"field":"max_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Jumlah maksimum peserta"}}},{"field":"price_per_pax","name":"price_per_pax","type":"integer","meta":{"field":"price_per_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Harga paket"}}},{"field":"description","name":"description","type":"string","meta":{"field":"description","width":"half","type":"string","interface":"select-dropdown","options":{"choices":[{"text":"Weekend","value":"Weekend"},{"text":"Weekday","value":"Weekday"},{"text":"Hubungi CS","value":"Hubungi CS"}]}}}],"template":"{{ description }} ({{ min_pax }} - {{ max_pax }} Pax): Rp {{ price_per_pax }}","sort":"min_pax"}}	\N	\N
593	1013	directus_fields	113	{"id":113,"field":"price_tiers","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"min_pax","name":"min_pax","type":"integer","meta":{"field":"min_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Jumlah minimum peserta"}}},{"field":"max_pax","name":"max_pax","type":"integer","meta":{"field":"max_pax","width":"half","type":"integer","required":false,"interface":"input","options":{"placeholder":"Jumlah maksimum peserta"}}},{"field":"price_per_pax","name":"price_per_pax","type":"integer","meta":{"field":"price_per_pax","width":"half","type":"integer","required":false,"interface":"input","options":{"placeholder":"Harga paket"}}},{"field":"description","name":"description","type":"string","meta":{"field":"description","width":"half","type":"string","interface":"select-dropdown","options":{"choices":[{"text":"Weekend","value":"Weekend"},{"text":"Weekday","value":"Weekday"},{"text":"Hubungi CS","value":"Hubungi CS"}]}}}],"template":"{{ description }} ({{ min_pax }} - {{ max_pax }} Pax): Rp {{ price_per_pax }}","sort":"min_pax"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"price_tiers","options":{"fields":[{"field":"min_pax","name":"min_pax","type":"integer","meta":{"field":"min_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Jumlah minimum peserta"}}},{"field":"max_pax","name":"max_pax","type":"integer","meta":{"field":"max_pax","width":"half","type":"integer","required":false,"interface":"input","options":{"placeholder":"Jumlah maksimum peserta"}}},{"field":"price_per_pax","name":"price_per_pax","type":"integer","meta":{"field":"price_per_pax","width":"half","type":"integer","required":false,"interface":"input","options":{"placeholder":"Harga paket"}}},{"field":"description","name":"description","type":"string","meta":{"field":"description","width":"half","type":"string","interface":"select-dropdown","options":{"choices":[{"text":"Weekend","value":"Weekend"},{"text":"Weekday","value":"Weekday"},{"text":"Hubungi CS","value":"Hubungi CS"}]}}}],"template":"{{ description }} ({{ min_pax }} - {{ max_pax }} Pax): Rp {{ price_per_pax }}","sort":"min_pax"}}	\N	\N
594	1014	directus_dashboards	4524bb1d-338e-4720-989a-7d28fa193ef6	{"name":"a","icon":"space_dashboard","color":null,"note":null}	{"name":"a","icon":"space_dashboard","color":null,"note":null}	\N	\N
595	1016	directus_dashboards	1e1f96f4-9ff4-4ce5-987b-379796c2a11c	{"name":"Search","icon":"space_dashboard","color":null,"note":null}	{"name":"Search","icon":"space_dashboard","color":null,"note":null}	\N	\N
596	1017	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	{"type":"metric","width":6,"height":2,"position_x":4,"position_y":5,"options":{"collection":"searches","field":"id","function":"count","sortField":"id"}}	{"type":"metric","width":6,"height":2,"position_x":4,"position_y":5,"options":{"collection":"searches","field":"id","function":"count","sortField":"id"}}	\N	\N
597	1018	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	{"id":"47c2afb2-50bd-4867-9f97-887c8efccb36","name":null,"icon":null,"color":null,"show_header":false,"note":null,"type":"metric","position_x":4,"position_y":5,"width":6,"height":2,"options":{"collection":"searches","field":"id","function":"count","sortField":"id","prefix":"Total Pencarian"},"date_created":"2026-07-15T03:39:06.985Z"}	{"dashboard":"1e1f96f4-9ff4-4ce5-987b-379796c2a11c","name":null,"icon":null,"color":null,"show_header":false,"note":null,"type":"metric","position_x":4,"position_y":5,"width":6,"height":2,"options":{"collection":"searches","field":"id","function":"count","sortField":"id","prefix":"Total Pencarian"},"date_created":"2026-07-15T03:39:06.985Z","user_created":"bb454258-7d81-40f6-af80-ad85011fa204"}	\N	\N
598	1019	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	{"id":"47c2afb2-50bd-4867-9f97-887c8efccb36","name":null,"icon":null,"color":null,"show_header":false,"note":null,"type":"metric","position_x":4,"position_y":5,"width":6,"height":2,"options":{"collection":"searches","field":"id","function":"count","sortField":"id","prefix":"Total Pencarian","textAlign":"start"},"date_created":"2026-07-15T03:39:06.985Z"}	{"dashboard":"1e1f96f4-9ff4-4ce5-987b-379796c2a11c","name":null,"icon":null,"color":null,"show_header":false,"note":null,"type":"metric","position_x":4,"position_y":5,"width":6,"height":2,"options":{"collection":"searches","field":"id","function":"count","sortField":"id","prefix":"Total Pencarian","textAlign":"start"},"date_created":"2026-07-15T03:39:06.985Z","user_created":"bb454258-7d81-40f6-af80-ad85011fa204"}	\N	\N
599	1020	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	{"id":"47c2afb2-50bd-4867-9f97-887c8efccb36","name":null,"icon":null,"color":null,"show_header":false,"note":null,"type":"metric","position_x":4,"position_y":2,"width":21,"height":5,"options":{"collection":"searches","field":"id","function":"count","sortField":"id","prefix":"Total Pencarian","textAlign":"start"},"date_created":"2026-07-15T03:39:06.985Z"}	{"dashboard":"1e1f96f4-9ff4-4ce5-987b-379796c2a11c","name":null,"icon":null,"color":null,"show_header":false,"note":null,"type":"metric","position_x":4,"position_y":2,"width":21,"height":5,"options":{"collection":"searches","field":"id","function":"count","sortField":"id","prefix":"Total Pencarian","textAlign":"start"},"date_created":"2026-07-15T03:39:06.985Z","user_created":"bb454258-7d81-40f6-af80-ad85011fa204"}	\N	\N
600	1021	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	{"id":"47c2afb2-50bd-4867-9f97-887c8efccb36","name":"Total Pencarian","icon":null,"color":null,"show_header":true,"note":null,"type":"metric","position_x":7,"position_y":2,"width":21,"height":5,"options":{"collection":"searches","field":"id","function":"count","sortField":"id","prefix":null,"textAlign":"start"},"date_created":"2026-07-15T03:39:06.985Z"}	{"dashboard":"1e1f96f4-9ff4-4ce5-987b-379796c2a11c","name":"Total Pencarian","icon":null,"color":null,"show_header":true,"note":null,"type":"metric","position_x":7,"position_y":2,"width":21,"height":5,"options":{"collection":"searches","field":"id","function":"count","sortField":"id","prefix":null,"textAlign":"start"},"date_created":"2026-07-15T03:39:06.985Z","user_created":"bb454258-7d81-40f6-af80-ad85011fa204"}	\N	\N
601	1022	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	{"id":"47c2afb2-50bd-4867-9f97-887c8efccb36","name":"Total Pencarian","icon":null,"color":null,"show_header":true,"note":null,"type":"metric","position_x":7,"position_y":2,"width":8,"height":5,"options":{"collection":"searches","field":"id","function":"count","sortField":"id","prefix":null,"textAlign":"start"},"date_created":"2026-07-15T03:39:06.985Z"}	{"width":8}	\N	\N
602	1023	directus_panels	47c2afb2-50bd-4867-9f97-887c8efccb36	{"id":"47c2afb2-50bd-4867-9f97-887c8efccb36","name":"Total Pencarian","icon":null,"color":null,"show_header":true,"note":null,"type":"metric","position_x":7,"position_y":2,"width":10,"height":5,"options":{"collection":"searches","field":"id","function":"count","sortField":"id","prefix":null,"textAlign":"start"},"date_created":"2026-07-15T03:39:06.985Z"}	{"width":10}	\N	\N
603	1025	directus_dashboards	aa7204de-fda7-4cbf-a6ad-8552f2169c3d	{"name":"Overview","icon":"bar_chart","color":"#2A7A6E"}	{"name":"Overview","icon":"bar_chart","color":"#2A7A6E"}	\N	\N
604	1026	directus_dashboards	2c3afa5a-7b28-4a2b-8a21-f9804e99375a	{"name":"Paket & Destinasi","icon":"map","color":"#0A3B52"}	{"name":"Paket & Destinasi","icon":"map","color":"#0A3B52"}	\N	\N
605	1028	directus_panels	8665d8ba-8be5-4d7a-937d-93bcb8a16c14	{"name":"Total Paket","icon":"inventory_2","type":"metric","position_x":0,"position_y":0,"width":3,"height":2,"options":{"collection":"packages","aggregateFunction":"count","aggregateField":"id","sort":"id","filter":{"status":{"_eq":"published"}},"color":"#2A7A6E","precision":0,"fontSize":28}}	{"name":"Total Paket","icon":"inventory_2","type":"metric","position_x":0,"position_y":0,"width":3,"height":2,"options":{"collection":"packages","aggregateFunction":"count","aggregateField":"id","sort":"id","filter":{"status":{"_eq":"published"}},"color":"#2A7A6E","precision":0,"fontSize":28}}	\N	\N
606	1029	directus_panels	6e945b45-0c44-478f-803c-285c1a918677	{"name":"Total Destinasi","icon":"location_on","type":"metric","position_x":3,"position_y":0,"width":3,"height":2,"options":{"collection":"destinations","aggregateFunction":"count","aggregateField":"id","sort":"id","color":"#0A3B52","precision":0,"fontSize":28}}	{"name":"Total Destinasi","icon":"location_on","type":"metric","position_x":3,"position_y":0,"width":3,"height":2,"options":{"collection":"destinations","aggregateFunction":"count","aggregateField":"id","sort":"id","color":"#0A3B52","precision":0,"fontSize":28}}	\N	\N
607	1030	directus_panels	57b325d7-569c-4919-9692-ee9eb1a82938	{"name":"Wilayah","icon":"map","type":"metric","position_x":6,"position_y":0,"width":2,"height":2,"options":{"collection":"regions","aggregateFunction":"count","aggregateField":"id","sort":"id","color":"#356E78","precision":0,"fontSize":28}}	{"name":"Wilayah","icon":"map","type":"metric","position_x":6,"position_y":0,"width":2,"height":2,"options":{"collection":"regions","aggregateFunction":"count","aggregateField":"id","sort":"id","color":"#356E78","precision":0,"fontSize":28}}	\N	\N
608	1031	directus_panels	680f934f-fc6d-4518-bb4d-70bc4d1a9b52	{"name":"Total Pencarian","icon":"search","type":"metric","position_x":8,"position_y":0,"width":3,"height":2,"options":{"collection":"searches","aggregateFunction":"count","aggregateField":"id","sort":"id","color":"#E85D3A","precision":0,"fontSize":28}}	{"name":"Total Pencarian","icon":"search","type":"metric","position_x":8,"position_y":0,"width":3,"height":2,"options":{"collection":"searches","aggregateFunction":"count","aggregateField":"id","sort":"id","color":"#E85D3A","precision":0,"fontSize":28}}	\N	\N
609	1032	directus_panels	d3e495f3-8892-438a-bb1c-ecc3ff84da0c	{"name":"Pencarian Terbaru","icon":"list","type":"list","position_x":0,"position_y":2,"width":6,"height":4,"options":{"collection":"searches","limit":10,"fields":"date_created,destination_name,activity_type_name,pax_count,query","sort":"-date_created","filter":{}}}	{"name":"Pencarian Terbaru","icon":"list","type":"list","position_x":0,"position_y":2,"width":6,"height":4,"options":{"collection":"searches","limit":10,"fields":"date_created,destination_name,activity_type_name,pax_count,query","sort":"-date_created","filter":{}}}	\N	\N
610	1033	directus_panels	4e852818-ee4b-42fc-b575-a82f17e804e0	{"name":"Paket per Destinasi","icon":"bar_chart","type":"bar-chart","position_x":0,"position_y":0,"width":6,"height":4,"options":{"collection":"packages","group":"status","aggregateFunction":"count","aggregateField":"id","sort":"status","filter":{},"color":"#2A7A6E"}}	{"name":"Paket per Destinasi","icon":"bar_chart","type":"bar-chart","position_x":0,"position_y":0,"width":6,"height":4,"options":{"collection":"packages","group":"status","aggregateFunction":"count","aggregateField":"id","sort":"status","filter":{},"color":"#2A7A6E"}}	\N	\N
611	1034	directus_panels	57fc17a6-f156-4748-af27-5a57655a7279	{"name":"Aktivitas","icon":"pie_chart","type":"line-chart","position_x":6,"position_y":0,"width":6,"height":4,"options":{"collection":"activity_types","aggregateFunction":"count","aggregateField":"id","sort":"name","filter":{}}}	{"name":"Aktivitas","icon":"pie_chart","type":"line-chart","position_x":6,"position_y":0,"width":6,"height":4,"options":{"collection":"activity_types","aggregateFunction":"count","aggregateField":"id","sort":"name","filter":{}}}	\N	\N
612	1035	directus_panels	1ad9dd66-c143-48a8-9d96-90af26cf0b4a	{"name":"Semua Paket","icon":"table","type":"list","position_x":0,"position_y":4,"width":12,"height":5,"options":{"collection":"packages","limit":20,"fields":"name,status,duration,min_pax,max_pax","sort":"-id","filter":{}}}	{"name":"Semua Paket","icon":"table","type":"list","position_x":0,"position_y":4,"width":12,"height":5,"options":{"collection":"packages","limit":20,"fields":"name,status,duration,min_pax,max_pax","sort":"-id","filter":{}}}	\N	\N
613	1036	directus_panels	57b325d7-569c-4919-9692-ee9eb1a82938	{"id":"57b325d7-569c-4919-9692-ee9eb1a82938","name":"Wilayah","icon":"map","color":null,"show_header":false,"note":null,"type":"metric","position_x":19,"position_y":3,"width":11,"height":9,"options":{"collection":"regions","aggregateFunction":"count","aggregateField":"id","sort":"id","color":"#356E78","precision":0,"fontSize":28},"date_created":"2026-07-15T03:46:36.120Z"}	{"position_x":19,"position_y":3,"width":11,"height":9}	\N	\N
614	1037	directus_panels	8665d8ba-8be5-4d7a-937d-93bcb8a16c14	{"id":"8665d8ba-8be5-4d7a-937d-93bcb8a16c14","name":"Total Paket","icon":"inventory_2","color":null,"show_header":false,"note":null,"type":"metric","position_x":0,"position_y":0,"width":14,"height":39,"options":{"collection":"packages","aggregateFunction":"count","aggregateField":"id","sort":"id","filter":{"status":{"_eq":"published"}},"color":"#2A7A6E","precision":0,"fontSize":28},"date_created":"2026-07-15T03:46:36.088Z"}	{"width":14,"height":39}	\N	\N
615	1038	directus_panels	6e945b45-0c44-478f-803c-285c1a918677	{"id":"6e945b45-0c44-478f-803c-285c1a918677","name":"Total Destinasi","icon":"location_on","color":null,"show_header":false,"note":null,"type":"metric","position_x":15,"position_y":13,"width":19,"height":2,"options":{"collection":"destinations","aggregateFunction":"count","aggregateField":"id","sort":"id","color":"#0A3B52","precision":0,"fontSize":28},"date_created":"2026-07-15T03:46:36.105Z"}	{"position_x":15,"position_y":13,"width":19,"height":2}	\N	\N
616	1039	directus_panels	d3e495f3-8892-438a-bb1c-ecc3ff84da0c	{"id":"d3e495f3-8892-438a-bb1c-ecc3ff84da0c","name":"Pencarian Terbaru","icon":"list","color":null,"show_header":false,"note":null,"type":"list","position_x":14,"position_y":16,"width":20,"height":19,"options":{"collection":"searches","limit":10,"fields":"date_created,destination_name,activity_type_name,pax_count,query","sort":"-date_created","filter":{}},"date_created":"2026-07-15T03:46:36.149Z"}	{"position_x":14,"position_y":16,"width":20,"height":19}	\N	\N
617	1040	directus_panels	1ad9dd66-c143-48a8-9d96-90af26cf0b4a	{"id":"1ad9dd66-c143-48a8-9d96-90af26cf0b4a","name":"Semua Paket","icon":"table","color":null,"show_header":false,"note":null,"type":"list","position_x":2,"position_y":14,"width":48,"height":15,"options":{"collection":"packages","limit":20,"fields":"name,status,duration,min_pax,max_pax","sort":"-id","filter":{}},"date_created":"2026-07-15T03:46:36.189Z"}	{"position_x":2,"position_y":14,"width":48,"height":15}	\N	\N
618	1041	directus_panels	57fc17a6-f156-4748-af27-5a57655a7279	{"id":"57fc17a6-f156-4748-af27-5a57655a7279","name":"Aktivitas","icon":"pie_chart","color":null,"show_header":false,"note":null,"type":"line-chart","position_x":30,"position_y":1,"width":21,"height":11,"options":{"collection":"activity_types","aggregateFunction":"count","aggregateField":"id","sort":"name","filter":{}},"date_created":"2026-07-15T03:46:36.177Z"}	{"position_x":30,"position_y":1,"width":21,"height":11}	\N	\N
619	1042	directus_panels	4e852818-ee4b-42fc-b575-a82f17e804e0	{"id":"4e852818-ee4b-42fc-b575-a82f17e804e0","name":"Paket per Destinasi","icon":"bar_chart","color":null,"show_header":false,"note":null,"type":"bar-chart","position_x":0,"position_y":0,"width":32,"height":10,"options":{"collection":"packages","group":"status","aggregateFunction":"count","aggregateField":"id","sort":"status","filter":{},"color":"#2A7A6E"},"date_created":"2026-07-15T03:46:36.164Z"}	{"width":32,"height":10}	\N	\N
620	1046	packages	0e113d05-2450-4eb6-bfc3-5f47a891dc7c	{"name":"Paket Wisata Pulau Harapan 1 Hari (One Day Trip)","slug":"paket-wisata-pulau-harapan-one-day","description":"Cocok banget untuk kamu yang punya waktu terbatas tapi tetap ingin refreshing ke pulau. Biasanya berangkat pagi dari dermaga dan kembali sore hari. Dalam waktu singkat, kamu sudah bisa snorkeling, island hopping, dan menikmati suasana pulau yang asri.","duration":"1 Hari","facilities":["Tiket Masuk Ancol","Tiket Speedboat (pergi Dan Pulang)","Welcome Drink","Makan Siang","Peralatan Snorkeling Lengkap","Perahu Tradisional Untuk Snorkeling","Dokumentasi Underwater","Service Local Guide","Hopping Island (keliling Pulau)"],"price_tiers":[{"min_pax":1,"price_per_pax":1575000},{"min_pax":2,"price_per_pax":1100000},{"min_pax":3,"price_per_pax":941667},{"min_pax":4,"price_per_pax":862500},{"min_pax":5,"price_per_pax":815000},{"min_pax":6,"price_per_pax":783333},{"min_pax":7,"price_per_pax":760714},{"min_pax":8,"price_per_pax":743750},{"min_pax":9,"max_pax":null,"price_per_pax":743750}],"status":"published"}	{"name":"Paket Wisata Pulau Harapan 1 Hari (One Day Trip)","slug":"paket-wisata-pulau-harapan-one-day","description":"Cocok banget untuk kamu yang punya waktu terbatas tapi tetap ingin refreshing ke pulau. Biasanya berangkat pagi dari dermaga dan kembali sore hari. Dalam waktu singkat, kamu sudah bisa snorkeling, island hopping, dan menikmati suasana pulau yang asri.","duration":"1 Hari","facilities":["Tiket Masuk Ancol","Tiket Speedboat (pergi Dan Pulang)","Welcome Drink","Makan Siang","Peralatan Snorkeling Lengkap","Perahu Tradisional Untuk Snorkeling","Dokumentasi Underwater","Service Local Guide","Hopping Island (keliling Pulau)"],"price_tiers":[{"min_pax":1,"price_per_pax":1575000},{"min_pax":2,"price_per_pax":1100000},{"min_pax":3,"price_per_pax":941667},{"min_pax":4,"price_per_pax":862500},{"min_pax":5,"price_per_pax":815000},{"min_pax":6,"price_per_pax":783333},{"min_pax":7,"price_per_pax":760714},{"min_pax":8,"price_per_pax":743750},{"min_pax":9,"max_pax":null,"price_per_pax":743750}],"status":"published"}	\N	\N
621	1047	directus_fields	113	{"id":113,"field":"price_tiers","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"min_pax","name":"min_pax","type":"integer","meta":{"field":"min_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Jumlah minimum peserta"}}},{"field":"max_pax","name":"max_pax","type":"integer","meta":{"field":"max_pax","width":"half","type":"integer","required":false,"interface":"input","options":{"placeholder":"Jumlah maksimum peserta"}}},{"field":"price_per_pax","name":"price_per_pax","type":"integer","meta":{"field":"price_per_pax","width":"half","type":"integer","required":false,"interface":"input","options":{"placeholder":"Harga paket"}}},{"field":"description","name":"description","type":"string","meta":{"field":"description","width":"half","type":"string","interface":"input","options":{"choices":[{"text":"Weekend","value":"Weekend"},{"text":"Weekday","value":"Weekday"},{"text":"Hubungi CS","value":"Hubungi CS"}],"placeholder":"Deskripsi/Note"}}}],"template":"{{ description }} ({{ min_pax }} - {{ max_pax }} Pax): Rp {{ price_per_pax }}","sort":"min_pax"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"price_tiers","options":{"fields":[{"field":"min_pax","name":"min_pax","type":"integer","meta":{"field":"min_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Jumlah minimum peserta"}}},{"field":"max_pax","name":"max_pax","type":"integer","meta":{"field":"max_pax","width":"half","type":"integer","required":false,"interface":"input","options":{"placeholder":"Jumlah maksimum peserta"}}},{"field":"price_per_pax","name":"price_per_pax","type":"integer","meta":{"field":"price_per_pax","width":"half","type":"integer","required":false,"interface":"input","options":{"placeholder":"Harga paket"}}},{"field":"description","name":"description","type":"string","meta":{"field":"description","width":"half","type":"string","interface":"input","options":{"choices":[{"text":"Weekend","value":"Weekend"},{"text":"Weekday","value":"Weekday"},{"text":"Hubungi CS","value":"Hubungi CS"}],"placeholder":"Deskripsi/Note"}}}],"template":"{{ description }} ({{ min_pax }} - {{ max_pax }} Pax): Rp {{ price_per_pax }}","sort":"min_pax"}}	\N	\N
622	1048	packages	0e113d05-2450-4eb6-bfc3-5f47a891dc7c	{"id":"0e113d05-2450-4eb6-bfc3-5f47a891dc7c","name":"Paket Wisata Pulau Harapan 1 Hari (One Day Trip)","slug":"paket-wisata-pulau-harapan-one-day","description":"Cocok banget untuk kamu yang punya waktu terbatas tapi tetap ingin refreshing ke pulau. Biasanya berangkat pagi dari dermaga dan kembali sore hari. Dalam waktu singkat, kamu sudah bisa snorkeling, island hopping, dan menikmati suasana pulau yang asri.","duration":"1 Hari","itinerary":null,"price_tiers":[{"min_pax":1,"max_pax":1,"price_per_pax":1575000,"description":"Via Speedboat Marina Ancol"},{"min_pax":2,"max_pax":2,"price_per_pax":1100000,"description":"Via Speedboat Marina Ancol"},{"min_pax":3,"max_pax":3,"price_per_pax":941667,"description":"Via Speedboat Marina Ancol"},{"min_pax":4,"max_pax":4,"price_per_pax":862500,"description":"Via Speedboat Marina Ancol"},{"min_pax":5,"max_pax":5,"price_per_pax":815000,"description":"Via Speedboat Marina Ancol"},{"min_pax":6,"max_pax":6,"price_per_pax":783333,"description":"Via Speedboat Marina Ancol"},{"min_pax":7,"max_pax":7,"price_per_pax":760714,"description":"Via Speedboat Marina Ancol"},{"min_pax":8,"max_pax":8,"price_per_pax":743750,"description":"Via Speedboat Marina Ancol"},{"min_pax":9,"max_pax":null,"price_per_pax":730556,"description":"Via Speedboat Marina Ancol"}],"facilities":["Tiket Masuk Ancol","Tiket Speedboat (pergi Dan Pulang)","Welcome Drink","Makan Siang","Peralatan Snorkeling Lengkap","Perahu Tradisional Untuk Snorkeling","Dokumentasi Underwater","Service Local Guide","Hopping Island (keliling Pulau)"],"status":"published","gallery":null}	{"price_tiers":[{"min_pax":1,"max_pax":1,"price_per_pax":1575000,"description":"Via Speedboat Marina Ancol"},{"min_pax":2,"max_pax":2,"price_per_pax":1100000,"description":"Via Speedboat Marina Ancol"},{"min_pax":3,"max_pax":3,"price_per_pax":941667,"description":"Via Speedboat Marina Ancol"},{"min_pax":4,"max_pax":4,"price_per_pax":862500,"description":"Via Speedboat Marina Ancol"},{"min_pax":5,"max_pax":5,"price_per_pax":815000,"description":"Via Speedboat Marina Ancol"},{"min_pax":6,"max_pax":6,"price_per_pax":783333,"description":"Via Speedboat Marina Ancol"},{"min_pax":7,"max_pax":7,"price_per_pax":760714,"description":"Via Speedboat Marina Ancol"},{"min_pax":8,"max_pax":8,"price_per_pax":743750,"description":"Via Speedboat Marina Ancol"},{"min_pax":9,"max_pax":null,"price_per_pax":730556,"description":"Via Speedboat Marina Ancol"}]}	\N	\N
623	1052	packages	71d0c1b6-83be-4473-b73d-efc034075eda	{"price_tiers":[{"min_pax":2,"max_pax":2,"price_per_pax":958000,"description":"Via Boat Ferry"},{"min_pax":2,"max_pax":2,"price_per_pax":1471000,"description":"Via Speedboat"},{"min_pax":3,"max_pax":3,"price_per_pax":825000,"description":"Via Boat Ferry"},{"min_pax":3,"max_pax":3,"price_per_pax":1338000,"description":"Via Speedboat"},{"min_pax":4,"max_pax":4,"price_per_pax":685000,"description":"Via Boat Ferry"},{"min_pax":4,"max_pax":4,"price_per_pax":1108000,"description":"Via Speedboat"},{"min_pax":5,"max_pax":5,"price_per_pax":575000,"description":"Via Boat Ferry"},{"min_pax":5,"max_pax":5,"price_per_pax":1088000,"description":"Via Speedboat"},{"min_pax":6,"max_pax":6,"price_per_pax":528000,"description":"Via Boat Ferry"},{"min_pax":6,"max_pax":6,"price_per_pax":1041000,"description":"Via Speedboat"},{"min_pax":7,"max_pax":7,"price_per_pax":585000,"description":"Via Boat Ferry"},{"min_pax":7,"max_pax":7,"price_per_pax":998000,"description":"Via Speedboat"},{"min_pax":8,"max_pax":8,"price_per_pax":448000,"description":"Via Boat Ferry"},{"min_pax":8,"max_pax":8,"price_per_pax":961000,"description":"Via Speedboat"},{"min_pax":9,"max_pax":9,"price_per_pax":428000,"description":"Via Boat Ferry"},{"min_pax":9,"max_pax":9,"price_per_pax":941000,"description":"Via Speedboat"},{"min_pax":10,"max_pax":15,"price_per_pax":397000,"description":"Via Boat Ferry"},{"min_pax":10,"max_pax":15,"price_per_pax":910000,"description":"Via Speedboat"},{"min_pax":16,"max_pax":20,"price_per_pax":382000,"description":"Via Boat Ferry"},{"min_pax":16,"max_pax":20,"price_per_pax":895000,"description":"Via Speedboat"},{"min_pax":21,"max_pax":null,"price_per_pax":348000,"description":"Via Boat Ferry"},{"min_pax":21,"max_pax":null,"price_per_pax":861000,"description":"Via Speedboat"}],"facilities":["Tiket Masuk Ancol","Tiket Speedboat (Pergi & Pulang)","Welcome Drink","Homestay AC","Makan Siang","Makan Malam","Sarapan","BBQ Dinner","Peralatan Snorkeling Lengkap","Perahu Tradisional Untuk Snorkeling","Life Jacket","Dokumentasi Underwater","Service Local Guide","Island Hopping","Air Mineral"],"description":"Paket ini adalah pilihan paling umum. Kamu bisa menikmati dua kali snorkeling, BBQ malam, waktu luang di homestay, serta island hopping ke beberapa pulau terdekat. Biasanya sudah termasuk 3 kali makan, penginapan 1 malam, dan guide lokal.","name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","slug":"paket-wisata-pulau-harapan-2d1n","duration":"2 Hari 1 Malam","status":"published"}	{"price_tiers":[{"min_pax":2,"max_pax":2,"price_per_pax":958000,"description":"Via Boat Ferry"},{"min_pax":2,"max_pax":2,"price_per_pax":1471000,"description":"Via Speedboat"},{"min_pax":3,"max_pax":3,"price_per_pax":825000,"description":"Via Boat Ferry"},{"min_pax":3,"max_pax":3,"price_per_pax":1338000,"description":"Via Speedboat"},{"min_pax":4,"max_pax":4,"price_per_pax":685000,"description":"Via Boat Ferry"},{"min_pax":4,"max_pax":4,"price_per_pax":1108000,"description":"Via Speedboat"},{"min_pax":5,"max_pax":5,"price_per_pax":575000,"description":"Via Boat Ferry"},{"min_pax":5,"max_pax":5,"price_per_pax":1088000,"description":"Via Speedboat"},{"min_pax":6,"max_pax":6,"price_per_pax":528000,"description":"Via Boat Ferry"},{"min_pax":6,"max_pax":6,"price_per_pax":1041000,"description":"Via Speedboat"},{"min_pax":7,"max_pax":7,"price_per_pax":585000,"description":"Via Boat Ferry"},{"min_pax":7,"max_pax":7,"price_per_pax":998000,"description":"Via Speedboat"},{"min_pax":8,"max_pax":8,"price_per_pax":448000,"description":"Via Boat Ferry"},{"min_pax":8,"max_pax":8,"price_per_pax":961000,"description":"Via Speedboat"},{"min_pax":9,"max_pax":9,"price_per_pax":428000,"description":"Via Boat Ferry"},{"min_pax":9,"max_pax":9,"price_per_pax":941000,"description":"Via Speedboat"},{"min_pax":10,"max_pax":15,"price_per_pax":397000,"description":"Via Boat Ferry"},{"min_pax":10,"max_pax":15,"price_per_pax":910000,"description":"Via Speedboat"},{"min_pax":16,"max_pax":20,"price_per_pax":382000,"description":"Via Boat Ferry"},{"min_pax":16,"max_pax":20,"price_per_pax":895000,"description":"Via Speedboat"},{"min_pax":21,"max_pax":null,"price_per_pax":348000,"description":"Via Boat Ferry"},{"min_pax":21,"max_pax":null,"price_per_pax":861000,"description":"Via Speedboat"}],"facilities":["Tiket Masuk Ancol","Tiket Speedboat (Pergi & Pulang)","Welcome Drink","Homestay AC","Makan Siang","Makan Malam","Sarapan","BBQ Dinner","Peralatan Snorkeling Lengkap","Perahu Tradisional Untuk Snorkeling","Life Jacket","Dokumentasi Underwater","Service Local Guide","Island Hopping","Air Mineral"],"description":"Paket ini adalah pilihan paling umum. Kamu bisa menikmati dua kali snorkeling, BBQ malam, waktu luang di homestay, serta island hopping ke beberapa pulau terdekat. Biasanya sudah termasuk 3 kali makan, penginapan 1 malam, dan guide lokal.","name":"Paket Wisata Pulau Harapan 2 Hari 1 Malam","slug":"paket-wisata-pulau-harapan-2d1n","duration":"2 Hari 1 Malam","status":"published"}	\N	\N
624	1053	packages	1fdbcdba-d886-443f-864b-6a1b65967c7e	{"name":"Paket Wisata Pulau Harapan 3 Hari 2 Malam","description":"Kalau kamu ingin menikmati suasana pulau tanpa terburu-buru, ini adalah paket yang paling santai. Cocok untuk staycation bareng pasangan, keluarga, atau teman dekat. Kamu punya lebih banyak waktu untuk bersantai, explore pantai, hunting sunrise dan sunset, serta ngobrol bareng warga lokal.","slug":"paket-wisata-pulau-harapan-3d2n","price_tiers":[{"min_pax":2,"max_pax":2,"price_per_pax":1375000,"description":"Via Boat Ferry"},{"min_pax":2,"max_pax":2,"price_per_pax":1888000,"description":"Via Speedboat"},{"min_pax":3,"max_pax":3,"price_per_pax":1125000,"description":"Via Boat Ferry"},{"min_pax":3,"max_pax":3,"price_per_pax":1638000,"description":"Via Speedboat"},{"min_pax":4,"max_pax":4,"price_per_pax":878000,"description":"Via Boat Ferry"},{"min_pax":4,"max_pax":4,"price_per_pax":1391000,"description":"Via Speedboat"},{"min_pax":5,"max_pax":5,"price_per_pax":842000,"description":"Via Boat Ferry"},{"min_pax":5,"max_pax":5,"price_per_pax":1355000,"description":"Via Speedboat"},{"min_pax":6,"max_pax":6,"price_per_pax":794000,"description":"Via Boat Ferry"},{"min_pax":6,"max_pax":6,"price_per_pax":1307000,"description":"Via Speedboat"},{"min_pax":7,"max_pax":7,"price_per_pax":682000,"description":"Via Boat Ferry"},{"min_pax":7,"max_pax":7,"price_per_pax":1195000,"description":"Via Speedboat"},{"min_pax":8,"max_pax":8,"price_per_pax":641000,"description":"Via Boat Ferry"},{"min_pax":8,"max_pax":8,"price_per_pax":1154000,"description":"Via Speedboat"},{"min_pax":9,"max_pax":9,"price_per_pax":587000,"description":"Via Boat Ferry"},{"min_pax":9,"max_pax":9,"price_per_pax":1100000,"description":"Via Speedboat"},{"min_pax":10,"max_pax":15,"price_per_pax":572000,"description":"Via Boat Ferry"},{"min_pax":10,"max_pax":15,"price_per_pax":1085000,"description":"Via Speedboat"},{"min_pax":16,"max_pax":20,"price_per_pax":542000,"description":"Via Boat Ferry"},{"min_pax":16,"max_pax":20,"price_per_pax":1055000,"description":"Via Speedboat"},{"min_pax":21,"max_pax":null,"price_per_pax":497000,"description":"Via Boat Ferry"},{"min_pax":21,"max_pax":null,"price_per_pax":1010000,"description":"Via Speedboat"}],"duration":"3 Hari 2 Malam","status":"published"}	{"name":"Paket Wisata Pulau Harapan 3 Hari 2 Malam","description":"Kalau kamu ingin menikmati suasana pulau tanpa terburu-buru, ini adalah paket yang paling santai. Cocok untuk staycation bareng pasangan, keluarga, atau teman dekat. Kamu punya lebih banyak waktu untuk bersantai, explore pantai, hunting sunrise dan sunset, serta ngobrol bareng warga lokal.","slug":"paket-wisata-pulau-harapan-3d2n","price_tiers":[{"min_pax":2,"max_pax":2,"price_per_pax":1375000,"description":"Via Boat Ferry"},{"min_pax":2,"max_pax":2,"price_per_pax":1888000,"description":"Via Speedboat"},{"min_pax":3,"max_pax":3,"price_per_pax":1125000,"description":"Via Boat Ferry"},{"min_pax":3,"max_pax":3,"price_per_pax":1638000,"description":"Via Speedboat"},{"min_pax":4,"max_pax":4,"price_per_pax":878000,"description":"Via Boat Ferry"},{"min_pax":4,"max_pax":4,"price_per_pax":1391000,"description":"Via Speedboat"},{"min_pax":5,"max_pax":5,"price_per_pax":842000,"description":"Via Boat Ferry"},{"min_pax":5,"max_pax":5,"price_per_pax":1355000,"description":"Via Speedboat"},{"min_pax":6,"max_pax":6,"price_per_pax":794000,"description":"Via Boat Ferry"},{"min_pax":6,"max_pax":6,"price_per_pax":1307000,"description":"Via Speedboat"},{"min_pax":7,"max_pax":7,"price_per_pax":682000,"description":"Via Boat Ferry"},{"min_pax":7,"max_pax":7,"price_per_pax":1195000,"description":"Via Speedboat"},{"min_pax":8,"max_pax":8,"price_per_pax":641000,"description":"Via Boat Ferry"},{"min_pax":8,"max_pax":8,"price_per_pax":1154000,"description":"Via Speedboat"},{"min_pax":9,"max_pax":9,"price_per_pax":587000,"description":"Via Boat Ferry"},{"min_pax":9,"max_pax":9,"price_per_pax":1100000,"description":"Via Speedboat"},{"min_pax":10,"max_pax":15,"price_per_pax":572000,"description":"Via Boat Ferry"},{"min_pax":10,"max_pax":15,"price_per_pax":1085000,"description":"Via Speedboat"},{"min_pax":16,"max_pax":20,"price_per_pax":542000,"description":"Via Boat Ferry"},{"min_pax":16,"max_pax":20,"price_per_pax":1055000,"description":"Via Speedboat"},{"min_pax":21,"max_pax":null,"price_per_pax":497000,"description":"Via Boat Ferry"},{"min_pax":21,"max_pax":null,"price_per_pax":1010000,"description":"Via Speedboat"}],"duration":"3 Hari 2 Malam","status":"published"}	\N	\N
625	1054	destinations	e2c9f388-06bd-4a3c-8713-efc97ce59124	{"status":"published","name":"Pulau Putri","slug":"pulau-putri","description":"Pulau Putri merupakan salah satu resort eksklusif di Kepulauan Seribu yang menawarkan pengalaman menginap di cottage tepi laut dengan berbagai fasilitas rekreasi bahari. Resort ini terkenal dengan Undersea Tunnel Aquarium, Glass Bottom Boat, Sunset Cruise, kolam renang, dan cottage yang seluruhnya menghadap ke laut. Pulau Putri cocok untuk liburan keluarga, pasangan, outing perusahaan, gathering, maupun meeting."}	{"status":"published","name":"Pulau Putri","slug":"pulau-putri","description":"Pulau Putri merupakan salah satu resort eksklusif di Kepulauan Seribu yang menawarkan pengalaman menginap di cottage tepi laut dengan berbagai fasilitas rekreasi bahari. Resort ini terkenal dengan Undersea Tunnel Aquarium, Glass Bottom Boat, Sunset Cruise, kolam renang, dan cottage yang seluruhnya menghadap ke laut. Pulau Putri cocok untuk liburan keluarga, pasangan, outing perusahaan, gathering, maupun meeting."}	\N	\N
626	1055	packages	6fe7ac8a-f231-4949-b2b2-77b9b309c74a	{"name":"One Day Trip Pulau Putri","slug":"one-day-trip-pulau-putri","description":"Paket wisata sehari ke Pulau Putri Resort yang cocok bagi wisatawan yang ingin menikmati fasilitas resort tanpa menginap. Perjalanan menggunakan speedboat dari Marina Ancol dengan aktivitas utama berupa Glass Bottom Boat, Undersea Tunnel Aquarium, berenang di kolam renang, serta menikmati makan siang di resort.","duration":"1 Hari","itinerary":[{"day":1,"title":"One Day Escape","activities":["Boarding di Marina Ancol Dermaga 9","Keberangkatan menuju Pulau Putri pukul 08.00 WIB","Welcome Drink","Menikmati Undersea Tunnel Aquarium","Glass Bottom Boat","Makan Siang","Berenang di Swimming Pool","Bermain di Children Playground","Free Time","Kembali ke Marina Ancol pukul 14.00 WIB"]}],"facilities":["Transportasi Speedboat PP Marina Ancol","Welcome Drink","1x Makan Siang","Glass Bottom Boat","Undersea Tunnel Aquarium","Swimming Pool","Children Playground","Boat Passenger Insurance","Government Tax & Service Charge"],"price_tiers":[{"min_pax":1,"max_pax":1,"price_per_pax":1250000,"description":"Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":1250000,"description":"Child"},{"min_pax":1,"max_pax":1,"price_per_pax":190000,"description":"Infant (<2 Tahun)"}],"status":"published"}	{"name":"One Day Trip Pulau Putri","slug":"one-day-trip-pulau-putri","description":"Paket wisata sehari ke Pulau Putri Resort yang cocok bagi wisatawan yang ingin menikmati fasilitas resort tanpa menginap. Perjalanan menggunakan speedboat dari Marina Ancol dengan aktivitas utama berupa Glass Bottom Boat, Undersea Tunnel Aquarium, berenang di kolam renang, serta menikmati makan siang di resort.","duration":"1 Hari","itinerary":[{"day":1,"title":"One Day Escape","activities":["Boarding di Marina Ancol Dermaga 9","Keberangkatan menuju Pulau Putri pukul 08.00 WIB","Welcome Drink","Menikmati Undersea Tunnel Aquarium","Glass Bottom Boat","Makan Siang","Berenang di Swimming Pool","Bermain di Children Playground","Free Time","Kembali ke Marina Ancol pukul 14.00 WIB"]}],"facilities":["Transportasi Speedboat PP Marina Ancol","Welcome Drink","1x Makan Siang","Glass Bottom Boat","Undersea Tunnel Aquarium","Swimming Pool","Children Playground","Boat Passenger Insurance","Government Tax & Service Charge"],"price_tiers":[{"min_pax":1,"max_pax":1,"price_per_pax":1250000,"description":"Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":1250000,"description":"Child"},{"min_pax":1,"max_pax":1,"price_per_pax":190000,"description":"Infant (<2 Tahun)"}],"status":"published"}	\N	\N
627	1056	packages	4e215743-3f94-4328-a631-92597e4ee300	{"name":"Paket Tour Pulau Putri 2 Hari 1 Malam","slug":"paket-tour-pulau-putri-2-hari-1-malam","description":"Paket wisata menginap selama 2 hari 1 malam di Pulau Putri Resort, Kepulauan Seribu. Nikmati pengalaman menginap di cottage tepi laut dengan fasilitas lengkap seperti Undersea Tunnel Aquarium, Glass Bottom Boat, Sunset Cruise, kolam renang, dan berbagai aktivitas rekreasi. Cocok untuk keluarga, pasangan, maupun corporate gathering.","duration":"2 Hari 1 Malam","itinerary":[{"day":1,"title":"Arrival & Resort Experience","activities":["Boarding di Marina Ancol Dermaga 9 pukul 07.30 WIB","Keberangkatan menuju Pulau Putri pukul 08.00 WIB","Welcome Drink","Check-in Cottage","Makan Siang","Glass Bottom Boat","Undersea Tunnel Aquarium","Swimming Pool","Sunset Cruise (diganti Snorkeling jika peserta kurang dari 30 orang)","Makan Malam","Free Time","Istirahat"]},{"day":2,"title":"Morning Leisure & Return","activities":["Sarapan","Menikmati fasilitas resort","Swimming Pool","Children Playground","Check-out Cottage","Keberangkatan menuju Marina Ancol pukul 14.00 WIB"]}],"facilities":["Transportasi Speedboat PP Marina Ancol","Welcome Drink","Akomodasi Cottage","4x Makan (2x Makan Siang, 1x Makan Malam, 1x Sarapan)","Glass Bottom Boat","Sunset Cruise","Undersea Tunnel Aquarium","Swimming Pool","Children Playground","Boat Passenger Insurance","Government Tax & Service Charge"],"price_tiers":[{"min_pax":1,"max_pax":1,"price_per_pax":2200000,"description":"Weekday - Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":2650000,"description":"Weekend / Public Holiday - Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":1360000,"description":"Weekday - Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1500000,"description":"Weekend / Public Holiday - Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":180000,"description":"Weekday - Infant (<2 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":190000,"description":"Weekend / Public Holiday - Infant (<2 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1610000,"description":"Additional Night - Weekday Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":1950000,"description":"Additional Night - Weekend Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":940000,"description":"Additional Night - Weekday Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1100000,"description":"Additional Night - Weekend Child (2-10 Tahun)"}]}	{"name":"Paket Tour Pulau Putri 2 Hari 1 Malam","slug":"paket-tour-pulau-putri-2-hari-1-malam","description":"Paket wisata menginap selama 2 hari 1 malam di Pulau Putri Resort, Kepulauan Seribu. Nikmati pengalaman menginap di cottage tepi laut dengan fasilitas lengkap seperti Undersea Tunnel Aquarium, Glass Bottom Boat, Sunset Cruise, kolam renang, dan berbagai aktivitas rekreasi. Cocok untuk keluarga, pasangan, maupun corporate gathering.","duration":"2 Hari 1 Malam","itinerary":[{"day":1,"title":"Arrival & Resort Experience","activities":["Boarding di Marina Ancol Dermaga 9 pukul 07.30 WIB","Keberangkatan menuju Pulau Putri pukul 08.00 WIB","Welcome Drink","Check-in Cottage","Makan Siang","Glass Bottom Boat","Undersea Tunnel Aquarium","Swimming Pool","Sunset Cruise (diganti Snorkeling jika peserta kurang dari 30 orang)","Makan Malam","Free Time","Istirahat"]},{"day":2,"title":"Morning Leisure & Return","activities":["Sarapan","Menikmati fasilitas resort","Swimming Pool","Children Playground","Check-out Cottage","Keberangkatan menuju Marina Ancol pukul 14.00 WIB"]}],"facilities":["Transportasi Speedboat PP Marina Ancol","Welcome Drink","Akomodasi Cottage","4x Makan (2x Makan Siang, 1x Makan Malam, 1x Sarapan)","Glass Bottom Boat","Sunset Cruise","Undersea Tunnel Aquarium","Swimming Pool","Children Playground","Boat Passenger Insurance","Government Tax & Service Charge"],"price_tiers":[{"min_pax":1,"max_pax":1,"price_per_pax":2200000,"description":"Weekday - Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":2650000,"description":"Weekend / Public Holiday - Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":1360000,"description":"Weekday - Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1500000,"description":"Weekend / Public Holiday - Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":180000,"description":"Weekday - Infant (<2 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":190000,"description":"Weekend / Public Holiday - Infant (<2 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1610000,"description":"Additional Night - Weekday Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":1950000,"description":"Additional Night - Weekend Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":940000,"description":"Additional Night - Weekday Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1100000,"description":"Additional Night - Weekend Child (2-10 Tahun)"}]}	\N	\N
628	1057	packages	4e215743-3f94-4328-a631-92597e4ee300	{"id":"4e215743-3f94-4328-a631-92597e4ee300","name":"Paket Tour Pulau Putri 2 Hari 1 Malam","slug":"paket-tour-pulau-putri-2-hari-1-malam","description":"Paket wisata menginap selama 2 hari 1 malam di Pulau Putri Resort, Kepulauan Seribu. Nikmati pengalaman menginap di cottage tepi laut dengan fasilitas lengkap seperti Undersea Tunnel Aquarium, Glass Bottom Boat, Sunset Cruise, kolam renang, dan berbagai aktivitas rekreasi. Cocok untuk keluarga, pasangan, maupun corporate gathering.","duration":"2 Hari 1 Malam","itinerary":[{"day":1,"title":"Arrival & Resort Experience","activities":["Boarding di Marina Ancol Dermaga 9 pukul 07.30 WIB","Keberangkatan menuju Pulau Putri pukul 08.00 WIB","Welcome Drink","Check-in Cottage","Makan Siang","Glass Bottom Boat","Undersea Tunnel Aquarium","Swimming Pool","Sunset Cruise (diganti Snorkeling jika peserta kurang dari 30 orang)","Makan Malam","Free Time","Istirahat"]},{"day":2,"title":"Morning Leisure & Return","activities":["Sarapan","Menikmati fasilitas resort","Swimming Pool","Children Playground","Check-out Cottage","Keberangkatan menuju Marina Ancol pukul 14.00 WIB"]}],"price_tiers":[{"min_pax":1,"max_pax":1,"price_per_pax":2200000,"description":"Weekday - Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":2650000,"description":"Weekend / Public Holiday - Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":1360000,"description":"Weekday - Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1500000,"description":"Weekend / Public Holiday - Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":180000,"description":"Weekday - Infant (<2 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":190000,"description":"Weekend / Public Holiday - Infant (<2 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1610000,"description":"Additional Night - Weekday Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":1950000,"description":"Additional Night - Weekend Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":940000,"description":"Additional Night - Weekday Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1100000,"description":"Additional Night - Weekend Child (2-10 Tahun)"}],"facilities":["Transportasi Speedboat PP Marina Ancol","Welcome Drink","Akomodasi Cottage","4x Makan (2x Makan Siang, 1x Makan Malam, 1x Sarapan)","Glass Bottom Boat","Sunset Cruise","Undersea Tunnel Aquarium","Swimming Pool","Children Playground","Boat Passenger Insurance","Government Tax & Service Charge"],"status":null,"gallery":null}	{"image":"794bfde6-a082-4ea6-8cfc-438e14ddb651"}	\N	\N
629	1058	packages_activity_types	d7d315e7-a26c-42aa-8e93-fe5a23b10036	\N	\N	\N	\N
630	1059	packages_activity_types	f7d36bbb-1da9-41b1-ba39-1b3f1ffe229a	\N	\N	\N	\N
631	1060	packages_activity_types	8fca081e-d37c-4cbb-b4e4-64be8446bf91	\N	\N	\N	\N
632	1061	packages_activity_types	3f70db38-0bd0-4d59-9841-75e4a23d31d8	\N	\N	\N	\N
633	1062	packages_activity_types	43f73151-16ad-46b3-959a-713be9ff480f	\N	\N	\N	\N
634	1063	packages_activity_types	7608e659-9c1e-41bb-b66b-331fac00c408	\N	\N	\N	\N
635	1064	packages_activity_types	8f2ab01b-b2eb-4020-a93c-37f3ba1527bd	\N	\N	\N	\N
636	1066	directus_settings	1	{"id":1,"project_name":"Voda Tour & Event","project_url":null,"project_color":"#6644FF","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"dark","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":null,"org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false}	{"project_name":"Voda Tour & Event"}	\N	\N
637	1067	directus_settings	1	{"id":1,"project_name":"Voda Tour & Event","project_url":null,"project_color":"#EE7D0F","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"dark","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":null,"org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false}	{"project_color":"#EE7D0F"}	\N	\N
657	1090	directus_fields	194	{"sort":21,"interface":"list","special":["cast-json"],"options":{"fields":[{"field":"addon_name","name":"addon_name","type":"string","meta":{"field":"addon_name","width":"half","type":"string","required":true,"interface":"input","options":{"placeholder":"Nama Additional ( Layanan Tambahan )"}}},{"field":"price","name":"price","type":"integer","meta":{"field":"price","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Harga Additional (Layanan Tambahan)"}}},{"field":"description","name":"description","type":"text","meta":{"field":"description","width":"full","type":"text","interface":"input","options":{"placeholder":"Deskripsi / Note Singkat"}}}],"template":"{{ addon_name }} - {{ price }}"},"field":"addons"}	{"sort":21,"interface":"list","special":["cast-json"],"options":{"fields":[{"field":"addon_name","name":"addon_name","type":"string","meta":{"field":"addon_name","width":"half","type":"string","required":true,"interface":"input","options":{"placeholder":"Nama Additional ( Layanan Tambahan )"}}},{"field":"price","name":"price","type":"integer","meta":{"field":"price","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Harga Additional (Layanan Tambahan)"}}},{"field":"description","name":"description","type":"text","meta":{"field":"description","width":"full","type":"text","interface":"input","options":{"placeholder":"Deskripsi / Note Singkat"}}}],"template":"{{ addon_name }} - {{ price }}"},"field":"addons"}	\N	\N
658	1091	directus_fields	194	{"id":194,"field":"addons","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"addon_name","name":"addon_name","type":"string","meta":{"field":"addon_name","width":"half","type":"string","required":true,"interface":"input","options":{"placeholder":"Nama Additional ( Layanan Tambahan )"}}},{"field":"price","name":"price","type":"integer","meta":{"field":"price","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Harga Additional (Layanan Tambahan)"}}},{"field":"description","name":"description","type":"text","meta":{"field":"description","width":"full","type":"text","interface":"input","options":{"placeholder":"Deskripsi / Note Singkat"}}}],"template":"{{ addon_name }} — Rp {{ price }}","sort":"addon_name"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":21,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"addons","options":{"fields":[{"field":"addon_name","name":"addon_name","type":"string","meta":{"field":"addon_name","width":"half","type":"string","required":true,"interface":"input","options":{"placeholder":"Nama Additional ( Layanan Tambahan )"}}},{"field":"price","name":"price","type":"integer","meta":{"field":"price","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Harga Additional (Layanan Tambahan)"}}},{"field":"description","name":"description","type":"text","meta":{"field":"description","width":"full","type":"text","interface":"input","options":{"placeholder":"Deskripsi / Note Singkat"}}}],"template":"{{ addon_name }} — Rp {{ price }}","sort":"addon_name"}}	\N	\N
638	1068	directus_files	04b20e66-94f5-4784-9f42-f43f3c8551fa	{"storage":"local","title":"Voda Travel Icon","filename_download":"VodaTravelIcon.webp","type":"image/webp"}	{"storage":"local","title":"Voda Travel Icon","filename_download":"VodaTravelIcon.webp","type":"image/webp"}	\N	\N
639	1069	directus_settings	1	{"id":1,"project_name":"Voda Tour & Event","project_url":null,"project_color":"#EE7D0F","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"dark","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":null,"org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false}	{"project_logo":"04b20e66-94f5-4784-9f42-f43f3c8551fa"}	\N	\N
640	1070	directus_settings	1	{"id":1,"project_name":"Voda Tour & Event","project_url":null,"project_color":"#EE7D0F","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"dark","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":null,"org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false}	{"project_logo":null}	\N	\N
645	1075	directus_fields	116	{"id":116,"field":"name","special":null,"interface":"input","options":null,"display":"icon","display_options":{},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"activity_types","field":"name","display":"icon","display_options":{}}	\N	\N
647	1077	activity_types	ef4be35a-a6c5-4e79-9c5c-2a5f7752e586	{"id":"ef4be35a-a6c5-4e79-9c5c-2a5f7752e586","name":"Team Building Asu","slug":"team-building","description":"Fokus pada aktivitas kerja sama tim, biasanya dikombinasikan dengan games/outbound terstruktur dan fasilitator.","status":"published"}	{"name":"Team Building Asu"}	\N	\N
650	1080	directus_fields	116	{"id":116,"field":"name","special":null,"interface":"input","options":null,"display":null,"display_options":{},"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"activity_types","field":"name","display":null}	\N	\N
659	1092	directus_fields	104	{"id":104,"field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"id","sort":1,"group":null}	\N	\N
660	1093	directus_fields	105	{"id":105,"field":"name","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"name","sort":2,"group":null}	\N	\N
661	1094	directus_fields	106	{"id":106,"field":"slug","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"slug","sort":3,"group":null}	\N	\N
662	1095	directus_fields	107	{"id":107,"field":"description","special":null,"interface":"input-multiline","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"description","sort":4,"group":null}	\N	\N
663	1096	directus_fields	108	{"id":108,"field":"destination_id","special":["m2o"],"interface":"select-dropdown-m2o","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"destination_id","sort":5,"group":null}	\N	\N
664	1097	directus_fields	109	{"id":109,"field":"image","special":["file-image"],"interface":"file-image","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"image","sort":6,"group":null}	\N	\N
665	1098	directus_fields	111	{"id":111,"field":"duration","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"duration","sort":7,"group":null}	\N	\N
641	1071	directus_settings	1	{"id":1,"project_name":"Voda Tour & Event","project_url":null,"project_color":"#EE7D0F","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"light","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":null,"org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false}	{"default_appearance":"light"}	\N	\N
642	1072	directus_settings	1	{"id":1,"project_name":"Voda Tour & Event","project_url":null,"project_color":"#0F2C4C","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"light","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":null,"org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false}	{"project_color":"#0F2C4C"}	\N	\N
644	1074	directus_settings	1	{"id":1,"project_name":"Voda Tour & Event","project_url":null,"project_color":"#EE7D0F","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"dark","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":null,"org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false}	{"project_color":"#EE7D0F"}	\N	\N
666	1099	directus_fields	112	{"id":112,"field":"itinerary","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"day","name":"day","type":"integer","meta":{"field":"day","width":"half","type":"integer","required":true,"note":"Angka hari ke sekian contoh \\"1\\"","interface":"input","options":{"placeholder":"Hari (Contoh : 1)"}}},{"field":"title","name":"title","type":"string","meta":{"field":"title","width":"half","type":"string","note":null,"interface":"input","options":{"placeholder":"Judul Hari (Contoh : Arrival & Island Adventure)"}}},{"field":"activities","name":"activities","type":"json","meta":{"field":"activities","width":"full","type":"json","required":true,"interface":"tags","options":{"presets":[],"placeholder":"Isi dengan kegiatan (Contoh : Check-in homestay)"}}}],"template":"Day {{ day }}: {{ title }}","sort":"day"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"itinerary","sort":8,"group":null}	\N	\N
667	1100	directus_fields	114	{"id":114,"field":"facilities","special":["cast-json"],"interface":"tags","options":{"placeholder":"Isi dengan Fasilitas yang disediakan","whitespace":null,"capitalization":"auto-format"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"facilities","sort":9,"group":null}	\N	\N
643	1073	directus_settings	1	{"id":1,"project_name":"Voda Tour & Event","project_url":null,"project_color":"#0F2C4C","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"dark","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":null,"org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false}	{"default_appearance":"dark"}	\N	\N
668	1101	directus_fields	113	{"id":113,"field":"price_tiers","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"min_pax","name":"min_pax","type":"integer","meta":{"field":"min_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Jumlah minimum peserta"}}},{"field":"max_pax","name":"max_pax","type":"integer","meta":{"field":"max_pax","width":"half","type":"integer","required":false,"interface":"input","options":{"placeholder":"Jumlah maksimum peserta"}}},{"field":"price_per_pax","name":"price_per_pax","type":"integer","meta":{"field":"price_per_pax","width":"half","type":"integer","required":false,"interface":"input","options":{"placeholder":"Harga paket"}}},{"field":"description","name":"description","type":"string","meta":{"field":"description","width":"half","type":"string","interface":"input","options":{"choices":[{"text":"Weekend","value":"Weekend"},{"text":"Weekday","value":"Weekday"},{"text":"Hubungi CS","value":"Hubungi CS"}],"placeholder":"Deskripsi/Note"}}}],"template":"{{ description }} ({{ min_pax }} - {{ max_pax }} Pax): Rp {{ price_per_pax }}","sort":"min_pax"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"price_tiers","sort":10,"group":null}	\N	\N
669	1102	directus_fields	122	{"id":122,"field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"Published","value":"published"},{"text":"Draft","value":"draft"},{"text":"Archived","value":"archived"}]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":11,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"status","sort":11,"group":null}	\N	\N
670	1103	directus_fields	194	{"id":194,"field":"addons","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"addon_name","name":"addon_name","type":"string","meta":{"field":"addon_name","width":"half","type":"string","required":true,"interface":"input","options":{"placeholder":"Nama Additional ( Layanan Tambahan )"}}},{"field":"price","name":"price","type":"integer","meta":{"field":"price","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Harga Additional (Layanan Tambahan)"}}},{"field":"description","name":"description","type":"text","meta":{"field":"description","width":"full","type":"text","interface":"input","options":{"placeholder":"Deskripsi / Note Singkat"}}}],"template":"{{ addon_name }} — Rp {{ price }}","sort":"addon_name"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":12,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"addons","sort":12,"group":null}	\N	\N
671	1104	directus_fields	190	{"id":190,"field":"gallery","special":["json"],"interface":"json","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":13,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"gallery","sort":13,"group":null}	\N	\N
646	1076	activity_types	ef4be35a-a6c5-4e79-9c5c-2a5f7752e586	{"id":"ef4be35a-a6c5-4e79-9c5c-2a5f7752e586","name":"Team Building ","slug":"team-building","description":"Fokus pada aktivitas kerja sama tim, biasanya dikombinasikan dengan games/outbound terstruktur dan fasilitator.","status":"published"}	{"name":"Team Building "}	\N	\N
672	1105	packages	1fdbcdba-d886-443f-864b-6a1b65967c7e	{"id":"1fdbcdba-d886-443f-864b-6a1b65967c7e","name":"Paket Wisata Pulau Harapan 3 Hari 2 Malam","slug":"paket-wisata-pulau-harapan-3d2n","description":"Kalau kamu ingin menikmati suasana pulau tanpa terburu-buru, ini adalah paket yang paling santai. Cocok untuk staycation bareng pasangan, keluarga, atau teman dekat. Kamu punya lebih banyak waktu untuk bersantai, explore pantai, hunting sunrise dan sunset, serta ngobrol bareng warga lokal.","duration":"3 Hari 2 Malam","itinerary":null,"price_tiers":[{"min_pax":2,"max_pax":2,"price_per_pax":1375000,"description":"Via Boat Ferry"},{"min_pax":2,"max_pax":2,"price_per_pax":1888000,"description":"Via Speedboat"},{"min_pax":3,"max_pax":3,"price_per_pax":1125000,"description":"Via Boat Ferry"},{"min_pax":3,"max_pax":3,"price_per_pax":1638000,"description":"Via Speedboat"},{"min_pax":4,"max_pax":4,"price_per_pax":878000,"description":"Via Boat Ferry"},{"min_pax":4,"max_pax":4,"price_per_pax":1391000,"description":"Via Speedboat"},{"min_pax":5,"max_pax":5,"price_per_pax":842000,"description":"Via Boat Ferry"},{"min_pax":5,"max_pax":5,"price_per_pax":1355000,"description":"Via Speedboat"},{"min_pax":6,"max_pax":6,"price_per_pax":794000,"description":"Via Boat Ferry"},{"min_pax":6,"max_pax":6,"price_per_pax":1307000,"description":"Via Speedboat"},{"min_pax":7,"max_pax":7,"price_per_pax":682000,"description":"Via Boat Ferry"},{"min_pax":7,"max_pax":7,"price_per_pax":1195000,"description":"Via Speedboat"},{"min_pax":8,"max_pax":8,"price_per_pax":641000,"description":"Via Boat Ferry"},{"min_pax":8,"max_pax":8,"price_per_pax":1154000,"description":"Via Speedboat"},{"min_pax":9,"max_pax":9,"price_per_pax":587000,"description":"Via Boat Ferry"},{"min_pax":9,"max_pax":9,"price_per_pax":1100000,"description":"Via Speedboat"},{"min_pax":10,"max_pax":15,"price_per_pax":572000,"description":"Via Boat Ferry"},{"min_pax":10,"max_pax":15,"price_per_pax":1085000,"description":"Via Speedboat"},{"min_pax":16,"max_pax":20,"price_per_pax":542000,"description":"Via Boat Ferry"},{"min_pax":16,"max_pax":20,"price_per_pax":1055000,"description":"Via Speedboat"},{"min_pax":21,"max_pax":null,"price_per_pax":497000,"description":"Via Boat Ferry"},{"min_pax":21,"max_pax":null,"price_per_pax":1010000,"description":"Via Speedboat"}],"facilities":null,"status":"published","gallery":null,"addons":[{"addon_name":"Banana Boat","price":300000,"description":"Banana Boat max 7 orang"}]}	{"addons":[{"addon_name":"Banana Boat","price":300000,"description":"Banana Boat max 7 orang"}]}	\N	\N
648	1078	activity_types	ef4be35a-a6c5-4e79-9c5c-2a5f7752e586	{"id":"ef4be35a-a6c5-4e79-9c5c-2a5f7752e586","name":"BuildTea","slug":"team-building","description":"Fokus pada aktivitas kerja sama tim, biasanya dikombinasikan dengan games/outbound terstruktur dan fasilitator.","status":"published"}	{"name":"BuildTea"}	\N	\N
649	1079	activity_types	ef4be35a-a6c5-4e79-9c5c-2a5f7752e586	{"id":"ef4be35a-a6c5-4e79-9c5c-2a5f7752e586","name":"Team Building","slug":"team-building","description":"Fokus pada aktivitas kerja sama tim, biasanya dikombinasikan dengan games/outbound terstruktur dan fasilitator.","status":"published"}	{"name":"Team Building"}	\N	\N
673	1106	directus_fields	113	{"id":113,"field":"price_tiers","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"table_title","name":"table_title","type":"json","meta":{"field":"table_title","type":"json","interface":"list","options":{"template":"{{ description }} ({{ min_pax }} - {{ max_pax }} Pax): Rp {{ price_per_pax }}","fields":[{"field":"min_pax","name":"min_pax","type":"integer","meta":{"field":"min_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Jumlah Peserta Minimal"}}},{"field":"max_pax","name":"max_pax","type":"integer","meta":{"field":"max_pax","type":"integer","interface":"input","options":{"placeholder":"Jumlah Peserta Maksimal"}}},{"field":"price_per_pax","name":"price_per_pax","type":"integer","meta":{"field":"price_per_pax","type":"integer","required":true,"interface":"input","options":{"placeholder":"Harga Paket"}}},{"field":"description","name":"description","type":"string","meta":{"field":"description","type":"string","interface":"input","options":{"placeholder":"Deskripsi"}}}]}}}],"template":"{{ table_title }} ","sort":"table_title"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"price_tiers","options":{"fields":[{"field":"table_title","name":"table_title","type":"json","meta":{"field":"table_title","type":"json","interface":"list","options":{"template":"{{ description }} ({{ min_pax }} - {{ max_pax }} Pax): Rp {{ price_per_pax }}","fields":[{"field":"min_pax","name":"min_pax","type":"integer","meta":{"field":"min_pax","width":"half","type":"integer","required":true,"interface":"input","options":{"placeholder":"Jumlah Peserta Minimal"}}},{"field":"max_pax","name":"max_pax","type":"integer","meta":{"field":"max_pax","type":"integer","interface":"input","options":{"placeholder":"Jumlah Peserta Maksimal"}}},{"field":"price_per_pax","name":"price_per_pax","type":"integer","meta":{"field":"price_per_pax","type":"integer","required":true,"interface":"input","options":{"placeholder":"Harga Paket"}}},{"field":"description","name":"description","type":"string","meta":{"field":"description","type":"string","interface":"input","options":{"placeholder":"Deskripsi"}}}]}}}],"template":"{{ table_title }} ","sort":"table_title"}}	\N	\N
674	1107	directus_fields	113	{"id":113,"field":"price_tiers","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"tiers","name":"tiers","type":"json","meta":{"field":"tiers","type":"json","interface":"list","options":{"fields":[{"field":"min_pax","name":"min_pax","type":"integer","meta":{"field":"min_pax","type":"integer","interface":"input"}},{"field":"max_pax","name":"max_pax","type":"integer","meta":{"field":"max_pax","type":"integer","interface":"input"}},{"field":"price_per_pax","name":"price_per_pax","type":"integer","meta":{"field":"price_per_pax","type":"integer","interface":"input"}},{"field":"description","name":"description","type":"string","meta":{"field":"description","type":"string","interface":"input"}}]}}}],"template":"{{ table_title }} Paket Harga","sort":"table_title"},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"price_tiers","options":{"fields":[{"field":"tiers","name":"tiers","type":"json","meta":{"field":"tiers","type":"json","interface":"list","options":{"fields":[{"field":"min_pax","name":"min_pax","type":"integer","meta":{"field":"min_pax","type":"integer","interface":"input"}},{"field":"max_pax","name":"max_pax","type":"integer","meta":{"field":"max_pax","type":"integer","interface":"input"}},{"field":"price_per_pax","name":"price_per_pax","type":"integer","meta":{"field":"price_per_pax","type":"integer","interface":"input"}},{"field":"description","name":"description","type":"string","meta":{"field":"description","type":"string","interface":"input"}}]}}}],"template":"{{ table_title }} Paket Harga","sort":"table_title"}}	\N	\N
675	1111	directus_fields	195	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
676	1112	directus_collections	package_price_tables	{"singleton":false,"sort_field":"sort","archive_field":null,"archive_value":null,"unarchive_value":null,"icon":"table_chart","note":"Harga per tabel (grup) — setiap baris = 1 tier harga dalam 1 tabel. Frontend group by table_title.","sort":10,"collection":"package_price_tables"}	{"singleton":false,"sort_field":"sort","archive_field":null,"archive_value":null,"unarchive_value":null,"icon":"table_chart","note":"Harga per tabel (grup) — setiap baris = 1 tier harga dalam 1 tabel. Frontend group by table_title.","sort":10,"collection":"package_price_tables"}	\N	\N
677	1113	directus_fields	196	{"sort":2,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"display":"related-values","field":"package_id"}	{"sort":2,"interface":"select-dropdown-m2o","special":["m2o"],"required":true,"display":"related-values","field":"package_id"}	\N	\N
687	1144	directus_settings	1	{"id":1,"project_name":"Voda Tour & Event","project_url":null,"project_color":"#EE7D0F","public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"default_appearance":"dark","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_email_filter":null,"visual_editor_urls":null,"project_id":"019f49ff-f861-74eb-a783-58a863877da3","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null,"project_owner":"bb454258-7d81-40f6-af80-ad85011fa204","project_usage":"personal","org_name":null,"product_updates":null,"project_status":null,"ai_openai_api_key":null,"ai_anthropic_api_key":null,"ai_system_prompt":null,"ai_google_api_key":null,"ai_openai_compatible_api_key":null,"ai_openai_compatible_base_url":null,"ai_openai_compatible_name":null,"ai_openai_compatible_models":null,"ai_openai_compatible_headers":null,"ai_openai_allowed_models":["gpt-5-nano","gpt-5-mini","gpt-5"],"ai_anthropic_allowed_models":["claude-haiku-4-5","claude-sonnet-4-5"],"ai_google_allowed_models":["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"],"collaborative_editing_enabled":false,"ai_translation_default_model":null,"ai_translation_glossary":null,"ai_translation_style_guide":null,"license_key":null,"license_token":null,"mcp_oauth_enabled":false,"mcp_oauth_dcr_enabled":false,"mcp_oauth_cimd_enabled":false}	{"project_usage":"personal"}	\N	\N
651	1081	searches	41	{"activity_type_name":"corporate-gathering","query":"One Day Trip Pulau Putri","destination_name":"One Day Trip Pulau Putri","ip_hash":"vmritrtl14oew"}	{"activity_type_name":"corporate-gathering","query":"One Day Trip Pulau Putri","destination_name":"One Day Trip Pulau Putri","ip_hash":"vmritrtl14oew"}	\N	\N
678	1114	directus_fields	197	{"sort":3,"interface":"input","required":true,"width":"full","options":{"placeholder":"Contoh: Harga Domestik (WNI), Harga Paket 3 Hari 2 Malam"},"field":"table_title"}	{"sort":3,"interface":"input","required":true,"width":"full","options":{"placeholder":"Contoh: Harga Domestik (WNI), Harga Paket 3 Hari 2 Malam"},"field":"table_title"}	\N	\N
679	1115	directus_fields	198	{"sort":4,"interface":"input","width":"half","options":{"placeholder":"Min. peserta","min":1},"field":"min_pax"}	{"sort":4,"interface":"input","width":"half","options":{"placeholder":"Min. peserta","min":1},"field":"min_pax"}	\N	\N
680	1116	directus_fields	199	{"sort":5,"interface":"input","width":"half","options":{"placeholder":"Max. peserta (kosongi jika unlimited)"},"field":"max_pax"}	{"sort":5,"interface":"input","width":"half","options":{"placeholder":"Max. peserta (kosongi jika unlimited)"},"field":"max_pax"}	\N	\N
681	1117	directus_fields	200	{"sort":6,"interface":"input","width":"half","options":{"placeholder":"Harga per orang (Rp)","prefix":"Rp"},"field":"price_per_pax"}	{"sort":6,"interface":"input","width":"half","options":{"placeholder":"Harga per orang (Rp)","prefix":"Rp"},"field":"price_per_pax"}	\N	\N
682	1118	directus_fields	201	{"sort":7,"interface":"input-multiline","width":"full","options":{"placeholder":"Keterangan tambahan (opsional)","softLength":200},"field":"description"}	{"sort":7,"interface":"input-multiline","width":"full","options":{"placeholder":"Keterangan tambahan (opsional)","softLength":200},"field":"description"}	\N	\N
683	1119	directus_fields	202	{"sort":100,"interface":"input","hidden":true,"field":"sort"}	{"sort":100,"interface":"input","hidden":true,"field":"sort"}	\N	\N
684	1120	directus_fields	203	{"sort":14,"interface":"list-o2m","special":["o2m"],"required":false,"display":"related-values","options":{"fields":"table_title,min_pax,max_pax,price_per_pax,description,sort","enableCreate":true,"enableSelect":false,"enableDuplicate":true,"sort":11,"layout":"table","template":"{{table_title}} — Rp {{price_per_pax}} ({{min_pax}}-{{max_pax}} pax)"},"field":"price_tables"}	{"sort":14,"interface":"list-o2m","special":["o2m"],"required":false,"display":"related-values","options":{"fields":"table_title,min_pax,max_pax,price_per_pax,description,sort","enableCreate":true,"enableSelect":false,"enableDuplicate":true,"sort":11,"layout":"table","template":"{{table_title}} — Rp {{price_per_pax}} ({{min_pax}}-{{max_pax}} pax)"},"field":"price_tables"}	\N	\N
688	1146	directus_fields	113	{"id":113,"field":"price_tiers","special":["cast-json"],"interface":"list","options":{"template":"{{table_title}} ({{tiers.length}} tier)","fields":[{"field":"table_title","type":"string","name":"Judul Tabel","meta":{"width":"full","interface":"input","required":true,"options":{"placeholder":"Contoh: Paket Speedboat, Paket Ferry"}}},{"field":"tiers","type":"json","name":"Daftar Harga","meta":{"width":"full","interface":"list","options":{"template":"{{min_pax}}-{{max_pax}} pax: Rp {{price_per_pax}}","fields":[{"field":"min_pax","type":"integer","name":"Min Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Min","min":1}}},{"field":"max_pax","type":"integer","name":"Max Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Max (kosongi = unlimited)"}}},{"field":"price_per_pax","type":"integer","name":"Harga per Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Harga (Rp)","prefix":"Rp"}}},{"field":"description","type":"text","name":"Keterangan","meta":{"width":"full","interface":"input-multiline","options":{"placeholder":"Ket. tambahan (opsional)"}}}]}}}]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"price_tiers","interface":"list","options":{"template":"{{table_title}} ({{tiers.length}} tier)","fields":[{"field":"table_title","type":"string","name":"Judul Tabel","meta":{"width":"full","interface":"input","required":true,"options":{"placeholder":"Contoh: Paket Speedboat, Paket Ferry"}}},{"field":"tiers","type":"json","name":"Daftar Harga","meta":{"width":"full","interface":"list","options":{"template":"{{min_pax}}-{{max_pax}} pax: Rp {{price_per_pax}}","fields":[{"field":"min_pax","type":"integer","name":"Min Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Min","min":1}}},{"field":"max_pax","type":"integer","name":"Max Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Max (kosongi = unlimited)"}}},{"field":"price_per_pax","type":"integer","name":"Harga per Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Harga (Rp)","prefix":"Rp"}}},{"field":"description","type":"text","name":"Keterangan","meta":{"width":"full","interface":"input-multiline","options":{"placeholder":"Ket. tambahan (opsional)"}}}]}}}]}}	\N	\N
685	1125	directus_fields	203	{"id":203,"field":"price_tables","special":["o2m"],"interface":null,"options":{"fields":"table_title,min_pax,max_pax,price_per_pax,description,sort","enableCreate":true,"enableSelect":false,"enableDuplicate":true,"sort":11,"layout":"table","template":"{{table_title}} — Rp {{price_per_pax}} ({{min_pax}}-{{max_pax}} pax)"},"display":"related-values","display_options":null,"readonly":false,"hidden":false,"sort":14,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"price_tables","interface":null}	\N	\N
689	1148	directus_fields	113	{"id":113,"field":"price_tiers","special":["cast-json"],"interface":"list","options":{"template":"{{table_title}} ({{tiers.length}} tier)","fields":[{"field":"table_title","type":"string","name":"Judul Tabel","meta":{"width":"full","interface":"input","required":true,"options":{"placeholder":"Contoh: Paket Speedboat, Paket Ferry"}}},{"field":"tiers","type":"json","name":"Daftar Harga","meta":{"width":"full","interface":"list","options":{"template":"{{min_pax}}-{{max_pax}} pax: Rp {{price_per_pax}}","fields":[{"field":"min_pax","type":"integer","name":"Min Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Min","min":1}}},{"field":"max_pax","type":"integer","name":"Max Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Max (kosongi = unlimited)"}}},{"field":"price_per_pax","type":"integer","name":"Harga per Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Harga (Rp)","prefix":"Rp"}}},{"field":"description","type":"text","name":"Keterangan","meta":{"width":"full","interface":"input-multiline","options":{"placeholder":"Ket. tambahan (opsional)"}}}]}}}]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":{"_and":[{"price_tiers":{"_length":{"_lte":3}}}]},"validation_message":"Maksimal 3 tabel harga per paket. Hapus salah satu atau gabungkan ke tabel yang sudah ada.","searchable":true}	{"collection":"packages","field":"price_tiers","validation":{"_and":[{"price_tiers":{"_length":{"_lte":3}}}]},"validation_message":"Maksimal 3 tabel harga per paket. Hapus salah satu atau gabungkan ke tabel yang sudah ada."}	\N	\N
686	1142	directus_fields	113	{"id":113,"field":"price_tiers","special":["cast-json"],"interface":"list","options":{"template":"{{table_title}} — Rp {{price_per_pax}} ({{min_pax}}-{{max_pax}} pax)","fields":[{"field":"table_title","type":"string","name":"Judul Tabel","meta":{"width":"full","interface":"input","options":{"placeholder":"Contoh: Harga Domestik (WNI)"},"required":true},"schema":{"is_nullable":false}},{"field":"min_pax","type":"integer","name":"Min Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Min. peserta","min":1}}},{"field":"max_pax","type":"integer","name":"Max Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Max. (kosongi = unlimited)"}}},{"field":"price_per_pax","type":"integer","name":"Harga per Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Harga (Rp)","prefix":"Rp"}}},{"field":"description","type":"text","name":"Keterangan","meta":{"width":"full","interface":"input-multiline","options":{"placeholder":"Ket. tambahan (opsional)"}}}]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":10,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"packages","field":"price_tiers","interface":"list","options":{"template":"{{table_title}} — Rp {{price_per_pax}} ({{min_pax}}-{{max_pax}} pax)","fields":[{"field":"table_title","type":"string","name":"Judul Tabel","meta":{"width":"full","interface":"input","options":{"placeholder":"Contoh: Harga Domestik (WNI)"},"required":true},"schema":{"is_nullable":false}},{"field":"min_pax","type":"integer","name":"Min Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Min. peserta","min":1}}},{"field":"max_pax","type":"integer","name":"Max Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Max. (kosongi = unlimited)"}}},{"field":"price_per_pax","type":"integer","name":"Harga per Pax","meta":{"width":"half","interface":"input","options":{"placeholder":"Harga (Rp)","prefix":"Rp"}}},{"field":"description","type":"text","name":"Keterangan","meta":{"width":"full","interface":"input-multiline","options":{"placeholder":"Ket. tambahan (opsional)"}}}]}}	\N	\N
690	1152	directus_flows	2f2e9681-7f89-4d83-a388-8565a696a502	{"name":"Validasi Max 3 Tabel Harga","status":"active","icon":"table_chart","color":"#E53935","description":"Mencegah user menambah lebih dari 3 tabel harga per paket","trigger":"event","options":{"type":"filter","scope":["items.create","items.update"],"collections":["packages"],"response_body":{}},"accountability":"all"}	{"name":"Validasi Max 3 Tabel Harga","status":"active","icon":"table_chart","color":"#E53935","description":"Mencegah user menambah lebih dari 3 tabel harga per paket","trigger":"event","options":{"type":"filter","scope":["items.create","items.update"],"collections":["packages"],"response_body":{}},"accountability":"all"}	\N	\N
692	1155	directus_operations	a50f40e2-1d80-4c5f-80d0-e63ec5bbf7ee	{"name":"Tolak: Max 3 tabel","key":"reject","type":"log","position_x":20,"position_y":120,"options":{"message":"Maksimal 3 tabel harga per paket. Hapus salah satu atau gabungkan."}}	{"name":"Tolak: Max 3 tabel","key":"reject","type":"log","position_x":20,"position_y":120,"options":{"message":"Maksimal 3 tabel harga per paket. Hapus salah satu atau gabungkan."}}	\N	\N
693	1156	directus_operations	69515475-2a33-4b04-a09c-86e491b20e0a	{"id":"69515475-2a33-4b04-a09c-86e491b20e0a","name":"Cek > 3 tabel","key":"check_max_3","type":"condition","position_x":20,"position_y":20,"options":{"_and":[{"$trigger":{"body":{"price_tiers":{"_length":{"_gt":3}}}}}]},"date_created":"2026-07-17T02:26:08.291Z"}	{"resolve":"a50f40e2-1d80-4c5f-80d0-e63ec5bbf7ee"}	\N	\N
696	1160	directus_flows	2f2e9681-7f89-4d83-a388-8565a696a502	{"id":"2f2e9681-7f89-4d83-a388-8565a696a502","name":"Validasi Max 3 Tabel Harga","icon":"table_chart","color":"#E53935","description":"Mencegah user menambah lebih dari 3 tabel harga per paket","status":"active","trigger":"event","accountability":"all","options":{"type":"filter","scope":["items.create","items.update"],"collections":["packages"],"response_body":{"error":"Maksimal 3 tabel harga per paket."}},"date_created":"2026-07-17T02:24:44.548Z"}	{"options":{"type":"filter","scope":["items.create","items.update"],"collections":["packages"],"response_body":{"error":"Maksimal 3 tabel harga per paket."}}}	\N	\N
700	1169	directus_operations	69515475-2a33-4b04-a09c-86e491b20e0a	{"id":"69515475-2a33-4b04-a09c-86e491b20e0a","name":"Cek > 3 tabel","key":"check_max_3","type":"condition","position_x":20,"position_y":20,"options":{"conditions":[{"rule":{"_and":[{"$trigger":{"body":{"price_tiers":{"_length":{"_gt":3}}}}}]},"name":"Lebih dari 3 tabel"}]},"date_created":"2026-07-17T02:26:08.291Z"}	{"options":{"conditions":[{"rule":{"_and":[{"$trigger":{"body":{"price_tiers":{"_length":{"_gt":3}}}}}]},"name":"Lebih dari 3 tabel"}]}}	\N	\N
691	1154	directus_operations	69515475-2a33-4b04-a09c-86e491b20e0a	{"name":"Cek > 3 tabel","key":"check_max_3","type":"condition","position_x":20,"position_y":20,"options":{"_and":[{"$trigger":{"body":{"price_tiers":{"_length":{"_gt":3}}}}}]}}	{"name":"Cek > 3 tabel","key":"check_max_3","type":"condition","position_x":20,"position_y":20,"options":{"_and":[{"$trigger":{"body":{"price_tiers":{"_length":{"_gt":3}}}}}]}}	\N	\N
695	1159	directus_operations	69515475-2a33-4b04-a09c-86e491b20e0a	{"id":"69515475-2a33-4b04-a09c-86e491b20e0a","name":"Cek > 3 tabel","key":"check_max_3","type":"condition","position_x":20,"position_y":20,"options":{"_and":[{"$trigger":{"body":{"price_tiers":{"_length":{"_gt":3}}}}}]},"date_created":"2026-07-17T02:26:08.291Z"}	{"resolve":"a50f40e2-1d80-4c5f-80d0-e63ec5bbf7ee"}	\N	\N
694	1158	directus_operations	a50f40e2-1d80-4c5f-80d0-e63ec5bbf7ee	{"id":"a50f40e2-1d80-4c5f-80d0-e63ec5bbf7ee","name":"Tolak: Max 3 tabel","key":"reject","type":"log","position_x":20,"position_y":120,"options":{"message":"Maksimal 3 tabel harga per paket. Hapus salah satu atau gabungkan."},"date_created":"2026-07-17T02:26:08.313Z"}	{"name":"Tolak: Max 3 tabel","key":"reject","type":"log","position_x":20,"position_y":120,"flow":"2f2e9681-7f89-4d83-a388-8565a696a502"}	695	\N
697	1164	directus_operations	d96f8f25-4262-4562-b849-0ca30534d242	{"name":"Reject: Max 3 tabel","key":"reject_event","type":"script","position_x":20,"position_y":120,"options":{"body":"module.exports = async function(data) {\\n    throw new Error('Maksimal 3 tabel harga per paket. Hapus salah satu atau gabungkan.');\\n}"}}	{"name":"Reject: Max 3 tabel","key":"reject_event","type":"script","position_x":20,"position_y":120,"options":{"body":"module.exports = async function(data) {\\n    throw new Error('Maksimal 3 tabel harga per paket. Hapus salah satu atau gabungkan.');\\n}"}}	\N	\N
699	1166	directus_operations	69515475-2a33-4b04-a09c-86e491b20e0a	{"id":"69515475-2a33-4b04-a09c-86e491b20e0a","name":"Cek > 3 tabel","key":"check_max_3","type":"condition","position_x":20,"position_y":20,"options":{"_and":[{"$trigger":{"body":{"price_tiers":{"_length":{"_gt":3}}}}}]},"date_created":"2026-07-17T02:26:08.291Z"}	{"resolve":"d96f8f25-4262-4562-b849-0ca30534d242"}	\N	\N
698	1165	directus_operations	d96f8f25-4262-4562-b849-0ca30534d242	{"id":"d96f8f25-4262-4562-b849-0ca30534d242","name":"Reject: Max 3 tabel","key":"reject_event","type":"script","position_x":20,"position_y":120,"options":{"body":"module.exports = async function(data) {\\n    throw new Error('Maksimal 3 tabel harga per paket. Hapus salah satu atau gabungkan.');\\n}"},"date_created":"2026-07-17T02:27:13.270Z"}	{"name":"Reject: Max 3 tabel","key":"reject_event","type":"script","position_x":20,"position_y":120,"flow":"2f2e9681-7f89-4d83-a388-8565a696a502"}	699	\N
701	1171	directus_flows	2f2e9681-7f89-4d83-a388-8565a696a502	{"steps":[],"data":{"$trigger":{"payload":{"name":"TEST-Package-4-Tabel","slug":"test-package-4-tabel","description":"Test package untuk validasi flow","destination_id":"9e57cb99-472b-4605-bc3d-952a1e0a75ba","duration":"1 Hari","price_tiers":[{"table_title":"Tabel Kecepatan","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":500000,"description":"Harga reguler"}]},{"table_title":"Tabel Lambat","tiers":[{"min_pax":3,"max_pax":5,"price_per_pax":400000,"description":"Harga group kecil"}]},{"table_title":"Tabel Super","tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":300000,"description":"Harga group besar"}]},{"table_title":"Tabel Ekstra","tiers":[{"min_pax":11,"max_pax":20,"price_per_pax":200000,"description":"Hargarombongan"}]}],"facilities":["Test Facility"],"status":"published"},"event":"packages.items.create","collection":"packages"},"$last":{"payload":{"name":"TEST-Package-4-Tabel","slug":"test-package-4-tabel","description":"Test package untuk validasi flow","destination_id":"9e57cb99-472b-4605-bc3d-952a1e0a75ba","duration":"1 Hari","price_tiers":[{"table_title":"Tabel Kecepatan","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":500000,"description":"Harga reguler"}]},{"table_title":"Tabel Lambat","tiers":[{"min_pax":3,"max_pax":5,"price_per_pax":400000,"description":"Harga group kecil"}]},{"table_title":"Tabel Super","tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":300000,"description":"Harga group besar"}]},{"table_title":"Tabel Ekstra","tiers":[{"min_pax":11,"max_pax":20,"price_per_pax":200000,"description":"Hargarombongan"}]}],"facilities":["Test Facility"],"status":"published"},"event":"packages.items.create","collection":"packages"},"$accountability":{"role":"67f28eff-0807-43ec-abd6-c8c9da586552","user":"bb454258-7d81-40f6-af80-ad85011fa204","roles":["67f28eff-0807-43ec-abd6-c8c9da586552"],"admin":true,"app":true,"ip":"172.20.0.1","userAgent":"Python-urllib/3.14"},"$env":{}}}	\N	\N	\N
702	1172	packages	875d00c0-86da-4cf9-a2d7-87b61a4ac671	{"name":"TEST-Package-4-Tabel","slug":"test-package-4-tabel","description":"Test package untuk validasi flow","duration":"1 Hari","price_tiers":[{"table_title":"Tabel Kecepatan","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":500000,"description":"Harga reguler"}]},{"table_title":"Tabel Lambat","tiers":[{"min_pax":3,"max_pax":5,"price_per_pax":400000,"description":"Harga group kecil"}]},{"table_title":"Tabel Super","tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":300000,"description":"Harga group besar"}]},{"table_title":"Tabel Ekstra","tiers":[{"min_pax":11,"max_pax":20,"price_per_pax":200000,"description":"Hargarombongan"}]}],"facilities":["Test Facility"],"status":"published"}	{"name":"TEST-Package-4-Tabel","slug":"test-package-4-tabel","description":"Test package untuk validasi flow","duration":"1 Hari","price_tiers":[{"table_title":"Tabel Kecepatan","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":500000,"description":"Harga reguler"}]},{"table_title":"Tabel Lambat","tiers":[{"min_pax":3,"max_pax":5,"price_per_pax":400000,"description":"Harga group kecil"}]},{"table_title":"Tabel Super","tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":300000,"description":"Harga group besar"}]},{"table_title":"Tabel Ekstra","tiers":[{"min_pax":11,"max_pax":20,"price_per_pax":200000,"description":"Hargarombongan"}]}],"facilities":["Test Facility"],"status":"published"}	\N	\N
703	1174	directus_flows	2f2e9681-7f89-4d83-a388-8565a696a502	{"steps":[],"data":{"$trigger":{"payload":{"name":"TEST-Package-3-Tabel","slug":"test-package-3-tabel","description":"Test package 3 tabel","destination_id":"9e57cb99-472b-4605-bc3d-952a1e0a75ba","duration":"1 Hari","price_tiers":[{"table_title":"Tabel Kecepatan","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":500000,"description":"Harga reguler"}]},{"table_title":"Tabel Lambat","tiers":[{"min_pax":3,"max_pax":5,"price_per_pax":400000,"description":"Harga group kecil"}]},{"table_title":"Tabel Super","tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":300000,"description":"Harga group besar"}]}],"facilities":["Test"],"status":"published"},"event":"packages.items.create","collection":"packages"},"$last":{"payload":{"name":"TEST-Package-3-Tabel","slug":"test-package-3-tabel","description":"Test package 3 tabel","destination_id":"9e57cb99-472b-4605-bc3d-952a1e0a75ba","duration":"1 Hari","price_tiers":[{"table_title":"Tabel Kecepatan","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":500000,"description":"Harga reguler"}]},{"table_title":"Tabel Lambat","tiers":[{"min_pax":3,"max_pax":5,"price_per_pax":400000,"description":"Harga group kecil"}]},{"table_title":"Tabel Super","tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":300000,"description":"Harga group besar"}]}],"facilities":["Test"],"status":"published"},"event":"packages.items.create","collection":"packages"},"$accountability":{"role":"67f28eff-0807-43ec-abd6-c8c9da586552","user":"bb454258-7d81-40f6-af80-ad85011fa204","roles":["67f28eff-0807-43ec-abd6-c8c9da586552"],"admin":true,"app":true,"ip":"172.20.0.1","userAgent":"Python-urllib/3.14"},"$env":{}}}	\N	\N	\N
704	1175	packages	3302f909-8a68-4e4d-921d-03df9728758b	{"name":"TEST-Package-3-Tabel","slug":"test-package-3-tabel","description":"Test package 3 tabel","duration":"1 Hari","price_tiers":[{"table_title":"Tabel Kecepatan","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":500000,"description":"Harga reguler"}]},{"table_title":"Tabel Lambat","tiers":[{"min_pax":3,"max_pax":5,"price_per_pax":400000,"description":"Harga group kecil"}]},{"table_title":"Tabel Super","tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":300000,"description":"Harga group besar"}]}],"facilities":["Test"],"status":"published"}	{"name":"TEST-Package-3-Tabel","slug":"test-package-3-tabel","description":"Test package 3 tabel","duration":"1 Hari","price_tiers":[{"table_title":"Tabel Kecepatan","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":500000,"description":"Harga reguler"}]},{"table_title":"Tabel Lambat","tiers":[{"min_pax":3,"max_pax":5,"price_per_pax":400000,"description":"Harga group kecil"}]},{"table_title":"Tabel Super","tiers":[{"min_pax":6,"max_pax":10,"price_per_pax":300000,"description":"Harga group besar"}]}],"facilities":["Test"],"status":"published"}	\N	\N
705	1179	directus_flows	02d22919-356c-4ccb-9405-42d13a35fdbc	{"name":"Validasi Max 3 Tabel Harga","status":"active","icon":"table_chart","color":"#E53935","description":"Mencegah user menambah lebih dari 3 tabel harga per paket","trigger":"event","options":{"type":"filter","scope":["packages.items.create","packages.items.update"],"collections":["packages"]},"accountability":"all"}	{"name":"Validasi Max 3 Tabel Harga","status":"active","icon":"table_chart","color":"#E53935","description":"Mencegah user menambah lebih dari 3 tabel harga per paket","trigger":"event","options":{"type":"filter","scope":["packages.items.create","packages.items.update"],"collections":["packages"]},"accountability":"all"}	\N	\N
707	1181	directus_operations	3c6f9900-7a31-4da1-a48b-823c9633cfed	{"name":"Reject: Max 3 tabel","key":"reject_event","type":"script","position_x":20,"position_y":120,"options":{"body":"module.exports = async function(data) {\\n    return null;\\n}"}}	{"name":"Reject: Max 3 tabel","key":"reject_event","type":"script","position_x":20,"position_y":120,"options":{"body":"module.exports = async function(data) {\\n    return null;\\n}"}}	\N	\N
706	1180	directus_operations	cfb637cd-e34c-4506-aca3-f69085cdeae9	{"name":"Cek > 3 tabel","key":"check_max_3","type":"condition","position_x":20,"position_y":20,"options":{"_and":[{"$trigger":{"body":{"price_tiers":{"_length":{"_gt":3}}}}}]}}	{"name":"Cek > 3 tabel","key":"check_max_3","type":"condition","position_x":20,"position_y":20,"options":{"_and":[{"$trigger":{"body":{"price_tiers":{"_length":{"_gt":3}}}}}]}}	\N	\N
709	1183	directus_operations	cfb637cd-e34c-4506-aca3-f69085cdeae9	{"id":"cfb637cd-e34c-4506-aca3-f69085cdeae9","name":"Cek > 3 tabel","key":"check_max_3","type":"condition","position_x":20,"position_y":20,"options":{"_and":[{"$trigger":{"body":{"price_tiers":{"_length":{"_gt":3}}}}}]},"date_created":"2026-07-17T02:29:05.907Z"}	{"resolve":"3c6f9900-7a31-4da1-a48b-823c9633cfed"}	\N	\N
708	1182	directus_operations	3c6f9900-7a31-4da1-a48b-823c9633cfed	{"id":"3c6f9900-7a31-4da1-a48b-823c9633cfed","name":"Reject: Max 3 tabel","key":"reject_event","type":"script","position_x":20,"position_y":120,"options":{"body":"module.exports = async function(data) {\\n    return null;\\n}"},"date_created":"2026-07-17T02:29:05.933Z"}	{"key":"reject_event","type":"script","position_x":20,"position_y":120,"flow":"02d22919-356c-4ccb-9405-42d13a35fdbc"}	709	\N
713	1190	directus_operations	07a7e5a9-1695-4cc2-9382-12ea25aa8145	{"name":"Always Reject","key":"always_reject","type":"script","position_x":20,"position_y":20,"options":{"body":"module.exports = async function(data) {\\n    return null;\\n}"}}	{"name":"Always Reject","key":"always_reject","type":"script","position_x":20,"position_y":20,"options":{"body":"module.exports = async function(data) {\\n    return null;\\n}"}}	\N	\N
715	1192	directus_flows	bc154261-1232-4c56-a826-02a808a3e959	{"steps":[{"operation":"07a7e5a9-1695-4cc2-9382-12ea25aa8145","key":"always_reject","status":"unknown","options":null}],"data":{"$trigger":{"payload":{"name":"TEST-Reject","slug":"test-reject","description":"Test","destination_id":"9e57cb99-472b-4605-bc3d-952a1e0a75ba","duration":"1H","price_tiers":[{"table_title":"T1","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":100,"description":"A"}]}],"facilities":["T"],"status":"published"},"event":"packages.items.create","collection":"packages"},"$last":null,"$accountability":{"role":"67f28eff-0807-43ec-abd6-c8c9da586552","user":"bb454258-7d81-40f6-af80-ad85011fa204","roles":["67f28eff-0807-43ec-abd6-c8c9da586552"],"admin":true,"app":true,"ip":"172.20.0.1","userAgent":"Python-urllib/3.14"},"$env":{},"always_reject":null}}	\N	\N	\N
716	1193	packages	d7dfa9ca-235a-4b12-bd87-f0fcc6b21e67	{"name":"TEST-Reject","slug":"test-reject","description":"Test","duration":"1H","price_tiers":[{"table_title":"T1","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":100,"description":"A"}]}],"facilities":["T"],"status":"published"}	{"name":"TEST-Reject","slug":"test-reject","description":"Test","duration":"1H","price_tiers":[{"table_title":"T1","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":100,"description":"A"}]}],"facilities":["T"],"status":"published"}	\N	\N
710	1184	directus_flows	02d22919-356c-4ccb-9405-42d13a35fdbc	{"steps":[],"data":{"$trigger":{"payload":{"name":"TEST-4-Tabels","slug":"test-4-tabels","description":"Test","destination_id":"9e57cb99-472b-4605-bc3d-952a1e0a75ba","duration":"1H","price_tiers":[{"table_title":"T1","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":100,"description":"A"}]},{"table_title":"T2","tiers":[{"min_pax":3,"max_pax":4,"price_per_pax":90,"description":"B"}]},{"table_title":"T3","tiers":[{"min_pax":5,"max_pax":6,"price_per_pax":80,"description":"C"}]},{"table_title":"T4","tiers":[{"min_pax":7,"max_pax":8,"price_per_pax":70,"description":"D"}]}],"facilities":["T"],"status":"published"},"event":"packages.items.create","collection":"packages"},"$last":{"payload":{"name":"TEST-4-Tabels","slug":"test-4-tabels","description":"Test","destination_id":"9e57cb99-472b-4605-bc3d-952a1e0a75ba","duration":"1H","price_tiers":[{"table_title":"T1","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":100,"description":"A"}]},{"table_title":"T2","tiers":[{"min_pax":3,"max_pax":4,"price_per_pax":90,"description":"B"}]},{"table_title":"T3","tiers":[{"min_pax":5,"max_pax":6,"price_per_pax":80,"description":"C"}]},{"table_title":"T4","tiers":[{"min_pax":7,"max_pax":8,"price_per_pax":70,"description":"D"}]}],"facilities":["T"],"status":"published"},"event":"packages.items.create","collection":"packages"},"$accountability":{"role":"67f28eff-0807-43ec-abd6-c8c9da586552","user":"bb454258-7d81-40f6-af80-ad85011fa204","roles":["67f28eff-0807-43ec-abd6-c8c9da586552"],"admin":true,"app":true,"ip":"172.20.0.1","userAgent":"Python-urllib/3.14"},"$env":{}}}	\N	\N	\N
711	1185	packages	e837e5d1-90ce-4d57-96ff-07aa10b38c4b	{"name":"TEST-4-Tabels","slug":"test-4-tabels","description":"Test","duration":"1H","price_tiers":[{"table_title":"T1","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":100,"description":"A"}]},{"table_title":"T2","tiers":[{"min_pax":3,"max_pax":4,"price_per_pax":90,"description":"B"}]},{"table_title":"T3","tiers":[{"min_pax":5,"max_pax":6,"price_per_pax":80,"description":"C"}]},{"table_title":"T4","tiers":[{"min_pax":7,"max_pax":8,"price_per_pax":70,"description":"D"}]}],"facilities":["T"],"status":"published"}	{"name":"TEST-4-Tabels","slug":"test-4-tabels","description":"Test","duration":"1H","price_tiers":[{"table_title":"T1","tiers":[{"min_pax":1,"max_pax":2,"price_per_pax":100,"description":"A"}]},{"table_title":"T2","tiers":[{"min_pax":3,"max_pax":4,"price_per_pax":90,"description":"B"}]},{"table_title":"T3","tiers":[{"min_pax":5,"max_pax":6,"price_per_pax":80,"description":"C"}]},{"table_title":"T4","tiers":[{"min_pax":7,"max_pax":8,"price_per_pax":70,"description":"D"}]}],"facilities":["T"],"status":"published"}	\N	\N
712	1189	directus_flows	bc154261-1232-4c56-a826-02a808a3e959	{"name":"Test Filter Simple","status":"active","icon":"block","color":"#E53935","description":"Test: always reject","trigger":"event","options":{"type":"filter","scope":["items.create"],"collections":["packages"]},"accountability":"all"}	{"name":"Test Filter Simple","status":"active","icon":"block","color":"#E53935","description":"Test: always reject","trigger":"event","options":{"type":"filter","scope":["items.create"],"collections":["packages"]},"accountability":"all"}	\N	\N
714	1191	directus_flows	bc154261-1232-4c56-a826-02a808a3e959	{"id":"bc154261-1232-4c56-a826-02a808a3e959","name":"Test Filter Simple","icon":"block","color":"#E53935","description":"Test: always reject","status":"active","trigger":"event","accountability":"all","options":{"type":"filter","scope":["items.create"],"collections":["packages"]},"date_created":"2026-07-17T02:29:32.628Z"}	{"operation":"07a7e5a9-1695-4cc2-9382-12ea25aa8145"}	\N	\N
717	1195	packages	0e113d05-2450-4eb6-bfc3-5f47a891dc7c	{"id":"0e113d05-2450-4eb6-bfc3-5f47a891dc7c","name":"Paket Wisata Pulau Harapan 1 Hari (One Day Trip)","slug":"paket-wisata-pulau-harapan-one-day","description":"Cocok banget untuk kamu yang punya waktu terbatas tapi tetap ingin refreshing ke pulau. Biasanya berangkat pagi dari dermaga dan kembali sore hari. Dalam waktu singkat, kamu sudah bisa snorkeling, island hopping, dan menikmati suasana pulau yang asri.","duration":"1 Hari","itinerary":null,"price_tiers":[{"table_title":"Paket SpeedBoat","tiers":[{"min_pax":1,"max_pax":10,"price_per_pax":500000}]},{"table_title":"Paket Ferry","tiers":[{"min_pax":1,"max_pax":5,"price_per_pax":700000}]},{"table_title":"Paket Renang","tiers":[{"min_pax":1,"max_pax":5,"price_per_pax":500000}]}],"facilities":["Tiket Masuk Ancol","Tiket Speedboat (pergi Dan Pulang)","Welcome Drink","Makan Siang","Peralatan Snorkeling Lengkap","Perahu Tradisional Untuk Snorkeling","Dokumentasi Underwater","Service Local Guide","Hopping Island (keliling Pulau)"],"status":"published","gallery":null,"addons":null}	{"price_tiers":[{"table_title":"Paket SpeedBoat","tiers":[{"min_pax":1,"max_pax":10,"price_per_pax":500000}]},{"table_title":"Paket Ferry","tiers":[{"min_pax":1,"max_pax":5,"price_per_pax":700000}]},{"table_title":"Paket Renang","tiers":[{"min_pax":1,"max_pax":5,"price_per_pax":500000}]}]}	\N	\N
767	1279	directus_extensions	6d5e25af-4c3e-4c81-8a42-d7b6f66c9703	{"id":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703","enabled":true,"folder":"4b646e9f-e187-45ac-b9dc-f3e71245687a","source":"registry","bundle":null}	{"id":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703","enabled":true,"folder":"4b646e9f-e187-45ac-b9dc-f3e71245687a","source":"registry","bundle":null}	\N	\N
768	1280	directus_extensions	f0d96c04-7385-4b39-8e80-186e045f9bed	{"enabled":true,"folder":"seo-display","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	{"enabled":true,"folder":"seo-display","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	\N	\N
769	1281	directus_extensions	88060c13-f7ba-4edd-89fb-3f2e353f5350	{"enabled":true,"folder":"seo-interface","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	{"enabled":true,"folder":"seo-interface","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	\N	\N
718	1196	packages	0e113d05-2450-4eb6-bfc3-5f47a891dc7c	{"id":"0e113d05-2450-4eb6-bfc3-5f47a891dc7c","name":"Paket Wisata Pulau Harapan 1 Hari (One Day Trip)","slug":"paket-wisata-pulau-harapan-one-day","description":"Cocok banget untuk kamu yang punya waktu terbatas tapi tetap ingin refreshing ke pulau. Biasanya berangkat pagi dari dermaga dan kembali sore hari. Dalam waktu singkat, kamu sudah bisa snorkeling, island hopping, dan menikmati suasana pulau yang asri.","duration":"1 Hari","itinerary":null,"price_tiers":[{"table_title":"Paket SpeedBoat","tiers":[{"min_pax":1,"max_pax":10,"price_per_pax":500000}]},{"table_title":"Paket Ferry","tiers":[{"min_pax":1,"max_pax":5,"price_per_pax":700000}]}],"facilities":["Tiket Masuk Ancol","Tiket Speedboat (pergi Dan Pulang)","Welcome Drink","Makan Siang","Peralatan Snorkeling Lengkap","Perahu Tradisional Untuk Snorkeling","Dokumentasi Underwater","Service Local Guide","Hopping Island (keliling Pulau)"],"status":"published","gallery":null,"addons":null}	{"price_tiers":[{"table_title":"Paket SpeedBoat","tiers":[{"min_pax":1,"max_pax":10,"price_per_pax":500000}]},{"table_title":"Paket Ferry","tiers":[{"min_pax":1,"max_pax":5,"price_per_pax":700000}]}]}	\N	\N
770	1282	directus_extensions	6d5e25af-4c3e-4c81-8a42-d7b6f66c9703	{"id":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703","enabled":true,"folder":"4b646e9f-e187-45ac-b9dc-f3e71245687a","source":"registry","bundle":null}	{"id":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703","enabled":true,"folder":"4b646e9f-e187-45ac-b9dc-f3e71245687a","source":"registry","bundle":null}	\N	\N
771	1283	directus_extensions	ad7d7b2d-e460-4473-851e-e6a2b82c98b3	{"enabled":true,"folder":"seo-display","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	{"enabled":true,"folder":"seo-display","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	\N	\N
772	1284	directus_extensions	7189f4ad-f45a-42d7-9d21-6a0e534253ba	{"enabled":true,"folder":"seo-interface","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	{"enabled":true,"folder":"seo-interface","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	\N	\N
719	1197	packages	0e113d05-2450-4eb6-bfc3-5f47a891dc7c	{"id":"0e113d05-2450-4eb6-bfc3-5f47a891dc7c","name":"Paket Wisata Pulau Harapan 1 Hari (One Day Trip)","slug":"paket-wisata-pulau-harapan-one-day","description":"Cocok banget untuk kamu yang punya waktu terbatas tapi tetap ingin refreshing ke pulau. Biasanya berangkat pagi dari dermaga dan kembali sore hari. Dalam waktu singkat, kamu sudah bisa snorkeling, island hopping, dan menikmati suasana pulau yang asri.","duration":"1 Hari","itinerary":null,"price_tiers":[{"table_title":"Paket SpeedBoat","tiers":[{"min_pax":1,"max_pax":10,"price_per_pax":500000}]},{"table_title":"Paket Ferry","tiers":[{"min_pax":1,"max_pax":5,"price_per_pax":700000}]}],"facilities":["Tiket Masuk Ancol","Tiket Speedboat (pergi Dan Pulang)","Welcome Drink","Makan Siang","Peralatan Snorkeling Lengkap","Perahu Tradisional Untuk Snorkeling","Dokumentasi Underwater","Service Local Guide","Hopping Island (keliling Pulau)"],"status":"published","gallery":null,"addons":[{"addon_name":"Banana Boat","price":300000,"description":"Untuk 7 orang max"},{"addon_name":"Extra Bed","price":100000}]}	{"addons":[{"addon_name":"Banana Boat","price":300000,"description":"Untuk 7 orang max"},{"addon_name":"Extra Bed","price":100000}]}	\N	\N
773	1285	directus_extensions	6d5e25af-4c3e-4c81-8a42-d7b6f66c9703	{"id":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703","enabled":true,"folder":"4b646e9f-e187-45ac-b9dc-f3e71245687a","source":"registry","bundle":null}	{"id":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703","enabled":true,"folder":"4b646e9f-e187-45ac-b9dc-f3e71245687a","source":"registry","bundle":null}	\N	\N
774	1286	directus_extensions	698faa29-4765-4c6b-931c-4c0633ef27a9	{"enabled":true,"folder":"seo-display","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	{"enabled":true,"folder":"seo-display","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	\N	\N
775	1287	directus_extensions	adb374ac-c95c-4024-af4a-d9938e8cd2b2	{"enabled":true,"folder":"seo-interface","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	{"enabled":true,"folder":"seo-interface","source":"registry","bundle":"6d5e25af-4c3e-4c81-8a42-d7b6f66c9703"}	\N	\N
720	1198	settings	3	{"id":3,"key":"wa_number","value":"628571002233","description":"Nomor WhatsApp bisnis"}	{"value":"628571002233"}	\N	\N
722	1204	directus_fields	204	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	{"sort":1,"hidden":true,"interface":"numeric","readonly":true,"field":"id"}	\N	\N
723	1205	directus_collections	articles	{"icon":"article","note":"Artikel blog untuk SEO & content marketing","sort_field":"publish_date","accountability":"all","archive_field":"status","archive_value":"archived","unarchive_value":"draft","archive_app_filter":true,"status":"active","collection":"articles"}	{"icon":"article","note":"Artikel blog untuk SEO & content marketing","sort_field":"publish_date","accountability":"all","archive_field":"status","archive_value":"archived","unarchive_value":"draft","archive_app_filter":true,"status":"active","collection":"articles"}	\N	\N
724	1207	directus_fields	205	{"sort":1,"interface":"select-dropdown","options":{"choices":[{"text":"Draft","value":"draft"},{"text":"Published","value":"published"},{"text":"Archived","value":"archived"}]},"width":"half","required":true,"field":"status"}	{"sort":1,"interface":"select-dropdown","options":{"choices":[{"text":"Draft","value":"draft"},{"text":"Published","value":"published"},{"text":"Archived","value":"archived"}]},"width":"half","required":true,"field":"status"}	\N	\N
721	1199	settings	3	{"id":3,"key":"wa_number","value":"6285771002233","description":"Nomor WhatsApp bisnis"}	{"value":"6285771002233"}	\N	\N
725	1208	directus_fields	206	{"sort":2,"interface":"input","width":"full","required":true,"field":"title"}	{"sort":2,"interface":"input","width":"full","required":true,"field":"title"}	\N	\N
726	1209	directus_fields	207	{"sort":3,"interface":"input","width":"half","note":"Auto-generate dari title","field":"slug"}	{"sort":3,"interface":"input","width":"half","note":"Auto-generate dari title","field":"slug"}	\N	\N
727	1210	directus_fields	208	{"sort":4,"interface":"input-block-editor","width":"full","options":{"placeholder":"Mulai menulis artikel..."},"special":["cast-json"],"field":"content"}	{"sort":4,"interface":"input-block-editor","width":"full","options":{"placeholder":"Mulai menulis artikel..."},"special":["cast-json"],"field":"content"}	\N	\N
728	1211	directus_fields	209	{"sort":5,"interface":"file-image","width":"half","required":true,"field":"featured_image"}	{"sort":5,"interface":"file-image","width":"half","required":true,"field":"featured_image"}	\N	\N
729	1212	directus_fields	210	{"sort":7,"interface":"list","width":"full","options":{"fields":[{"field":"image","type":"uuid","name":"Gambar Iklan","meta":{"interface":"file-image","width":"half","required":true}},{"field":"url","type":"string","name":"Link Tujuan","meta":{"interface":"input","width":"half","required":true}}],"limit":10},"note":"Maksimal 10 iklan per artikel","special":["cast-json"],"field":"ads"}	{"sort":7,"interface":"list","width":"full","options":{"fields":[{"field":"image","type":"uuid","name":"Gambar Iklan","meta":{"interface":"file-image","width":"half","required":true}},{"field":"url","type":"string","name":"Link Tujuan","meta":{"interface":"input","width":"half","required":true}}],"limit":10},"note":"Maksimal 10 iklan per artikel","special":["cast-json"],"field":"ads"}	\N	\N
730	1213	directus_fields	211	{"sort":8,"interface":"json","width":"full","note":"Meta title, meta description, OG tags","special":["cast-json"],"field":"seo"}	{"sort":8,"interface":"json","width":"full","note":"Meta title, meta description, OG tags","special":["cast-json"],"field":"seo"}	\N	\N
731	1214	directus_permissions	10	{"collection":"articles","action":"read","role":null,"permissions":{},"fields":["*"]}	{"collection":"articles","action":"read","role":null,"permissions":{},"fields":["*"]}	\N	\N
732	1217	directus_fields	212	{"sort":6,"interface":"datetime","width":"half","options":{"includeSeconds":true},"field":"publish_date"}	{"sort":6,"interface":"datetime","width":"half","options":{"includeSeconds":true},"field":"publish_date"}	\N	\N
733	1231	directus_fields	213	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	{"sort":1,"hidden":true,"readonly":true,"interface":"input","special":["uuid"],"field":"id"}	\N	\N
734	1232	directus_fields	214	{"sort":1,"interface":"select-dropdown","options":{"choices":[{"text":"Draft","value":"draft"},{"text":"Published","value":"published"},{"text":"Archived","value":"archived"}]},"width":"half","required":true,"field":"status"}	{"sort":1,"interface":"select-dropdown","options":{"choices":[{"text":"Draft","value":"draft"},{"text":"Published","value":"published"},{"text":"Archived","value":"archived"}]},"width":"half","required":true,"field":"status"}	\N	\N
735	1233	directus_fields	215	{"sort":2,"interface":"input","width":"full","required":true,"field":"title"}	{"sort":2,"interface":"input","width":"full","required":true,"field":"title"}	\N	\N
736	1234	directus_fields	216	{"sort":3,"interface":"input","width":"half","note":"Auto-generate dari title","field":"slug"}	{"sort":3,"interface":"input","width":"half","note":"Auto-generate dari title","field":"slug"}	\N	\N
737	1235	directus_fields	217	{"sort":4,"interface":"input-block-editor","width":"full","options":{"placeholder":"Mulai menulis artikel..."},"field":"content","special":["cast-json"]}	{"sort":4,"interface":"input-block-editor","width":"full","options":{"placeholder":"Mulai menulis artikel..."},"field":"content","special":["cast-json"]}	\N	\N
738	1236	directus_fields	218	{"sort":5,"interface":"file-image","width":"half","required":true,"field":"featured_image"}	{"sort":5,"interface":"file-image","width":"half","required":true,"field":"featured_image"}	\N	\N
739	1237	directus_fields	219	{"sort":6,"interface":"datetime","width":"half","options":{"includeSeconds":true},"field":"publish_date"}	{"sort":6,"interface":"datetime","width":"half","options":{"includeSeconds":true},"field":"publish_date"}	\N	\N
740	1238	directus_fields	220	{"sort":7,"interface":"list","width":"full","options":{"fields":[{"field":"image","type":"uuid","name":"Gambar Iklan","meta":{"interface":"file-image","width":"half","required":true}},{"field":"url","type":"string","name":"Link Tujuan","meta":{"interface":"input","width":"half","required":true}}],"limit":10},"note":"Maksimal 10 iklan per artikel","field":"ads","special":["cast-json"]}	{"sort":7,"interface":"list","width":"full","options":{"fields":[{"field":"image","type":"uuid","name":"Gambar Iklan","meta":{"interface":"file-image","width":"half","required":true}},{"field":"url","type":"string","name":"Link Tujuan","meta":{"interface":"input","width":"half","required":true}}],"limit":10},"note":"Maksimal 10 iklan per artikel","field":"ads","special":["cast-json"]}	\N	\N
741	1239	directus_fields	221	{"sort":8,"interface":"json","width":"full","note":"Meta title, meta description, OG tags (sementara raw JSON)","field":"seo","special":["cast-json"]}	{"sort":8,"interface":"json","width":"full","note":"Meta title, meta description, OG tags (sementara raw JSON)","field":"seo","special":["cast-json"]}	\N	\N
742	1240	directus_collections	articles	{"icon":"article","note":"Artikel blog untuk SEO & content marketing","sort_field":"publish_date","accountability":"all","archive_field":"status","archive_value":"archived","unarchive_value":"draft","archive_app_filter":true,"status":"active","collection":"articles"}	{"icon":"article","note":"Artikel blog untuk SEO & content marketing","sort_field":"publish_date","accountability":"all","archive_field":"status","archive_value":"archived","unarchive_value":"draft","archive_app_filter":true,"status":"active","collection":"articles"}	\N	\N
743	1241	directus_permissions	11	{"collection":"articles","action":"read","permissions":{},"fields":["*"]}	{"collection":"articles","action":"read","permissions":{},"fields":["*"]}	\N	\N
744	1244	directus_fields	222	{"sort":9,"interface":"input-rich-text-html","special":null,"required":true,"options":{"toolbar":["undo","redo","bold","italic","underline","fontfamily","fontsize","h1","h2","h3","h4","h5","alignleft","aligncenter","alignright","alignjustify","alignnone","indent","outdent","numlist","bullist","removeformat","cut","copy","paste","selectall","blockquote","customLink","customImage","customMedia","table","hr","fullscreen","code"]},"field":"content"}	{"sort":9,"interface":"input-rich-text-html","special":null,"required":true,"options":{"toolbar":["undo","redo","bold","italic","underline","fontfamily","fontsize","h1","h2","h3","h4","h5","alignleft","aligncenter","alignright","alignjustify","alignnone","indent","outdent","numlist","bullist","removeformat","cut","copy","paste","selectall","blockquote","customLink","customImage","customMedia","table","hr","fullscreen","code"]},"field":"content"}	\N	\N
745	1245	directus_fields	213	{"id":213,"field":"id","special":["uuid"],"interface":"input","options":null,"display":null,"display_options":null,"readonly":true,"hidden":true,"sort":1,"width":"full","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"id","sort":1,"group":null}	\N	\N
746	1246	directus_fields	214	{"id":214,"field":"status","special":null,"interface":"select-dropdown","options":{"choices":[{"text":"Draft","value":"draft"},{"text":"Published","value":"published"},{"text":"Archived","value":"archived"}]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":2,"width":"half","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"status","sort":2,"group":null}	\N	\N
747	1247	directus_fields	215	{"id":215,"field":"title","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":3,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"title","sort":3,"group":null}	\N	\N
748	1248	directus_fields	216	{"id":216,"field":"slug","special":null,"interface":"input","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"half","translations":null,"note":"Auto-generate dari title","conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"slug","sort":4,"group":null}	\N	\N
749	1249	directus_fields	222	{"id":222,"field":"content","special":null,"interface":"input-rich-text-html","options":{"toolbar":["undo","redo","bold","italic","underline","fontfamily","fontsize","h1","h2","h3","h4","h5","alignleft","aligncenter","alignright","alignjustify","alignnone","indent","outdent","numlist","bullist","removeformat","cut","copy","paste","selectall","blockquote","customLink","customImage","customMedia","table","hr","fullscreen","code"]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"content","sort":5,"group":null}	\N	\N
750	1250	directus_fields	218	{"id":218,"field":"featured_image","special":null,"interface":"file-image","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":6,"width":"half","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"featured_image","sort":6,"group":null}	\N	\N
751	1251	directus_fields	219	{"id":219,"field":"publish_date","special":null,"interface":"datetime","options":{"includeSeconds":true},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":7,"width":"half","translations":null,"note":null,"conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"publish_date","sort":7,"group":null}	\N	\N
752	1252	directus_fields	220	{"id":220,"field":"ads","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"image","type":"uuid","name":"Gambar Iklan","meta":{"interface":"file-image","width":"half","required":true}},{"field":"url","type":"string","name":"Link Tujuan","meta":{"interface":"input","width":"half","required":true}}],"limit":10},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":"Maksimal 10 iklan per artikel","conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"ads","sort":8,"group":null}	\N	\N
753	1253	directus_fields	221	{"id":221,"field":"seo","special":["cast-json"],"interface":"json","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":"Meta title, meta description, OG tags (sementara raw JSON)","conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"seo","sort":9,"group":null}	\N	\N
754	1254	directus_fields	222	{"id":222,"field":"content","special":null,"interface":"input-rich-text-html","options":{"toolbar":["undo","redo","bold","italic","underline","fontfamily","fontsize","h1","h2","h3","h4","h5","alignleft","aligncenter","alignright","alignjustify","alignnone","indent","outdent","numlist","bullist","removeformat","cut","copy","paste","selectall","blockquote","customLink","customImage","customMedia","table","hr","fullscreen","code"]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"fill","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"content","width":"fill"}	\N	\N
755	1255	directus_fields	222	{"id":222,"field":"content","special":null,"interface":"input-rich-text-html","options":{"toolbar":["bold","italic","underline","fontfamily","fontsize","h1","h2","h3","alignleft","aligncenter","alignright","alignjustify","alignnone","indent","outdent","numlist","bullist","removeformat","blockquote","customLink","customImage","customMedia","table","hr","fullscreen","code"]},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":5,"width":"fill","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"content","options":{"toolbar":["bold","italic","underline","fontfamily","fontsize","h1","h2","h3","alignleft","aligncenter","alignright","alignjustify","alignnone","indent","outdent","numlist","bullist","removeformat","blockquote","customLink","customImage","customMedia","table","hr","fullscreen","code"]}}	\N	\N
756	1256	articles	3def676a-3b03-44aa-82a7-08edf7717d4e	{"content":"<h2>Tips Cerdas Travel Anti Kena Tipu: Panduan Liburan Tenang dan Aman</h2>\\n<p>Liburan seharusnya menjadi momen yang menyenangkan untuk melepas penat. Namun, ketidaktahuan kita tentang destinasi baru sering kali dimanfaatkan oleh oknum tidak bertanggung jawab untuk melakukan penipuan (<em>scam</em>). Mulai dari taksi dengan argo 'tembak', agen travel bodong, hingga harga makanan yang tidak masuk akal sering kali menghantui para traveler.</p>\\n<p>Agar liburan Anda tetap aman, nyaman, dan ramah di kantong, yuk simak tips travel anti kena tipu berikut ini!</p>\\n<h3>1. Lakukan Riset Mendalam Sebelum Berangkat</h3>\\n<p>Riset adalah kunci utama keselamatan Anda. Sebelum memesan apa pun, cari tahu informasi dasar mengenai destinasi tujuan Anda. Ketahui berapa estimasi biaya transportasi dari bandara ke hotel, area mana saja yang rawan kejahatan, serta jenis penipuan apa yang paling sering dilaporkan oleh turis lain di sana. Anda bisa membaca forum <em>traveler</em> seperti TripAdvisor atau Reddit untuk mendapatkan informasi terkini.</p>\\n<h3>2. Gunakan Aplikasi Resmi untuk Transportasi dan Akomodasi</h3>\\n<p>Hindari menerima tawaran dari calo atau pengemudi taksi liar yang menghampiri Anda di bandara atau stasiun. Sebisa mungkin, gunakan aplikasi <em>ride-hailing</em> resmi (seperti Grab, Gojek, Uber, atau Bolt) yang tarifnya sudah pasti dan rutenya terpantau GPS. Begitu juga dengan penginapan, selalu pesan melalui platform terpercaya seperti Agoda, Booking.com, atau Airbnb, dan baca ulasan dari tamu sebelumnya.</p>\\n<h3>3. Selalu Minta Menu yang Tertera Harganya</h3>\\n<p>Salah satu jebakan yang paling sering menimpa wisatawan adalah \\"harga tembak\\" di warung makan atau restoran. Sebelum duduk dan memesan makanan, pastikan Anda meminta buku menu yang mencantumkan harga dengan jelas. Jika pelayan mengatakan harga secara lisan atau menu tidak mencantumkan harga, lebih baik cari tempat makan lain untuk menghindari tagihan yang membengkak saat selesai makan.</p>\\n<h3>4. Jangan Mudah Percaya pada Orang Asing yang Terlalu Ramah</h3>\\n<p>Sikap ramah penduduk lokal memang menyenangkan, namun Anda tetap harus waspada terhadap orang asing yang tiba-tiba mendekat dan menawarkan bantuan yang tidak diminta. Modus operandi seperti pura-pura menumpahkan sesuatu ke baju Anda, menawarkan gelang persahabatan \\"gratis\\" yang berujung pemerasan, atau mengajak ke toko suvenir tertentu patut dicurigai sebagai upaya penipuan.</p>\\n<h3>5. Tawar-menawar dengan Bijak dan Tentukan Harga di Awal</h3>\\n<p>Jika Anda ingin berbelanja di pasar tradisional atau menggunakan transportasi lokal yang tidak berbasis aplikasi (seperti tuk-tuk atau becak), selalu sepakati harga di awal sebelum Anda naik atau mengambil barang tersebut. Jangan ragu untuk menawar hingga 50-70% dari harga awal yang ditawarkan, namun lakukanlah dengan sopan.</p>\\n<h3>6. Simpan Salinan Dokumen Penting Secara Digital</h3>\\n<p>Kehilangan dompet atau paspor karena dicopet bisa menjadi mimpi buruk. Sebagai langkah antisipasi, buatlah salinan digital (scan/foto) dari paspor, KTP, visa, dan bukti <em>booking</em> hotel. Simpan salinan tersebut di Google Drive, iCloud, atau email Anda, sehingga Anda tetap bisa mengaksesnya kapan saja jika dokumen fisik hilang.</p>\\n<h3>Kesimpulan</h3>\\n<p>Menjadi <em>traveler</em> yang waspada bukan berarti Anda tidak bisa menikmati liburan. Dengan menerapkan persiapan yang matang dan tetap bersikap kritis selama di perjalanan, Anda bisa terhindar dari berbagai modus penipuan dan pulang membawa kenangan yang indah. <strong>Safe travels!</strong></p>","status":"published","title":"Tips Cerdas Travel","slug":"tips-cerdas-travel","publish_date":"2026-07-17T14:52:58"}	{"content":"<h2>Tips Cerdas Travel Anti Kena Tipu: Panduan Liburan Tenang dan Aman</h2>\\n<p>Liburan seharusnya menjadi momen yang menyenangkan untuk melepas penat. Namun, ketidaktahuan kita tentang destinasi baru sering kali dimanfaatkan oleh oknum tidak bertanggung jawab untuk melakukan penipuan (<em>scam</em>). Mulai dari taksi dengan argo 'tembak', agen travel bodong, hingga harga makanan yang tidak masuk akal sering kali menghantui para traveler.</p>\\n<p>Agar liburan Anda tetap aman, nyaman, dan ramah di kantong, yuk simak tips travel anti kena tipu berikut ini!</p>\\n<h3>1. Lakukan Riset Mendalam Sebelum Berangkat</h3>\\n<p>Riset adalah kunci utama keselamatan Anda. Sebelum memesan apa pun, cari tahu informasi dasar mengenai destinasi tujuan Anda. Ketahui berapa estimasi biaya transportasi dari bandara ke hotel, area mana saja yang rawan kejahatan, serta jenis penipuan apa yang paling sering dilaporkan oleh turis lain di sana. Anda bisa membaca forum <em>traveler</em> seperti TripAdvisor atau Reddit untuk mendapatkan informasi terkini.</p>\\n<h3>2. Gunakan Aplikasi Resmi untuk Transportasi dan Akomodasi</h3>\\n<p>Hindari menerima tawaran dari calo atau pengemudi taksi liar yang menghampiri Anda di bandara atau stasiun. Sebisa mungkin, gunakan aplikasi <em>ride-hailing</em> resmi (seperti Grab, Gojek, Uber, atau Bolt) yang tarifnya sudah pasti dan rutenya terpantau GPS. Begitu juga dengan penginapan, selalu pesan melalui platform terpercaya seperti Agoda, Booking.com, atau Airbnb, dan baca ulasan dari tamu sebelumnya.</p>\\n<h3>3. Selalu Minta Menu yang Tertera Harganya</h3>\\n<p>Salah satu jebakan yang paling sering menimpa wisatawan adalah \\"harga tembak\\" di warung makan atau restoran. Sebelum duduk dan memesan makanan, pastikan Anda meminta buku menu yang mencantumkan harga dengan jelas. Jika pelayan mengatakan harga secara lisan atau menu tidak mencantumkan harga, lebih baik cari tempat makan lain untuk menghindari tagihan yang membengkak saat selesai makan.</p>\\n<h3>4. Jangan Mudah Percaya pada Orang Asing yang Terlalu Ramah</h3>\\n<p>Sikap ramah penduduk lokal memang menyenangkan, namun Anda tetap harus waspada terhadap orang asing yang tiba-tiba mendekat dan menawarkan bantuan yang tidak diminta. Modus operandi seperti pura-pura menumpahkan sesuatu ke baju Anda, menawarkan gelang persahabatan \\"gratis\\" yang berujung pemerasan, atau mengajak ke toko suvenir tertentu patut dicurigai sebagai upaya penipuan.</p>\\n<h3>5. Tawar-menawar dengan Bijak dan Tentukan Harga di Awal</h3>\\n<p>Jika Anda ingin berbelanja di pasar tradisional atau menggunakan transportasi lokal yang tidak berbasis aplikasi (seperti tuk-tuk atau becak), selalu sepakati harga di awal sebelum Anda naik atau mengambil barang tersebut. Jangan ragu untuk menawar hingga 50-70% dari harga awal yang ditawarkan, namun lakukanlah dengan sopan.</p>\\n<h3>6. Simpan Salinan Dokumen Penting Secara Digital</h3>\\n<p>Kehilangan dompet atau paspor karena dicopet bisa menjadi mimpi buruk. Sebagai langkah antisipasi, buatlah salinan digital (scan/foto) dari paspor, KTP, visa, dan bukti <em>booking</em> hotel. Simpan salinan tersebut di Google Drive, iCloud, atau email Anda, sehingga Anda tetap bisa mengaksesnya kapan saja jika dokumen fisik hilang.</p>\\n<h3>Kesimpulan</h3>\\n<p>Menjadi <em>traveler</em> yang waspada bukan berarti Anda tidak bisa menikmati liburan. Dengan menerapkan persiapan yang matang dan tetap bersikap kritis selama di perjalanan, Anda bisa terhindar dari berbagai modus penipuan dan pulang membawa kenangan yang indah. <strong>Safe travels!</strong></p>","status":"published","title":"Tips Cerdas Travel","slug":"tips-cerdas-travel","publish_date":"2026-07-17T14:52:58"}	\N	\N
757	1257	articles	3def676a-3b03-44aa-82a7-08edf7717d4e	{"id":"3def676a-3b03-44aa-82a7-08edf7717d4e","status":"published","title":"Tips Cerdas Travel","slug":"tips-cerdas-travel","publish_date":"2026-07-17T14:52:58","ads":null,"seo":null,"content":"<h2><a href=\\"google.com\\" target=\\"_blank\\" rel=\\"noopener\\">Tips Cerdas Travel Anti Kena Tipu: Panduan Liburan Tenang dan Aman</a></h2>\\n<p>Liburan seharusnya menjadi momen yang menyenangkan untuk melepas penat. Namun, ketidaktahuan kita tentang destinasi baru sering kali dimanfaatkan oleh oknum tidak bertanggung jawab untuk melakukan penipuan (<em>scam</em>). Mulai dari taksi dengan argo 'tembak', agen travel bodong, hingga harga makanan yang tidak masuk akal sering kali menghantui para traveler.</p>\\n<p>Agar liburan Anda tetap aman, nyaman, dan ramah di kantong, yuk simak tips travel anti kena tipu berikut ini!</p>\\n<h3>1. Lakukan Riset Mendalam Sebelum Berangkat</h3>\\n<p>Riset adalah kunci utama keselamatan Anda. Sebelum memesan apa pun, cari tahu informasi dasar mengenai destinasi tujuan Anda. Ketahui berapa estimasi biaya transportasi dari bandara ke hotel, area mana saja yang rawan kejahatan, serta jenis penipuan apa yang paling sering dilaporkan oleh turis lain di sana. Anda bisa membaca forum <em>traveler</em> seperti TripAdvisor atau Reddit untuk mendapatkan informasi terkini.</p>\\n<h3>2. Gunakan Aplikasi Resmi untuk Transportasi dan Akomodasi</h3>\\n<p>Hindari menerima tawaran dari calo atau pengemudi taksi liar yang menghampiri Anda di bandara atau stasiun. Sebisa mungkin, gunakan aplikasi <em>ride-hailing</em> resmi (seperti Grab, Gojek, Uber, atau Bolt) yang tarifnya sudah pasti dan rutenya terpantau GPS. Begitu juga dengan penginapan, selalu pesan melalui platform terpercaya seperti Agoda, Booking.com, atau Airbnb, dan baca ulasan dari tamu sebelumnya.</p>\\n<h3>3. Selalu Minta Menu yang Tertera Harganya</h3>\\n<p>Salah satu jebakan yang paling sering menimpa wisatawan adalah \\"harga tembak\\" di warung makan atau restoran. Sebelum duduk dan memesan makanan, pastikan Anda meminta buku menu yang mencantumkan harga dengan jelas. Jika pelayan mengatakan harga secara lisan atau menu tidak mencantumkan harga, lebih baik cari tempat makan lain untuk menghindari tagihan yang membengkak saat selesai makan.</p>\\n<h3>4. Jangan Mudah Percaya pada Orang Asing yang Terlalu Ramah</h3>\\n<p>Sikap ramah penduduk lokal memang menyenangkan, namun Anda tetap harus waspada terhadap orang asing yang tiba-tiba mendekat dan menawarkan bantuan yang tidak diminta. Modus operandi seperti pura-pura menumpahkan sesuatu ke baju Anda, menawarkan gelang persahabatan \\"gratis\\" yang berujung pemerasan, atau mengajak ke toko suvenir tertentu patut dicurigai sebagai upaya penipuan.</p>\\n<h3>5. Tawar-menawar dengan Bijak dan Tentukan Harga di Awal</h3>\\n<p>Jika Anda ingin berbelanja di pasar tradisional atau menggunakan transportasi lokal yang tidak berbasis aplikasi (seperti tuk-tuk atau becak), selalu sepakati harga di awal sebelum Anda naik atau mengambil barang tersebut. Jangan ragu untuk menawar hingga 50-70% dari harga awal yang ditawarkan, namun lakukanlah dengan sopan.</p>\\n<h3>6. Simpan Salinan Dokumen Penting Secara Digital</h3>\\n<p>Kehilangan dompet atau paspor karena dicopet bisa menjadi mimpi buruk. Sebagai langkah antisipasi, buatlah salinan digital (scan/foto) dari paspor, KTP, visa, dan bukti <em>booking</em> hotel. Simpan salinan tersebut di Google Drive, iCloud, atau email Anda, sehingga Anda tetap bisa mengaksesnya kapan saja jika dokumen fisik hilang.</p>\\n<h3>Kesimpulan</h3>\\n<p>Menjadi <em>traveler</em> yang waspada bukan berarti Anda tidak bisa menikmati liburan. Dengan menerapkan persiapan yang matang dan tetap bersikap kritis selama di perjalanan, Anda bisa terhindar dari berbagai modus penipuan dan pulang membawa kenangan yang indah. <strong>Safe travels!</strong></p>"}	{"content":"<h2><a href=\\"google.com\\" target=\\"_blank\\" rel=\\"noopener\\">Tips Cerdas Travel Anti Kena Tipu: Panduan Liburan Tenang dan Aman</a></h2>\\n<p>Liburan seharusnya menjadi momen yang menyenangkan untuk melepas penat. Namun, ketidaktahuan kita tentang destinasi baru sering kali dimanfaatkan oleh oknum tidak bertanggung jawab untuk melakukan penipuan (<em>scam</em>). Mulai dari taksi dengan argo 'tembak', agen travel bodong, hingga harga makanan yang tidak masuk akal sering kali menghantui para traveler.</p>\\n<p>Agar liburan Anda tetap aman, nyaman, dan ramah di kantong, yuk simak tips travel anti kena tipu berikut ini!</p>\\n<h3>1. Lakukan Riset Mendalam Sebelum Berangkat</h3>\\n<p>Riset adalah kunci utama keselamatan Anda. Sebelum memesan apa pun, cari tahu informasi dasar mengenai destinasi tujuan Anda. Ketahui berapa estimasi biaya transportasi dari bandara ke hotel, area mana saja yang rawan kejahatan, serta jenis penipuan apa yang paling sering dilaporkan oleh turis lain di sana. Anda bisa membaca forum <em>traveler</em> seperti TripAdvisor atau Reddit untuk mendapatkan informasi terkini.</p>\\n<h3>2. Gunakan Aplikasi Resmi untuk Transportasi dan Akomodasi</h3>\\n<p>Hindari menerima tawaran dari calo atau pengemudi taksi liar yang menghampiri Anda di bandara atau stasiun. Sebisa mungkin, gunakan aplikasi <em>ride-hailing</em> resmi (seperti Grab, Gojek, Uber, atau Bolt) yang tarifnya sudah pasti dan rutenya terpantau GPS. Begitu juga dengan penginapan, selalu pesan melalui platform terpercaya seperti Agoda, Booking.com, atau Airbnb, dan baca ulasan dari tamu sebelumnya.</p>\\n<h3>3. Selalu Minta Menu yang Tertera Harganya</h3>\\n<p>Salah satu jebakan yang paling sering menimpa wisatawan adalah \\"harga tembak\\" di warung makan atau restoran. Sebelum duduk dan memesan makanan, pastikan Anda meminta buku menu yang mencantumkan harga dengan jelas. Jika pelayan mengatakan harga secara lisan atau menu tidak mencantumkan harga, lebih baik cari tempat makan lain untuk menghindari tagihan yang membengkak saat selesai makan.</p>\\n<h3>4. Jangan Mudah Percaya pada Orang Asing yang Terlalu Ramah</h3>\\n<p>Sikap ramah penduduk lokal memang menyenangkan, namun Anda tetap harus waspada terhadap orang asing yang tiba-tiba mendekat dan menawarkan bantuan yang tidak diminta. Modus operandi seperti pura-pura menumpahkan sesuatu ke baju Anda, menawarkan gelang persahabatan \\"gratis\\" yang berujung pemerasan, atau mengajak ke toko suvenir tertentu patut dicurigai sebagai upaya penipuan.</p>\\n<h3>5. Tawar-menawar dengan Bijak dan Tentukan Harga di Awal</h3>\\n<p>Jika Anda ingin berbelanja di pasar tradisional atau menggunakan transportasi lokal yang tidak berbasis aplikasi (seperti tuk-tuk atau becak), selalu sepakati harga di awal sebelum Anda naik atau mengambil barang tersebut. Jangan ragu untuk menawar hingga 50-70% dari harga awal yang ditawarkan, namun lakukanlah dengan sopan.</p>\\n<h3>6. Simpan Salinan Dokumen Penting Secara Digital</h3>\\n<p>Kehilangan dompet atau paspor karena dicopet bisa menjadi mimpi buruk. Sebagai langkah antisipasi, buatlah salinan digital (scan/foto) dari paspor, KTP, visa, dan bukti <em>booking</em> hotel. Simpan salinan tersebut di Google Drive, iCloud, atau email Anda, sehingga Anda tetap bisa mengaksesnya kapan saja jika dokumen fisik hilang.</p>\\n<h3>Kesimpulan</h3>\\n<p>Menjadi <em>traveler</em> yang waspada bukan berarti Anda tidak bisa menikmati liburan. Dengan menerapkan persiapan yang matang dan tetap bersikap kritis selama di perjalanan, Anda bisa terhindar dari berbagai modus penipuan dan pulang membawa kenangan yang indah. <strong>Safe travels!</strong></p>"}	\N	\N
758	1262	directus_fields	222	{"id":222,"field":"content","special":null,"interface":"directus-extension-tiptap-interface","options":{"toolbar":["bold","italic","underline","strike","code","blockquote","heading","bulletList","orderedList","table","link","image","textAlign","horizontalRule","undo","redo"],"placeholder":"Mulai menulis artikel..."},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"content","interface":"directus-extension-tiptap-interface","options":{"toolbar":["bold","italic","underline","strike","code","blockquote","heading","bulletList","orderedList","table","link","image","textAlign","horizontalRule","undo","redo"],"placeholder":"Mulai menulis artikel..."},"sort":4,"width":"full"}	\N	\N
759	1265	directus_fields	222	{"id":222,"field":"content","special":null,"interface":"input-rich-text-html","options":{"toolbar":["bold","italic","underline","strike","code","blockquote","heading","bulletList","orderedList","table","link","image","textAlign","horizontalRule","undo","redo"],"placeholder":"Mulai menulis artikel..."},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"full","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"content","interface":"input-rich-text-html"}	\N	\N
760	1266	directus_fields	222	{"id":222,"field":"content","special":null,"interface":"input-rich-text-html","options":{"toolbar":["bold","italic","underline","strike","code","blockquote","heading","bulletList","orderedList","table","link","image","textAlign","horizontalRule","undo","redo"],"placeholder":"Mulai menulis artikel..."},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"fill","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"content","width":"fill"}	\N	\N
761	1267	directus_fields	222	{"id":222,"field":"content","special":null,"interface":"input-rich-text-html","options":{"toolbar":["undo","redo","bold","italic","underline","h1","h2","h3","h4","h5","h6","alignleft","aligncenter","alignright","alignjustify","alignnone","indent","outdent","numlist","bullist","removeformat","blockquote","customLink","strike","heading","bulletList","orderedList","link","image","textAlign","horizontalRule","unlink","customImage","customMedia","table","fullscreen","code"],"placeholder":"Mulai menulis artikel..."},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":4,"width":"fill","translations":null,"note":null,"conditions":null,"required":true,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"content","options":{"toolbar":["undo","redo","bold","italic","underline","h1","h2","h3","h4","h5","h6","alignleft","aligncenter","alignright","alignjustify","alignnone","indent","outdent","numlist","bullist","removeformat","blockquote","customLink","strike","heading","bulletList","orderedList","link","image","textAlign","horizontalRule","unlink","customImage","customMedia","table","fullscreen","code"],"placeholder":"Mulai menulis artikel..."}}	\N	\N
762	1268	articles	3def676a-3b03-44aa-82a7-08edf7717d4e	{"id":"3def676a-3b03-44aa-82a7-08edf7717d4e","status":"published","title":"Tips Cerdas Travel","slug":"tips-cerdas-travel","publish_date":"2026-07-17T14:52:58","ads":null,"seo":null,"content":"<article>\\n<h1>20+ Tips Traveling Anti Kena Tipu: Panduan Lengkap Biar Liburan Aman dan Dompet Selamat</h1>\\n<p>Traveling itu soal menciptakan kenangan, bukan menciptakan cerita \\"gara-gara ditipu di jalan\\". Sayangnya, makin ramai destinasi wisata, makin kreatif juga modus penipuan yang mengincar turis, baik turis domestik maupun mancanegara. Mulai dari calo tiket, penginapan fiktif, sampai QR code palsu di tempat parkir, semua modus ini terus berkembang mengikuti kebiasaan traveler modern.</p>\\n<p>Artikel ini merangkum <strong>tips anti kena tipu</strong> yang bisa kamu terapkan mulai dari tahap perencanaan sampai hari-H di lokasi wisata. Simak baik-baik, siapa tahu satu tips di bawah ini bisa menyelamatkan liburan kamu dari drama yang nggak perlu.</p>\\n<h2>1. Kenapa Modus Penipuan Traveler Makin Kreatif?</h2>\\n<p>Di era digital, penipu nggak cuma beroperasi di jalanan. Mereka juga masuk ke marketplace, media sosial, bahkan aplikasi booking. Modusnya makin variatif karena:</p>\\n<ul>\\n<li>Turis biasanya nggak familiar dengan harga lokal, jadi gampang di-<em>mark up</em>.</li>\\n<li>Turis cenderung terburu-buru dan nggak sempat riset mendalam.</li>\\n<li>Bahasa dan budaya yang berbeda membuat turis ragu untuk menawar atau protes.</li>\\n<li>Media sosial mempermudah penipu bikin akun palsu yang terlihat meyakinkan.</li>\\n</ul>\\n<p>Makanya, kunci utama anti kena tipu adalah <strong>persiapan</strong> dan <strong>kewaspadaan yang konsisten</strong>, bukan cuma pas berangkat aja.</p>\\n<h2>2. Riset Sebelum Berangkat Itu Wajib Hukumnya</h2>\\n<p>Sebelum packing baju, luangkan waktu buat riset destinasi. Beberapa hal yang wajib kamu cek:</p>\\n<ol>\\n<li><strong>Harga wajar</strong> untuk transportasi lokal, makanan, dan aktivitas wisata di destinasi tersebut.</li>\\n<li><strong>Modus penipuan yang umum terjadi</strong> di kota atau negara itu, biasanya banyak dibahas di forum traveler seperti <a href=\\"https://www.tripadvisor.com\\" target=\\"_blank\\" rel=\\"noopener noreferrer\\">TripAdvisor</a> atau grup Facebook komunitas traveler.</li>\\n<li><strong>Peraturan setempat</strong>, termasuk soal tawar-menawar, tipping, dan area yang perlu dihindari saat malam hari.</li>\\n<li><strong>Nomor darurat lokal</strong> dan lokasi kedutaan/konsulat jika kamu traveling ke luar negeri.</li>\\n</ol>\\n<blockquote>\\"Traveler yang siap bukan berarti paranoid, tapi traveler yang siap tahu kapan harus curiga dan kapan harus santai menikmati perjalanan.\\"</blockquote>\\n<h2>3. Booking Tiket dan Hotel: Jangan Asal Klik Link</h2>\\n<p>Salah satu modus paling klasik adalah <strong>website atau akun palsu</strong> yang menawarkan tiket pesawat atau kamar hotel dengan harga jauh di bawah pasaran. Supaya nggak kena jebakan ini:</p>\\n<ul>\\n<li>Booking hanya lewat platform resmi seperti situs maskapai langsung, atau agen tepercaya semacam <a href=\\"https://www.booking.com\\" target=\\"_blank\\" rel=\\"noopener noreferrer\\">Booking.com</a> dan <a href=\\"https://www.agoda.com\\" target=\\"_blank\\" rel=\\"noopener noreferrer\\">Agoda</a>.</li>\\n<li>Perhatikan URL, pastikan ada ikon gembok (HTTPS) dan domain resmi, bukan tiruan seperti <em>bookiing-com.net</em>.</li>\\n<li>Hindari transfer langsung ke rekening pribadi tanpa jejak transaksi resmi, walaupun harganya menggiurkan.</li>\\n<li>Cek ulasan penginapan, bukan cuma rating, tapi juga baca komentar detail dari tamu sebelumnya.</li>\\n</ul>\\n<p>Kalau harga terasa \\"terlalu bagus untuk jadi kenyataan\\", biasanya memang bukan kenyataan.</p>\\n<h2>4. Waspada di Bandara dan Transportasi Umum</h2>\\n<p>Bandara dan stasiun adalah tempat favorit modus penipuan karena traveler biasanya capek dan nggak fokus. Beberapa hal yang perlu diwaspadai:</p>\\n<table style=\\"border-collapse: collapse; width: 100%;\\" border=\\"1\\" cellspacing=\\"0\\" cellpadding=\\"8\\">\\n<thead>\\n<tr>\\n<th>Modus</th>\\n<th>Ciri-Ciri</th>\\n<th>Cara Menghindari</th>\\n</tr>\\n</thead>\\n<tbody>\\n<tr>\\n<td>Taksi argo \\"rusak\\"</td>\\n<td>Sopir bilang argo rusak lalu minta tarif flat yang jauh lebih mahal</td>\\n<td>Gunakan aplikasi ride-hailing resmi atau taksi bandara berstiker resmi</td>\\n</tr>\\n<tr>\\n<td>Porter tak diminta</td>\\n<td>Tiba-tiba ada orang bawa koper lo tanpa diminta, lalu minta tip besar</td>\\n<td>Tolak dengan tegas dan pegang barang bawaan sendiri</td>\\n</tr>\\n<tr>\\n<td>Calo tiket transit</td>\\n<td>Menawarkan \\"bantuan\\" transit dengan biaya tambahan tidak resmi</td>\\n<td>Selalu tanya ke petugas berseragam resmi bandara/stasiun</td>\\n</tr>\\n<tr>\\n<td>SIM card palsu</td>\\n<td>Dijual di luar gerai resmi dengan harga tinggi dan kuota tidak sesuai</td>\\n<td>Beli SIM card di konter resmi operator dalam bandara</td>\\n</tr>\\n</tbody>\\n</table>\\n<h2>5. Cari Penginapan: Ciri-Ciri yang Harus Dicurigai</h2>\\n<p>Selain booking online, kadang traveler juga mencari penginapan dadakan di lokasi. Ini beberapa red flag yang wajib diwaspadai:</p>\\n<ul>\\n<li>Pemilik penginapan menolak memberi bukti pemesanan tertulis.</li>\\n<li>Foto kamar di internet jauh berbeda dari kondisi asli.</li>\\n<li>Diminta membayar penuh di muka tanpa opsi pembatalan sama sekali.</li>\\n<li>Lokasi \\"5 menit dari pusat kota\\" ternyata butuh 45 menit naik kendaraan.</li>\\n</ul>\\n<p>Solusinya, selalu simpan bukti chat, email konfirmasi, dan screenshot histori transaksi sebagai bukti kalau ada sengketa nantinya.</p>\\n<h2>6. Modus Calo dan \\"Guide Dadakan\\" di Tempat Wisata</h2>\\n<p>Di banyak destinasi populer, ada orang yang tiba-tiba menawarkan diri jadi <em>guide</em> dadakan atau membantu \\"gratis\\" padahal ujung-ujungnya minta bayaran besar. Tips menghadapinya:</p>\\n<ol>\\n<li>Sopan tapi tegas menolak tawaran bantuan yang tidak diminta.</li>\\n<li>Gunakan guide resmi dari agen wisata terpercaya atau yang direkomendasikan hotel.</li>\\n<li>Kalau ragu, cukup jawab \\"Terima kasih, saya sudah ada rencana sendiri.\\"</li>\\n<li>Jangan mudah percaya orang yang mengaku \\"teman dari hotel/agen kamu\\".</li>\\n</ol>\\n<h2>7. Money Changer dan Transaksi Uang</h2>\\n<p>Urusan uang adalah target utama penipuan karena traveler sering bingung dengan mata uang asing. Supaya aman:</p>\\n<ul>\\n<li>Tukar uang di <strong>money changer berizin resmi</strong>, hindari yang menawarkan kurs jauh lebih tinggi dari pasaran di pinggir jalan.</li>\\n<li>Selalu hitung ulang uang kembalian di depan kasir, jangan langsung dimasukkan ke dompet.</li>\\n<li>Hati-hati dengan trik \\"salah hitung\\" saat pecahan uang mata uang asing terlihat mirip.</li>\\n<li>Gunakan kartu debit/kredit dari bank yang mendukung transaksi luar negeri sebagai cadangan.</li>\\n</ul>\\n<h2>8. Belanja dan Kuliner: Jangan Sampai Kena Harga Turis</h2>\\n<p>Di pasar tradisional atau area wisata, harga barang sering kali punya \\"tarif turis\\" yang jauh lebih mahal dari harga lokal. Cara menyiasatinya:</p>\\n<ul>\\n<li>Tanyakan harga ke beberapa toko sebelum membeli untuk membandingkan.</li>\\n<li>Pelajari kisaran harga wajar dari riset sebelum berangkat.</li>\\n<li>Jangan ragu menawar di tempat yang memang budayanya tawar-menawar.</li>\\n<li>Pilih restoran dengan daftar harga jelas, hindari tempat yang baru kasih harga setelah makanan disajikan.</li>\\n</ul>\\n<h2>9. Teknologi Jadi Senjata: Wifi Publik, QR Code Palsu, dan Aplikasi Abal-Abal</h2>\\n<p>Modus penipuan modern makin sering memanfaatkan teknologi. Beberapa yang perlu diwaspadai:</p>\\n<table style=\\"border-collapse: collapse; width: 100%;\\" border=\\"1\\" cellspacing=\\"0\\" cellpadding=\\"8\\">\\n<thead>\\n<tr>\\n<th>Ancaman Digital</th>\\n<th>Risiko</th>\\n<th>Solusi</th>\\n</tr>\\n</thead>\\n<tbody>\\n<tr>\\n<td>Wifi publik palsu</td>\\n<td>Data pribadi dan login akun bisa dicuri</td>\\n<td>Gunakan VPN dan hindari transaksi finansial di wifi publik</td>\\n</tr>\\n<tr>\\n<td>QR code tempel palsu</td>\\n<td>Pembayaran masuk ke rekening penipu, bukan merchant asli</td>\\n<td>Cek nama merchant yang muncul sebelum konfirmasi bayar</td>\\n</tr>\\n<tr>\\n<td>Aplikasi booking abal-abal</td>\\n<td>Data kartu kredit dicuri, pemesanan fiktif</td>\\n<td>Unduh aplikasi resmi hanya dari App Store/Play Store dengan rating jelas</td>\\n</tr>\\n<tr>\\n<td>Charging station USB publik</td>\\n<td>Rawan \\"juice jacking\\" alias pencurian data lewat kabel USB</td>\\n<td>Gunakan power bank sendiri atau adaptor charger biasa</td>\\n</tr>\\n</tbody>\\n</table>\\n<h2>10. Checklist Anti Kena Tipu Sebelum dan Selama Traveling</h2>\\n<p>Biar makin gampang diingat, ini rangkuman checklist yang bisa kamu simpan sebelum berangkat:</p>\\n<ul>\\n<li>✅ Riset harga wajar transportasi, makanan, dan aktivitas di destinasi</li>\\n<li>✅ Booking tiket dan hotel hanya lewat platform resmi</li>\\n<li>✅ Simpan salinan digital paspor, tiket, dan bukti booking</li>\\n<li>✅ Gunakan aplikasi ride-hailing resmi, bukan taksi sembarangan</li>\\n<li>✅ Tukar uang hanya di money changer berizin</li>\\n<li>✅ Aktifkan VPN saat pakai wifi publik</li>\\n<li>✅ Simpan nomor darurat dan alamat kedutaan/konsulat</li>\\n<li>✅ Percaya insting, kalau terasa aneh, lebih baik hindari</li>\\n</ul>\\n<h2>Kesimpulan</h2>\\n<p>Traveling anti kena tipu bukan soal jadi parno sepanjang perjalanan, tapi soal <strong>siap sedia</strong> dan tahu pola-pola modus yang sering muncul. Dengan riset yang matang, transaksi yang hati-hati, dan insting yang terus diasah, kamu bisa menikmati perjalanan dengan jauh lebih tenang.</p>\\n<p>Ingat, tujuan liburan adalah menciptakan cerita indah, bukan cerita \\"hampir ketipu di destinasi X\\". Jadi, siapkan diri, riset destinasi, dan selamat menjelajah dunia dengan aman!</p>\\n</article>"}	{"content":"<article>\\n<h1>20+ Tips Traveling Anti Kena Tipu: Panduan Lengkap Biar Liburan Aman dan Dompet Selamat</h1>\\n<p>Traveling itu soal menciptakan kenangan, bukan menciptakan cerita \\"gara-gara ditipu di jalan\\". Sayangnya, makin ramai destinasi wisata, makin kreatif juga modus penipuan yang mengincar turis, baik turis domestik maupun mancanegara. Mulai dari calo tiket, penginapan fiktif, sampai QR code palsu di tempat parkir, semua modus ini terus berkembang mengikuti kebiasaan traveler modern.</p>\\n<p>Artikel ini merangkum <strong>tips anti kena tipu</strong> yang bisa kamu terapkan mulai dari tahap perencanaan sampai hari-H di lokasi wisata. Simak baik-baik, siapa tahu satu tips di bawah ini bisa menyelamatkan liburan kamu dari drama yang nggak perlu.</p>\\n<h2>1. Kenapa Modus Penipuan Traveler Makin Kreatif?</h2>\\n<p>Di era digital, penipu nggak cuma beroperasi di jalanan. Mereka juga masuk ke marketplace, media sosial, bahkan aplikasi booking. Modusnya makin variatif karena:</p>\\n<ul>\\n<li>Turis biasanya nggak familiar dengan harga lokal, jadi gampang di-<em>mark up</em>.</li>\\n<li>Turis cenderung terburu-buru dan nggak sempat riset mendalam.</li>\\n<li>Bahasa dan budaya yang berbeda membuat turis ragu untuk menawar atau protes.</li>\\n<li>Media sosial mempermudah penipu bikin akun palsu yang terlihat meyakinkan.</li>\\n</ul>\\n<p>Makanya, kunci utama anti kena tipu adalah <strong>persiapan</strong> dan <strong>kewaspadaan yang konsisten</strong>, bukan cuma pas berangkat aja.</p>\\n<h2>2. Riset Sebelum Berangkat Itu Wajib Hukumnya</h2>\\n<p>Sebelum packing baju, luangkan waktu buat riset destinasi. Beberapa hal yang wajib kamu cek:</p>\\n<ol>\\n<li><strong>Harga wajar</strong> untuk transportasi lokal, makanan, dan aktivitas wisata di destinasi tersebut.</li>\\n<li><strong>Modus penipuan yang umum terjadi</strong> di kota atau negara itu, biasanya banyak dibahas di forum traveler seperti <a href=\\"https://www.tripadvisor.com\\" target=\\"_blank\\" rel=\\"noopener noreferrer\\">TripAdvisor</a> atau grup Facebook komunitas traveler.</li>\\n<li><strong>Peraturan setempat</strong>, termasuk soal tawar-menawar, tipping, dan area yang perlu dihindari saat malam hari.</li>\\n<li><strong>Nomor darurat lokal</strong> dan lokasi kedutaan/konsulat jika kamu traveling ke luar negeri.</li>\\n</ol>\\n<blockquote>\\"Traveler yang siap bukan berarti paranoid, tapi traveler yang siap tahu kapan harus curiga dan kapan harus santai menikmati perjalanan.\\"</blockquote>\\n<h2>3. Booking Tiket dan Hotel: Jangan Asal Klik Link</h2>\\n<p>Salah satu modus paling klasik adalah <strong>website atau akun palsu</strong> yang menawarkan tiket pesawat atau kamar hotel dengan harga jauh di bawah pasaran. Supaya nggak kena jebakan ini:</p>\\n<ul>\\n<li>Booking hanya lewat platform resmi seperti situs maskapai langsung, atau agen tepercaya semacam <a href=\\"https://www.booking.com\\" target=\\"_blank\\" rel=\\"noopener noreferrer\\">Booking.com</a> dan <a href=\\"https://www.agoda.com\\" target=\\"_blank\\" rel=\\"noopener noreferrer\\">Agoda</a>.</li>\\n<li>Perhatikan URL, pastikan ada ikon gembok (HTTPS) dan domain resmi, bukan tiruan seperti <em>bookiing-com.net</em>.</li>\\n<li>Hindari transfer langsung ke rekening pribadi tanpa jejak transaksi resmi, walaupun harganya menggiurkan.</li>\\n<li>Cek ulasan penginapan, bukan cuma rating, tapi juga baca komentar detail dari tamu sebelumnya.</li>\\n</ul>\\n<p>Kalau harga terasa \\"terlalu bagus untuk jadi kenyataan\\", biasanya memang bukan kenyataan.</p>\\n<h2>4. Waspada di Bandara dan Transportasi Umum</h2>\\n<p>Bandara dan stasiun adalah tempat favorit modus penipuan karena traveler biasanya capek dan nggak fokus. Beberapa hal yang perlu diwaspadai:</p>\\n<table style=\\"border-collapse: collapse; width: 100%;\\" border=\\"1\\" cellspacing=\\"0\\" cellpadding=\\"8\\">\\n<thead>\\n<tr>\\n<th>Modus</th>\\n<th>Ciri-Ciri</th>\\n<th>Cara Menghindari</th>\\n</tr>\\n</thead>\\n<tbody>\\n<tr>\\n<td>Taksi argo \\"rusak\\"</td>\\n<td>Sopir bilang argo rusak lalu minta tarif flat yang jauh lebih mahal</td>\\n<td>Gunakan aplikasi ride-hailing resmi atau taksi bandara berstiker resmi</td>\\n</tr>\\n<tr>\\n<td>Porter tak diminta</td>\\n<td>Tiba-tiba ada orang bawa koper lo tanpa diminta, lalu minta tip besar</td>\\n<td>Tolak dengan tegas dan pegang barang bawaan sendiri</td>\\n</tr>\\n<tr>\\n<td>Calo tiket transit</td>\\n<td>Menawarkan \\"bantuan\\" transit dengan biaya tambahan tidak resmi</td>\\n<td>Selalu tanya ke petugas berseragam resmi bandara/stasiun</td>\\n</tr>\\n<tr>\\n<td>SIM card palsu</td>\\n<td>Dijual di luar gerai resmi dengan harga tinggi dan kuota tidak sesuai</td>\\n<td>Beli SIM card di konter resmi operator dalam bandara</td>\\n</tr>\\n</tbody>\\n</table>\\n<h2>5. Cari Penginapan: Ciri-Ciri yang Harus Dicurigai</h2>\\n<p>Selain booking online, kadang traveler juga mencari penginapan dadakan di lokasi. Ini beberapa red flag yang wajib diwaspadai:</p>\\n<ul>\\n<li>Pemilik penginapan menolak memberi bukti pemesanan tertulis.</li>\\n<li>Foto kamar di internet jauh berbeda dari kondisi asli.</li>\\n<li>Diminta membayar penuh di muka tanpa opsi pembatalan sama sekali.</li>\\n<li>Lokasi \\"5 menit dari pusat kota\\" ternyata butuh 45 menit naik kendaraan.</li>\\n</ul>\\n<p>Solusinya, selalu simpan bukti chat, email konfirmasi, dan screenshot histori transaksi sebagai bukti kalau ada sengketa nantinya.</p>\\n<h2>6. Modus Calo dan \\"Guide Dadakan\\" di Tempat Wisata</h2>\\n<p>Di banyak destinasi populer, ada orang yang tiba-tiba menawarkan diri jadi <em>guide</em> dadakan atau membantu \\"gratis\\" padahal ujung-ujungnya minta bayaran besar. Tips menghadapinya:</p>\\n<ol>\\n<li>Sopan tapi tegas menolak tawaran bantuan yang tidak diminta.</li>\\n<li>Gunakan guide resmi dari agen wisata terpercaya atau yang direkomendasikan hotel.</li>\\n<li>Kalau ragu, cukup jawab \\"Terima kasih, saya sudah ada rencana sendiri.\\"</li>\\n<li>Jangan mudah percaya orang yang mengaku \\"teman dari hotel/agen kamu\\".</li>\\n</ol>\\n<h2>7. Money Changer dan Transaksi Uang</h2>\\n<p>Urusan uang adalah target utama penipuan karena traveler sering bingung dengan mata uang asing. Supaya aman:</p>\\n<ul>\\n<li>Tukar uang di <strong>money changer berizin resmi</strong>, hindari yang menawarkan kurs jauh lebih tinggi dari pasaran di pinggir jalan.</li>\\n<li>Selalu hitung ulang uang kembalian di depan kasir, jangan langsung dimasukkan ke dompet.</li>\\n<li>Hati-hati dengan trik \\"salah hitung\\" saat pecahan uang mata uang asing terlihat mirip.</li>\\n<li>Gunakan kartu debit/kredit dari bank yang mendukung transaksi luar negeri sebagai cadangan.</li>\\n</ul>\\n<h2>8. Belanja dan Kuliner: Jangan Sampai Kena Harga Turis</h2>\\n<p>Di pasar tradisional atau area wisata, harga barang sering kali punya \\"tarif turis\\" yang jauh lebih mahal dari harga lokal. Cara menyiasatinya:</p>\\n<ul>\\n<li>Tanyakan harga ke beberapa toko sebelum membeli untuk membandingkan.</li>\\n<li>Pelajari kisaran harga wajar dari riset sebelum berangkat.</li>\\n<li>Jangan ragu menawar di tempat yang memang budayanya tawar-menawar.</li>\\n<li>Pilih restoran dengan daftar harga jelas, hindari tempat yang baru kasih harga setelah makanan disajikan.</li>\\n</ul>\\n<h2>9. Teknologi Jadi Senjata: Wifi Publik, QR Code Palsu, dan Aplikasi Abal-Abal</h2>\\n<p>Modus penipuan modern makin sering memanfaatkan teknologi. Beberapa yang perlu diwaspadai:</p>\\n<table style=\\"border-collapse: collapse; width: 100%;\\" border=\\"1\\" cellspacing=\\"0\\" cellpadding=\\"8\\">\\n<thead>\\n<tr>\\n<th>Ancaman Digital</th>\\n<th>Risiko</th>\\n<th>Solusi</th>\\n</tr>\\n</thead>\\n<tbody>\\n<tr>\\n<td>Wifi publik palsu</td>\\n<td>Data pribadi dan login akun bisa dicuri</td>\\n<td>Gunakan VPN dan hindari transaksi finansial di wifi publik</td>\\n</tr>\\n<tr>\\n<td>QR code tempel palsu</td>\\n<td>Pembayaran masuk ke rekening penipu, bukan merchant asli</td>\\n<td>Cek nama merchant yang muncul sebelum konfirmasi bayar</td>\\n</tr>\\n<tr>\\n<td>Aplikasi booking abal-abal</td>\\n<td>Data kartu kredit dicuri, pemesanan fiktif</td>\\n<td>Unduh aplikasi resmi hanya dari App Store/Play Store dengan rating jelas</td>\\n</tr>\\n<tr>\\n<td>Charging station USB publik</td>\\n<td>Rawan \\"juice jacking\\" alias pencurian data lewat kabel USB</td>\\n<td>Gunakan power bank sendiri atau adaptor charger biasa</td>\\n</tr>\\n</tbody>\\n</table>\\n<h2>10. Checklist Anti Kena Tipu Sebelum dan Selama Traveling</h2>\\n<p>Biar makin gampang diingat, ini rangkuman checklist yang bisa kamu simpan sebelum berangkat:</p>\\n<ul>\\n<li>✅ Riset harga wajar transportasi, makanan, dan aktivitas di destinasi</li>\\n<li>✅ Booking tiket dan hotel hanya lewat platform resmi</li>\\n<li>✅ Simpan salinan digital paspor, tiket, dan bukti booking</li>\\n<li>✅ Gunakan aplikasi ride-hailing resmi, bukan taksi sembarangan</li>\\n<li>✅ Tukar uang hanya di money changer berizin</li>\\n<li>✅ Aktifkan VPN saat pakai wifi publik</li>\\n<li>✅ Simpan nomor darurat dan alamat kedutaan/konsulat</li>\\n<li>✅ Percaya insting, kalau terasa aneh, lebih baik hindari</li>\\n</ul>\\n<h2>Kesimpulan</h2>\\n<p>Traveling anti kena tipu bukan soal jadi parno sepanjang perjalanan, tapi soal <strong>siap sedia</strong> dan tahu pola-pola modus yang sering muncul. Dengan riset yang matang, transaksi yang hati-hati, dan insting yang terus diasah, kamu bisa menikmati perjalanan dengan jauh lebih tenang.</p>\\n<p>Ingat, tujuan liburan adalah menciptakan cerita indah, bukan cerita \\"hampir ketipu di destinasi X\\". Jadi, siapkan diri, riset destinasi, dan selamat menjelajah dunia dengan aman!</p>\\n</article>"}	\N	\N
763	1269	directus_fields	220	{"id":220,"field":"ads","special":["cast-json"],"interface":"list","options":{"fields":[{"field":"gambar_iklan","name":"gambar_iklan","meta":{"interface":"file-image","width":"half","required":true,"options":{"allowedMimeTypes":["image/jpeg","image/png","image/gif","image/webp","image/svg+xml","image/avif","image/tiff"]},"field":"gambar_iklan"}},{"meta":{"interface":"input","width":"half","required":true}}],"limit":10},"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":8,"width":"full","translations":null,"note":"Maksimal 10 iklan per artikel","conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"ads","options":{"fields":[{"field":"gambar_iklan","name":"gambar_iklan","meta":{"interface":"file-image","width":"half","required":true,"options":{"allowedMimeTypes":["image/jpeg","image/png","image/gif","image/webp","image/svg+xml","image/avif","image/tiff"]},"field":"gambar_iklan"}},{"meta":{"interface":"input","width":"half","required":true}}],"limit":10}}	\N	\N
764	1270	directus_collections	articles	{"collection":"articles","icon":"article","note":"Artikel blog untuk SEO & content marketing","display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":"status","archive_app_filter":true,"archive_value":"archived","unarchive_value":"draft","sort_field":"publish_date","accountability":"all","color":null,"item_duplication_fields":["slug"],"sort":null,"collapse":"open","preview_url":null,"versioning":false,"status":"active","autosave_revision_interval":null}	{"item_duplication_fields":["slug"]}	\N	\N
765	1271	directus_collections	articles	{"collection":"articles","icon":"article","note":"Artikel blog untuk SEO & content marketing","display_template":null,"hidden":false,"singleton":false,"translations":null,"archive_field":"status","archive_app_filter":true,"archive_value":"archived","unarchive_value":"draft","sort_field":"publish_date","accountability":"all","color":null,"item_duplication_fields":[],"sort":null,"collapse":"open","preview_url":null,"versioning":false,"status":"active","autosave_revision_interval":null}	{"item_duplication_fields":[]}	\N	\N
766	1272	directus_fields	221	{"id":221,"field":"seo","special":["cast-json"],"interface":"seo-analyzer","options":null,"display":null,"display_options":null,"readonly":false,"hidden":false,"sort":9,"width":"full","translations":null,"note":"SEO Analyzer (Rank Math Clone)","conditions":null,"required":false,"validation":null,"validation_message":null,"searchable":true}	{"collection":"articles","field":"seo","interface":"seo-analyzer","width":"full","note":"SEO Analyzer (Rank Math Clone)"}	\N	\N
\.


--
-- Data for Name: directus_roles; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_roles (id, name, icon, description, parent) FROM stdin;
67f28eff-0807-43ec-abd6-c8c9da586552	Administrator	verified	$t:admin_description	\N
\.


--
-- Data for Name: directus_sessions; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_sessions (token, "user", expires, ip, user_agent, share, origin, next_token, oauth_client) FROM stdin;
CUMh-LCBTr-Zt_Wor3QgW1lhFn_GgTMjbPGuHGjdl-Q9Fht3r9O4_zRm2Io9FFq5	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 08:38:37.094+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
5cAcItHMz3Wegt76WOls7mkHR7FAFTT176dP6_W7SckETZCE1LU1bahhs5TQ6DwQ	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 08:39:50.345+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
0LWfbcv0HdrmKnOJ8mxEsba50ihOQ5nJDRfE2LMJBTVFGraOxHn6n6WlS0b-2zOk	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 08:49:23.091+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
eLgrnhpJGZUKHq2imHRki2yNjBwn21REv49lvUxn5oUMYuKZqFMABOjla5FJJU9B	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 08:41:09.908+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
RsuRotzZQ-uL8JcKi-O1F0jJzzp77iUOEcLb0Y0exqlMVcbFIjNjTy3tEVq1vsCt	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 08:41:22.775+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
o_kDM3wdTfV-T2xK1UdhxOmc42ElHwdOtxcasbOWCILMm-d6f7NgUuEXVTk6cAu1	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 08:49:56.62+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
itmPuZNCXGn9nHcQtBaXy7iB0Ljh3gTAWl1ekMiJ9zGxufQuDY6EcGZKm7zAW0Gz	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 08:50:20.895+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
n5Hbqbm445T2jVXcdHnyULXCQ8vnn1loen9CvQaXdujm1aHo2Z0g_kotSxmJs4kN	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 08:54:28.629+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
GClrZ7_6bZQr3qMS_SwgzqjAZk6id030wp1OCCiPoTlGYuMzI9hwo0IW9oJrPqkw	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 05:02:33.619+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
aF8Tooq9aA_rz16r87Xyqlr0l99Ndkta8VPsQk0t-VNLvDTFQ3b0GMx_j7brXQDh	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 08:43:16.435+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
HGQnWaxJC1XgfyZ5z26oxKQxTvzM8FpHtIss_H05cOQiWgSJ4dRstd7SjDfrvB67	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 08:43:29.967+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
1g07Mg0KfMNnMnGlF6OFhUKReKZLNte_ACNS1LjzUw38NQi0Q5Zbiium5MiIdKYY	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 08:44:02.557+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
rH_6WgI-bj7-Y2LfwshLkRI05pIeLVh-WRCOsv1FJaZJcsovM79i_0E-onxyYa56	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 05:02:45.836+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
81sxsGM_QcDvJwS2iwD7L0sur9vIZQ_ALcN7aw74jslHNE9MQQBxIj9SgNpNcjjj	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:02:39.783+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
70DHYBz85qC67pu1C62ETB-S3VQiGVNS6dF8OLnzYSW9oxkA5j0C46NSJo-CMYui	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:02:52.7+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
GOWawCm5lettTKXRPn_ikiIOWP7SKyK5xVBt_XB4Z1axtWX8jGl-u1hCMWYZ8J0q	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:03:02.66+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
HdY1Nw0sXMN0WMHmW_mlxZuSoVCRG48KL5xB-xPNItv_XWm8Yl8f0eSPL_Q_Adnt	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:03:32.395+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
3NOFSmdKas3t0coxtCDdzx894DJ0LmkQDlQq-7gvSAUKDv8mA9_blIHIz_pq5MuH	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:04:27.054+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
eFWXKYIKF_o11eQh0Z_zLUP5tZTg6E-OuWtXv5RpRIPKwkgQ17k-gk8skoi67jeT	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:04:48.792+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
ZUdr5dTnwTfadRenBu9XIl6liDzwRfaQZYQ9kVlt0Y-1_QsausndPSu9HJjwqU96	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:27:13.066+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
GSdJ_rWCD5iYiAhZ5gTcrb4cUDT0mMsf6gYklsFiq3oZmZO9c0oA_jVOCIMmYDHd	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:27:32.661+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
767uEf85vE46rwheUfOsQvFQSPiOo6287zZ2ZrhSpjePnKvJUz790ZoWVUVuzJ1T	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:27:49.281+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
ecqOL-Yjk07-j5z8tH4eH82fvc-0FIBc4NmeaeQcAotviADFtNN_oKuttg5Hesb2	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:28:02.962+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
WRHQ0uSyWibzAAN8Aewp4k89mD-wjm97ZcAERE75dIZbwIV4FcO4c-c_Sugoy_d5	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:28:16.961+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
NYDClSO9y7_M9gsRnDApIz4SzrJ-b6zBpG1OXcshfx9zwOBdp2I6xLUIfE3cWdSr	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 04:30:24.595+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
QN1omIsM4qtZlvoxKK_rIYbIK6iz-Uy_T7DSY70y7EUh5tizIzD-fYqN2mUo-xE4	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 05:03:25.49+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
ME-zny1ysVcObZnq9CnQ6MfVcmSOpeC49E8Ctt1b0cukUl0TQd0arz_g7HM9JQKT	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 05:02:49.967+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
6uvb-v4exDOCAbtx4RhKm7McuaAkotcOTBfkr90wVxoF9qSIJjjrz-WrD3tH-V4_	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 05:03:03.852+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
xt24vqojAXjbuX-vZiw96bht2IImtMfCAe4xrgP0uDU9Jpwda_fc0UOe4CQYXLP-	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 05:03:17.037+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
5lyYHmgKIFfnEymmASSDu5jgUMJEdYPKoz-r1AfJp30AMFbLIJRyAtNtWHWB21mk	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:04:38.368+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
OrjjzVe4YINgkwRcfF3SaKApgbI-kAhHxT8hNEgT3HzFit2lEJwrB0hQbJvnWpQQ	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:04:08.998+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
RG6-UeiUhD7ytR0kxe_bNtsBJ2PDDLYUinzrghDqfqrkysfhyS1k-1Evol9eym3Q	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:04:28.908+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
LgGKQ8x5IDznzHN1OmS-HKCF1wu-AnJQu_JMJVXSJY2MnAE5caa8XjDAUWCG5wt-	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:04:58.244+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
6DxlU0eBs3N89vCsDVqQ7vDkRNcvbhuh9ipTUg2hfECRgaZGilWHD-N47GHY0otc	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:06:59.087+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
EkW5FQxrJVL72631y4j5JiySvQAO3QtCm-CVlAexuqiYfWBRri5u68B27SObCkog	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:07:17.012+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
HZ1gpAkMdcDPlHTdw0gZyDfitRUYRU2UlzQY_xUNsMd6SxfDb9kcKTKxS9SeF_XK	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:07:31.118+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
YMIo7TkGtRzurX0h6V2WyRDyCDhh3noOFLGVuLqo-GI1AcbmjY-7xo1pWTIJiTqN	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:07:43.692+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
yLY6BIL7A9Y1ZWWnKkD5nQhtPP2LtN0DtJ8_AjFrD0WA6JkfQshJ_-s08Cgih--6	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:08:04.158+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
Y8tGOnwQv6GD-XzOWL5jxZ-aXU2BfkifEbuMvqvSnTTMN_cpVA1OP8nvH50t80ps	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:08:17.472+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
iaZvz8YElOACaW9X1IOxWZDfUM3GEhBPvMvQrKUhyK5r-bP99WzOAXzFdPbUV0x6	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:08:31.833+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
XYfokO6URu6XzqdnnaJvF0fV6OMI3Zc-y6cLou0A6GChUoOtNpEPW_zFwV06sMEO	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:08:45.028+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
2nmY0AGDyPijemaZwWOKK0uJu_HC0u0aWpBJbWSCUBkZUyNrKIaVvRJeAj8FShz3	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:23:12.88+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
73xSbdNwKog7uFo__qvcdEA2kFll4Zq1Kwk75Wi-MgcmOYPjwLRMgyFAhHy8Zskn	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:11:44.366+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
qYM28OfrzhGUVgBi4bx-3ViSwpHWI6SX4vD5A0oTQjNzx_ak0qiMoNRb4Ubi5KD1	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:12:05.72+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
bgbWaArviywbjOGMVQ9ejzZExwIRExGC1vtny2LlS12dMlE1uUSDiQYRxfS-tUA_	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:15:16.968+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
Wpb6VeMywGmGfBzmmPp3Qoplf5EGi2_0c9fV8tJVdKpCd_R0rgyKvxeepBIAcTmC	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:15:34.676+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
-U83J2uNa0jC4CZl7nBV_3QRf00YbR_t1BIcB7y9auNhi__c5s7_aPrBX95bBfbz	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:16:17.004+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
3calODUkwq1C5mm4uSsOQYS8jAJamm59AtUBYjOaeclxYK3UKinsiX-nS-iEHzVA	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:12:58.222+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	\N	http://localhost:8055	\N	\N
kj43iVyay_rbhdwml_w4ZZPqELYvstQoLzCsx-LZjPqmzJCJrNuzvsZ2YZBI2CHN	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:24:04.739+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
U5yVaQ7jIyRLWp_7f4NSSjUK4o27Tzfi1d6xFMIC7Uvdo2rNklqqCbmLujJavBgw	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:16:31.03+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
ceQnlb9Gbr7Ime89_QJf1ArOeOvt4vCXBCJM2gh2XFDtmEudxcY8pnKdd46VHnbR	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:16:42.419+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
rEoIC_NMKO3D_sQUubXU6NMCP3HVh6FJmME1jkMU68O13Ds8OLo-vwBviACtnyOS	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:16:57.824+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
_K-CRj87vxY5tPulSsy82Q5hbK8ZvMUYiICZmQCX7WqaH7U8KAUugoQJYrH8OXjS	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:17:12.965+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
WUec6cvpTKERF4i0sifsLzP9LdlkFAmcBwRDU4j4UzF0DtDo7JU00tAGRnm2jWAE	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:17:41.922+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
Az_Q3sf2IejAzzriyX9ApTtQawEtaKYu1f7mCEMJEXXi2RJ2_2vlmWWemxGPAEqQ	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:24:42.377+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
cfks_55EGFuNMdi2PuS2NKoaysAJjLcDfKVZW85G8nS0prQvGGvFQ8fvvC6ApsCe	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:18:29.96+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
3WyHQVZFyDoFGKVqYu0GcjwsN5d-5UoyVeC_3fP9K6jXw84Ush0g1_gZFuSg0zkq	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:18:41.707+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
-vPb4-CA-4wRz5auyTVgmqPZOEJGr4-CVeXaLc4uC5DAZjbrclQ8edt_JJ0JvY6f	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:26:40.051+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
qhOeZw6dEBiuoGcvyA7wywnLCxG139jEPtb3mDSVBwQjDIFQWIqXW50IKBFHhppt	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:20:22.514+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
UDm_0JldqNywSd9VH7euN4-mW1vQOVGeSjWzybZtCVOKDmmrXNPgyx2kkaGtqXTV	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:20:40.859+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
zljVZhuTqAgiXWxMvtOolihwo6nFtmom2zhfmhztto6vDxLeeGmT8MxtOsG0gFva	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:33:42.175+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
M6DUcJgtjCcUjrILvWxm_Q8E_0hsPqyVdYaXUnbC4hXTLZFoLdNCMac3TFxyxNzo	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:27:31.14+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
fPO4aqyoU2qeXsNeI9lGEC33Ea1mgeM7zOyxQl6mtuwBIFj3kJImBoxMMSloXod2	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:28:01.545+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
MafTC9ZbGb9V7vndhKV_2yk1eVbviwUqOGyFpyvkrRyTfcjkJs1vLS-a6loNogl0	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:35:09.54+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
-DH6uAJcZrVACU6I54-CFMOWIsfvFwSA5VBD9Ry_QCjSYB84q1AnOY5IsjofIwqr	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:35:30.032+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
AOtCJHJW90Vgy1U34tri7c64m30dVPjAcOZ9wcdH1tx3fq7NVDFTj4DB_w5YiEx6	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:32:03.412+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
3DZW59KWM52YCSQq3FjuvigVPi6lG7b-1feZg7euHEXDEJOGbhR7qq1C_k6N2ouj	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:32:16.612+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
xqE_A_C56WyGB9NTG8mlvlVCylPbK_zBILUrxp6fDdyEruG6iBOr9UFVMn30aM8I	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:32:44.778+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
tBphHSa1m4c392E137PtX4J3VEATfMafMhbxPBAMpKU0o7BWMQDPDztyoaTkg7JE	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:33:01.993+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
Cf9af3wQx8Bhyi2cnN0f_EbJ_85EawjxLNh-bJ31CiXi7ACBwnabLfm9yowvc1e6	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:36:04.271+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
jgBFqSEfrr1lv4KcOMGDXq7dK1livk8Ay7HXCSK0HyQk9BeMq-JwPort4BnCe-Qu	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:39:34.895+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
x7Dy6MOBqLci-ZTj-C3v-8Uy3LnYjFO4I4Aku4WOVA5zsQdaMrb-fEBFzzEkhOLC	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 06:53:30.439+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
M-oLKR0jLSFCcI6CMW7oPe6WjARyUh7PB_mQkRlbz1Ct0-GYMFWfHHm5JzkUtJ-o	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 07:57:07.34+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
DNgwNFlnaWfMycu4szAKFXqrApZntNNFpN01trDhnSXuly9hoG_e4wfncbSrxRRk	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 07:57:22.491+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
YOnd2tlHH-7EN-ADjBMChm5XPVERk8kxHwEPpehJ_jDNCJVrYZEyxQZ-q74SInEs	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 07:57:38.437+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
u_ms8J21fNFRuE-X8FUTc6iYwOwqrnZLJWetFKURjdhTV5yoDZ5waLWpJ8Eqta9z	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 07:58:26.174+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
GvGpMOYIQv3Gjm4F1-L1ZO6BskASdy35HS6qTxMfF3H8Wkj3I3gysk5RyfxtQT7v	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-22 03:46:16.568+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
aod9r80XiDNkVv2Esfiz5OZxumHKtlAhyJ9sfVAEcZqnmWlZB2cOt4BIq-pJcD7R	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-22 03:46:35.656+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
h_D6If83V8aKMMZ_4e9E4IbdopnAJ1nMacr9oOQxPYR8wiHmtHIL0e4WG2ueBDvg	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-22 07:36:02.466+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
eQEZKNKBbrB06JZlvxniKNxrIQ7T7ytqIqwYQdD04emd5iKDAAQFhrrxCJWp2zK5	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-22 08:48:47.502+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	\N	http://api.vodaevent.id	\N	\N
CGFIXfbgwdmnp0tvtEyUgEpsswSJCMrm1kTU9IpvEXJve-jkTCC82MnrU_xVaF_f	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:25:04.754+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
oCzGx9_AwxB9Q947RWbjQUtaawCbZoMY0MhqIcxYAbVeK0Mchvsy0VPFNXYJxmGf	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:25:14.782+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
gtnYN0dCc_AW9KcoKRH-oOSNRKjrfA5ht3s_x4ZvFTvCUVwszoheEqog8A6-UKaQ	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:25:57.162+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
FlN8UIZP7bJdBJ210EiKzv0SGO-AyEo6QkGcVG4GrygUQX8kekWPrnSxNp_wDQAw	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:28:23.354+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
JDjEHIUgoJ2E7XUV1Wl_ArNvS9t7AArXBhfRVU_967SWf-e5vI497nYBIZ_Vk3vk	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:26:51.806+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
roZFliYvC4XBe6HblCi12HmgLDRNNfhGlDObyCyx5qE7DmSCmoRog7NwmHlSKlWS	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:21:28.033+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
HvU5OnOW5U3zW7Zzm91cU8pRjK2zcUTboF9HzGhEVjhCUf2eX7N94niMWu-pUGwF	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:23:11.257+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
M36V6vR6AeND_F_HOdk5-8HJKSoQ1mFHLADtU4HbEcQKdNdCskC2VRuAu3Q03COG	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:27:11.756+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
pwG_72uMc81Uw9Ejikgsp1K-FKip4IM4jf4Wg5Lxj4s0WxLOj-Kw3JahemDt89dc	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:27:37.886+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
XC-iddudoE6Jz1_MT_Raw0UGw_NuJZ_1hJGAQD-dWQtNG0LXwR3uzHtsvRsyPJM1	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:16:49.941+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
EnwllUgajzhBOgw1gG-B9cXTSfk7yvXZgFGIllPgYk96gFfAoyh-CoHRXhK-Bq71	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:24:51.273+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
fhaBW7Gdarnj8MEaPSlBELvnShoil-Kbw2bgzAaXfuDXGndpPg4cWtivNfPxigyq	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:29:05.384+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
Y7YoLYJFsAcOt0rzOIsBToQjA1S2waw8OqadIvmuYJlFHLsBsj0D_djWpJ6d4vpT	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:36:57.047+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
WPKAYWCCZtgo10E-pQq9-rvemOJZ08dOgysGSlg7np7kcDAnFVJ2HDICsH66wXTw	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:37:17.146+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
uEAMdm_aGxW4G-XrvMq07LlbWGWcFGILn0YbqxBbGCdfy19J6e67iK0a_tU_t1jL	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 01:37:30.46+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
qNPLoKxY6Afdl2XwysC43t_SOyLCNZPqHTROcRj5qfsTqvXetvloeq3Y7IPM0ABm	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:19:33.33+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
k6G_aHQGnKZycj5CeJP5bj4m6ZfYYD1jAWOA-HYC7s4ODTGPNtF5dgfYfSk5PAm1	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:29:32.161+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
dwWgSV6DLTgcZJAcb0FglNiLEQmjXh4W18GgUmBpq3abNlev2mllYIrs69o4b9aP	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:07:08.01+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
_nGsMHDa8rSGp8p03oqDIrotATQj4OOxJVt2KtkLAB1QqBHdClTRqnAG1tkmYWba	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 07:26:37.263+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
8JvkLfXlDbtLDyArP5oXqRwsYn5oAV6kfnY6JeUZJEljF34dr0bUBZHwW2Vr25hL	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:24:44.115+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
r-R2MBcxdajEhGYjc6rbpowtNjxKHuNRxEW9v0Q-AEc4BCwqagjsMCxa2D40A0jD	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:26:07.851+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
WsZe2hxFi_fccTF6xqMK_N1btYTtOQk3gLyPbUQ7mqrpKt_3KKC1Hw5KAIUzPVSn	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:26:22.856+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
PATRoJRhB70S9Z-QhvuiYsEfRdrOMIUT1Ss4KKDsJqAC89SouO8C1QU5hWbRzitB	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:26:32.342+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
TeqyvGua83n1MLajgvNdFkrqqWW1mPcuer3Sr5UzBtp_zTJJuYppHZ-LGlNFo-C8	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:27:01.664+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
cC1-rkHWfjgZI_CfP53dvbxjC8-raFhy8Gd1hb2HaVhcPy-crSg1U2uCkJriE8KQ	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:27:12.816+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
xUzgyl2wMgadE9CWxLwZm8t2oLY3vucBGSWSXJ15S5CgZC8ztzDw9N8pz9YyPn2G	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:27:22.712+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
2GQHGJYtQgWv_jl-Cc-0JT5IDAMxD5L5Y3dzn_AwquBaLficR-Dz0HqR08vj2uO8	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 02:27:37.02+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
UAqWauRS-aRffEBOT1Lk0asuE2-jdKooMqcfeymNys9HNZwFHja5BbbrlIKIQ3EC	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 07:31:12.94+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
w-w8SQlIJV-q3sRg3TBgWL8vniRerxHJzlQz0-AZ32QfckvMb45xnSI8_jR618ar	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 07:26:48.882+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
ISaJF56QbjVxe-BGHyp36n6L1NBnmNRXH54TCK8fnjKHH_lqdYpZyRNs5CRisTCF	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 07:27:15.059+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
mhCe5VkI9j6YX2x4c7wYRemZ6aXvwt-LT9xJY6Wuv_syhECTt1RRT7NK541D3kvD	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 07:27:38.456+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
RL4l8kpnnVUwF9YwPA1K9fnmncOlqfC2pR8hKUp0WB8zbrbvit97-C4HfqZVE3gz	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 07:28:08.59+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
41WV-_vRKJpJqsxbAf2UkGZsvvqv8ixVKvTWSUlNoy-A0p36AnZ1ammBLzvImsNo	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 07:28:23.137+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
R-32MflS_xGZ9qzw3bykAu07yxVwQH4fGmT6tb2xUIv3OxZESvPH7BahPA-c7yUt	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 07:28:34.731+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
8emYW55luTaQdrNaLNulSLd9Ac4vCnSsgoizdihrnmmfBqJfwaa2J5_7sPA4UVC_	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 07:28:48.341+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
A9itOme6LQYtvdTX8cGRYLcM9bq4r2QVLhD5TRmzYOJFpT631til_srd9lwCsz2M	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 07:29:03.648+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
iVnrpe1TOX7Q_gdvP8aRCGDKz0tqaZBP43vhRjHoS9iGBXg6fxA0jHf6AGDstPZl	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 08:01:48.724+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
TRl3cDWo4HJAxi2zGPjxypGfAISdC5Lv7CIqCbuYD99C2pWlhE0pNe3ZkDYVi_Mm	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 07:31:32.673+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
SAWqh68OjGqy7RaJhEofqYMSygtnyBuWOFtqz4WNzYZg0d9qRNOccCsRcqK45AcI	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 08:01:23.208+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
kex2VuF7ehz-eh3YsDbT1dL8A1Fgh7evlhpJ1eT-ioJ539NHQ1uVHj7BYTRh7tWG	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 08:03:56.209+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
_KhUXe02EFsnmExPamZEFCyfSfXvfugRYqYOi9IzlhHXT5N1ItcRCgayKFytqAsU	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 08:04:07.991+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
_owhiweLZxuaEH1Re5TUUC6EHsEhGPdBQCic2Is956HU9ih2bhDJH_S3b2B3VlZA	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-27 03:23:40.001+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	\N	http://localhost:8055	\N	\N
aQa_fDlQ_LArdTIOV2py4qIBw0FOvohmg7ITy3lROhzMyFXkMUGyBrKeN0hzrLp1	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 08:07:54.246+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
uEQAaOJP-y_zLVB8wPbfdrUb_0BIUxxqfm5NFCyUApq087xnQukiYr8vJAYEPPg6	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 08:08:05.71+00	172.20.0.1	Python-urllib/3.14	\N	\N	\N	\N
N6FVZrqx-goo0QK0519A0ce68io3VHnnnrL_qWy4ioBp8Feo-YmFIK_knR7DeBTD	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-24 08:48:47.071+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0	\N	http://localhost:8055	\N	\N
c622xfAgNHDoePxRTdRhALZJ8jMCvz46cFTj20qGYnGFE2guLe9xpVxqhKVzxVbN	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-27 03:03:15.711+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	\N	http://localhost:8055	\N	\N
0o6S6AnBeRR-w7o1GQ1bVEJ8QyqHB1sWQH2b3gNhNc4DcrJx96X35OAT1JT29Nkl	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-20 03:42:15.646+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	\N	http://localhost:8055	TwxloSBz1jj_XtxhdGTYTYmC0f9t_wsQKAkJialYw0iSSTH3LVCIHYheJZNjfBoq	\N
TwxloSBz1jj_XtxhdGTYTYmC0f9t_wsQKAkJialYw0iSSTH3LVCIHYheJZNjfBoq	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-21 03:42:05.646+00	172.20.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36	\N	http://localhost:8055	\N	\N
\.


--
-- Data for Name: directus_settings; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_settings (id, project_name, project_url, project_color, project_logo, public_foreground, public_background, public_note, auth_login_attempts, auth_password_policy, storage_asset_transform, storage_asset_presets, custom_css, storage_default_folder, basemaps, mapbox_key, module_bar, project_descriptor, default_language, custom_aspect_ratios, public_favicon, default_appearance, default_theme_light, theme_light_overrides, default_theme_dark, theme_dark_overrides, report_error_url, report_bug_url, report_feature_url, public_registration, public_registration_verify_email, public_registration_role, public_registration_email_filter, visual_editor_urls, project_id, mcp_enabled, mcp_allow_deletes, mcp_prompts_collection, mcp_system_prompt_enabled, mcp_system_prompt, project_owner, project_usage, org_name, product_updates, project_status, ai_openai_api_key, ai_anthropic_api_key, ai_system_prompt, ai_google_api_key, ai_openai_compatible_api_key, ai_openai_compatible_base_url, ai_openai_compatible_name, ai_openai_compatible_models, ai_openai_compatible_headers, ai_openai_allowed_models, ai_anthropic_allowed_models, ai_google_allowed_models, collaborative_editing_enabled, ai_translation_default_model, ai_translation_glossary, ai_translation_style_guide, license_key, license_token, mcp_oauth_enabled, mcp_oauth_dcr_enabled, mcp_oauth_cimd_enabled) FROM stdin;
1	Voda Tour & Event	\N	#EE7D0F	\N	\N	\N	\N	25	\N	all	\N	\N	\N	\N	\N	\N	\N	en-US	\N	\N	dark	\N	\N	\N	\N	\N	\N	\N	f	t	\N	\N	\N	019f49ff-f861-74eb-a783-58a863877da3	f	f	\N	t	\N	bb454258-7d81-40f6-af80-ad85011fa204	personal	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	["gpt-5-nano","gpt-5-mini","gpt-5"]	["claude-haiku-4-5","claude-sonnet-4-5"]	["gemini-3-pro-preview","gemini-3-flash-preview","gemini-2.5-pro","gemini-2.5-flash"]	f	\N	\N	\N	\N	\N	f	f	f
\.


--
-- Data for Name: directus_shares; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_shares (id, name, collection, item, role, password, user_created, date_created, date_start, date_end, times_used, max_uses) FROM stdin;
\.


--
-- Data for Name: directus_translations; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_translations (id, language, key, value) FROM stdin;
\.


--
-- Data for Name: directus_users; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_users (id, first_name, last_name, email, password, location, title, description, tags, avatar, language, tfa_secret, status, role, token, last_access, last_page, provider, external_identifier, auth_data, email_notifications, appearance, theme_dark, theme_light, theme_light_overrides, theme_dark_overrides, text_direction) FROM stdin;
bb454258-7d81-40f6-af80-ad85011fa204	Admin	User	admin@vodaevent.id	$argon2id$v=19$m=65536,t=3,p=4$J6azwZADnKYeGozrgHzFYg$6Aqzz26F3H1kxOscIbb2K7I+lxvvL5A0BMbKeDoRnmU	\N	\N	\N	\N	\N	\N	\N	active	67f28eff-0807-43ec-abd6-c8c9da586552	super-secret-admin-token	2026-07-20 03:42:05.655+00	/settings/marketplace/extension/6d5e25af-4c3e-4c81-8a42-d7b6f66c9703	default	\N	\N	t	\N	\N	\N	\N	\N	auto
\.


--
-- Data for Name: directus_versions; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.directus_versions (id, key, name, collection, item, hash, date_created, date_updated, user_created, user_updated, delta) FROM stdin;
\.


--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.packages (id, name, slug, description, destination_id, image, duration, itinerary, price_tiers, facilities, status, gallery, addons) FROM stdin;
71d0c1b6-83be-4473-b73d-efc034075eda	Paket Wisata Pulau Harapan 2 Hari 1 Malam	paket-wisata-pulau-harapan-2d1n	Paket ini adalah pilihan paling umum. Kamu bisa menikmati dua kali snorkeling, BBQ malam, waktu luang di homestay, serta island hopping ke beberapa pulau terdekat. Biasanya sudah termasuk 3 kali makan, penginapan 1 malam, dan guide lokal.	9e57cb99-472b-4605-bc3d-952a1e0a75ba	96c0bc18-ba54-4173-b78c-2910338c56e2	2 Hari 1 Malam	\N	[{"min_pax":2,"max_pax":2,"price_per_pax":958000,"description":"Via Boat Ferry"},{"min_pax":2,"max_pax":2,"price_per_pax":1471000,"description":"Via Speedboat"},{"min_pax":3,"max_pax":3,"price_per_pax":825000,"description":"Via Boat Ferry"},{"min_pax":3,"max_pax":3,"price_per_pax":1338000,"description":"Via Speedboat"},{"min_pax":4,"max_pax":4,"price_per_pax":685000,"description":"Via Boat Ferry"},{"min_pax":4,"max_pax":4,"price_per_pax":1108000,"description":"Via Speedboat"},{"min_pax":5,"max_pax":5,"price_per_pax":575000,"description":"Via Boat Ferry"},{"min_pax":5,"max_pax":5,"price_per_pax":1088000,"description":"Via Speedboat"},{"min_pax":6,"max_pax":6,"price_per_pax":528000,"description":"Via Boat Ferry"},{"min_pax":6,"max_pax":6,"price_per_pax":1041000,"description":"Via Speedboat"},{"min_pax":7,"max_pax":7,"price_per_pax":585000,"description":"Via Boat Ferry"},{"min_pax":7,"max_pax":7,"price_per_pax":998000,"description":"Via Speedboat"},{"min_pax":8,"max_pax":8,"price_per_pax":448000,"description":"Via Boat Ferry"},{"min_pax":8,"max_pax":8,"price_per_pax":961000,"description":"Via Speedboat"},{"min_pax":9,"max_pax":9,"price_per_pax":428000,"description":"Via Boat Ferry"},{"min_pax":9,"max_pax":9,"price_per_pax":941000,"description":"Via Speedboat"},{"min_pax":10,"max_pax":15,"price_per_pax":397000,"description":"Via Boat Ferry"},{"min_pax":10,"max_pax":15,"price_per_pax":910000,"description":"Via Speedboat"},{"min_pax":16,"max_pax":20,"price_per_pax":382000,"description":"Via Boat Ferry"},{"min_pax":16,"max_pax":20,"price_per_pax":895000,"description":"Via Speedboat"},{"min_pax":21,"max_pax":null,"price_per_pax":348000,"description":"Via Boat Ferry"},{"min_pax":21,"max_pax":null,"price_per_pax":861000,"description":"Via Speedboat"}]	["Tiket Masuk Ancol","Tiket Speedboat (Pergi & Pulang)","Welcome Drink","Homestay AC","Makan Siang","Makan Malam","Sarapan","BBQ Dinner","Peralatan Snorkeling Lengkap","Perahu Tradisional Untuk Snorkeling","Life Jacket","Dokumentasi Underwater","Service Local Guide","Island Hopping","Air Mineral"]	published	\N	\N
6fe7ac8a-f231-4949-b2b2-77b9b309c74a	One Day Trip Pulau Putri	one-day-trip-pulau-putri	Paket wisata sehari ke Pulau Putri Resort yang cocok bagi wisatawan yang ingin menikmati fasilitas resort tanpa menginap. Perjalanan menggunakan speedboat dari Marina Ancol dengan aktivitas utama berupa Glass Bottom Boat, Undersea Tunnel Aquarium, berenang di kolam renang, serta menikmati makan siang di resort.	e2c9f388-06bd-4a3c-8713-efc97ce59124	088c8736-3301-4a7f-b0d8-84434409638c	1 Hari	[{"day":1,"title":"One Day Escape","activities":["Boarding di Marina Ancol Dermaga 9","Keberangkatan menuju Pulau Putri pukul 08.00 WIB","Welcome Drink","Menikmati Undersea Tunnel Aquarium","Glass Bottom Boat","Makan Siang","Berenang di Swimming Pool","Bermain di Children Playground","Free Time","Kembali ke Marina Ancol pukul 14.00 WIB"]}]	[{"min_pax":1,"max_pax":1,"price_per_pax":1250000,"description":"Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":1250000,"description":"Child"},{"min_pax":1,"max_pax":1,"price_per_pax":190000,"description":"Infant (<2 Tahun)"}]	["Transportasi Speedboat PP Marina Ancol","Welcome Drink","1x Makan Siang","Glass Bottom Boat","Undersea Tunnel Aquarium","Swimming Pool","Children Playground","Boat Passenger Insurance","Government Tax & Service Charge"]	published	\N	\N
4e215743-3f94-4328-a631-92597e4ee300	Paket Tour Pulau Putri 2 Hari 1 Malam	paket-tour-pulau-putri-2-hari-1-malam	Paket wisata menginap selama 2 hari 1 malam di Pulau Putri Resort, Kepulauan Seribu. Nikmati pengalaman menginap di cottage tepi laut dengan fasilitas lengkap seperti Undersea Tunnel Aquarium, Glass Bottom Boat, Sunset Cruise, kolam renang, dan berbagai aktivitas rekreasi. Cocok untuk keluarga, pasangan, maupun corporate gathering.	e2c9f388-06bd-4a3c-8713-efc97ce59124	794bfde6-a082-4ea6-8cfc-438e14ddb651	2 Hari 1 Malam	[{"day":1,"title":"Arrival & Resort Experience","activities":["Boarding di Marina Ancol Dermaga 9 pukul 07.30 WIB","Keberangkatan menuju Pulau Putri pukul 08.00 WIB","Welcome Drink","Check-in Cottage","Makan Siang","Glass Bottom Boat","Undersea Tunnel Aquarium","Swimming Pool","Sunset Cruise (diganti Snorkeling jika peserta kurang dari 30 orang)","Makan Malam","Free Time","Istirahat"]},{"day":2,"title":"Morning Leisure & Return","activities":["Sarapan","Menikmati fasilitas resort","Swimming Pool","Children Playground","Check-out Cottage","Keberangkatan menuju Marina Ancol pukul 14.00 WIB"]}]	[{"min_pax":1,"max_pax":1,"price_per_pax":2200000,"description":"Weekday - Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":2650000,"description":"Weekend / Public Holiday - Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":1360000,"description":"Weekday - Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1500000,"description":"Weekend / Public Holiday - Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":180000,"description":"Weekday - Infant (<2 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":190000,"description":"Weekend / Public Holiday - Infant (<2 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1610000,"description":"Additional Night - Weekday Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":1950000,"description":"Additional Night - Weekend Adult"},{"min_pax":1,"max_pax":1,"price_per_pax":940000,"description":"Additional Night - Weekday Child (2-10 Tahun)"},{"min_pax":1,"max_pax":1,"price_per_pax":1100000,"description":"Additional Night - Weekend Child (2-10 Tahun)"}]	["Transportasi Speedboat PP Marina Ancol","Welcome Drink","Akomodasi Cottage","4x Makan (2x Makan Siang, 1x Makan Malam, 1x Sarapan)","Glass Bottom Boat","Sunset Cruise","Undersea Tunnel Aquarium","Swimming Pool","Children Playground","Boat Passenger Insurance","Government Tax & Service Charge"]	\N	\N	\N
6d63b96b-d000-4d17-a7db-4969bd8983ec	Paket 1 Hari Pulau Pari	paket-pulau-pari-1	Paket 1 Hari Pulau Pari Paket 1 Hari Pulau Pari Paket 1 Hari Pulau Pari Paket 1 Hari Pulau Pari	393287c3-c166-4522-99d2-a27ab0f62dfa	7af52fd4-e747-4133-8b4a-2522506f8c2f	1 Hari	[{"day":1,"title":"Hari pertama bermain","activities":["07.00 - 09.00 : Kumpul"]}]	[{"min_pax":1,"max_pax":5,"price_per_pax":900000},{"min_pax":6,"max_pax":10,"price_per_pax":500000}]	["Perahu","Makan Siang","Kudapan"]	published	\N	\N
1fdbcdba-d886-443f-864b-6a1b65967c7e	Paket Wisata Pulau Harapan 3 Hari 2 Malam	paket-wisata-pulau-harapan-3d2n	Kalau kamu ingin menikmati suasana pulau tanpa terburu-buru, ini adalah paket yang paling santai. Cocok untuk staycation bareng pasangan, keluarga, atau teman dekat. Kamu punya lebih banyak waktu untuk bersantai, explore pantai, hunting sunrise dan sunset, serta ngobrol bareng warga lokal.	9e57cb99-472b-4605-bc3d-952a1e0a75ba	7af52fd4-e747-4133-8b4a-2522506f8c2f	3 Hari 2 Malam	\N	[{"min_pax":2,"max_pax":2,"price_per_pax":1375000,"description":"Via Boat Ferry"},{"min_pax":2,"max_pax":2,"price_per_pax":1888000,"description":"Via Speedboat"},{"min_pax":3,"max_pax":3,"price_per_pax":1125000,"description":"Via Boat Ferry"},{"min_pax":3,"max_pax":3,"price_per_pax":1638000,"description":"Via Speedboat"},{"min_pax":4,"max_pax":4,"price_per_pax":878000,"description":"Via Boat Ferry"},{"min_pax":4,"max_pax":4,"price_per_pax":1391000,"description":"Via Speedboat"},{"min_pax":5,"max_pax":5,"price_per_pax":842000,"description":"Via Boat Ferry"},{"min_pax":5,"max_pax":5,"price_per_pax":1355000,"description":"Via Speedboat"},{"min_pax":6,"max_pax":6,"price_per_pax":794000,"description":"Via Boat Ferry"},{"min_pax":6,"max_pax":6,"price_per_pax":1307000,"description":"Via Speedboat"},{"min_pax":7,"max_pax":7,"price_per_pax":682000,"description":"Via Boat Ferry"},{"min_pax":7,"max_pax":7,"price_per_pax":1195000,"description":"Via Speedboat"},{"min_pax":8,"max_pax":8,"price_per_pax":641000,"description":"Via Boat Ferry"},{"min_pax":8,"max_pax":8,"price_per_pax":1154000,"description":"Via Speedboat"},{"min_pax":9,"max_pax":9,"price_per_pax":587000,"description":"Via Boat Ferry"},{"min_pax":9,"max_pax":9,"price_per_pax":1100000,"description":"Via Speedboat"},{"min_pax":10,"max_pax":15,"price_per_pax":572000,"description":"Via Boat Ferry"},{"min_pax":10,"max_pax":15,"price_per_pax":1085000,"description":"Via Speedboat"},{"min_pax":16,"max_pax":20,"price_per_pax":542000,"description":"Via Boat Ferry"},{"min_pax":16,"max_pax":20,"price_per_pax":1055000,"description":"Via Speedboat"},{"min_pax":21,"max_pax":null,"price_per_pax":497000,"description":"Via Boat Ferry"},{"min_pax":21,"max_pax":null,"price_per_pax":1010000,"description":"Via Speedboat"}]	\N	published	\N	[{"addon_name":"Banana Boat","price":300000,"description":"Banana Boat max 7 orang"}]
0e113d05-2450-4eb6-bfc3-5f47a891dc7c	Paket Wisata Pulau Harapan 1 Hari (One Day Trip)	paket-wisata-pulau-harapan-one-day	Cocok banget untuk kamu yang punya waktu terbatas tapi tetap ingin refreshing ke pulau. Biasanya berangkat pagi dari dermaga dan kembali sore hari. Dalam waktu singkat, kamu sudah bisa snorkeling, island hopping, dan menikmati suasana pulau yang asri.	9e57cb99-472b-4605-bc3d-952a1e0a75ba	40ae6b39-86a0-4814-a1e1-85f147754ae7	1 Hari	\N	[{"table_title":"Paket SpeedBoat","tiers":[{"min_pax":1,"max_pax":10,"price_per_pax":500000}]},{"table_title":"Paket Ferry","tiers":[{"min_pax":1,"max_pax":5,"price_per_pax":700000}]}]	["Tiket Masuk Ancol","Tiket Speedboat (pergi Dan Pulang)","Welcome Drink","Makan Siang","Peralatan Snorkeling Lengkap","Perahu Tradisional Untuk Snorkeling","Dokumentasi Underwater","Service Local Guide","Hopping Island (keliling Pulau)"]	published	\N	[{"addon_name":"Banana Boat","price":300000,"description":"Untuk 7 orang max"},{"addon_name":"Extra Bed","price":100000}]
\.


--
-- Data for Name: packages_activity_types; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.packages_activity_types (id, package_id, activity_type_id) FROM stdin;
d7d315e7-a26c-42aa-8e93-fe5a23b10036	6fe7ac8a-f231-4949-b2b2-77b9b309c74a	02e09c30-728c-412c-9058-89df82c61c47
f7d36bbb-1da9-41b1-ba39-1b3f1ffe229a	6fe7ac8a-f231-4949-b2b2-77b9b309c74a	e6a14e35-f137-4bf5-a445-21bbff7e2955
8fca081e-d37c-4cbb-b4e4-64be8446bf91	6fe7ac8a-f231-4949-b2b2-77b9b309c74a	3081b30f-b4d9-4395-b070-336e2d58e9c0
3f70db38-0bd0-4d59-9841-75e4a23d31d8	4e215743-3f94-4328-a631-92597e4ee300	e0506893-412e-4824-8d8b-ae019a08b904
43f73151-16ad-46b3-959a-713be9ff480f	6fe7ac8a-f231-4949-b2b2-77b9b309c74a	b909dcf6-2837-4369-a6c6-fbfd5b2b5134
7608e659-9c1e-41bb-b66b-331fac00c408	4e215743-3f94-4328-a631-92597e4ee300	e6a14e35-f137-4bf5-a445-21bbff7e2955
8f2ab01b-b2eb-4020-a93c-37f3ba1527bd	4e215743-3f94-4328-a631-92597e4ee300	3081b30f-b4d9-4395-b070-336e2d58e9c0
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.regions (id, status, user_created, date_created, user_updated, date_updated, name, slug, description, image) FROM stdin;
d3eb9365-e929-413f-a770-e0f491bbeb35	published	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:27:33.135+00	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:56:44.972+00	Kepulauan Seribu (Pulau Penduduk)	kepulauan-seribu-penduduk	Rasakan hangatnya petualangan otentik di Pulau Penduduk Kepulauan Seribu, di mana keindahan alam berpadu harmonis dengan kearifan lokal masyarakat pesisir. Destinasi ini menjadi pilihan sempurna bagi Anda yang ingin menikmati liburan seru namun ramah di kantong, lengkap dengan keseruan aktivitas water sport, snorkeling di terumbu karang yang indah, hingga berburu kuliner laut segar langsung dari nelayan setempat. Menjelajahi keramahan gang-gang kecil pulau dan menyaksikan matahari terbenam bersama warga lokal akan memberikan Anda pengalaman liburan yang hidup, hangat, dan tak terlupakan.	a45ff57c-32ed-4fec-8c2c-9fe05b59cd4a
5ec5476a-aad9-4b36-a20e-23b5f8dc7347	published	bb454258-7d81-40f6-af80-ad85011fa204	2026-07-14 04:59:04.554+00	\N	\N	Kepulauan Seribu (Pulau Resort)	kepulauan-seribu-resort	Wujudkan pelarian mewah yang privat dan eksklusif di Pulau Resort Kepulauan Seribu, sebuah surga tersembunyi yang menawarkan ketenangan mutlak jauh dari hiruk-pikuk ibu kota. Manjakan diri Anda dengan fasilitas kelas dunia, mulai dari menginap di cottage apung yang estetik, menikmati layanan spa tepi pantai, hingga bersantai di pasir putih bersih yang dikelilingi laut jernih berkilau layaknya kristal. Sangat cocok untuk momen honeymoon, liburan keluarga premium, atau self-healing, pulau resort siap memberikan Anda privasi penuh dan kemewahan alami yang memulihkan raga dan jiwa.	40ae6b39-86a0-4814-a1e1-85f147754ae7
\.


--
-- Data for Name: searches; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.searches (id, destination_name, region_name, activity_type_name, pax_count, travel_date, visitor_ip) FROM stdin;
36	Paket Wisata Pulau Harapan 2 Hari 1 Malam	\N	open-trip	\N	\N	\N
37	Paket Wisata Pulau Harapan 2 Hari 1 Malam	\N	corporate-gathering	\N	\N	\N
38	Paket Wisata Pulau Harapan 2 Hari 1 Malam	\N	corporate-gathering	\N	\N	\N
39	Pulau Harapan	\N	corporate-gathering	\N	\N	\N
40	Pulau Harapan	\N	honeymoon-pasangan	\N	\N	\N
41	One Day Trip Pulau Putri	\N	corporate-gathering	\N	\N	\N
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: voda
--

COPY public.settings (id, key, value, description) FROM stdin;
1	site_name	Voda Tour & Event	Nama situs
2	site_description	Perjalanan Berkesan, Momen Tak Terlupakan — Voda Tour & Event adalah mitra perjalanan wisata, gathering, dan event organizer terpercaya di Indonesia.	Deskripsi situs untuk SEO
4	email	info@vodaevent.id	Email kontak
5	phone	(021) 1234-5678	Nomor telepon kantor
7	instagram	https://instagram.com/vodatour.event	Akun Instagram
8	facebook	https://facebook.com/vodatour.event	Akun Facebook
9	youtube	https://youtube.com/@vodatour.event	Akun YouTube
6	address	Jl. Budi No 83, Bandung, Jawa Barat	Alamat kantor
3	wa_number	6285771002233	Nomor WhatsApp bisnis
\.


--
-- Name: directus_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voda
--

SELECT pg_catalog.setval('public.directus_activity_id_seq', 1287, true);


--
-- Name: directus_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voda
--

SELECT pg_catalog.setval('public.directus_fields_id_seq', 222, true);


--
-- Name: directus_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voda
--

SELECT pg_catalog.setval('public.directus_notifications_id_seq', 1, false);


--
-- Name: directus_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voda
--

SELECT pg_catalog.setval('public.directus_permissions_id_seq', 11, true);


--
-- Name: directus_presets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voda
--

SELECT pg_catalog.setval('public.directus_presets_id_seq', 10, true);


--
-- Name: directus_relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voda
--

SELECT pg_catalog.setval('public.directus_relations_id_seq', 68, true);


--
-- Name: directus_revisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voda
--

SELECT pg_catalog.setval('public.directus_revisions_id_seq', 775, true);


--
-- Name: directus_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voda
--

SELECT pg_catalog.setval('public.directus_settings_id_seq', 1, true);


--
-- Name: searches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voda
--

SELECT pg_catalog.setval('public.searches_id_seq', 41, true);


--
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: voda
--

SELECT pg_catalog.setval('public.settings_id_seq', 9, true);


--
-- Name: activity_types activity_types_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.activity_types
    ADD CONSTRAINT activity_types_pkey PRIMARY KEY (id);


--
-- Name: activity_types activity_types_slug_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.activity_types
    ADD CONSTRAINT activity_types_slug_unique UNIQUE (slug);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: articles articles_slug_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_slug_unique UNIQUE (slug);


--
-- Name: destinations destinations_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_pkey PRIMARY KEY (id);


--
-- Name: destinations destinations_slug_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_slug_unique UNIQUE (slug);


--
-- Name: directus_access directus_access_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_pkey PRIMARY KEY (id);


--
-- Name: directus_activity directus_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_activity
    ADD CONSTRAINT directus_activity_pkey PRIMARY KEY (id);


--
-- Name: directus_collections directus_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_pkey PRIMARY KEY (collection);


--
-- Name: directus_comments directus_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_pkey PRIMARY KEY (id);


--
-- Name: directus_dashboards directus_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_pkey PRIMARY KEY (id);


--
-- Name: directus_deployment_projects directus_deployment_projects_deployment_external_id_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_deployment_projects
    ADD CONSTRAINT directus_deployment_projects_deployment_external_id_unique UNIQUE (deployment, external_id);


--
-- Name: directus_deployment_projects directus_deployment_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_deployment_projects
    ADD CONSTRAINT directus_deployment_projects_pkey PRIMARY KEY (id);


--
-- Name: directus_deployment_runs directus_deployment_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_deployment_runs
    ADD CONSTRAINT directus_deployment_runs_pkey PRIMARY KEY (id);


--
-- Name: directus_deployments directus_deployments_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_deployments
    ADD CONSTRAINT directus_deployments_pkey PRIMARY KEY (id);


--
-- Name: directus_deployments directus_deployments_provider_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_deployments
    ADD CONSTRAINT directus_deployments_provider_unique UNIQUE (provider);


--
-- Name: directus_extensions directus_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_extensions
    ADD CONSTRAINT directus_extensions_pkey PRIMARY KEY (id);


--
-- Name: directus_fields directus_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_fields
    ADD CONSTRAINT directus_fields_pkey PRIMARY KEY (id);


--
-- Name: directus_files directus_files_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_pkey PRIMARY KEY (id);


--
-- Name: directus_flows directus_flows_operation_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_operation_unique UNIQUE (operation);


--
-- Name: directus_flows directus_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_pkey PRIMARY KEY (id);


--
-- Name: directus_folders directus_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_pkey PRIMARY KEY (id);


--
-- Name: directus_migrations directus_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_migrations
    ADD CONSTRAINT directus_migrations_pkey PRIMARY KEY (version);


--
-- Name: directus_notifications directus_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_pkey PRIMARY KEY (id);


--
-- Name: directus_oauth_clients directus_oauth_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_clients
    ADD CONSTRAINT directus_oauth_clients_pkey PRIMARY KEY (client_id);


--
-- Name: directus_oauth_codes directus_oauth_codes_code_hash_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_codes
    ADD CONSTRAINT directus_oauth_codes_code_hash_unique UNIQUE (code_hash);


--
-- Name: directus_oauth_codes directus_oauth_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_codes
    ADD CONSTRAINT directus_oauth_codes_pkey PRIMARY KEY (id);


--
-- Name: directus_oauth_consents directus_oauth_consents_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_consents
    ADD CONSTRAINT directus_oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: directus_oauth_consents directus_oauth_consents_user_client_redirect_uri_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_consents
    ADD CONSTRAINT directus_oauth_consents_user_client_redirect_uri_unique UNIQUE ("user", client, redirect_uri);


--
-- Name: directus_oauth_tokens directus_oauth_tokens_client_user_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_tokens
    ADD CONSTRAINT directus_oauth_tokens_client_user_unique UNIQUE (client, "user");


--
-- Name: directus_oauth_tokens directus_oauth_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_tokens
    ADD CONSTRAINT directus_oauth_tokens_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_reject_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_unique UNIQUE (reject);


--
-- Name: directus_operations directus_operations_resolve_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_unique UNIQUE (resolve);


--
-- Name: directus_panels directus_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_pkey PRIMARY KEY (id);


--
-- Name: directus_permissions directus_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_pkey PRIMARY KEY (id);


--
-- Name: directus_policies directus_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_policies
    ADD CONSTRAINT directus_policies_pkey PRIMARY KEY (id);


--
-- Name: directus_presets directus_presets_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_pkey PRIMARY KEY (id);


--
-- Name: directus_relations directus_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_relations
    ADD CONSTRAINT directus_relations_pkey PRIMARY KEY (id);


--
-- Name: directus_revisions directus_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_pkey PRIMARY KEY (id);


--
-- Name: directus_roles directus_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_pkey PRIMARY KEY (id);


--
-- Name: directus_sessions directus_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_pkey PRIMARY KEY (token);


--
-- Name: directus_settings directus_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_pkey PRIMARY KEY (id);


--
-- Name: directus_shares directus_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_pkey PRIMARY KEY (id);


--
-- Name: directus_translations directus_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_translations
    ADD CONSTRAINT directus_translations_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_email_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_email_unique UNIQUE (email);


--
-- Name: directus_users directus_users_external_identifier_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_external_identifier_unique UNIQUE (external_identifier);


--
-- Name: directus_users directus_users_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_token_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_token_unique UNIQUE (token);


--
-- Name: directus_versions directus_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_pkey PRIMARY KEY (id);


--
-- Name: packages_activity_types packages_activity_types_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.packages_activity_types
    ADD CONSTRAINT packages_activity_types_pkey PRIMARY KEY (id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: packages packages_slug_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_slug_unique UNIQUE (slug);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: regions regions_slug_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_slug_unique UNIQUE (slug);


--
-- Name: searches searches_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.searches
    ADD CONSTRAINT searches_pkey PRIMARY KEY (id);


--
-- Name: settings settings_key_unique; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_key_unique UNIQUE (key);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: directus_activity_timestamp_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_activity_timestamp_index ON public.directus_activity USING btree ("timestamp");


--
-- Name: directus_oauth_clients_date_created_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_oauth_clients_date_created_index ON public.directus_oauth_clients USING btree (date_created);


--
-- Name: directus_oauth_codes_expires_at_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_oauth_codes_expires_at_index ON public.directus_oauth_codes USING btree (expires_at);


--
-- Name: directus_oauth_codes_used_at_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_oauth_codes_used_at_index ON public.directus_oauth_codes USING btree (used_at);


--
-- Name: directus_oauth_consents_client_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_oauth_consents_client_index ON public.directus_oauth_consents USING btree (client);


--
-- Name: directus_oauth_tokens_code_hash_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_oauth_tokens_code_hash_index ON public.directus_oauth_tokens USING btree (code_hash);


--
-- Name: directus_oauth_tokens_expires_at_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_oauth_tokens_expires_at_index ON public.directus_oauth_tokens USING btree (expires_at);


--
-- Name: directus_oauth_tokens_previous_session_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_oauth_tokens_previous_session_index ON public.directus_oauth_tokens USING btree (previous_session);


--
-- Name: directus_oauth_tokens_session_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_oauth_tokens_session_index ON public.directus_oauth_tokens USING btree (session);


--
-- Name: directus_revisions_activity_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_revisions_activity_index ON public.directus_revisions USING btree (activity);


--
-- Name: directus_revisions_parent_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_revisions_parent_index ON public.directus_revisions USING btree (parent);


--
-- Name: directus_sessions_oauth_client_index; Type: INDEX; Schema: public; Owner: voda
--

CREATE INDEX directus_sessions_oauth_client_index ON public.directus_sessions USING btree (oauth_client);


--
-- Name: articles articles_featured_image_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_featured_image_foreign FOREIGN KEY (featured_image) REFERENCES public.directus_files(id);


--
-- Name: destinations destinations_image_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_image_foreign FOREIGN KEY (image) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: destinations destinations_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: destinations destinations_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: destinations destinations_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.destinations
    ADD CONSTRAINT destinations_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: directus_access directus_access_policy_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_policy_foreign FOREIGN KEY (policy) REFERENCES public.directus_policies(id) ON DELETE CASCADE;


--
-- Name: directus_access directus_access_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_access directus_access_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_collections directus_collections_group_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_group_foreign FOREIGN KEY ("group") REFERENCES public.directus_collections(collection);


--
-- Name: directus_comments directus_comments_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_comments directus_comments_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: directus_dashboards directus_dashboards_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_deployment_projects directus_deployment_projects_deployment_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_deployment_projects
    ADD CONSTRAINT directus_deployment_projects_deployment_foreign FOREIGN KEY (deployment) REFERENCES public.directus_deployments(id) ON DELETE CASCADE;


--
-- Name: directus_deployment_projects directus_deployment_projects_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_deployment_projects
    ADD CONSTRAINT directus_deployment_projects_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_deployment_runs directus_deployment_runs_project_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_deployment_runs
    ADD CONSTRAINT directus_deployment_runs_project_foreign FOREIGN KEY (project) REFERENCES public.directus_deployment_projects(id) ON DELETE CASCADE;


--
-- Name: directus_deployment_runs directus_deployment_runs_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_deployment_runs
    ADD CONSTRAINT directus_deployment_runs_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_deployments directus_deployments_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_deployments
    ADD CONSTRAINT directus_deployments_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_folder_foreign FOREIGN KEY (folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_modified_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_modified_by_foreign FOREIGN KEY (modified_by) REFERENCES public.directus_users(id);


--
-- Name: directus_files directus_files_uploaded_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_uploaded_by_foreign FOREIGN KEY (uploaded_by) REFERENCES public.directus_users(id);


--
-- Name: directus_flows directus_flows_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_folders directus_folders_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_folders(id);


--
-- Name: directus_notifications directus_notifications_recipient_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_recipient_foreign FOREIGN KEY (recipient) REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_notifications directus_notifications_sender_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_sender_foreign FOREIGN KEY (sender) REFERENCES public.directus_users(id);


--
-- Name: directus_oauth_codes directus_oauth_codes_client_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_codes
    ADD CONSTRAINT directus_oauth_codes_client_foreign FOREIGN KEY (client) REFERENCES public.directus_oauth_clients(client_id) ON DELETE CASCADE;


--
-- Name: directus_oauth_codes directus_oauth_codes_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_codes
    ADD CONSTRAINT directus_oauth_codes_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_oauth_consents directus_oauth_consents_client_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_consents
    ADD CONSTRAINT directus_oauth_consents_client_foreign FOREIGN KEY (client) REFERENCES public.directus_oauth_clients(client_id) ON DELETE CASCADE;


--
-- Name: directus_oauth_consents directus_oauth_consents_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_consents
    ADD CONSTRAINT directus_oauth_consents_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_oauth_tokens directus_oauth_tokens_client_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_tokens
    ADD CONSTRAINT directus_oauth_tokens_client_foreign FOREIGN KEY (client) REFERENCES public.directus_oauth_clients(client_id) ON DELETE CASCADE;


--
-- Name: directus_oauth_tokens directus_oauth_tokens_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_oauth_tokens
    ADD CONSTRAINT directus_oauth_tokens_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_operations directus_operations_flow_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_flow_foreign FOREIGN KEY (flow) REFERENCES public.directus_flows(id) ON DELETE CASCADE;


--
-- Name: directus_operations directus_operations_reject_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_foreign FOREIGN KEY (reject) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_resolve_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_foreign FOREIGN KEY (resolve) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_panels directus_panels_dashboard_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_dashboard_foreign FOREIGN KEY (dashboard) REFERENCES public.directus_dashboards(id) ON DELETE CASCADE;


--
-- Name: directus_panels directus_panels_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_permissions directus_permissions_policy_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_policy_foreign FOREIGN KEY (policy) REFERENCES public.directus_policies(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_activity_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_activity_foreign FOREIGN KEY (activity) REFERENCES public.directus_activity(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_revisions(id);


--
-- Name: directus_revisions directus_revisions_version_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_version_foreign FOREIGN KEY (version) REFERENCES public.directus_versions(id) ON DELETE CASCADE;


--
-- Name: directus_roles directus_roles_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_roles(id);


--
-- Name: directus_sessions directus_sessions_oauth_client_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_oauth_client_foreign FOREIGN KEY (oauth_client) REFERENCES public.directus_oauth_clients(client_id) ON DELETE CASCADE;


--
-- Name: directus_sessions directus_sessions_share_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_share_foreign FOREIGN KEY (share) REFERENCES public.directus_shares(id) ON DELETE CASCADE;


--
-- Name: directus_sessions directus_sessions_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_settings directus_settings_project_logo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_project_logo_foreign FOREIGN KEY (project_logo) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_background_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_background_foreign FOREIGN KEY (public_background) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_favicon_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_favicon_foreign FOREIGN KEY (public_favicon) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_foreground_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_foreground_foreign FOREIGN KEY (public_foreground) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_registration_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_registration_role_foreign FOREIGN KEY (public_registration_role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- Name: directus_settings directus_settings_storage_default_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_storage_default_folder_foreign FOREIGN KEY (storage_default_folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_shares directus_shares_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_users directus_users_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- Name: directus_versions directus_versions_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_versions directus_versions_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_versions directus_versions_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: packages_activity_types packages_activity_types_activity_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.packages_activity_types
    ADD CONSTRAINT packages_activity_types_activity_type_id_foreign FOREIGN KEY (activity_type_id) REFERENCES public.activity_types(id);


--
-- Name: packages_activity_types packages_activity_types_package_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.packages_activity_types
    ADD CONSTRAINT packages_activity_types_package_id_foreign FOREIGN KEY (package_id) REFERENCES public.packages(id);


--
-- Name: packages packages_destination_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_destination_id_foreign FOREIGN KEY (destination_id) REFERENCES public.destinations(id);


--
-- Name: packages packages_image_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_image_foreign FOREIGN KEY (image) REFERENCES public.directus_files(id);


--
-- Name: regions regions_image_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_image_foreign FOREIGN KEY (image) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: regions regions_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: regions regions_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: voda
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict FcUKc6eY6yIEr7uxZFACoWWzqtcTaqgHfw8BjdbFNQOSbPFCc6Ab8TLPhoyFJ7O

