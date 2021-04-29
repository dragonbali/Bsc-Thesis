--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

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
-- Name: my_new_topo; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA my_new_topo;


ALTER SCHEMA my_new_topo OWNER TO postgres;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Name: contact_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.contact_type AS ENUM (
    'phone',
    'callback',
    'message',
    'job-received'
);


ALTER TYPE public.contact_type OWNER TO postgres;

--
-- Name: plan_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.plan_type AS ENUM (
    'time based subscription',
    'balance',
    'first place booster',
    'social ads'
);


ALTER TYPE public.plan_type OWNER TO postgres;

--
-- Name: exec(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.exec(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$ BEGIN EXECUTE $1; RETURN $1; END; $_$;


ALTER FUNCTION public.exec(text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: edge_data; Type: TABLE; Schema: my_new_topo; Owner: postgres
--

CREATE TABLE my_new_topo.edge_data (
    edge_id integer NOT NULL,
    start_node integer NOT NULL,
    end_node integer NOT NULL,
    next_left_edge integer NOT NULL,
    abs_next_left_edge integer NOT NULL,
    next_right_edge integer NOT NULL,
    abs_next_right_edge integer NOT NULL,
    left_face integer NOT NULL,
    right_face integer NOT NULL,
    geom public.geometry(LineString,26986)
);


ALTER TABLE my_new_topo.edge_data OWNER TO postgres;

--
-- Name: edge; Type: VIEW; Schema: my_new_topo; Owner: postgres
--

CREATE VIEW my_new_topo.edge AS
 SELECT edge_data.edge_id,
    edge_data.start_node,
    edge_data.end_node,
    edge_data.next_left_edge,
    edge_data.next_right_edge,
    edge_data.left_face,
    edge_data.right_face,
    edge_data.geom
   FROM my_new_topo.edge_data;


ALTER TABLE my_new_topo.edge OWNER TO postgres;

--
-- Name: VIEW edge; Type: COMMENT; Schema: my_new_topo; Owner: postgres
--

COMMENT ON VIEW my_new_topo.edge IS 'Contains edge topology primitives';


--
-- Name: COLUMN edge.edge_id; Type: COMMENT; Schema: my_new_topo; Owner: postgres
--

COMMENT ON COLUMN my_new_topo.edge.edge_id IS 'Unique identifier of the edge';


--
-- Name: COLUMN edge.start_node; Type: COMMENT; Schema: my_new_topo; Owner: postgres
--

COMMENT ON COLUMN my_new_topo.edge.start_node IS 'Unique identifier of the node at the start of the edge';


--
-- Name: COLUMN edge.end_node; Type: COMMENT; Schema: my_new_topo; Owner: postgres
--

COMMENT ON COLUMN my_new_topo.edge.end_node IS 'Unique identifier of the node at the end of the edge';


--
-- Name: COLUMN edge.next_left_edge; Type: COMMENT; Schema: my_new_topo; Owner: postgres
--

COMMENT ON COLUMN my_new_topo.edge.next_left_edge IS 'Unique identifier of the next edge of the face on the left (when looking in the direction from START_NODE to END_NODE), moving counterclockwise around the face boundary';


--
-- Name: COLUMN edge.next_right_edge; Type: COMMENT; Schema: my_new_topo; Owner: postgres
--

COMMENT ON COLUMN my_new_topo.edge.next_right_edge IS 'Unique identifier of the next edge of the face on the right (when looking in the direction from START_NODE to END_NODE), moving counterclockwise around the face boundary';


--
-- Name: COLUMN edge.left_face; Type: COMMENT; Schema: my_new_topo; Owner: postgres
--

COMMENT ON COLUMN my_new_topo.edge.left_face IS 'Unique identifier of the face on the left side of the edge when looking in the direction from START_NODE to END_NODE';


--
-- Name: COLUMN edge.right_face; Type: COMMENT; Schema: my_new_topo; Owner: postgres
--

COMMENT ON COLUMN my_new_topo.edge.right_face IS 'Unique identifier of the face on the right side of the edge when looking in the direction from START_NODE to END_NODE';


--
-- Name: COLUMN edge.geom; Type: COMMENT; Schema: my_new_topo; Owner: postgres
--

COMMENT ON COLUMN my_new_topo.edge.geom IS 'The geometry of the edge';


--
-- Name: edge_data_edge_id_seq; Type: SEQUENCE; Schema: my_new_topo; Owner: postgres
--

CREATE SEQUENCE my_new_topo.edge_data_edge_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE my_new_topo.edge_data_edge_id_seq OWNER TO postgres;

--
-- Name: edge_data_edge_id_seq; Type: SEQUENCE OWNED BY; Schema: my_new_topo; Owner: postgres
--

ALTER SEQUENCE my_new_topo.edge_data_edge_id_seq OWNED BY my_new_topo.edge_data.edge_id;


--
-- Name: face; Type: TABLE; Schema: my_new_topo; Owner: postgres
--

CREATE TABLE my_new_topo.face (
    face_id integer NOT NULL,
    mbr public.geometry(Polygon,26986)
);


ALTER TABLE my_new_topo.face OWNER TO postgres;

--
-- Name: TABLE face; Type: COMMENT; Schema: my_new_topo; Owner: postgres
--

COMMENT ON TABLE my_new_topo.face IS 'Contains face topology primitives';


--
-- Name: face_face_id_seq; Type: SEQUENCE; Schema: my_new_topo; Owner: postgres
--

CREATE SEQUENCE my_new_topo.face_face_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE my_new_topo.face_face_id_seq OWNER TO postgres;

--
-- Name: face_face_id_seq; Type: SEQUENCE OWNED BY; Schema: my_new_topo; Owner: postgres
--

ALTER SEQUENCE my_new_topo.face_face_id_seq OWNED BY my_new_topo.face.face_id;


--
-- Name: layer_id_seq; Type: SEQUENCE; Schema: my_new_topo; Owner: postgres
--

CREATE SEQUENCE my_new_topo.layer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE my_new_topo.layer_id_seq OWNER TO postgres;

--
-- Name: node; Type: TABLE; Schema: my_new_topo; Owner: postgres
--

CREATE TABLE my_new_topo.node (
    node_id integer NOT NULL,
    containing_face integer,
    geom public.geometry(Point,26986)
);


ALTER TABLE my_new_topo.node OWNER TO postgres;

--
-- Name: TABLE node; Type: COMMENT; Schema: my_new_topo; Owner: postgres
--

COMMENT ON TABLE my_new_topo.node IS 'Contains node topology primitives';


--
-- Name: node_node_id_seq; Type: SEQUENCE; Schema: my_new_topo; Owner: postgres
--

CREATE SEQUENCE my_new_topo.node_node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE my_new_topo.node_node_id_seq OWNER TO postgres;

--
-- Name: node_node_id_seq; Type: SEQUENCE OWNED BY; Schema: my_new_topo; Owner: postgres
--

ALTER SEQUENCE my_new_topo.node_node_id_seq OWNED BY my_new_topo.node.node_id;


--
-- Name: relation; Type: TABLE; Schema: my_new_topo; Owner: postgres
--

CREATE TABLE my_new_topo.relation (
    topogeo_id integer NOT NULL,
    layer_id integer NOT NULL,
    element_id integer NOT NULL,
    element_type integer NOT NULL
);


ALTER TABLE my_new_topo.relation OWNER TO postgres;

--
-- Name: billing_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.billing_info (
    id integer NOT NULL,
    user_id integer,
    payment_request_id character varying(50) NOT NULL,
    payment_id character varying(1000) DEFAULT NULL::character varying,
    transaction_id character varying(50) NOT NULL,
    order_number character varying(16) NOT NULL,
    order_state character varying(16) NOT NULL,
    payment_method character varying(50) DEFAULT NULL::character varying,
    payment_prep_request json,
    payment_prep_response json,
    payment_state json,
    completed boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    completed_at timestamp without time zone,
    subscription_state json
);


ALTER TABLE public.billing_info OWNER TO postgres;

--
-- Name: billing_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.billing_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_info_id_seq OWNER TO postgres;

--
-- Name: billing_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.billing_info_id_seq OWNED BY public.billing_info.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    icon character varying(15) DEFAULT ''::character varying
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    id integer NOT NULL,
    owner_email character varying(50) NOT NULL,
    description text NOT NULL,
    due_date date,
    category integer,
    title character varying(100) NOT NULL,
    phone character varying(18) DEFAULT NULL::character varying,
    profession integer,
    price_min integer,
    price_max integer,
    urgent boolean DEFAULT false,
    created_at date DEFAULT CURRENT_DATE,
    location_id integer,
    source_ip_address character varying(50) DEFAULT ''::character varying,
    "id,""owner_email"",""description"",""due_date"",""category"",""title"",""p" character varying(510)
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jobs_id_seq OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location (
    id integer NOT NULL,
    name character varying(25),
    zip integer DEFAULT 0 NOT NULL,
    coordinates public.geometry DEFAULT '010100000000000000000000000000000000000000'::public.geometry NOT NULL,
    ranking integer DEFAULT 0
);


ALTER TABLE public.location OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.location_id_seq OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.location_id_seq OWNED BY public.location.id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plans (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(250) NOT NULL,
    sku character varying(50) NOT NULL,
    price integer NOT NULL,
    type public.plan_type DEFAULT 'time based subscription'::public.plan_type,
    duration_in_hours integer DEFAULT 0,
    balance_to_add integer DEFAULT 0,
    visible boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    boosts_first_place boolean DEFAULT false,
    stripe_price_id character varying(200) DEFAULT ''::character varying,
    stripe_product_id character varying(200) DEFAULT ''::character varying
);


ALTER TABLE public.plans OWNER TO postgres;

--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plans_id_seq OWNER TO postgres;

--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;


--
-- Name: profession; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profession (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    category integer,
    aliases character varying(250) DEFAULT ''::character varying,
    priority integer DEFAULT 0
);


ALTER TABLE public.profession OWNER TO postgres;

--
-- Name: profession_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.profession_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.profession_id_seq OWNER TO postgres;

--
-- Name: profession_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.profession_id_seq OWNED BY public.profession.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    email_verified boolean DEFAULT false,
    profile_pic character varying(150) DEFAULT 'default'::character varying,
    phone character varying(20) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: worker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.worker (
    id integer NOT NULL,
    user_id integer,
    name character varying(50) NOT NULL,
    phone character varying(18) NOT NULL,
    email character varying(50),
    location character varying(50) NOT NULL,
    description character varying(2500) DEFAULT ''::character varying NOT NULL,
    website character varying(50) DEFAULT ''::character varying NOT NULL,
    drop_off_fee integer DEFAULT 0,
    profile_pic character varying(70) DEFAULT ''::character varying,
    joined date DEFAULT CURRENT_DATE,
    highlight boolean DEFAULT false,
    visible boolean DEFAULT false,
    priority integer DEFAULT 0,
    zip integer DEFAULT 0,
    payed_plan boolean DEFAULT false,
    url character varying(100) DEFAULT NULL::character varying,
    location_id integer,
    inspected boolean DEFAULT false,
    business_activities character varying(1400) DEFAULT ''::character varying NOT NULL,
    registration_number character varying(30) DEFAULT ''::character varying NOT NULL,
    can_issue_invoice boolean DEFAULT false
);


ALTER TABLE public.worker OWNER TO postgres;

--
-- Name: worker_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.worker_comments (
    comment character varying(3000) NOT NULL,
    rating integer NOT NULL,
    date date DEFAULT CURRENT_DATE,
    owner_id integer NOT NULL,
    worker_id integer NOT NULL
);


ALTER TABLE public.worker_comments OWNER TO postgres;

--
-- Name: worker_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.worker_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.worker_id_seq OWNER TO postgres;

--
-- Name: worker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.worker_id_seq OWNED BY public.worker.id;


--
-- Name: worker_plan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.worker_plan (
    id integer NOT NULL,
    worker_id integer,
    status character varying(60) DEFAULT 'Nincs aktív csomag'::character varying,
    active boolean DEFAULT false,
    plan_valid_until date DEFAULT CURRENT_DATE,
    plan_id integer DEFAULT 1,
    first_place_booster boolean DEFAULT false,
    first_place_booster_valid_until date DEFAULT CURRENT_DATE,
    social_ads boolean DEFAULT false,
    social_ads_valid_until date DEFAULT CURRENT_DATE,
    balance integer DEFAULT 0,
    stripe_subscription_id character varying(200) DEFAULT ''::character varying
);


ALTER TABLE public.worker_plan OWNER TO postgres;

--
-- Name: worker_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.worker_plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.worker_plan_id_seq OWNER TO postgres;

--
-- Name: worker_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.worker_plan_id_seq OWNED BY public.worker_plan.id;


--
-- Name: workers_professions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workers_professions (
    worker integer NOT NULL,
    profession integer NOT NULL
);


ALTER TABLE public.workers_professions OWNER TO postgres;

--
-- Name: edge_data edge_id; Type: DEFAULT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.edge_data ALTER COLUMN edge_id SET DEFAULT nextval('my_new_topo.edge_data_edge_id_seq'::regclass);


--
-- Name: face face_id; Type: DEFAULT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.face ALTER COLUMN face_id SET DEFAULT nextval('my_new_topo.face_face_id_seq'::regclass);


--
-- Name: node node_id; Type: DEFAULT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.node ALTER COLUMN node_id SET DEFAULT nextval('my_new_topo.node_node_id_seq'::regclass);


--
-- Name: billing_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_info ALTER COLUMN id SET DEFAULT nextval('public.billing_info_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: location id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location ALTER COLUMN id SET DEFAULT nextval('public.location_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);


--
-- Name: profession id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profession ALTER COLUMN id SET DEFAULT nextval('public.profession_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: worker id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker ALTER COLUMN id SET DEFAULT nextval('public.worker_id_seq'::regclass);


--
-- Name: worker_plan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_plan ALTER COLUMN id SET DEFAULT nextval('public.worker_plan_id_seq'::regclass);


--
-- Data for Name: edge_data; Type: TABLE DATA; Schema: my_new_topo; Owner: postgres
--

COPY my_new_topo.edge_data (edge_id, start_node, end_node, next_left_edge, abs_next_left_edge, next_right_edge, abs_next_right_edge, left_face, right_face, geom) FROM stdin;
\.


--
-- Data for Name: face; Type: TABLE DATA; Schema: my_new_topo; Owner: postgres
--

COPY my_new_topo.face (face_id, mbr) FROM stdin;
0	\N
\.


--
-- Data for Name: node; Type: TABLE DATA; Schema: my_new_topo; Owner: postgres
--

COPY my_new_topo.node (node_id, containing_face, geom) FROM stdin;
\.


--
-- Data for Name: relation; Type: TABLE DATA; Schema: my_new_topo; Owner: postgres
--

COPY my_new_topo.relation (topogeo_id, layer_id, element_id, element_type) FROM stdin;
\.


--
-- Data for Name: billing_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_info (id, user_id, payment_request_id, payment_id, transaction_id, order_number, order_state, payment_method, payment_prep_request, payment_prep_response, payment_state, completed, created_at, completed_at, subscription_state) FROM stdin;
75	3	75de0068-f2a0-4a93-aa74-9bcaa7037d67	079f5515aa42eb118bc4001dd8b71cc4	5073ebc1-59e6-4c83-99f1-8da114806c64	653172082	completed	barion	{"payer_email":"avenger9637@gmail.com","billing_address":{"name":"Bajusz Patrik","tax_number":"12345678-9-10","country":"HU","region":null,"city":"Halmaj","zip":"3842","street":"Alkotmány út 65","street_2":"","street_3":""},"payment_request_id":"75de0068-f2a0-4a93-aa74-9bcaa7037d67","order_number":"653172082","items":[{"name":"12 havi csomag","description":"Mester szolgáltatás csomag 12 hónap","quantity":1,"unit":"db","unit_price":23880,"item_total":23880,"sku":"CSOM-3"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":1,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":1,"unit":"db","unit_price":19900,"item_total":19900,"sku":"EXTRA-2"}],"transaction_id":"5073ebc1-59e6-4c83-99f1-8da114806c64","coupon":"","card_holder_hint":"Bajusz Patrik","payer_phone_number":"36301741451","payer_account_id":"53","payer_account_created":1608422400}	{"PaymentId":"079f5515aa42eb118bc4001dd8b71cc4","PaymentRequestId":"75de0068-f2a0-4a93-aa74-9bcaa7037d67","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=079f5515-aa42-eb11-8bc4-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"5073ebc1-59e6-4c83-99f1-8da114806c64","TransactionId":"089f5515aa42eb118bc4001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2020-12-20T09:59:44.463Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"079f5515aa42eb118bc4001dd8b71cc4","PaymentRequestID":"75de0068-f2a0-4a93-aa74-9bcaa7037d67","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Expired","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"","GuestCheckout":true,"CreatedAt":"2020-12-20T09:59:44.463Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2020-12-20T10:31:15.783Z","ValidUntil":"2020-12-20T10:29:44.463Z","Total":44780,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=079f5515aa42eb118bc4001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=079f5515aa42eb118bc4001dd8b71cc4"}	f	2020-12-20 10:59:15.010035	\N	\N
149	2	e8799a39-8cd5-461b-af74-ec1c1fe3de86	\N	57f8358e-df51-4ca5-b683-e1830f2e383d	284208937	initiated	\N	{"payer_email":"bajusz.patrik@gmail.com","billing_address":{"name":"Teszt Tesz","tax_number":"56559583-1-25 ","country":"HU","region":null,"city":"Závod","zip":"3000","street":"Teszt u 1","street_2":"","street_3":""},"payment_request_id":"e8799a39-8cd5-461b-af74-ec1c1fe3de86","order_number":"284208937","items":[{"name":"6 havi csomag","description":"6 havi mester szolgáltatás csomag","quantity":1,"unit":"db","unit_price":17940,"item_total":17940,"sku":"ALAP-2","stripe_price_id":"price_1IXp77FwXtu51BxSoyY2019a"}],"transaction_id":"57f8358e-df51-4ca5-b683-e1830f2e383d","coupon":"","card_holder_hint":"Angyal Ferenc","payer_phone_number":"36301741451","payer_account_id":"62","payer_account_created":1616371200,"Discount":0}	\N	\N	f	2021-04-07 20:05:02.909328	\N	\N
76	3	41a97aa0-099b-40f2-a025-c926a91df7c6	3b80f2ddc642eb118bc4001dd8b71cc4	20dee57b-502a-4cb1-93ac-891e8cac529d	539128414	completed	barion	{"payer_email":"avenger9637@gmail.com","billing_address":{"name":"Bajusz Patrik","tax_number":"12345678-9-10","country":"HU","region":null,"city":"Halmaj","zip":"3842","street":"Alkotmány út 65","street_2":"","street_3":""},"payment_request_id":"41a97aa0-099b-40f2-a025-c926a91df7c6","order_number":"539128414","items":[{"name":"12 havi csomag","description":"Mester szolgáltatás csomag 12 hónap","quantity":1,"unit":"db","unit_price":23880,"item_total":23880,"sku":"CSOM-3"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":1,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":1,"unit":"db","unit_price":19900,"item_total":19900,"sku":"EXTRA-2"}],"transaction_id":"20dee57b-502a-4cb1-93ac-891e8cac529d","coupon":"","card_holder_hint":"Bajusz Patrik","payer_phone_number":"36301741451","payer_account_id":"53","payer_account_created":1608422400}	{"PaymentId":"3b80f2ddc642eb118bc4001dd8b71cc4","PaymentRequestId":"41a97aa0-099b-40f2-a025-c926a91df7c6","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=3b80f2dd-c642-eb11-8bc4-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"20dee57b-502a-4cb1-93ac-891e8cac529d","TransactionId":"3c80f2ddc642eb118bc4001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2020-12-20T13:25:46.95Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"3b80f2ddc642eb118bc4001dd8b71cc4","PaymentRequestID":"41a97aa0-099b-40f2-a025-c926a91df7c6","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2020-12-20T13:25:46.95Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2020-12-20T13:25:53.49Z","ValidUntil":"2020-12-20T13:55:46.95Z","Total":44780,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=3b80f2ddc642eb118bc4001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=3b80f2ddc642eb118bc4001dd8b71cc4"}	t	2020-12-20 14:25:40.154969	2020-12-20 14:25:54.061777	\N
130	1	27e73acf-27ad-447f-bed9-74115a1edac1	\N	3ff2c045-e1fb-486d-a458-3e8ffe8ec545	780789720	initiated	\N	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25  ","country":"HU","region":null,"city":"Budapest","zip":"1231","street":"sadsd","street_2":"","street_3":""},"payment_request_id":"27e73acf-27ad-447f-bed9-74115a1edac1","order_number":"780789720","items":[{"name":"6 havi csomag","description":"6 havi mester szolgáltatás csomag","quantity":1,"unit":"db","unit_price":17940,"item_total":17940,"sku":"ALAP-2","stripe_price_id":"price_1IXp77FwXtu51BxSoyY2019a"}],"transaction_id":"3ff2c045-e1fb-486d-a458-3e8ffe8ec545","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-04-05 18:15:55.032829	\N	\N
77	1	1403b31c-cdee-4fda-ab5e-63047236b402	9c8ab5d7514ceb118bc4001dd8b71cc4	370c01dd-7ef7-4f78-b8d6-f307ccf7eddf	468912265	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"12345678-9-10","country":"HU","region":null,"city":"Miskolc","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"1403b31c-cdee-4fda-ab5e-63047236b402","order_number":"468912265","items":[{"name":"12 havi csomag","description":"Mester szolgáltatás csomag 12 hónap","quantity":1,"unit":"db","unit_price":23880,"item_total":23880,"sku":"CSOM-3"}],"transaction_id":"370c01dd-7ef7-4f78-b8d6-f307ccf7eddf","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"44","payer_account_created":1604275200}	{"PaymentId":"9c8ab5d7514ceb118bc4001dd8b71cc4","PaymentRequestId":"1403b31c-cdee-4fda-ab5e-63047236b402","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=9c8ab5d7-514c-eb11-8bc4-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"370c01dd-7ef7-4f78-b8d6-f307ccf7eddf","TransactionId":"9d8ab5d7514ceb118bc4001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-01-01T16:53:16.984Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	\N	f	2021-01-01 17:53:12.505027	\N	\N
154	1	eb3099db-e309-4303-9d8c-e3730161827a	55bfd90fef63eb118bc5001dd8b71cc4	ec13dd63-2806-47f8-9d58-70cfce7b511e	775803317	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"eb3099db-e309-4303-9d8c-e3730161827a","order_number":"775803317","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"}],"transaction_id":"ec13dd63-2806-47f8-9d58-70cfce7b511e","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000}	{"PaymentId":"55bfd90fef63eb118bc5001dd8b71cc4","PaymentRequestId":"eb3099db-e309-4303-9d8c-e3730161827a","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=55bfd90f-ef63-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"ec13dd63-2806-47f8-9d58-70cfce7b511e","TransactionId":"56bfd90fef63eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-01-31T18:06:38.892Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"55bfd90fef63eb118bc5001dd8b71cc4","PaymentRequestID":"eb3099db-e309-4303-9d8c-e3730161827a","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-01-31T18:06:38.892Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-01-31T18:07:57.816Z","ValidUntil":"2021-01-31T18:36:38.892Z","Total":14940,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=55bfd90fef63eb118bc5001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=55bfd90fef63eb118bc5001dd8b71cc4"}	t	2021-04-29 19:06:28.160925	2021-04-29 19:07:58.297293	\N
80	1	9bac7bbd-bd26-4b87-81b9-8deefc5c34ff	cc1de730f163eb118bc5001dd8b71cc4	e1d3e514-9a13-4899-a5f6-29784012819a	303292441	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"9bac7bbd-bd26-4b87-81b9-8deefc5c34ff","order_number":"303292441","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"}],"transaction_id":"e1d3e514-9a13-4899-a5f6-29784012819a","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000}	{"PaymentId":"cc1de730f163eb118bc5001dd8b71cc4","PaymentRequestId":"9bac7bbd-bd26-4b87-81b9-8deefc5c34ff","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=cc1de730-f163-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"e1d3e514-9a13-4899-a5f6-29784012819a","TransactionId":"cd1de730f163eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-01-31T18:21:53.343Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	\N	f	2021-01-31 19:21:41.231043	\N	\N
79	1	5bc59efa-b824-4aeb-a0fe-4763c8c05220	68c9ad91f063eb118bc5001dd8b71cc4	1e27e1f0-7d39-41e0-9227-a991df4f7c68	850442058	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemetekert utva 2","street_2":"","street_3":""},"payment_request_id":"5bc59efa-b824-4aeb-a0fe-4763c8c05220","order_number":"850442058","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":1,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"}],"transaction_id":"1e27e1f0-7d39-41e0-9227-a991df4f7c68","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000}	{"PaymentId":"68c9ad91f063eb118bc5001dd8b71cc4","PaymentRequestId":"5bc59efa-b824-4aeb-a0fe-4763c8c05220","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=68c9ad91-f063-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"1e27e1f0-7d39-41e0-9227-a991df4f7c68","TransactionId":"69c9ad91f063eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-01-31T18:17:26.214Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"68c9ad91f063eb118bc5001dd8b71cc4","PaymentRequestID":"5bc59efa-b824-4aeb-a0fe-4763c8c05220","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-01-31T18:17:26.214Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-01-31T18:17:55.285Z","ValidUntil":"2021-01-31T18:47:26.214Z","Total":15940,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=68c9ad91f063eb118bc5001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=68c9ad91f063eb118bc5001dd8b71cc4"}	t	2021-01-31 19:17:18.729387	2021-01-31 20:22:43.11491	\N
83	75	e6efd901-f151-43af-9ed1-59cbddc11e72	5158b67b0264eb118bc5001dd8b71cc4	1720970b-0d7d-44c5-9c09-5735b3279175	198662389	completed	barion	{"payer_email":"foe010@gmail.com","billing_address":{"name":"Patrik Bajusz","tax_number":"20925345-1-05","country":"HU","region":null,"city":"Halmaj","zip":"3842","street":"Alkotmány út 65","street_2":"","street_3":""},"payment_request_id":"e6efd901-f151-43af-9ed1-59cbddc11e72","order_number":"198662389","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":5,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"}],"transaction_id":"1720970b-0d7d-44c5-9c09-5735b3279175","coupon":"","card_holder_hint":"Patrik Bajusz","payer_phone_number":"36301741451","payer_account_id":"60","payer_account_created":1612051200}	{"PaymentId":"5158b67b0264eb118bc5001dd8b71cc4","PaymentRequestId":"e6efd901-f151-43af-9ed1-59cbddc11e72","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=5158b67b-0264-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"1720970b-0d7d-44c5-9c09-5735b3279175","TransactionId":"5258b67b0264eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-01-31T20:25:40.352Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"5158b67b0264eb118bc5001dd8b71cc4","PaymentRequestID":"e6efd901-f151-43af-9ed1-59cbddc11e72","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-01-31T20:25:40.352Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-01-31T20:26:05.772Z","ValidUntil":"2021-01-31T20:55:40.352Z","Total":19940,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=5158b67b0264eb118bc5001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=5158b67b0264eb118bc5001dd8b71cc4"}	t	2021-01-31 21:25:34.764707	2021-01-31 21:26:06.557694	\N
81	1	ffd35a7b-1d99-4177-8452-b7c9340704c6	11b5d49efa63eb118bc5001dd8b71cc4	d8ebb24d-f18f-4e2e-87f8-34070350ea9d	736272391	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Valaki haahaha","tax_number":"55670263-1-35","country":"HU","region":null,"city":"Halmaj","zip":"3842","street":"Teleki László tér","street_2":"","street_3":""},"payment_request_id":"ffd35a7b-1d99-4177-8452-b7c9340704c6","order_number":"736272391","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"}],"transaction_id":"d8ebb24d-f18f-4e2e-87f8-34070350ea9d","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000}	{"PaymentId":"11b5d49efa63eb118bc5001dd8b71cc4","PaymentRequestId":"ffd35a7b-1d99-4177-8452-b7c9340704c6","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=11b5d49e-fa63-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"d8ebb24d-f18f-4e2e-87f8-34070350ea9d","TransactionId":"12b5d49efa63eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-01-31T19:29:23.168Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"11b5d49efa63eb118bc5001dd8b71cc4","PaymentRequestID":"ffd35a7b-1d99-4177-8452-b7c9340704c6","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-01-31T19:29:23.152Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-01-31T19:29:47.012Z","ValidUntil":"2021-01-31T19:59:23.152Z","Total":14940,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://localhost:5000/payment/barion/callback?paymentId=11b5d49efa63eb118bc5001dd8b71cc4","RedirectUrl":"http://localhost:5000/vasarlas/koszonjuk?paymentId=11b5d49efa63eb118bc5001dd8b71cc4"}	t	2021-01-31 20:29:16.718184	2021-01-31 20:33:25.648957	\N
133	1	64fa5744-eb3a-4373-92a7-54b93e9c876e	\N	2051e198-4590-4e9f-94c2-1afbf22618a6	753525476	initiated	\N	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25  ","country":"HU","region":null,"city":"Budapest","zip":"1113","street":"Teszt utca 2","street_2":"","street_3":""},"payment_request_id":"64fa5744-eb3a-4373-92a7-54b93e9c876e","order_number":"753525476","items":[{"name":"6 havi csomag","description":"6 havi mester szolgáltatás csomag","quantity":1,"unit":"db","unit_price":17940,"item_total":17940,"sku":"ALAP-2","stripe_price_id":"price_1IXp77FwXtu51BxSoyY2019a"}],"transaction_id":"2051e198-4590-4e9f-94c2-1afbf22618a6","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-04-05 18:30:44.762872	\N	\N
87	1	db3fdb06-8b4a-4176-a548-792eea083ded	\N	a41be08a-69fd-4426-b81a-35d338ebf813	214942129	initiated	\N	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Valaki","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemete","street_2":"","street_3":""},"payment_request_id":"db3fdb06-8b4a-4176-a548-792eea083ded","order_number":"214942129","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":3,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"}],"transaction_id":"a41be08a-69fd-4426-b81a-35d338ebf813","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-02-02 11:46:01.816351	\N	\N
84	1	ce5cb92d-69cb-4e3b-b5b1-1e4de52bf1a0	6fb1482ca364eb118bc5001dd8b71cc4	7334688f-a458-4176-ba59-49acba146de2	430233048	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Miskolc","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"ce5cb92d-69cb-4e3b-b5b1-1e4de52bf1a0","order_number":"430233048","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"}],"transaction_id":"7334688f-a458-4176-ba59-49acba146de2","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	{"PaymentId":"6fb1482ca364eb118bc5001dd8b71cc4","PaymentRequestId":"ce5cb92d-69cb-4e3b-b5b1-1e4de52bf1a0","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=6fb1482c-a364-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"7334688f-a458-4176-ba59-49acba146de2","TransactionId":"70b1482ca364eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-02-01T15:36:03.844Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"6fb1482ca364eb118bc5001dd8b71cc4","PaymentRequestID":"ce5cb92d-69cb-4e3b-b5b1-1e4de52bf1a0","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-02-01T15:36:03.844Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-02-01T15:36:30.203Z","ValidUntil":"2021-02-01T16:06:03.844Z","Total":14940,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=6fb1482ca364eb118bc5001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=6fb1482ca364eb118bc5001dd8b71cc4"}	t	2021-02-01 16:35:55.261411	2021-02-01 16:36:30.869127	\N
85	1	1c50cc1c-9632-41ff-8771-711ab0d78e8c	\N	fa32549f-7625-4b96-9a67-eb274ff2418d	417481452	initiated	\N	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"1c50cc1c-9632-41ff-8771-711ab0d78e8c","order_number":"417481452","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"}],"transaction_id":"fa32549f-7625-4b96-9a67-eb274ff2418d","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-02-01 22:29:22.074076	\N	\N
88	1	2a20dd03-7b6b-4094-bcf5-64c86cf087b5	b3c412e14365eb118bc5001dd8b71cc4	fc0977ad-f29a-449f-bb3e-03c17659cc40	627437377	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Valaki","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemete","street_2":"","street_3":""},"payment_request_id":"2a20dd03-7b6b-4094-bcf5-64c86cf087b5","order_number":"627437377","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":12699,"sku":"CSOM-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":3,"unit":"db","unit_price":1000,"item_total":850,"sku":"EXTRA-1"}],"transaction_id":"fc0977ad-f29a-449f-bb3e-03c17659cc40","coupon":"bajusz15","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":15}	{"PaymentId":"b3c412e14365eb118bc5001dd8b71cc4","PaymentRequestId":"2a20dd03-7b6b-4094-bcf5-64c86cf087b5","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=b3c412e1-4365-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"fc0977ad-f29a-449f-bb3e-03c17659cc40","TransactionId":"b4c412e14365eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-02-02T10:46:18.814Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"b3c412e14365eb118bc5001dd8b71cc4","PaymentRequestID":"2a20dd03-7b6b-4094-bcf5-64c86cf087b5","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-02-02T10:46:18.798Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-02-02T10:46:42.593Z","ValidUntil":"2021-02-02T11:16:18.798Z","Total":15249,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=b3c412e14365eb118bc5001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=b3c412e14365eb118bc5001dd8b71cc4"}	t	2021-02-02 11:46:11.93489	2021-02-02 11:46:43.293111	\N
86	1	14a43a4a-66eb-48ad-af52-858033f9183b	c4a977a5d464eb118bc5001dd8b71cc4	f147f987-9914-4ef9-b091-b73ce03268ad	74954068	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemeteket utca 2","street_2":"","street_3":""},"payment_request_id":"14a43a4a-66eb-48ad-af52-858033f9183b","order_number":"074954068","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":12699,"sku":"CSOM-2"}],"transaction_id":"f147f987-9914-4ef9-b091-b73ce03268ad","coupon":"bajusz15","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":15}	{"PaymentId":"c4a977a5d464eb118bc5001dd8b71cc4","PaymentRequestId":"14a43a4a-66eb-48ad-af52-858033f9183b","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=c4a977a5-d464-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"f147f987-9914-4ef9-b091-b73ce03268ad","TransactionId":"c5a977a5d464eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-02-01T21:30:04.697Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"c4a977a5d464eb118bc5001dd8b71cc4","PaymentRequestID":"14a43a4a-66eb-48ad-af52-858033f9183b","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-02-01T21:30:04.697Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-02-01T21:30:37.672Z","ValidUntil":"2021-02-01T22:00:04.697Z","Total":12699,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=c4a977a5d464eb118bc5001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=c4a977a5d464eb118bc5001dd8b71cc4"}	t	2021-02-01 22:29:54.294705	2021-02-01 22:30:38.336936	\N
91	75	8e46da49-49c1-453d-9e49-b500e8343bb2	\N	79065706-713a-4819-b325-793b2ae57ecc	309577325	initiated	\N	{"payer_email":"foe010@gmail.com","billing_address":{"name":"Patrik Bajusz","tax_number":"20925345-1-05","country":"HU","region":null,"city":"Halmaj","zip":"3842","street":"Alkotmány út 65","street_2":"","street_3":""},"payment_request_id":"8e46da49-49c1-453d-9e49-b500e8343bb2","order_number":"309577325","items":[{"name":"12 havi csomag","description":"Mester szolgáltatás csomag 12 hónap","quantity":1,"unit":"db","unit_price":23880,"item_total":20298,"sku":"CSOM-3"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":4,"unit":"db","unit_price":1000,"item_total":850,"sku":"EXTRA-1"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":5,"unit":"db","unit_price":19900,"item_total":16915,"sku":"EXTRA-2"}],"transaction_id":"79065706-713a-4819-b325-793b2ae57ecc","coupon":"bajusz15","card_holder_hint":"Patrik Bajusz","payer_phone_number":"36301741451","payer_account_id":"60","payer_account_created":1612051200,"Discount":15}	\N	\N	f	2021-02-02 16:48:42.675422	\N	\N
89	1	c53594db-a905-41e5-9a89-891779c71ced	8eadca9a4465eb118bc5001dd8b71cc4	a28c237b-6e74-4c28-a2eb-0988f44c9d65	137615745	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Valaki","tax_number":"55861331-1-43","country":"HU","region":null,"city":"Miskolc","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"c53594db-a905-41e5-9a89-891779c71ced","order_number":"137615745","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":12699,"sku":"CSOM-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":1,"unit":"db","unit_price":1000,"item_total":850,"sku":"EXTRA-1"}],"transaction_id":"a28c237b-6e74-4c28-a2eb-0988f44c9d65","coupon":"bajusz15","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":15}	{"PaymentId":"8eadca9a4465eb118bc5001dd8b71cc4","PaymentRequestId":"c53594db-a905-41e5-9a89-891779c71ced","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=8eadca9a-4465-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"a28c237b-6e74-4c28-a2eb-0988f44c9d65","TransactionId":"8fadca9a4465eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-02-02T10:51:35.683Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"8eadca9a4465eb118bc5001dd8b71cc4","PaymentRequestID":"c53594db-a905-41e5-9a89-891779c71ced","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-02-02T10:51:35.683Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-02-02T10:51:48.564Z","ValidUntil":"2021-02-02T11:21:35.683Z","Total":13549,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://localhost:5000/payment/barion/callback?paymentId=8eadca9a4465eb118bc5001dd8b71cc4","RedirectUrl":"http://localhost:5000/vasarlas/koszonjuk?paymentId=8eadca9a4465eb118bc5001dd8b71cc4"}	t	2021-02-02 11:51:29.059235	2021-02-02 14:10:59.079418	\N
90	75	30c9a86f-7b9b-4858-a2bc-234633d35801	ee0fe1e26d65eb118bc5001dd8b71cc4	79469145-1d99-48d8-9e3b-e15f13e43505	166575609	completed	barion	{"payer_email":"foe010@gmail.com","billing_address":{"name":"Patrik Bajusz","tax_number":"20925345-1-05","country":"HU","region":null,"city":"Halmaj","zip":"3842","street":"Alkotmány út 65","street_2":"","street_3":""},"payment_request_id":"30c9a86f-7b9b-4858-a2bc-234633d35801","order_number":"166575609","items":[{"name":"12 havi csomag","description":"Mester szolgáltatás csomag 12 hónap","quantity":1,"unit":"db","unit_price":23880,"item_total":20298,"sku":"CSOM-3"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":5,"unit":"db","unit_price":19900,"item_total":16915,"sku":"EXTRA-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":4,"unit":"db","unit_price":1000,"item_total":850,"sku":"EXTRA-1"}],"transaction_id":"79469145-1d99-48d8-9e3b-e15f13e43505","coupon":"bajusz15","card_holder_hint":"Patrik Bajusz","payer_phone_number":"36301741451","payer_account_id":"60","payer_account_created":1612051200,"Discount":15}	{"PaymentId":"ee0fe1e26d65eb118bc5001dd8b71cc4","PaymentRequestId":"30c9a86f-7b9b-4858-a2bc-234633d35801","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=ee0fe1e2-6d65-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"79469145-1d99-48d8-9e3b-e15f13e43505","TransactionId":"ef0fe1e26d65eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-02-02T15:47:00.698Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"ee0fe1e26d65eb118bc5001dd8b71cc4","PaymentRequestID":"30c9a86f-7b9b-4858-a2bc-234633d35801","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-02-02T15:47:00.698Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-02-02T15:47:52.55Z","ValidUntil":"2021-02-02T16:17:00.698Z","Total":108273,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=ee0fe1e26d65eb118bc5001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=ee0fe1e26d65eb118bc5001dd8b71cc4"}	t	2021-02-02 16:46:39.88705	2021-02-02 16:47:53.225858	\N
93	75	9cbabea1-e6fe-4ca5-86b2-e7e9ed84f63f	\N	fb125425-79af-4e8d-8d4b-427b746f44a9	23542201	completed	barion	{"payer_email":"foe010@gmail.com","billing_address":{"name":"Patrik Bajusz","tax_number":"20925345-1-05","country":"HU","region":null,"city":"Halmaj","zip":"3842","street":"Alkotmány út 65","street_2":"","street_3":""},"payment_request_id":"9cbabea1-e6fe-4ca5-86b2-e7e9ed84f63f","order_number":"023542201","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":8,"unit":"db","unit_price":19900,"item_total":19900,"sku":"EXTRA-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":4,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"}],"transaction_id":"fb125425-79af-4e8d-8d4b-427b746f44a9","coupon":"","card_holder_hint":"Patrik Bajusz","payer_phone_number":"36301741451","payer_account_id":"60","payer_account_created":1612051200,"Discount":0}	\N	\N	f	2021-02-02 20:10:23.272619	\N	\N
94	75	724fbd35-8245-41e3-9d89-4151497d5a95	\N	b262d040-0168-4749-9a3c-dc70bf346a52	831161491	completed	barion	{"payer_email":"foe010@gmail.com","billing_address":{"name":"Patrik Bajusz","tax_number":"20925345-1-05","country":"HU","region":null,"city":"Halmaj","zip":"3842","street":"Alkotmány út 65","street_2":"","street_3":""},"payment_request_id":"724fbd35-8245-41e3-9d89-4151497d5a95","order_number":"831161491","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":7,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":8,"unit":"db","unit_price":19900,"item_total":19900,"sku":"EXTRA-2"}],"transaction_id":"b262d040-0168-4749-9a3c-dc70bf346a52","coupon":"","card_holder_hint":"Patrik Bajusz","payer_phone_number":"36301741451","payer_account_id":"60","payer_account_created":1612051200,"Discount":0}	\N	\N	f	2021-02-02 20:11:56.695614	\N	\N
92	75	e62a1cbb-16b4-48c8-a61c-c56905a4b3f8	\N	6e7b4afa-602b-43a0-b4b0-63cdd4837c35	528774784	completed	barion	{"payer_email":"foe010@gmail.com","billing_address":{"name":"Patrik Bajusz","tax_number":"20925345-1-05","country":"HU","region":null,"city":"Halmaj","zip":"3842","street":"Alkotmány út 65","street_2":"","street_3":""},"payment_request_id":"e62a1cbb-16b4-48c8-a61c-c56905a4b3f8","order_number":"528774784","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":4,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":8,"unit":"db","unit_price":19900,"item_total":19900,"sku":"EXTRA-2"}],"transaction_id":"6e7b4afa-602b-43a0-b4b0-63cdd4837c35","coupon":"","card_holder_hint":"Patrik Bajusz","payer_phone_number":"36301741451","payer_account_id":"60","payer_account_created":1612051200,"Discount":0}	\N	\N	t	2021-02-02 20:09:45.993093	\N	\N
95	75	f59b93c3-86b6-42d4-8a10-cca6b95c977d	\N	f265334e-a14c-4e17-bbe3-75f2217c8762	651052753	completed	barion	{"payer_email":"foe010@gmail.com","billing_address":{"name":"Patrik Bajusz","tax_number":"20925345-1-05","country":"HU","region":null,"city":"Halmaj","zip":"3842","street":"Alkotmány út 65","street_2":"","street_3":""},"payment_request_id":"f59b93c3-86b6-42d4-8a10-cca6b95c977d","order_number":"651052753","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":7,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":8,"unit":"db","unit_price":19900,"item_total":19900,"sku":"EXTRA-2"}],"transaction_id":"f265334e-a14c-4e17-bbe3-75f2217c8762","coupon":"","card_holder_hint":"Patrik Bajusz","payer_phone_number":"36301741451","payer_account_id":"60","payer_account_created":1612051200,"Discount":0}	\N	\N	f	2021-02-02 20:12:35.715712	\N	\N
96	75	3b474fcb-f2f9-447e-bfa1-346d9531ade2	\N	69c8c525-a1b2-431b-b6f0-e86b15b83395	41567516	completed	barion	{"payer_email":"foe010@gmail.com","billing_address":{"name":"Patrik Bajusz","tax_number":"20925345-1-05","country":"HU","region":null,"city":"Halmaj","zip":"3842","street":"Alkotmány út 65","street_2":"","street_3":""},"payment_request_id":"3b474fcb-f2f9-447e-bfa1-346d9531ade2","order_number":"041567516","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":12699,"sku":"CSOM-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":8,"unit":"db","unit_price":1000,"item_total":850,"sku":"EXTRA-1"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":8,"unit":"db","unit_price":19900,"item_total":16915,"sku":"EXTRA-2"}],"transaction_id":"69c8c525-a1b2-431b-b6f0-e86b15b83395","coupon":"bajusz15","card_holder_hint":"Patrik Bajusz","payer_phone_number":"36301741451","payer_account_id":"60","payer_account_created":1612051200,"Discount":15}	\N	\N	f	2021-02-02 20:13:55.656111	\N	\N
97	1	9da33f8b-7d9a-4460-8920-b49623ee977a	\N	84929eff-b2cc-4217-88a7-ed3bfa67931b	498539521	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"9da33f8b-7d9a-4460-8920-b49623ee977a","order_number":"498539521","items":[{"name":"3 havi csomag","description":"Mester szolgáltatás csomag 3 hónap","quantity":1,"unit":"db","unit_price":9900,"item_total":9900,"sku":"CSOM-1"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":3,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":1,"unit":"db","unit_price":19900,"item_total":19900,"sku":"EXTRA-2"}],"transaction_id":"84929eff-b2cc-4217-88a7-ed3bfa67931b","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-02-02 20:14:36.490241	\N	\N
99	1	f3c635a3-84af-4b68-b301-4189673114f1	\N	9d08475b-4ee0-4522-9181-b8d7e339b701	121753269	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"f3c635a3-84af-4b68-b301-4189673114f1","order_number":"121753269","items":[{"name":"3 havi csomag","description":"Mester szolgáltatás csomag 3 hónap","quantity":1,"unit":"db","unit_price":9900,"item_total":9900,"sku":"CSOM-1"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":3,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":1,"unit":"db","unit_price":19900,"item_total":19900,"sku":"EXTRA-2"}],"transaction_id":"9d08475b-4ee0-4522-9181-b8d7e339b701","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-02-02 20:18:24.837807	\N	\N
138	1	18bb39b6-861b-4284-ad15-1e295f7ec712	\N	00f82637-9aa2-44c2-88e2-7ecf975e4e1b	201274029	initiated	\N	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25  ","country":"HU","region":null,"city":"Budapest","zip":"1231","street":"sadsd","street_2":"","street_3":""},"payment_request_id":"18bb39b6-861b-4284-ad15-1e295f7ec712","order_number":"201274029","items":[{"name":"6 havi csomag","description":"6 havi mester szolgáltatás csomag","quantity":1,"unit":"db","unit_price":17940,"item_total":17940,"sku":"ALAP-2","stripe_price_id":"price_1IXp77FwXtu51BxSoyY2019a"}],"transaction_id":"00f82637-9aa2-44c2-88e2-7ecf975e4e1b","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-04-05 18:37:31.910187	\N	\N
102	1	682490f1-02ea-4eab-95c5-49f2f104ae09	\N	7177348a-8a32-44dd-ab6e-5be6fcc80851	598111630	completed	bank transfer	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"BMáté","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Miskolc","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"682490f1-02ea-4eab-95c5-49f2f104ae09","order_number":"598111630","items":[{"name":"12 havi csomag","description":"Mester szolgáltatás csomag 12 hónap","quantity":1,"unit":"db","unit_price":23880,"item_total":23880,"sku":"CSOM-3"}],"transaction_id":"7177348a-8a32-44dd-ab6e-5be6fcc80851","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-02-26 15:33:48.12484	\N	\N
152	1	765d39c1-79ba-4b48-ac58-ee15a2994f07	53fa975f8b65eb118bc5001dd8b71cc4	1aea58f0-5cf3-4d9a-8c41-cf6fbf0c3330	326978140	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"csadssa","street_2":"","street_3":""},"payment_request_id":"765d39c1-79ba-4b48-ac58-ee15a2994f07","order_number":"326978140","items":[{"name":"3 havi csomag","description":"Mester szolgáltatás csomag 3 hónap","quantity":1,"unit":"db","unit_price":9900,"item_total":8415,"sku":"CSOM-1"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":3,"unit":"db","unit_price":1000,"item_total":850,"sku":"EXTRA-1"}],"transaction_id":"1aea58f0-5cf3-4d9a-8c41-cf6fbf0c3330","coupon":"bajusz15","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":15}	{"PaymentId":"53fa975f8b65eb118bc5001dd8b71cc4","PaymentRequestId":"765d39c1-79ba-4b48-ac58-ee15a2994f07","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=53fa975f-8b65-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"1aea58f0-5cf3-4d9a-8c41-cf6fbf0c3330","TransactionId":"54fa975f8b65eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-02-02T19:18:05.163Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"53fa975f8b65eb118bc5001dd8b71cc4","PaymentRequestID":"765d39c1-79ba-4b48-ac58-ee15a2994f07","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-02-02T19:18:05.163Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-02-02T19:20:55.92Z","ValidUntil":"2021-02-02T19:48:05.163Z","Total":10965,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://localhost:5000/payment/barion/callback?paymentId=53fa975f8b65eb118bc5001dd8b71cc4","RedirectUrl":"http://localhost:5000/vasarlas/koszonjuk?paymentId=53fa975f8b65eb118bc5001dd8b71cc4"}	t	2021-04-27 20:17:55.311306	2021-04-27 13:12:59.604534	\N
151	78	98c14e92-4d3f-471d-a712-d32e425146a9	\N	2234aada-a3bf-45ec-b7f1-99496f96d510	528893073	completed	bank transfer	{"payer_email":"rajeser880@onzmail.com","billing_address":{"name":"Hornyák Balázs","tax_number":"10745991-2-05","country":"HU","region":null,"city":"Miskolc","zip":"3530","street":"Arany János utca 29","street_2":"","street_3":""},"payment_request_id":"98c14e92-4d3f-471d-a712-d32e425146a9","order_number":"528893073","items":[{"name":"6 havi csomag","description":"Mester szolgáltatás csomag 6 hónap","quantity":1,"unit":"db","unit_price":14940,"item_total":14940,"sku":"CSOM-2"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":1,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"}],"transaction_id":"2234aada-a3bf-45ec-b7f1-99496f96d510","coupon":"","card_holder_hint":"Hornyák Balázs","payer_phone_number":"36204416868","payer_account_id":"61","payer_account_created":1614902400,"Discount":0}	\N	\N	f	2021-04-25 18:42:49.48236	\N	\N
105	1	71aa7f19-6a6c-4d70-b741-a2f2709ac20e	\N	a1831f3f-ae87-46a2-8074-8dee29d2915f	73297450	initiated	\N	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"BMáté","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Miskolc","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"71aa7f19-6a6c-4d70-b741-a2f2709ac20e","order_number":"073297450","items":null,"transaction_id":"a1831f3f-ae87-46a2-8074-8dee29d2915f","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-03-18 13:23:32.530991	\N	\N
101	1	048fb32c-ee65-422d-a735-08a94d0ff56f	01f1a0419176eb118bc6001dd8b71cc4	93e82d28-1664-4e04-a06b-6258d79ca734	187691904	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Miskolc","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"048fb32c-ee65-422d-a735-08a94d0ff56f","order_number":"187691904","items":[{"name":"12 havi csomag","description":"Mester szolgáltatás csomag 12 hónap","quantity":1,"unit":"db","unit_price":23880,"item_total":20298,"sku":"CSOM-3"},{"name":"Közösségi média hirdetés 1 hónap 19900 Ft","description":"Facebook reklám kampánnyal rengeteg ügyfelet hozunk neked rövid időn belül. Kezdő vagy megrendelő hiánnyal küzdő vállalkozóknak ajánljuk. Ezzel a csomaggal garantált hogy betáblázod magad egész hónapra.","quantity":4,"unit":"db","unit_price":19900,"item_total":16915,"sku":"EXTRA-2"}],"transaction_id":"93e82d28-1664-4e04-a06b-6258d79ca734","coupon":"bajusz15","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":15}	{"PaymentId":"01f1a0419176eb118bc6001dd8b71cc4","PaymentRequestId":"048fb32c-ee65-422d-a735-08a94d0ff56f","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=01f1a041-9176-eb11-8bc6-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"93e82d28-1664-4e04-a06b-6258d79ca734","TransactionId":"02f1a0419176eb118bc6001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-02-24T11:13:01.816Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"01f1a0419176eb118bc6001dd8b71cc4","PaymentRequestID":"048fb32c-ee65-422d-a735-08a94d0ff56f","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-02-24T11:13:01.816Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-02-24T11:14:03.388Z","ValidUntil":"2021-02-24T11:43:01.816Z","Total":87958,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=01f1a0419176eb118bc6001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=01f1a0419176eb118bc6001dd8b71cc4"}	f	2021-02-24 12:12:55.312687	2021-02-24 12:14:04.071376	\N
153	1	62764a61-6bc4-4307-83b5-475e8eee7c74	8b27490e1666eb118bc5001dd8b71cc4	acbe26b6-da10-4d55-972d-615958c98e21	174071555	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"valaki","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Miskolc","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"62764a61-6bc4-4307-83b5-475e8eee7c74","order_number":"174071555","items":[{"name":"3 havi csomag","description":"Mester szolgáltatás csomag 3 hónap","quantity":1,"unit":"db","unit_price":9900,"item_total":9900,"sku":"CSOM-1"},{"name":"Keresésben első hely + kiemelés 1 hónap 1000 Ft","description":"Keresésnél a többi mester előtt jelensz meg. A főoldalon megjelensz a kiemelt mesterek között.","quantity":1,"unit":"db","unit_price":1000,"item_total":1000,"sku":"EXTRA-1"}],"transaction_id":"acbe26b6-da10-4d55-972d-615958c98e21","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	{"PaymentId":"8b27490e1666eb118bc5001dd8b71cc4","PaymentRequestId":"62764a61-6bc4-4307-83b5-475e8eee7c74","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=8b27490e-1666-eb11-8bc5-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"acbe26b6-da10-4d55-972d-615958c98e21","TransactionId":"8c27490e1666eb118bc5001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-02-03T11:50:48.979Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"8b27490e1666eb118bc5001dd8b71cc4","PaymentRequestID":"62764a61-6bc4-4307-83b5-475e8eee7c74","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-02-03T11:50:48.979Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-02-03T11:51:05.379Z","ValidUntil":"2021-02-03T12:20:48.979Z","Total":10900,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=8b27490e1666eb118bc5001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=8b27490e1666eb118bc5001dd8b71cc4"}	f	2021-04-28 12:50:37.821213	2021-04-28 12:51:06.076836	\N
104	1	05307c38-d2c2-448b-b40a-671b08920da1	\N	0477f313-8269-4565-a371-927f850af9ef	43433046	initiated	\N	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"BMáté","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Miskolc","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"05307c38-d2c2-448b-b40a-671b08920da1","order_number":"043433046","items":null,"transaction_id":"0477f313-8269-4565-a371-927f850af9ef","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-03-18 13:11:26.344157	\N	\N
106	1	3bcfc564-0591-478f-b56f-ec5a63fd79fb	2b33a2a7e787eb118bc8001dd8b71cc4	190b83c6-9858-4eb7-9513-d4217c748cdb	91533678	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"BMáté","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Miskolc","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"3bcfc564-0591-478f-b56f-ec5a63fd79fb","order_number":"091533678","items":[{"name":"7000 egyenleg","description":"7000 egyenleg","quantity":1,"unit":"db","unit_price":7000,"item_total":7000,"sku":"ALAP-1"}],"transaction_id":"190b83c6-9858-4eb7-9513-d4217c748cdb","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	{"PaymentId":"2b33a2a7e787eb118bc8001dd8b71cc4","PaymentRequestId":"3bcfc564-0591-478f-b56f-ec5a63fd79fb","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=2b33a2a7-e787-eb11-8bc8-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"190b83c6-9858-4eb7-9513-d4217c748cdb","TransactionId":"2c33a2a7e787eb118bc8001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-03-18T12:44:19.432Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"2b33a2a7e787eb118bc8001dd8b71cc4","PaymentRequestID":"3bcfc564-0591-478f-b56f-ec5a63fd79fb","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-03-18T12:44:19.432Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-03-18T12:45:11.717Z","ValidUntil":"2021-03-18T13:14:19.432Z","Total":7000,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://localhost:5000/payment/barion/callback?paymentId=2b33a2a7e787eb118bc8001dd8b71cc4","RedirectUrl":"http://localhost:5000/vasarlas/koszonjuk?paymentId=2b33a2a7e787eb118bc8001dd8b71cc4"}	t	2021-03-18 13:44:02.88101	2021-03-18 13:46:24.46997	\N
107	2	cef868b6-c71a-4a34-ad8c-4736b3544128	446265ea3f8beb118bc8001dd8b71cc4	1bc74c61-e83c-43fd-aa6a-4597fe4e63fc	875237687	completed	barion	{"payer_email":"bajusz.patrik@gmail.com","billing_address":{"name":"Angyal Ferenc","tax_number":"20925345-1-05","country":"HU","region":null,"city":"Bugyi","zip":"3842","street":"Asd út 69","street_2":"","street_3":""},"payment_request_id":"cef868b6-c71a-4a34-ad8c-4736b3544128","order_number":"875237687","items":[{"name":"7000 egyenleg","description":"7000 egyenleg","quantity":1,"unit":"db","unit_price":7000,"item_total":7000,"sku":"ALAP-1"}],"transaction_id":"1bc74c61-e83c-43fd-aa6a-4597fe4e63fc","coupon":"","card_holder_hint":"Angyal Ferenc","payer_phone_number":"36301741451","payer_account_id":"62","payer_account_created":1616371200,"Discount":0}	{"PaymentId":"446265ea3f8beb118bc8001dd8b71cc4","PaymentRequestId":"cef868b6-c71a-4a34-ad8c-4736b3544128","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=446265ea-3f8b-eb11-8bc8-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"1bc74c61-e83c-43fd-aa6a-4597fe4e63fc","TransactionId":"456265ea3f8beb118bc8001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-03-22T18:53:40.649Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"446265ea3f8beb118bc8001dd8b71cc4","PaymentRequestID":"cef868b6-c71a-4a34-ad8c-4736b3544128","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-03-22T18:53:40.649Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-03-22T18:56:11.848Z","ValidUntil":"2021-03-22T19:23:40.649Z","Total":7000,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=446265ea3f8beb118bc8001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=446265ea3f8beb118bc8001dd8b71cc4"}	t	2021-03-22 19:53:26.392249	2021-03-22 19:56:12.667295	\N
108	2	d31ead2e-c3c2-4c2e-9da0-c0ab17a23d2a	d35c8167ff8beb118bc8001dd8b71cc4	814c1a13-ca04-4c51-b9b1-a9c0ca8c915b	57477544	completed	barion	{"payer_email":"bajusz.patrik@gmail.com","billing_address":{"name":"Angyal Ferenc","tax_number":"20925345-1-05","country":"HU","region":null,"city":"Závod","zip":"3842","street":"VALAMI ÚT VALAMI","street_2":"","street_3":""},"payment_request_id":"d31ead2e-c3c2-4c2e-9da0-c0ab17a23d2a","order_number":"057477544","items":[{"name":"20 000 ft prémium egyenleg","description":"20 000 ft prémium egyenleg","quantity":1,"unit":"db","unit_price":20000,"item_total":20000,"sku":"PREMIUM-1"}],"transaction_id":"814c1a13-ca04-4c51-b9b1-a9c0ca8c915b","coupon":"","card_holder_hint":"Angyal Ferenc","payer_phone_number":"36301741451","payer_account_id":"62","payer_account_created":1616371200,"Discount":0}	{"PaymentId":"d35c8167ff8beb118bc8001dd8b71cc4","PaymentRequestId":"d31ead2e-c3c2-4c2e-9da0-c0ab17a23d2a","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=d35c8167-ff8b-eb11-8bc8-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"814c1a13-ca04-4c51-b9b1-a9c0ca8c915b","TransactionId":"d45c8167ff8beb118bc8001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-03-23T17:44:24.412Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"d35c8167ff8beb118bc8001dd8b71cc4","PaymentRequestID":"d31ead2e-c3c2-4c2e-9da0-c0ab17a23d2a","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-03-23T17:44:24.412Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-03-23T17:45:36.706Z","ValidUntil":"2021-03-23T18:14:24.412Z","Total":20000,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=d35c8167ff8beb118bc8001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=d35c8167ff8beb118bc8001dd8b71cc4"}	t	2021-04-29 18:44:16.720952	2021-04-29 18:45:37.434465	\N
110	1	fc378742-d94e-4363-8661-87cd255d51e1	\N	35599e01-68d9-41ab-bee7-c21a29947917	514721209	initiated	\N	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"fc378742-d94e-4363-8661-87cd255d51e1","order_number":"514721209","items":[{"name":"7000 ft egyenleg csomag","description":"7000 egyenleg","quantity":1,"unit":"db","unit_price":7000,"item_total":7000,"sku":"ALAP-1","stripe_price_id":""}],"transaction_id":"35599e01-68d9-41ab-bee7-c21a29947917","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-03-30 21:23:26.464483	\N	\N
113	1	ea3cfbf7-3cf0-4007-a0db-3ed1a0983a9e	\N	c5544b8b-e82a-4ebc-b568-5cdd8017c594	761966092	initiated	\N	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"ea3cfbf7-3cf0-4007-a0db-3ed1a0983a9e","order_number":"761966092","items":[{"name":"6 havi csomag","description":"6 havi mester szolgáltatás csomag","quantity":1,"unit":"db","unit_price":17940,"item_total":17940,"sku":"ALAP-2","stripe_price_id":""}],"transaction_id":"c5544b8b-e82a-4ebc-b568-5cdd8017c594","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-03-30 21:34:11.716769	\N	\N
150	1	d7c0a908-ac00-4f60-a282-5d6101cfed23	197a2e6ab28ceb118bcd001dd8b71cc4	064d0c37-bcad-4f57-9d6e-4554a4663b4e	198248320	completed	barion	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Budapest","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"d7c0a908-ac00-4f60-a282-5d6101cfed23","order_number":"198248320","items":[{"name":"Próba egyenleg csomag","description":"5000 Ft próba egyenleg csomag","quantity":1,"unit":"db","unit_price":5000,"item_total":5000,"sku":"PROBA-1"}],"transaction_id":"064d0c37-bcad-4f57-9d6e-4554a4663b4e","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	{"PaymentId":"197a2e6ab28ceb118bcd001dd8b71cc4","PaymentRequestId":"d7c0a908-ac00-4f60-a282-5d6101cfed23","Status":"Prepared","QRUrl":"https://api.test.barion.com/qr/generate?paymentId=197a2e6a-b28c-eb11-8bcd-001dd8b71cc4\\u0026size=Large","Transactions":[{"POSTransactionId":"064d0c37-bcad-4f57-9d6e-4554a4663b4e","TransactionId":"1a7a2e6ab28ceb118bcd001dd8b71cc4","Status":"Prepared","Currency":"","TransactionTime":"2021-03-24T15:05:48.841Z","RelatedId":""}],"RecurrenceResult":"None","GatewayUrl":"","RedirectUrl":"","CallbackUrl":"","Errors":[]}	{"PaymentId":"197a2e6ab28ceb118bcd001dd8b71cc4","PaymentRequestID":"d7c0a908-ac00-4f60-a282-5d6101cfed23","POSId":"b65358fe510141f19aebcbadfca3ec6c","POSName":"mestertkeresek-test","POSOwnerEmail":"bajusz.mate@mestertkeresek.hu","Status":"Succeeded","PaymentType":"Immediate","AllowedFundingSources":["All"],"FundingSource":"BankCard","GuestCheckout":true,"CreatedAt":"2021-03-24T15:05:48.841Z","StartedAt":"0001-01-01T00:00:00Z","CompletedAt":"2021-03-24T15:06:55.646Z","ValidUntil":"2021-03-24T15:35:48.841Z","Total":5000,"Currency":"HUF","FraudRiskScore":0,"CallbackUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/payment/barion/callback?paymentId=197a2e6ab28ceb118bcd001dd8b71cc4","RedirectUrl":"http://mestertkeresek-staging-env.eu-central-1.elasticbeanstalk.com/vasarlas/koszonjuk?paymentId=197a2e6ab28ceb118bcd001dd8b71cc4"}	t	2021-04-24 16:05:43.144701	2021-04-24 16:06:56.236115	\N
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name, icon) FROM stdin;
1	Építkezés és felújítás	epitkezes.jpg
2	Ház, kert	haz-kert.jpg
3	Üzlet és tanácsadás	penzugyek.jpg
7	Szállítás, fuvarozás	szallitas.jpg
9	Vendéglátás	vendeglatas.jpg
4	Egészség, szépség, sport	egeszseg.jpg
6	Autó, motor, kerékpár	auto.jpg
8	Oktatás	tanulas.jpg
5	Informatika, számitástechnika	informatika.jpg
10	Egyéb	egyeb.jpeg
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, owner_email, description, due_date, category, title, phone, profession, price_min, price_max, urgent, created_at, location_id, source_ip_address, "id,""owner_email"",""description"",""due_date"",""category"",""title"",""p") FROM stdin;
10	bajusz5.mate@gmail.com	Teszt ajanlatkeres, vegyeszeknek.	2021-04-09	10	Vegyész		199	0	0	f	2021-03-19	146	80.99.103.169	\N
11	bajusz5.mate@gmail.com	Ez egy teszt hirdetés. Nincs szuksegem vegyeszre.	2021-04-09	10	Vegyész		199	0	0	f	2021-03-19	146	80.99.103.169	\N
9	bajszmate99@gmail.com	Ez egy teszt nem rendes ajanlatkedes.	2021-05-06	10	Valami munka	+36301234567	2	0	0	t	2021-01-20	146		\N
\.


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location (id, name, zip, coordinates, ranking) FROM stdin;
146	Keszthely	8360	010100000000000000000000000000000000000000	0
1	Som	8655	01010000007DB83F72C6233240A5C409A760674740	0
2	Somogyapáti	7922	010100000030CC5367FFBF3140800640811C0C4740	0
3	Patosfa	7536	0101000000384E65AC91AA31407A257FE662104740	0
4	Tab	8660	01010000003465A71FD40932409D088783295E4740	0
5	Sormás	8881	0101000000192EBCDC71EA3040C59C56C0F33A4740	0
6	Hetvehely	7681	01010000008503C69F4D0B32408EA8F523EA104740	0
7	Palkonya	7771	010100000007FAFA100A643240813D26529AF24640	0
8	Villánykövesd	7772	0101000000957C9175DD6C3240C6B5EBEFB6F04640	0
9	Villány	7773	0101000000D3A5DA029D743240CF9C9A7054EF4640	0
10	Pécs	7600	01010000005C0CD418633A3240B97A04EDC4094740	0
11	Cserdi	7683	01010000001B1021AE9CFD3140303B7AB2510A4740	0
12	Kishajmás	7391	010100000092F8269710153240E8065449AE194740	0
13	Egerág	7763	0101000000820F6FE70C4E3240FB5A971AA1FD4640	0
14	Szőkéd	7763	01010000002179420AF949324091C2AB9B41FB4640	0
15	Áta	7763	0101000000D993C0E61C4C324004D31F50ECF74640	0
16	Kisherend	7763	01010000000A0F9A5DF754324061133E004EFB4640	0
17	Komló	7300	010100000083E6CEA7E942324045C88A2B78184740	0
18	Kárász	7333	0101000000906F4AD46651324088D0AD7C3B224740	0
19	Tófű	7348	01010000007345CE67E55B324079680EFF9F274740	0
20	Egyházaskozár	7347	0101000000F719BC5411513240EE57A604692A4740	0
21	Bikal	7346	01010000002F8C4F5CE948324067B796C9702A4740	0
22	Olasz	7745	0101000000A59F70766B693240B4C70BE9F0014740	0
23	Belvárdgyula	7747	01010000004685A059C86E324090E0A18389FC4640	0
24	Lothárd	7761	01010000006019C000675A3240C678831E20004740	0
25	Birján	7747	0101000000E3665D482C60324084B7AC67ADFF4640	0
26	Hásságy	7745	01010000007220DA7D7D63324086D6790A6F044740	0
27	Magyarsarlós	7761	0101000000761085E0025A32403D65355D4F054740	0
28	Keszü	7668	01010000001C19F55A1A3132400124E4CD2B024740	0
29	Kökény	7639	0101000000023F4FA84C34324066C6360422004740	0
30	Harkány	7815	01010000008EED105A6A3C32402D2DD96784EC4640	0
31	Lad	7535	01010000005A643BDF4FA531409FC2B6EADF114740	0
32	Letenye	8868	010100000045C07C0D1CB930408A3F8A3A73374740	0
33	Abaliget	7678	010100000015014EEFE21D32404DBA2D910B124740	0
34	Orfű	7677	010100000005DB8827BB273240A204A2CCAB114740	0
35	Kozármisleny	7761	0101000000BDF7DCAE3C493240938C9C853D064740	0
36	Ellend	7744	01010000007F96F8ED35603240E569AFF490074740	0
37	Romonya	7743	01010000006CB3B112F3563240645C7171540B4740	0
38	Bogád	7742	01010000002619390B7B523240B7A79A0FBE0A4740	0
39	Szederkény	7751	0101000000AF84A4051E7432409E49F663EEFF4640	0
40	Bóly	7754	01010000009BD9F85D228432407497C45911FC4640	0
41	Vásárosdombó	7362	01010000008978EBFCDB21324039B69E211C274740	0
42	Hetes	7432	0101000000730690EBF0B131401EA3E13900364740	0
43	Kocsola	7212	010100000050DFD7ED582D3240A2CAD53494434740	0
44	Ságvár	8654	01010000006748707E1E1A3240F4F928232E6B4740	0
45	Szekszárd	7100	010100000031D0B52FA0B33240878494449B2C4740	0
46	Balatonudvari	8242	0101000000022956B208CE314032CC09DAE4734740	0
47	Sopron	9400	0101000000C5330D2F2D993040A2E1DE4614D74740	0
48	Kópháza	9495	01010000006F795160A6A43040A8CA5246B7D14740	0
49	Sárvár	9600	010100000033E202D028EF30404801FD1939A04740	0
50	Tapolca	8300	0101000000A5B09CCE5F70314053F2A08FE8704740	0
51	Okorvölgy	7681	010100000059BD68345E0F32409DF2E84658134740	0
52	Szentkatalin	7681	01010000005E6E8B8DD40C32400EF049CC58164740	0
53	Husztót	7678	0101000000597DBFE2BA173240C8505FE003164740	0
54	Csertő	7900	010100000058E0D00083CD3140DA4B6430900B4740	0
55	Szulimán	7932	0101000000138832AF7ECF31407D8BF3DCE70F4740	0
56	Kaposvár	7400	010100000060BAFF7EE7C93140010462C8A02D4740	0
57	Siklós	7800	01010000007C140901544C3240B686527B11ED4640	0
58	Balatonakali	8243	0101000000C8A06EFB79C031409C4940F108714740	0
59	Jászberény	5100	0101000000C35CF7FB6AE9334044DE72F563C04740	0
60	Eger	3300	0101000000CE37A27BD65F34409DFCCC0F12F34740	0
61	Tokaj	3910	0101000000F46A80D250693540A1270A99D00F4840	0
62	Debrecen	4000	01010000004A02791B40A035404510E7E104C44740	0
63	Sümeg	8330	0101000000C741AE79FA4731404C6A0D4A3D7D4740	0
64	Örvényes	8242	01010000002739BB1006D1314088BB7A1519754740	0
65	Balatonfőkajár	8164	0101000000F330FEC753363240F9E989F898824740	0
66	Mecsekpölöske	7305	01010000009B6BE22E0C363240EB4B80AB861C4740	0
67	Hobol	7971	0101000000E591E45E05C73140AA3D36131D034740	0
68	Teklafalu	7973	010100000044858F2D70BA3140FDD98F1491F94640	0
69	Hencse	7532	0101000000CFC6003F999F31405E1498A9A4194740	0
70	Mágocs	7342	0101000000CEAED6E4843A3240E107E753C72C4740	0
71	Jákó	7525	0101000000B04A3327798D31409A232BBF0C2B4740	0
72	Hegyháthodász	9915	01010000005C035B2558A83040ABFB11D08E774740	0
73	Komárom	2900	0101000000CAD067F62F1F3240A2E6502BF1DE4740	0
74	Szeged	6700	01010000001E2224C10A263440474552C197204740	0
75	Tihany	8237	01010000004BF784364AE43140663A2AEDC3744740	0
76	Algyő	6750	0101000000F64B1F155A3534401D91EF52EA2A4740	0
77	Makó	6900	0101000000F5413B4CA0793440911A248E861B4740	0
78	Kiszombor	6775	01010000001D8299A5536D3440B2EABD4230184740	0
79	Deszk	6772	01010000003198BF42E63C3440CD3D247CEF1B4740	0
80	Újszentiván	6754	01010000003CB8E0B1442E3440746E241AEE174740	0
81	Tiszasziget	6756	0101000000CB0CC0AB8A293440806CEDD863164740	0
82	Hódmezővásárhely	6800	0101000000479451C0D1513440AF04F7A864354740	0
83	Domaszék	6781	0101000000D107CBD8D0FF3340954CA9A67F1F4740	0
84	Mórahalom	6782	0101000000FDE88A08B5E33340582C8F7FB01B4740	0
85	Székkutas	6821	0101000000F15DEFA3BF8834407B8BE2B08F404740	0
86	Orosháza	5900	01010000001F27F15E5AAB34408AAB6F05B9474740	0
87	Nagykőrös	2750	010100000038E27FE14BC93340D4C3865DCA844740	0
88	Kunágota	5746	0101000000EFA023038A0C354064BD079E31364740	0
89	Barcs	7570	010100000011D9AC9FA376314036CE01DDF2FA4640	0
90	Rajka	9224	0101000000E0AAA1C332323140AEF199EC9FFF4740	0
91	Hegyeshalom	9222	01010000004B2EB594E2273140F9C907F30DF54740	0
92	Bezenye	9223	0101000000AF9F596D59373140B1DB0CDC26FB4740	0
93	Újpetre	7766	0101000000DE89FE75135D3240C75DCEB6E4F74640	0
94	Kecskemét	6000	0101000000DDBB61365CB1334064E025DD3B744740	0
95	Cserkeszőlő	5465	01010000009694BBCFF131344036DABB500A6F4740	0
96	Békéscsaba	5600	01010000001EC4CE143A193540CE273CB203574740	0
97	Gyula	5700	0101000000AAD4EC81564635407C821F306A524740	0
98	Szalkszentmárton	6086	01010000002B06FEA666033340DCFA44F9DD7C4740	0
99	Tass	6098	0101000000FFB858AC3C083340DA5FD10891824740	0
100	Sármellék	8391	0101000000D237691A142B3140D1A79F81A25A4740	0
101	Zala	8660	01010000008072254C620032404882154CA15E4740	0
102	Pécsely	8245	01010000004C76C7BD54C9314055BE6724427A4740	0
103	Pomáz	2013	0101000000FF3053A40C063340032E7E09CBD24740	0
104	Miskolc	3500	0101000000DFEF614040CA34404CF10236310D4840	0
105	Győr	9000	010100000050E09D7C7AA23140B7B75B9203D84740	0
106	Nyíregyháza	4400	0101000000E8D43A1680B7354009956E0157FA4740	0
107	Szentendre	2000	0101000000FE77E9CB771333405747E92D79D54740	0
108	Budakalász	2011	0101000000E31A9FC9FE0B3340D74E948444CF4740	0
109	Pilisszentkereszt	2098	010100000092EFADA305E732404EEFE2FDB8D84740	0
110	Pilisszentlászló	2009	01010000000AA9914C3DFD3240049DFF0D90DC4740	0
111	Öcsöd	5451	010100000060AB048BC36334401FC594A35B734740	0
112	Békésszentandrás	5561	010100000034DD465E317C344067E03609946F4740	0
113	Szarvas	5540	0101000000FC98C57A598D34402BBB05B75A6E4740	0
114	Kondoros	5553	010100000096FF35C588CB344083024A9E46614740	0
115	Székesfehérvár	8000	010100000049D6E1E82A693240DD3DE53D73984740	0
116	Solt	6320	0101000000112109563001334070404B57B0664740	0
117	Dunapataj	6328	010100000051DCF126BFFF3240990E9D9E77524740	0
118	Dunaszentgyörgy	7135	0101000000C1B1C288D8CF324098C28366D7434740	0
119	Pörböly	7142	0101000000E766C92DF7CF32400EB67D34411A4740	0
120	Bátaszék	7140	01010000001D9F7F715FB93240C8409E5DBE184740	0
121	Kiskunlacháza	2340	01010000000CEA5BE67401334036D318085D984740	0
122	Dömsöd	2344	01010000007910F1C5CD013340FBCDC474218C4740	0
123	Dormánd	3374	0101000000107FA88F1B6B3440905264085BDC4740	0
124	Besenyőtelek	3373	01010000008F2221808A6D344085CD001764D94740	0
125	Füzesabony	3390	01010000005E4DF96B0D6A344054A4671FD0DF4740	0
126	Mezőtárkány	3375	0101000000343AD67BE07934404FF6854666DC4740	0
127	Tiszafüred	5350	01010000008D9D4BCC0EC03440398A62A879CE4740	0
128	Tiszaszőlős	5244	01010000001A9249FC40B83440B63F619A33C74740	0
129	Egyek	4069	01010000001211A38C5DE334400B8AD5D5D3D04740	0
130	Kunszentmárton	5440	010100000099846632774A3440ED5D2805826B4740	0
131	Tiszaföldvár	5430	0101000000E75E16C90D413440F0FF3E3E7C7D4740	0
132	Martfű	5435	010100000043D02C6409483440455A74FC61824740	0
133	Cegléd	2700	0101000000E954E87239CC334010841A74F8954740	0
134	Szajol	5081	01010000004641F0F8F64C344084296FEC7E964740	0
135	Törökszentmiklós	5200	01010000006F0F4240BE6834405928E329F5964740	0
136	Fegyvernek	5231	01010000001191F52FA48634401BA43BE356A04740	0
137	Kenderes	5331	01010000001F6ADB300AAC3440BB97A02BB69F4740	0
138	Karcag	5300	010100000033ED516E91EC34409BE8F35146A84740	0
139	Berekfürdő	5309	0101000000DB34B6D782D63440A79AB40474B14740	0
140	Kunmadaras	5321	0101000000881A3B9798CB3440205ED72FD8B64740	0
141	Budapest	0	01010000003CF2AC495C0A334039B709F7CABF4740	0
142	Zalaapáti	8741	0101000000AAB0BE26101B31400FD8309E9C5E4740	0
143	Pacsa	8761	01010000006B3D8DC580023140A306D3307C5C4740	0
144	Zalaszentmihály	8936	010100000096B4E21B0AF33040682A1FDD635D4740	0
145	Pölöske	8929	010100000056157541D8EC3040B1AB240DC9604740	0
3172	Országos	0	010100000000000000000000000000000000000000	0
147	Hévíz	8380	0101000000B7FCD181F62E3140F28B5C8132654740	0
148	Verőce	2621	010100000093B4D1EFB10833406D6814DC59E94740	0
149	Kismaros	2623	0101000000E706F98F3B03334020555E3CCDE94740	0
150	Dömös	2027	0101000000FE9EB3603DE932402D7CD866BEE14740	0
151	Pilismarót	2028	010100000033DBBA40EEDF3240E73B534376E44740	0
152	Pilisvörösvár	2085	0101000000D1555F025CE932404EFC07477FCF4740	0
153	Ráckeve	2300	0101000000BCA24A8391F132405776C1E09A944740	0
154	Lórév	2309	0101000000FCF8F0D187E53240B364E99ED08E4740	0
155	Budajenő	2093	010100000006E4011BC6CD32409622F94A20C74740	0
156	Telki	2089	01010000006C38769A16D232405E64027E8DC64740	0
157	Tököl	2316	0101000000599CD61297F63240D2CE1F894DA94740	0
158	Csömör	2141	0101000000D24A6B1D66393340FCA078DF42C64740	0
159	Gödöllő	2100	0101000000EE073C30805A33406898350C7ACD4740	0
160	Budaörs	2040	01010000003C70294245F432400987DEE2E1BA4740	0
161	Patak	2648	01010000001E11F8681625334058816B3876024840	0
162	Dejtár	2649	01010000003A6A9615D42B334081B4FF01D6044840	0
163	Ipolyvece	2669	010100000092521A7B401A334068925852EE074840	0
164	Drégelypalánk	2646	0101000000EC6415DB490B33400255922BAB064840	0
165	Érsekvadkert	2659	01010000007B8DB85BED323340FAFDAC437FFF4740	0
166	Nagyoroszi	2645	01010000002E0A719B5F17334018456A357F004840	0
167	Rétság	2651	0101000000DDC0D31A392333401F1730DC14F74740	0
168	Budakeszi	2092	0101000000B77D8FFAEBED3240A163ACDB45C14740	0
169	Vértesszőlős	2837	0101000000B4F688E29F6132405C994B0570CF4740	0
170	Diósd	2049	01010000001549055FE2F13240E2E6543200B44740	0
171	Érd	2030	01010000009F94A4C6DFEB324057772CB649B04740	0
172	Sukoró	8096	01010000000CE544BB0A99324022C1F979F89E4740	0
173	Pákozd	8095	0101000000725C7CC0F28A3240F5DA6CACC49B4740	0
174	Velence	2481	0101000000DCA5684018A93240C1D5F0E31E9E4740	0
175	Kápolnásnyék	2475	01010000009363FC451AAC3240D7D9907F669E4740	0
176	Gárdony	2483	0101000000C0D3BF7F4EA032408836B68DF5994740	0
177	Nagykovácsi	2094	01010000009CFA40F2CEE132404FA26F1CC2C94740	0
178	Előszállás	2424	01010000001DC29DB069D2324025C2D034726A4740	0
179	Alsószentiván	7012	01010000002D639EF06DBB32403CAD9113DC654740	0
180	Cece	7013	0101000000D5A76620E0A03240F47D82D5A2624740	0
181	Simontornya	7081	0101000000417452A9238B32404A287D21E4604740	0
182	Tolnanémedi	7083	010100000017C5611F53793240E1197E816A5B4740	0
183	Pincehely	7084	01010000006A2FA2ED9870324091CB248F4C574740	0
184	Paks	7030	01010000000F588341E3DB3240ED9282B8BC4F4740	0
185	Bikács	7043	01010000005061B6AEE2AA324067E0360994564740	0
186	Nagydorog	7044	0101000000CFF2E1FEC8A73240CAE83697D14F4740	0
187	Bölcske	7025	010100000069D6636C32F832405004CCD7C05E4740	0
188	Madocsa	7026	0101000000112BED1EEAF43240FCEA60B312584740	0
189	Gyönk	7064	01010000000647C9AB737A32408A99D8D715474740	0
190	Varsád	7067	01010000004B6540ACED8432402D9B94DD27434740	0
191	Tárnok	2461	0101000000999F1B9AB2DD3240AC0C99E1F5AE4740	0
192	Vác	2600	0101000000A177746DB9203340323212EB9EE34740	0
193	Kisszékely	7082	0101000000FC96EFCFFB8932403A933655F7564740	0
194	Páty	2071	010100000075FA8BEABED33240698F17D2E1C14740	0
195	Biatorbágy	2051	010100000061C5A9D6C2D232407F901B34AABC4740	0
196	Sóskút	2038	01010000000ECCC0B79FD4324008CBD8D0CDB34740	0
197	Pusztazámor	2039	0101000000597F958D18C93240EC23A6FA84B34740	0
198	Fót	2151	0101000000BDC3EDD0B0323340CA390C4169CE4740	0
199	Dunakeszi	2120	01010000002B6C06B820213340E4AF7F8DDAD04740	0
200	Zalaegerszeg	8900	0101000000D37602507BD830409BBA3CE7B86B4740	0
201	Százhalombatta	2440	010100000006DA780B7FE932409F28BFFB99A84740	0
202	Ercsi	2451	010100000002F8020EFCE532409D8A0A8B40A04740	0
203	Martonvásár	2462	0101000000983B8E7AE3C93240BB3E181D35A84740	0
204	Ráckeresztúr	2465	01010000002D40DB6AD6D532408D2CF41CECA24740	0
205	Tordas	2463	010100000004E04499B2C03240035B25581CAC4740	0
206	Gyúró	2464	01010000006E3FCF55A9BD32401C5833D70EAF4740	0
207	Ártánd	4115	01010000006D9A2D0F88C235403F4FA84CD68F4740	0
208	Bedő	4128	01010000006753646314C03540C6C5AC72FC944740	0
209	Nagykereki	4127	01010000004289E0C9B8C935407CB4DDA925984740	0
210	Kismarja	4126	01010000004D63207475D235403718EAB0C29F4740	0
211	Pocsaj	4125	010100000091459A7807CE3540F18DD7721DA44740	0
212	Hosszúpályi	4274	0101000000CF8250DEC7BB3540E7C6F48425B24740	0
213	Nagyszékely	7085	01010000009D7818A42A873240B21F73AFDD524740	0
214	Szakadát	7071	01010000006729594E42793240693FADFDF8444740	0
215	Diósberény	7072	01010000003B0CF7DBE8713240A038DB3752444740	0
216	Miszla	7065	01010000003718EAB0C27B3240943FCEEAD3504740	0
217	Udvari	7066	0101000000A275F97BCE82324072B55F88E64B4740	0
218	Horpács	2658	010100000005508C2C99213340F58079C894FF4740	0
219	Borsosberény	2644	0101000000DE1335E2131E3340F783CB74F9FC4740	0
220	Bánk	2653	01010000003EDCC47F702C33400A9FAD8383F64740	0
221	Szendehely	2640	01010000004C68379FDF1A3340966C86657DED4740	0
222	Sárszentlőrinc	7047	01010000006E23545F4C9B3240AD72FCAB22504740	0
223	Kölesd	7052	01010000008BEE0F4A4E963240C647307A13414740	0
224	Kistormás	7068	01010000005C76887FD89032402937F69100404740	0
225	Németkér	7039	01010000007731CD74AFC332403F219628D65B4740	0
226	Kerepes	2144	01010000007E7D63BE72493340FDBE7FF3E2C74740	0
227	Dabas	2370	010100000043160E29AB523340D1BEA89322964740	0
228	Újhartyán	2367	0101000000BDBBDFB25462334080C1C991299C4740	0
229	Újlengyel	2724	0101000000F790F0BDBF713340B8C777CEBB9D4740	0
230	Gerjen	7134	01010000004D5CD8E43AE7324012F92EA52E3F4740	0
231	Fadd	7133	01010000000D4EE90544D332405107C3CAB23B4740	0
232	Tolna	7130	01010000008D6E7319EDC932409AB0A2AB19364740	0
233	Fácánkert	7136	0101000000958BE72274BC324020A3F26558394740	0
234	Sióagárd	7171	0101000000BE51860552A732401516815605324740	0
235	Piliscsaba	2081	010100000008FA55CA7CD332409323F83A04D14740	0
236	Dorog	2510	01010000005726FC523FBB3240F32B8CE376DC4740	0
237	Tokodaltáró	2532	0101000000EDE98FD552B132409C5E189FB8DD4740	0
238	Tokod	2531	0101000000CD61AD90A8A83240B689EEB490DC4740	0
239	Tát	2534	0101000000157541D884A732406F3A13E4B1DE4740	0
240	Esztergom	2500	01010000006296879686BD32406E0503BE91E44740	0
241	Felsőnána	7175	01010000003677F4BF5C87324007F3B281CF3B4740	0
242	Nyergesújfalu	2536	01010000004DF0F219F58D3240F2A3D06861E14740	0
243	Lábatlan	2541	0101000000D18CEA19678032407C1D82F45EDF4740	0
244	Tata	2890	01010000004F75C8CD70513240F009230736D34740	0
245	Hőgyész	7191	01010000005EEFA3BF3C6B3240D1D7E209733F4740	0
246	Kalaznó	7194	01010000004A51781A7A7932408D50227832404740	0
247	Ács	2941	0101000000F4E1B43BFF0332402CEA3823EFDA4740	0
248	Gönyű	9071	01010000005A1AAEC4F2D3314074A4E9A2D7DD4740	0
249	Süttő	2543	0101000000D3C1FA3F87713240A8FFACF9F1E04740	0
250	Neszmély	2544	0101000000F93C354D8E5D3240E33213B12DDE4740	0
251	Dunaszentmiklós	2897	01010000000AEDE6F39B613240C759226129DA4740	0
252	Szomód	2896	0101000000B8BBBD5AA4573240366387E75BD74740	0
253	Tardos	2834	01010000000D608033E7713240EE821CEFE9D44740	0
254	Baj	2836	01010000004AF14CC34B5D3240AA6807B710D34740	0
255	Vértestolna	2833	0101000000E6C4C32055753240E7AB3F1DEACF4740	0
256	Tarján	2831	0101000000203DEA549E813240CE8B135FEDCD4740	0
257	Héreg	2832	010100000091B2EA18FC823240BC08AE4DBED24740	0
258	Bajna	2525	010100000092B476363F99324039398DFEE1D34740	0
259	Epöl	2526	0101000000A2F19FC959A3324087E4BF9BC9D24740	0
260	Gyermely	2821	010100000074626AA6D6A432407AD91B21A8CB4740	0
261	Szomor	2822	01010000007F92F1DE07AA3240012D0208C4CB4740	0
262	Tinnye	2086	0101000000417452A923C7324051700C5C79CF4740	0
263	Perbál	2074	0101000000766F456282C23240CB3560EBADCB4740	0
264	Tök	2073	01010000003D6B6DD04DBB32409046AA9443C84740	0
265	Zsámbék	2072	01010000007F06E5C7A9B73240A6423C122FC64740	0
266	Mány	2065	01010000002AB3F798FEA73240ABDDC02ED4C34740	0
267	Csabdi	2064	01010000005AFB9694169B32406F6F6D97ECC24740	0
268	Bicske	2060	010100000078A51B17C4A2324037774F79CFBE4740	0
269	Herceghalom	2053	0101000000B7BEFEDAB0BE3240878C47A984BF4740	0
270	Veresegyház	2112	0101000000D253E41071493340E71890BDDED34740	0
271	Erdőkertes	2113	0101000000616D8C9DF04E33409E680D94CAD54740	0
272	Őrbottyán	2162	0101000000711DE38A8B433340204A0F9E64D74740	0
273	Csomád	2161	0101000000C1960D219D3C3340698CD651D5D34740	0
274	Vácrátót	2163	0101000000CB65A3737E3C33406D4892D6CEDA4740	0
275	Göd	2131	010100000038899C1958223340687E90C07AD74740	0
276	Sződ	2134	0101000000FCFB3152942E3340CFEE35A90DDC4740	0
277	Sződliget	2133	0101000000FC1065B9B62533406E7A06C36FDD4740	0
278	Csörög	2135	010100000004A1061DBE3033406BB0BA1F01DE4740	0
279	Vácduka	2167	010100000091819774EF363340AE2017E64EDF4740	0
280	Váchartyán	2164	01010000009B5F28BBF44033402201FE840EDD4740	0
281	Kisnémedi	2165	0101000000F433F5BA454A3340566C825E6EDE4740	0
282	Püspökszilágy	2166	01010000006121CE1EC3503340C720C19EC0DE4740	0
283	Váckisújfalu	2185	010100000062DA37F7575933401AC80E852ADA4740	0
284	Iklad	2181	010100000064D64114827133400716760767D44740	0
285	Vácegres	2184	01010000008109DCBA9B5D33408E7747C66AD64740	0
286	Szada	2111	0101000000B0B95972CB4F3340F5ADC55D73D14740	0
287	Domony	2182	010100000034B275BA3D703340B13ACD5DA6D34740	0
288	Aszód	2170	010100000096FF35C58879334038ADCA749ED34740	0
289	Hatvan	3000	0101000000A0D513A7A4AC3340E19E42098ED54740	0
290	Bonyhád	7150	0101000000BD395CAB3D8832406F3777AA32264740	0
291	Báta	7149	01010000000AD2318C60C632403BCA1C2675104740	0
292	Kisoroszi	2024	010100000098F6CDFDD5013340C746C5A464E74740	0
293	Rád	2613	0101000000928C41CCCA3733409886E12362E54740	0
294	Penc	2614	01010000005B2B35D65940334050FB52E4B5E64740	0
295	Keszeg	2616	0101000000AB984A3FE13C3340A435069D10EB4740	0
296	Kosd	2612	0101000000E0C03F00042D33403B5684F645E74740	0
297	Galgagyörk	2681	01010000009EE85F3711603340D888BBD5CEDE4740	0
298	Püspökhatvan	2682	0101000000DEF7B9EBB65D334041D47D0052E34740	0
299	Acsa	2683	01010000009D82FC6CE46233402B3D89BE71E54740	0
300	Nógrádsáp	2685	0101000000C17E3E80FB5A3340219B3F016FEB4740	0
301	Csővár	2615	01010000002A5F86B5E75233407A8EC87729E84740	0
302	Galgaguta	2686	01010000000310D2AE9D6333400A50AE8449EC4740	0
303	Bercel	2687	010100000008CE740A4D673340F180B22957EF4740	0
304	Nógrádkövesd	2691	010100000095C67949AD5F3340E010AAD4ECEF4740	0
305	Becske	2693	01010000002019BCF9576033400299428C7CF44740	0
306	Szirmabesenyő	3711	0101000000BF23CF9AC4CB3440013E2E60B8134840	0
307	Szob	2628	010100000057CEDE196DDF3240FE8172DBBEE84740	0
308	Zebegény	2627	0101000000B009C446B4E832400388CCA66DE64740	0
309	Nagymaros	2626	010100000080D18A146FF5324094E7B0B101E54740	0
310	Visegrád	2025	0101000000EC3A0AC677F832408775995077E44740	0
311	Dunabogdány	2023	0101000000BD32141C03093340F26899FB9AE54740	0
312	Szokolya	2624	01010000009F854E19490233407EF09018F3EE4740	0
313	Berkenye	2641	010100000071546EA2961233401C4DE438A6F14740	0
314	Nógrád	2642	010100000061527C7C420C3340668E401768F44740	0
315	Balassagyarmat	2660	010100000048307A13E84A334050CE064FD7094840	0
316	Ipolyszög	2660	010100000061BA5A385A3B334001F2CA9AFD064840	0
317	Szügy	2699	0101000000B0726891ED52334060CC96AC8A044840	0
318	Nógrádmarcal	2675	0101000000531564158062334031A715F07C034840	0
319	Patvarc	2668	0101000000F43BA81F2F59334028BDCA3560084840	0
320	Őrhalom	2671	0101000000325706D506693340548550EFF3094840	0
321	Hugyag	2672	0101000000AE6C7AAB096F3340FCDC75DB2A0B4840	0
322	Szécsény	3170	0101000000E9F010C64F853340E871CE3E450A4840	0
323	Kishartyán	3161	0101000000CC1CDCE742B43340C62EF603C30A4840	0
324	Salgótarján	3100	0101000000315981C6F1CC3340441A70F14B0C4840	0
325	Somoskőújfalu	3121	0101000000209BE447FCD2334004BBAB68BD144840	0
326	Gyöngyös	3200	01010000005523AAA6DAED334074345882D6E34740	0
327	Kápolna	3355	0101000000069CA564393F34408CE953D856E14740	0
328	Feldebrő	3352	010100000012DFE412A23B3440D98A47F311E84740	0
329	Aldebrő	3353	0101000000CA703C9F013B3440E55D9AC706E54740	0
330	Tófalu	3354	0101000000B0EB72A5F93C3440B186302361E34740	0
331	Vécs	3265	01010000002D12C946D62A344071C6302768E74740	0
332	Domoszló	3263	0101000000C41C4EAAC71D3440012D0208C4E94740	0
333	Verpelét	3351	010100000062646E63583A34401F3AF361ACEC4740	0
334	Markaz	3262	010100000033A5F5B7040E34400707205AD0E94740	0
335	Abasár	3261	0101000000001DE6CB0B003440C567FC0CB9E54740	0
336	Ipolytarnóc	3138	0101000000F200BB3F83A0334024FBD63D681E4840	0
337	Emőd	3432	0101000000AEB4311B09D13440EE9AEB8F8BF74740	0
338	Nyékládháza	3433	0101000000960BF038A0D434403B5A304C01FF4740	0
339	Mályi	3434	0101000000D66B1F97DDD23440E534FA87E3014840	0
340	Felsőzsolca	3561	01010000008485EEEDF1DB34403F81C17F040E4840	0
341	Zamárdi	8621	010100000060408A952CF23140D6308D70A4704740	0
342	Szántód	8622	01010000009FA97C748FE73140A61AACEE476F4740	0
343	Kőröshegy	8617	0101000000AD0DBA298AE6314030952309676A4740	0
344	Balatonendréd	8613	01010000009A76D61302FA3140488D64EA096B4740	0
345	Balatonföldvár	8623	010100000042D36DE415E13140D6F14EF4AF6C4740	0
346	Balatonszemes	8636	010100000087E2E9F06BC73140E9995E622C674740	0
347	Balatonőszöd	8637	0101000000010BAA57DBCC3140FECF06054A674740	0
348	Balatonlelle	8638	0101000000017B96314FB23140689F7D9BB4644740	0
349	Balatonboglár	8630	0101000000DE5C5727C2A73140691206AFA7634740	0
350	Látrány	8681	0101000000C8E3B3869CBE3140845C4EAECE5F4740	0
351	Visz	8681	010100000058F1FC5877C831402D32F092EE5C4740	0
352	Ordacsehi	8635	01010000003BC9B150C69F31406592EC6C235F4740	0
353	Fonyód	8640	0101000000CD751A69A98C314013DCA392955F4740	0
354	Balatonfenyves	8646	010100000058D81D9C997E3140B3DDF3B2DC5B4740	0
355	Balatonmáriafürdő	8647	010100000041A66BDC51683140864E1949CC594740	0
356	Balatonberény	8649	0101000000EC72A5F9BE513140E4688EACFC5A4740	0
357	Balatonszentgyörgy	8710	0101000000CDB85FF4CB4C314046F762DE99584740	0
358	Balatonújlak	8712	0101000000F8C3CF7F0F6231401B74F85A86564740	0
359	Balatonkeresztúr	8648	01010000008701A667D55E3140F7D84C744C594740	0
360	Kéthely	8713	010100000093FC885FB1643140492AF812CF524740	0
361	Marcali	8700	01010000005F2283818C69314043160E29AB4A4740	0
362	Tapsony	8718	010100000030890EDCDC5531400BC567FC0C3A4740	0
363	Somogyszob	7563	0101000000858E67E1FC4B31403B01A83D80254740	0
364	Ötvöskónyi	7511	01010000002EBB719C255C314013FD906DCF244740	0
365	Nagyatád	7500	0101000000F3846FAB6A5B3140BD8DCD8E541D4740	0
366	Gyenesdiás	8315	01010000009C05909037493140E60C20D7E1624740	0
367	Vonyarcvashegy	8314	01010000001B50CAFF3F4F31409BAC510FD1614740	0
368	Balatongyörök	8313	010100000036374B6EB95931401A0923AC7C614740	0
369	Balatonederics	8312	01010000003E9E4C929D61314003F3EBE291674740	0
370	Szigliget	8264	01010000000EF62686E46E31404E6A1E7695664740	0
371	Badacsonytomaj	8258	0101000000EA7AA2EBC2833140F993426A24674740	0
372	Ábrahámhegy	8256	010100000055AD3BCC4D923140C82CD6CB4A684740	0
373	Balatonrendes	8255	01010000009A1139D8F6953140F579D67FE7694740	0
374	Révfülöp	8253	0101000000E1FC97B55EA13140A4E4D539066A4740	0
375	Balatonszepezd	8252	01010000008DFEE1F8EBA93140736E6EA7086D4740	0
376	Csopak	8229	0101000000FED2A23EC9ED3140CF7E49CF997C4740	0
377	Alsóörs	8226	01010000008A5A9A5B21FA3140951E97827F7E4740	0
378	Balatonalmádi	8220	01010000005EFD8E97240532408527F4FA93844740	0
379	Balatonfűzfő	8175	01010000003DB1F3DB7C0A32400E5BC4C1EF874740	0
380	Balatonkenese	8174	0101000000E28222CCA31B3240038B0D277A844740	0
381	Balatonvilágos	8171	010100000081CB63CDC82832406A172E066A7B4740	0
382	Sajószentpéter	3770	0101000000372DC25E72B5344007787709F31B4840	0
383	Kazincbarcika	3700	0101000000DDFA9FB2509F3440CDDF298991204840	0
384	Heves	3360	01010000003C4ACA822E4A3440E4C0069F41CC4740	0
385	Tenk	3359	010100000028B9C32632573440AE090ED4CED34740	0
386	Erdőtelek	3358	0101000000E2A139FC7F503440316AAD1EE6D74740	0
387	Nagytálya	3398	0101000000DEAD2CD15968344084D9041896E84740	0
388	Andornaktálya	3399	010100000043DF8211A069344025FCF785FCEB4740	0
389	Edelény	3780	010100000065D35B4DE8BB344019575C1C95254840	0
390	Kereki	8618	0101000000B43A394371E931408604E7E7E1654740	0
391	Pusztaszemes	8619	010100000097523CD3F0EC31402F2BB92F0C624740	0
392	Igal	7275	0101000000CDB5C3BA4CF03140A557B9066C444740	0
393	Ráksi	7464	010100000007FB65E6B8EB314048293284AD414740	0
394	Andocs	8675	0101000000EFDAEF9AA1EC31401D0247020D534740	0
395	Magyaratád	7463	0101000000828B153598E631405E6E8B8DD43B4740	0
396	Somogyaszaló	7452	0101000000A9458EBE93CE3140A0FB7266BB3A4740	0
397	Törökbálint	2045	0101000000463AA869BCE9324084D151B3ACB74740	0
398	Verseg	2174	0101000000F29B1D04788C334010255AF278DC4740	0
399	Kartal	2173	010100000029E6C52EF6873340132C0E677ED54740	0
400	Egyházasdengeleg	3043	0101000000C9BE750F1A8F33400BFCF21318E64740	0
401	Héhalom	3041	0101000000BE778A0BF6953340D673D2FBC6E34740	0
402	Csokonyavisonta	7555	0101000000E15DD328C9713140F3A15577760A4740	0
403	Rinyaújlak	7556	01010000007A3B1D23346B314082340818020B4740	0
404	Görgeteg	7553	0101000000B3A0E69AB86F3140BA241818C3124740	0
405	Lábod	7551	0101000000F83768AF3E7431400023C385971A4740	0
406	Somogyaracs	7584	01010000000C3444BA446431405C53C5F940074740	0
407	Babócsa	7584	010100000017F2086EA45831404AEB6F09C0044740	0
408	Komlósd	7582	0101000000E0D91EBDE1623140E561A1D634024740	0
409	Péterhida	7582	0101000000A4912AE5105C314044F4103235014740	0
410	Darány	7988	01010000003476D377C8963140CC52FC299FFD4640	0
411	Szulok	7539	01010000005F4AB8EB008D3140FEA5FBEF77064740	0
412	Drávagárdony	7977	0101000000448D9D4BCC9A314003C12D69D6F84640	0
413	Kastélyosdombó	7977	01010000000C44AA83179E3140AC0727FD18FA4640	0
414	Zádor	7976	01010000006CB823F7CFA83140CBCF57DAF3FA4640	0
415	Potony	7977	01010000002052C2024EA53140BD5301F73CF74640	0
416	Lakócsa	7918	01010000003020C54A16B131403ADC589AA5F24640	0
417	Tótújfalu	7918	010100000065E1EB6B5DA431401AED026F92F34640	0
418	Szentborbás	7918	01010000002A560DC2DCA8314099034E000FF04640	0
419	Drávafok	7967	010100000076E50EF681C33140174C570B47F14640	0
420	Istvándi	7987	01010000001066C9D23D9F31403AE40BFF8E024740	0
421	Kadarkút	7530	0101000000E034D82F339D314085590D2EC21D4740	0
422	Bárdudvarnok	7478	0101000000BCD28D0B62AF3140341DF0AFD4294740	0
423	Kaposújlak	7522	01010000006359D537D5B931403CD3F0D2F22E4740	0
424	Jászdózsa	5122	0101000000F72AE8AC05043440D847A7AE7CC84740	0
425	Pilisborosjenő	2097	010100000013656F29E7FD3240DCF63DEAAFCD4740	0
426	Üröm	2096	0101000000D9E841E66F033340120DF736A2CC4740	0
427	Isaszeg	2117	0101000000C84C58D1D5663340923CD7F7E1C34740	0
428	Valkó	2114	01010000005DB4B6DF90823340E4E59FCF36C84740	0
429	Szomolya	3411	01010000001BDE077B6E7E3440789F3E5D38F24740	0
430	Tard	3416	01010000006E5974A1A89A3440AADF3B20BFEF4740	0
431	Cserépfalu	3413	0101000000E96E8DBE38893440C2323674B3F84740	0
432	Bükkzsérc	3414	0101000000418B5BBBA38134404757E9EE3AFA4740	0
433	Cserépváralja	3417	0101000000384C3448C18F344049EC246C89F74740	0
434	Noszvaj	3325	01010000007659A725B179344062314514EEF74740	0
435	Tibolddaróc	3423	0101000000F0EF7DBB36A3344072DAF8B8DBF54740	0
436	Háromfa	7585	0101000000D69CCDF45C543140322BCA5B640D4740	0
437	Mernye	7453	01010000008F667627E9D131404A35FD231D414740	0
438	Somogytúr	8683	0101000000CB8DD8DDF2C33140BCB9AE4E845A4740	0
439	Somogybabod	8684	01010000005AC63CE1DBC6314018FA714573564740	0
440	Osztopán	7444	0101000000F93DA0223DAB314084A4AA645B424740	0
441	Pamuk	8698	0101000000325B0DE434A33140490ED8D5E4464740	0
442	Somogyvár	8698	01010000008E3EE60302A73140ADC66D8F394A4740	0
443	Öreglak	8697	010100000033ADA81CEEA0314094B60254824D4740	0
444	Lengyeltóti	8693	01010000008BD69B621FA431408B76CBC463554740	0
445	Szőlősgyörök	8692	010100000053B36213F4AC31403D36B863A05A4740	0
446	Karád	8676	01010000008B0A8B40ABD631406726BD14C3584740	0
447	Somogymeggyes	8673	010100000099243BDB48EA31405FDD674B0C5C4740	0
448	Bernecebaráti	2639	01010000004A7CEE04FBE93240AA6400A8E2044840	0
449	Tésa	2636	0101000000DA11989878D73240D0B0BDBB3A044840	0
450	Vámosmikola	2635	01010000000B6AAE89BBC83240BB325EA91DFD4740	0
451	Ipolytölgyes	2633	0101000000271829EF3EC63240B3356CA521F64740	0
452	Letkés	2632	0101000000F110C64FE3C6324029649DE051F14740	0
453	Pilisszántó	2095	0101000000B5FB5580EFE232409BFCBBE3B9D54740	0
454	Zalkod	3957	0101000000017F42870A7535400BA139A1C6174840	0
455	Bodrogkeresztúr	3916	01010000001607E11B545C3540DCF4673F52144840	0
456	Timár	4466	010100000061318FA108763540BB16E3B2C0134840	0
457	Kenézlő	3955	0101000000B7FEA72C54883540A93E462F59194840	0
458	Kemence	2638	010100000093A641D13CE43240D5D40D6F31024840	0
459	Tarcal	3915	0101000000B79D110077583540C70B8E379E104840	0
460	Szegi	3918	0101000000DD723FF1AD613540251EF57C72194840	0
461	Szegilong	3918	0101000000B16D5166836635404A511D61071C4840	0
462	Bodrogkisfalud	3917	010100000011D8E610825B3540491520651F164840	0
463	Olaszliszka	3933	0101000000BB4CA83BAA6F354006A799492F1F4840	0
464	Vámosújfalu	3941	010100000057772CB649733540F250CA5AF9204840	0
465	Tolcsva	3934	01010000007CFEC57DF572354093CBDA0132244840	0
466	Hernádkak	3563	0101000000CD8A4DD0CBF73440C6D9194BFD0B4840	0
467	Hernádnémeti	3564	0101000000797F171120FA344045A6D7C11C094840	0
468	Bőcs	3574	01010000006F57F9AFBDF83440B5711F14EF044840	0
469	Berzék	3575	0101000000629C645012F534401224004922034840	0
470	Sajóhídvég	3576	010100000077F86BB246F33440BBB2B04C64004840	0
471	Köröm	3577	0101000000317491E79FF3344044C362D4B5FD4740	0
472	Girincs	3578	0101000000C3B645990DFC344000B3D6AB23FC4740	0
473	Kiscsécs	3578	01010000004098254BF70235403AF0C572A6FB4740	0
474	Kesznyéten	3579	010100000091EAE005B60B3540E271F673AFFB4740	0
475	Sajóörös	3586	0101000000838362D0AE053540C1BFAD60C0F94740	0
476	Sajószöged	3599	01010000004FDA0A5009FE34404B091C64EDF84740	0
477	Tiszalúc	3565	0101000000F360415024103540B6323C516D044840	0
478	Taktaharkány	3922	01010000002B515150E521354006B98B30450B4840	0
479	Vászoly	8245	01010000000DA25AE95AC23140C0DB72E437784740	0
480	Dörgicse	8244	01010000000E5A59EC40B93140E5A9584634754740	0
481	Szabadegyháza	2432	01010000005F888B9246B13240CF431262D3894740	0
482	Gyöngyöshalász	3212	0101000000CB0AEA002DEA334063DF0495A7DE4740	0
483	Filkeháza	3994	010100000065AFD2382F7D3540F41A16FE673F4840	0
484	Pálháza	3994	0101000000E0185D39D682354042AFE4CF5C3C4840	0
485	Telkibánya	3896	010100000075CC79C6BE5A354074EB353D283E4840	0
486	Gönc	3895	0101000000D47BCFEDCA453540E59F747D7A3C4840	0
487	Göncruszka	3894	010100000066773705E83D3540FFA380FE8C394840	0
488	Vilmány	3891	0101000000CFC76B14483B3540C3B414353D354840	0
489	Fony	3893	0101000000808EA042BF48354017B5A09C0D324840	0
490	Korlát	3886	010100000068757286E23E35408E249C7175304840	0
491	Hernádcéce	3887	0101000000B1D2EEA18E32354008228B34F12D4840	0
492	Boldogkőváralja	3885	0101000000E626C522E13C35402707FD964A2B4840	0
493	Mogyoróska	3893	0101000000E272BC02D153354029D9A0E52F304840	0
494	Regéc	3893	0101000000D520CCED5E5835402A0EB10B50324840	0
495	Hejce	3892	0101000000845F8F2EDB47354082E8A45247364840	0
496	Seregélyes	8111	0101000000F2EF332E1C943240BD564277498E4740	0
497	Zichyújfalu	8112	0101000000DE9623BFD9AB32402146BE011C904740	0
498	Sárosd	2433	0101000000013C58B55AA632405E15037F53854740	0
499	Perkáta	2431	01010000003CCC4D8A45CA3240BE4D7FF623864740	0
500	Kulcs	2458	01010000000249D8B793EA3240069C4AABC6864740	0
501	Rácalmás	2459	010100000069B812CB77F032402AF40BC050834740	0
502	Adony	2457	010100000083EF479BF4DC3240FDCDD5A0798F4740	0
503	Pusztaszabolcs	2490	0101000000132631ADF2C132403ABA00EABC914740	0
504	Besnyő	2456	0101000000654A35FD23CB324069A1AEFF84984740	0
505	Beloiannisz	2455	0101000000FC7BDFAE4DD3324001BD152E50974740	0
506	Iváncsa	2454	0101000000B213B93BC6D43240D11044CCDB924740	0
507	Baracska	2471	0101000000466BFB0DC9C13240A15E3AF768A44740	0
508	Szentmártonkáta	2254	01010000006F6AFBB20FB13340384481E3D7B84740	0
509	Kunhegyes	5340	010100000068A8F68EBFA13440EAFFC12C59AF4740	0
510	Tiszaigar	5361	01010000007A4A73D0CACC3440AF473C3487C44740	0
511	Nagyiván	5363	0101000000FD84B35BCBEE3440D93D1E9F35BE4740	0
512	Lovasberény	8093	01010000001129BCBA199032409CFA40F2CEA64740	0
513	Pátka	8092	01010000003969D086B27C324069E624EF77A34740	0
514	Csákvár	8083	01010000003E40F7E5CC7632407BF65CA626B24740	0
515	Pázmánd	2476	0101000000CA68893A18A83240F6D214014EA44740	0
516	Vereb	2477	01010000009188DF032A9E32409574DE10F4A84740	0
517	Nadap	8097	0101000000971FB8CA139E3240508A56EE05A14740	0
518	Vál	2473	01010000006AC82E0730AD324070B8EA950DAF4740	0
519	Kajászó	2472	0101000000A13836F1C4B83240BC53A63DCAA94740	0
520	Vértesacsa	8089	010100000061DD787764943240B102D770ECAF4740	0
521	Alcsútdoboz	8087	0101000000E07A5E3B629A32405895D81077B64740	0
522	Felcsút	8086	010100000020A79EBB13963240003219332EBA4740	0
523	Tabajd	8088	0101000000C579933A5CA032405CD6B3D606B44740	0
524	Etyek	2091	01010000005C3E92921EC032400D0DD5DEF1B84740	0
525	Gánt	8082	01010000004E092D90456332408B6EBDA607B24740	0
526	Mór	8060	0101000000579819918335324091DE26929EAF4740	0
527	Zámoly	8081	0101000000A46BCB25FA6932402244E856BEA84740	0
528	Csókakő	8074	01010000009A6B8775994632403851A62C9EAD4740	0
529	Csákberény	8073	010100000002976CE11E54324004A9B981A7AC4740	0
530	Vértesboglár	8085	010100000095DD825B2D8632404B372E88EDB64740	0
531	Bodmér	8080	01010000007A8D5DA27A8932403C1F5498ADB94740	0
532	Szár	2066	01010000002EF8D96DBC843240A5B84F3349BD4740	0
533	Polgárdi	8154	01010000003C9A8F108A4E32407E48090B38874740	0
534	Pápa	8500	01010000004D4FB39B7478314075B80CEEBDA94740	0
535	Körmend	9900	0101000000B2D7BB3FDE993040CC24EA059F814740	0
536	Ják	9798	0101000000268DD13AAA9430401711C5E40D924740	0
537	Egyházasrádóc	9783	01010000004C9BBBA7BC9D3040D2FF722D5A8B4740	0
538	Felsőszölnök	9985	01010000006EFEBA2E572A30400E55E70764704740	0
539	Hajdúszoboszló	4200	0101000000292504ABEA633540F5335074B8B84740	0
540	Kaba	4183	010100000085F70B2C364635405F9F94A4C6AD4740	0
541	Püspökladány	4150	010100000056C73BD1BF1C35401279DC01E8A84740	0
542	Mezőtúr	5400	01010000009B92077D44A134407B46C77A0F804740	0
543	Mezőberény	5650	010100000007054AAF720735401B71B7DA79694740	0
544	Szabadbattyán	8151	01010000003478A922265E324050317326128F4740	0
545	Kőszárhegy	8152	010100000099F5BDE199573240FF06EDD5C78B4740	0
546	Tác	8121	01010000000FFC5EF9E26732403E5695229E8A4740	0
547	Kisvárda	4600	0101000000D8B221A413143640492245AEE51C4840	0
548	Ózd	3600	01010000008703D7CBA54B3440E527D53E1D1C4840	0
549	Diósjenő	2643	01010000001DCFC2F92F0B33403777AA3242F84740	0
550	Tét	9100	010100000019E2FD5D448431404EA6C0B80AC24740	0
551	Győrszemere	9121	0101000000910BCEE0EF8F314001EB820BC3C64740	0
552	Zimány	7471	010100000032981AFC58E83140DF0F898C58364740	0
553	Orci	7461	01010000000F45813E91DF31404CDCCFCE0E344740	0
554	Rinyaújnép	7584	01010000006774513E4E5A3140CE7EEE15270A4740	0
555	Bakháza	7585	01010000006B1217DBFF5B3140139040CDDA0D4740	0
556	Rinyaszentkirály	7513	0101000000387C77D0916331408BBC51D092134740	0
557	Tarany	7514	0101000000767C6AAB484D314024D0059A74174740	0
558	Bolhó	7586	0101000000CB7AD6DAA04B31401CC5837703054740	0
559	Heresznye	7587	010100000073E26190AA463140C81462E41B074740	0
560	Vízvár	7588	0101000000A1945A39C53A314094298B67750B4740	0
561	Bélavár	7589	0101000000C2734A9B05373140C0594A96930F4740	0
562	Somogyudvarhely	7515	01010000008C039E6AE33031409857642AB3164740	0
563	Berzence	7516	0101000000CF13CFD902263140358B61985D1A4740	0
564	Csurgó	8840	0101000000FD42D9A5571831400B7668FDD2214740	0
565	Dunavecse	6087	0101000000690A534ABEF8324021167B794B754740	0
566	Dúzs	7224	0101000000CC14298359613240126BF129003F4740	0
567	Döbrököz	7228	0101000000EB6F09C03F3D324010B1C1C249364740	0
568	Dombóvár	7200	0101000000917F66101F223240E158BCFD5E304740	0
569	Attala	7252	0101000000B27ED877EA103240030BBB8333304740	0
570	Csoma	7253	01010000006C7DEC89090D32402754CB31B42F4740	0
571	Szabadi	7253	0101000000539DC4D622083240CD49DEEF062F4740	0
572	Nagyberki	7255	01010000000D94CACAE5013240AF20729FC12D4740	0
573	Mosdós	7257	01010000001DE38A8BA3FC3140333674B33F2D4740	0
574	Baté	7258	010100000010C935AA78F63140FBC9BD65F32D4740	0
575	Taszár	7261	01010000001F57D92DB8E73140F3339A01D32F4740	0
576	Kaposfő	7523	01010000003299E08A7AAB3140064C3B90502E4740	0
577	Kiskorpád	7524	0101000000550ACBE9FC9B31401A3D6D437B2E4740	0
578	Nagybajom	7561	0101000000CB90195EFF823140D989DC1D63324740	0
579	Böhönye	8719	0101000000A724462AE7623140F1A77CBE1C344740	0
580	Vése	8721	0101000000AD3594DA8B4A3140373D83E1B7344740	0
581	Nemesdéd	8722	0101000000EC45FEAA6D3E31406A0CDF6701374740	0
582	Nemesvid	8738	01010000009DD843FB583F3140F66A3645363E4740	0
583	Somogysimonyi	8737	01010000006933F389E135314050502F9D7B3E4740	0
584	Zalakomár	8751	0101000000CEF0B09AF82C3140218436EFEE454740	0
585	Zalakaros	8749	01010000008F9C9669451F31401749BBD1C7474740	0
586	Garabonc	8747	01010000002CEC0ECE4C1F31407E6E0D11DC4A4740	0
587	Nagyrada	8746	010100000009D4AC7D4B1E3140B573F5BE4C4F4740	0
588	Zalaszabar	8743	01010000000BDA3FAABC1C3140704221020E524740	0
589	Orosztony	8744	010100000018288469730F3140C8073D9B55504740	0
590	Kerecseny	8745	0101000000790CEAB69F0B3140DB5438DD0D504740	0
591	Kilimán	8774	0101000000D397EF2AB5FE3040B95164ADA1514740	0
592	Alsórajk	8767	010100000064D7ACE930FF30400DB55CECAC534740	0
593	Felsőrajk	8767	01010000001212691B7FFC30406EB2FCAF29574740	0
594	Pötréte	8767	0101000000B9D7930A74F33040F439D274D1564740	0
595	Hahót	8771	01010000003A47D38F3CEC3040D535A49B0E534740	0
596	Szigetcsép	2317	0101000000A97C19D69EF73240B71787E931A24740	0
597	Szigetújfalu	2319	010100000004FE953A6DEC3240F0D302C5D99D4740	0
598	Kunszentmiklós	6090	0101000000BC07E8BE9C1F3340E6176F754A834740	0
599	Apostag	6088	01010000009A8EA5B4A3F73240EDED3B2B0E714740	0
600	Dunaföldvár	7020	0101000000F2DBC6551BEC3240E1D05B3CBC674740	0
601	Nagyvenyim	2421	0101000000E9899DDFE6DB324009B254CD627A4740	0
602	Mezőszilas	7017	010100000082CD943199793240B6323C516D684740	0
603	Mezőfalva	2422	01010000006EC2BD326FC73240BF8E49905B774740	0
604	Halásztelek	2314	01010000004FA786472CFB3240CD0182397AAE4740	0
605	Szigethalom	2315	0101000000ACD6D3580C0033409CEA7F6F89A94740	0
606	Dunavarsány	2336	0101000000529E7939EC103340CD64EE10B5A34740	0
607	Délegyháza	2337	0101000000BFB513252111334019AE0E80B89F4740	0
608	Szigetbecse	2321	01010000006142BBF9FCF2324020A5C810B6904740	0
609	Makád	2322	0101000000EE75F7A523ED3240D66542DD518B4740	0
610	Szigetszentmiklós	2310	010100000010C935AA780A3340FC8C0B0742AC4740	0
611	Dunaharaszti	2330	01010000002AA4A1EB6718334026AC8DB113AE4740	0
612	Taksony	2335	0101000000C819D4C8F80F3340B7F2EDB83CAA4740	0
613	Gyál	2360	01010000007834C467A13733404EAAC7C738B14740	0
614	Újireg	7095	01010000004B1DE4F5602C324076C993FF24544740	0
615	Iregszemcse	7095	01010000000C941458002F324009693288B4584740	0
616	Nagykónyi	7092	0101000000E002BFFC043432406E7BCC51914B4740	0
617	Koppányszántó	7094	0101000000214322C89C1C3240EAA97A9EE44B4740	0
618	Értény	7093	010100000092A34ADE4A223240E0E9DF3F274E4740	0
619	Törökkoppány	7285	0101000000F9331713F60C324009032A77FA4C4740	0
620	Szorosad	7285	0101000000EB5F483DFA053240A2BB7F87FD4C4740	0
621	Somogydöröcske	7284	01010000006EDA311A9E01324050B3F62D294B4740	0
622	Somogyacsa	7283	0101000000BB2473D135F431408E65B098C74B4740	0
623	Tamási	7090	01010000000AC7E2EDF748324051966B1B90504740	0
624	Kéty	7174	01010000006F1283C0CA853240D2A68F6566384740	0
625	Zomba	7173	0101000000A57FEE70E0903240D7F1046795344740	0
626	Kisdorog	7159	01010000001F88878B377F3240D238D4EFC2314740	0
627	Harc	7172	010100000095E87640239E3240A23A675595334740	0
628	Bonyhádvarasd	7158	0101000000C92DF713DF7A3240543DF438672F4740	0
629	Murga	7176	0101000000F4E967A0E87C3240D3C155F9F93A4740	0
630	Szatta	9938	01010000001F1FE340FE7A304008C5FB1642664740	0
631	Becsvölgye	8985	0101000000D6B9B3C068AE30404D535FF12F614740	0
632	Szilvágy	8986	0101000000FCB1FFF0A9A030407E2FCF94E75D4740	0
633	Pórszombat	8986	010100000094298B6775933040678EF6894D5D4740	0
634	Csesztreg	8973	0101000000D57954FCDF833040CE1143BCBF5B4740	0
635	Kerkafalva	8973	0101000000A2BF86962B7C3040A58BA8E4F7624740	0
636	Nagyrákos	9938	0101000000F9C89C1D5F75304044B1CBA6126A4740	0
637	Pankasz	9937	01010000007D433C6DE87F30409361CBE1496B4740	0
638	Felsőjánosfa	9934	0101000000BF3CAE57A28D3040EA8FD552E56B4740	0
639	Zalalövő	8999	010100000012AFA18AD19530402437D439506C4740	0
640	Zalacséb	8996	010100000047EE44A401A9304056CDBDD1D86D4740	0
641	Zalaszentgyörgy	8994	01010000004141CEA046B430405CA6CB07A96F4740	0
642	Kávás	8994	01010000001C188A856BB53040EC53E982556E4740	0
643	Boncodfölde	8992	0101000000EF6F75A50ABD3040A656A9EA2F6F4740	0
644	Teskánd	8991	0101000000FDD0162186C730403E35A847646D4740	0
645	Gellénháza	8981	010100000097F782609FC83040AFF83C354D614740	0
646	Sárhida	8944	0101000000DB526232B0D730405BCD3AE3FB604740	0
647	Bak	8945	0101000000BD12921678D83040394B242C855D4740	0
648	Aba	8127	0101000000EE9AEB8F8B85324004BBAB68BD834740	0
649	Sárbogárd	7000	0101000000374B6EB99F9E3240E8E0F48997714740	0
650	Sárkeresztúr	8125	0101000000F3D4D97F538C32403A1966B2C9804740	0
651	Káloz	8124	0101000000D90528B27B7B3240CB72C8BC447A4740	0
652	Sárszentágota	8126	0101000000783F13060A913240760360973C7C4740	0
653	Németfalu	8918	01010000008CAE1C6B90AF3040D3E98A636E684740	0
654	Salomvár	8995	0101000000612DE34B4DA930401F9D5F39E76C4740	0
655	Nagylengyel	8983	01010000006F8676A96CC33040BC24CE8AA8634740	0
656	Babosdöbréte	8983	01010000008B46883C93C73040694C2D0032684740	0
657	Dobronhegy	8989	0101000000BA449A1D4EBF3040975E51007B684740	0
658	Milejszeg	8917	010100000042AACDA4F2BD3040E17B7F83F6644740	0
659	Gombosszeg	8984	0101000000A81721E120B8304024E0C61CBA604740	0
660	Csonkahegyhát	8918	01010000004E40B8A750B83040C6F99B5088664740	0
661	Kustánszeg	8919	0101000000B24B546F0DAE30404A404CC285644740	0
662	Őriszentpéter	9941	0101000000A46318C1106B30404E379A6DB86B4740	0
663	Szalafő	9942	010100000037A1B547145D304087889B53C96E4740	0
664	Nagykapornak	8935	010100000018C7928323FE304083723678BA684740	0
665	Ligetfalva	8782	01010000003E5B07077B0F3140939B977961694740	0
666	Zalacsány	8782	0101000000272EC72B10193140F943D8953B674740	0
667	Ikrény	9141	01010000001C3E8E8B0F863140C209963490D34740	0
668	Szilsárkány	9312	01010000006557B5FF5C413140BFE7D19EDCC44740	0
669	Szil	9326	0101000000218491A8613B31403DFA15212BC04740	0
670	Rábasebes	9327	0101000000F9C73148B03D3140FF9600FC53B84740	0
671	Vág	9327	01010000008B016D06133631407AD33E671CB94740	0
672	Szany	9317	01010000006045FC79094E314039888CFD1BBB4740	0
673	Csorna	9300	01010000001F300F99F23F3140DA2E7E6484CE4740	0
674	Kóny	9144	0101000000DAB91FA6335C314085C7235DD8D04740	0
675	Enese	9143	010100000041A7D6B1006C3140AB764D486BD24740	0
676	Dág	2522	0101000000D4E3086355B832407F6EC383C1D44740	0
677	Abda	9151	0101000000FB31F7DA7D8A3140D80121A34DD94740	0
678	Börcs	9152	0101000000AC1919E42E803140008BA141AFD74740	0
679	Öttevény	9153	010100000081311125107D3140C7F5EFFACCDC4740	0
680	Vámosszabadi	9061	01010000001B52FB6310A63140B1A0D56E60E04740	0
681	Győrújfalu	9171	0101000000A5396865B19B31403646A11B50DC4740	0
682	Győrzámoly	9172	0101000000A10F3BF82E94314065767176C6DE4740	0
683	Győrladamér	9173	0101000000B72000DD3C903140E9A3E77173E04740	0
684	Dunaszeg	9174	0101000000AEEFC341428A31403A7F6EC383E24740	0
685	Ásványráró	9177	01010000001CD36E4FEB7F314005F291393BEA4740	0
686	Hédervár	9178	01010000004CF443B63D75314023884E2A75EA4740	0
687	Lipót	9233	0101000000A2D3F36E2C763140A38FF98040EE4740	0
688	Darnózseli	9232	01010000005D20F763496D3140184740E0DCEC4740	0
689	Halászi	9228	01010000007E4056A64E543140FAD577D90AF24740	0
690	Mosonmagyaróvár	9200	01010000004CDAF923B1453140A785DC56C4EF4740	0
691	Máriakálnok	9231	01010000007FAC962A075331400C79043752EE4740	0
692	Mórichida	9131	0101000000700BF1A3756B31403D4272D7B7C14740	0
693	Árpás	9132	01010000008F1436A8A265314033ABD27190C14740	0
694	Egyed	9314	0101000000899EEF02805631408E65B098C7C24740	0
695	Rábacsanak	9313	0101000000C948AC7B1A4A3140CCA6125443C34740	0
696	Rábaszentandrás	9316	0101000000315F5E807D543140F1A6B62FFBBA4740	0
697	Kemenesszentpéter	8518	0101000000CDDAB7A4B43A3140B1B90FE5B0B64740	0
698	Pápoc	9515	0101000000718DCF64FF203140BDEFCE90E0B44740	0
699	Dunasziget	9226	01010000008436EFEEB75A31404B18721184F84740	0
700	Koroncó	9113	01010000001EE9C2FEA1873140B76FFFDB76CC4740	0
701	Rábapatona	9142	01010000000882B68B1F7B3140F3C011EEDFD04740	0
702	Bágyogszovát	9145	0101000000AD832804175E3140D6F14EF4AFCA4740	0
703	Dör	9147	0101000000A482D4377A4C3140723DC04989CC4740	0
704	Barbacs	9169	010100000030D1C54BDC4B314093D96A20A7D24740	0
705	Bősárkány	9167	010100000027F33405D73F3140E0AEA8D260D84740	0
706	Jánossomorja	9241	0101000000C26DC89AEC2231402397491E99E44740	0
707	Levél	9221	01010000004255F1EB2C333140A13E13AB50F24740	0
708	Városlőd	8445	01010000006064B8F072A731400AB7216BB2924740	0
709	Takácsi	8541	01010000001D37A1B547783140D3E5835440B34740	0
710	Gyarmat	9126	0101000000F5865682207D31402992AF0452BB4740	0
711	Csikvánd	9127	01010000000ADEEBFF777331400C4746BD96BB4740	0
712	Tényő	9111	0101000000B29A536E47A53140E5A9584634C54740	0
713	Écs	9083	0101000000086E49B31EB731407596B43DD5C74740	0
714	Pannonhalma	9090	01010000006831C22511C13140E65AB4006DC64740	0
715	Nyúl	9082	01010000000A760D4460B03140706A566C82CB4740	0
716	Nagyszentjános	9072	01010000003F259D3704DF31403B53E8BCC6DA4740	0
717	Bábolna	2943	01010000006391CB248FFA3140685A626534D24740	0
718	Bana	2944	0101000000FDDE01F96DEB3140316C83C943D34740	0
719	Csömend	8700	010100000011BF0754A47D31409697FC4FFE484740	0
720	Nikla	8706	0101000000FE4A427D26843140DC92663DC6494740	0
721	Pusztakovácsi	8707	0101000000D92D5D1CF09231409D6E8F94E3434740	0
722	Somogyfajsz	8708	01010000004DE8E4FB9891314015F2F7414C404740	0
723	Bodrog	7439	010100000007D0EFFB37A731404897EDF9503E4740	0
724	Csombárd	7432	0101000000FF44C07C0DAC3140473B6EF8DD394740	0
725	Juta	7431	0101000000DC9035D9F5BB3140F797384DFA334740	0
726	Tengelic	7054	010100000033F8A00CFAB53240065960D916444740	0
727	Szedres	7056	010100000063E6A7DD54AF32401EC76A4EB93C4740	0
728	Dunakiliti	9225	0101000000575AEB30CB493140268DD13AAAFB4740	0
729	Pálfa	7042	0101000000250E8FB39F9D32401E17D522A25B4740	0
730	Szárazd	7063	010100000029E78BBD176D3240239F573CF5484740	0
731	Aparhant	7186	0101000000CAA9F81ADD72324005BB0622302A4740	0
732	Izmény	7353	0101000000E906AF02216A3240689027EE1D284740	0
733	Szárász	7188	01010000008E12AA8A5F5F32407BDF5394A62C4740	0
734	Hegyhátmaróc	7348	01010000002CA688C21D5632404342EFE8DA274740	0
735	Alsómocsolád	7345	01010000008A4F4BBDB83E3240209331E312284740	0
736	Ág	7381	010100000019726C3D433432401B907351E3254740	0
737	Tarrós	7362	010100000025123B095B24324070F7281202244740	0
738	Gerényes	7362	010100000050B7FD3C572F3240C4639A4418274740	0
739	Sásd	7370	01010000007C11C880471B324043DA102DC3204740	0
740	Felsőegerszeg	7370	01010000004531D4BC3E223240A84D41237D204740	0
741	Varga	7370	0101000000098E26721C2532405FD218ADA31F4740	0
742	Kisbajcs	9062	0101000000149C55FA64AE3140559F50F465DF4740	0
743	Nagybajcs	9063	01010000001A59E839D8AF3140A2DA96B7D9E14740	0
744	Mosonszentmiklós	9154	0101000000688302A5576D314048043E9A45DD4740	0
745	Kimle	9181	01010000008187B36CF75E31405DDE1CAED5E94740	0
746	Farád	9321	01010000001C6ACA04B2333140C32CB4739ACD4740	0
747	Rábatamási	9322	010100000079ACBE5F712B3140F8E7FDDA55CB4740	0
748	Jobaháza	9323	0101000000DA4F6B3FBE2F314076AE83DE76CA4740	0
749	Lébény	9155	01010000004DF96B0D00643140E7B287AC24DE4740	0
750	Babót	9351	0101000000CF5D5CF45F133140B2F6D26FBAC94740	0
751	Veszkény	9352	0101000000FB1175D5F2153140A58DD948C8CC4740	0
752	Agyagosszergény	9441	01010000000A59CCBEE1F030402672C119FCCD4740	0
753	Szárföld	9353	0101000000FC766DCA701F314020370D9B12CC4740	0
754	Tékes	7381	01010000001D0B653CA52C3240E36C3A02B8244740	0
755	Kisvaszar	7381	0101000000FE45D098493632400E54217942234740	0
756	Liget	7331	010100000021730A97FA303240B9742733391E4740	0
757	Bodolyabér	7394	0101000000DDE9735A5C1E3240E7B0564854194740	0
758	Magyarszék	7396	0101000000131C4DE438323240E7278BB102194740	0
759	Kapuvár	9330	010100000031372916090731404EFFA380FECB4740	0
760	Szászvár	7349	0101000000FCC973D8D8603240DE5E2DD21F234740	0
761	Máza	7351	010100000051CC8B5DEC653240C5B6FB0BF3224740	0
762	Magyaregregy	7332	010100000040C3F6EEEA4E3240CBBFF11021204740	0
763	Nagycenk	9485	0101000000CC800E4E9FB2304058BCA2A53CCD4740	0
764	Pereszteg	9484	0101000000564B958334BC3040329303D1EECB4740	0
765	Fertőendréd	9442	01010000002D793C2D3FE83040DF7D9FBB6ECD4740	0
766	Petőháza	9443	0101000000AC787EAC3BE530409477C4D78DCC4740	0
767	Fertőszentmiklós	9444	010100000049A2F20A9FE0304026A8E15B58CB4740	0
768	Fertőd	9431	0101000000EC39443756DD3040A91DB40D92CF4740	0
769	Sarród	9435	010100000075F8B53F61DC3040AB0DA9FD31D14740	0
770	Röjtökmuzsaj	9451	0101000000D8E4DF1DCFD5304088C7348930C74740	0
771	Nagylózs	9482	0101000000E30D7A8038C530403862D28492C84740	0
772	Pinnye	9481	0101000000B994A938C4C43040AB1ED55526CB4740	0
773	Sopronkövesd	9483	0101000000963C43DDACBE3040A18BE145BAC54740	0
774	Fertőrákos	9421	0101000000AB49A6F919A730408A0453CDACDB4740	0
775	Hidegség	9491	0101000000CED20440CBBD3040627F7E8406D04740	0
776	Hegykő	9437	010100000099524DFF48CB3040312999F793CF4740	0
777	Markotabödöge	9164	0101000000C85EEFFE784F3140EF20D15F43D74740	0
778	Rábcakapi	9165	01010000006C3B12D495463140AAA8B008B4DA4740	0
779	Fehértó	9163	010100000061399DBF645831403B1856968DD64740	0
780	Győrsövényház	9161	0101000000294CCE3FB05F3140CF12640454D84740	0
781	Bezi	9162	01010000002E6123FF826331405E46562360D64740	0
782	Feketeerdő	9211	01010000002F8100BE804731403D659016C2F74740	0
783	Mosonszolnok	9245	01010000003DEBBF73942C3140D4B1EF2F27ED4740	0
784	Újrónafő	9244	01010000002D59BA27B4333140ADCC4A49C5E74740	0
785	Tárnokréti	9165	01010000000D118134AD4E3140EBC6BB2363DC4740	0
786	Bőny	9073	010100000051C13CBF83DE31401357DF0A72D34740	0
787	Töltéstava	9086	01010000005D972BCDF7BB3140C29437763FD04740	0
788	Pér	9099	0101000000689E12C605CC314015B3B9C557CE4740	0
789	Mezőörs	9097	0101000000EC6987BF26E1314045793073CBC84740	0
790	Rétalap	9074	010100000002959636C1E831401F7EA3C27DCD4740	0
791	Csém	2949	01010000005B90D21165163240F72004E44BD74740	0
792	Mocsa	2911	0101000000ACC77DAB752E32401A27CF06AAD54740	0
793	Almásfüzitő	2931	01010000005CC64D0D344332409128B4ACFBDC4740	0
794	Tatabánya	2800	0101000000FCCCB458E56532408F0C8343B9CA4740	0
795	Sopronnémeti	9325	010100000013831B841435314062D9CC21A9C44740	0
796	Magyarkeresztúr	9346	010100000030D461855B2A314034C97ECCBDC24740	0
797	Zsebeháza	9346	0101000000721D3E44FE3031402F08F6A974C14740	0
798	Bogyoszló	9324	01010000005840FC57B12F3140DE44E33F93C74740	0
799	Potyond	9324	0101000000D9E49590B42E3140799DC36B4DC64740	0
800	Pásztori	9311	0101000000D60341DBC5453140E7B0564854C74740	0
801	Rábapordány	9146	0101000000F2C7FEC3A7523140D53CEC2A49C74740	0
802	Mérges	9136	0101000000A30804954C71314064DF5F4E1ACD4740	0
803	Rábacsécsény	9136	01010000007C31EFCC5F6C3140ED951EF23BCB4740	0
804	Rábaszentmihály	9135	0101000000BF60DCB2E86E3140B94B87F315CA4740	0
805	Bodonhely	9134	0101000000ACAF09C446683140A8493A144FC84740	0
806	Kisbabot	9133	01010000007612B644D36A314045C9F50027C74740	0
807	Rábaszentmiklós	9133	0101000000F92F1004C86A314096B61380DAC44740	0
808	Gyömöre	9124	0101000000083A5AD592903140652D4F3118C04740	0
809	Felpéc	9122	0101000000F1EA6690CC9831404DD2A1783AC34740	0
810	Kajárpéc	9123	0101000000312999F793A03140C866A26362BF4740	0
811	Szerecseny	9125	01010000003A3A538D038E31409CB11EAD20BB4740	0
812	Sokorópátka	9112	0101000000EFB6C13F5BB33140645DDC4603BE4740	0
813	Ravazd	9091	0101000000C444DECDAEC0314024EB15BB22C24740	0
814	Pázmándfalu	9085	0101000000862EF2FCB3C83140F3B51D09EAC84740	0
815	Győrság	9084	0101000000761C9A0D8DC0314030945D7A45CA4740	0
816	Nyalka	9096	010100000069F1738DE0CE3140696BE9769BC54740	0
817	Táp	9095	01010000005F3C28CD8BD431404F90D8EE1EC24740	0
818	Tápszentmiklós	9094	01010000001270630EDDD93140D316D7F84CBF4740	0
819	Tarjánpuszta	9092	0101000000F188658E40C9314083F92B64AEC04740	0
820	Győrasszonyfa	9093	010100000099ABD50DCACE3140F144B52D6FBF4740	0
821	Veszprémvarsány	8438	010100000054A3FC4921D5314099C6E52E78B64740	0
822	Bakonypéterd	9088	01010000001A8057152BCC3140EA4EC12B93BB4740	0
823	Románd	8434	010100000027005A4E9DCA3140592437D439B94740	0
824	Lázi	9089	01010000000E97660465D6314096CBEB2D8ABB4740	0
825	Sikátor	8439	0101000000F893E7B0B1D931402EC0E38002B84740	0
826	Bakonygyirót	8433	0101000000EE38EA8DFFCD3140483FD0C07EB54740	0
827	Bakonyszentlászló	8431	01010000001EF34B0EE9CD31401C4FBAE303B24740	0
828	Fenyőfő	8432	01010000003A0D07F824C43140A2B77878CFAC4740	0
829	Győrújbarát	9081	0101000000BD01C177F6A2314034F0486183CE4740	0
830	Sobor	9315	010100000005977D0D775E314002A4912AE5BC4740	0
831	Páli	9345	0101000000BFE83C748B2A31405F9F94A4C6BC4740	0
832	Kisfalud	9341	0101000000C67B1F589F1631409015FC36C4C34740	0
833	Mihályi	9342	0101000000C90D750E54183140C2D5A65604C24740	0
834	Vadosfa	9346	0101000000CCD24ECDE520314033203130E1BF4740	0
835	Beled	9343	0101000000BD7ACB8B02173140DFE00B93A9BB4740	0
836	Edve	9343	01010000005072874D64223140AC1F9BE447BA4740	0
837	Vásárosfalu	9343	010100000072F3322F2C1E31403CE3B15538BA4740	0
838	Rábakecöl	9344	010100000015E63DCE341D3140AC2814D852B74740	0
839	Cirák	9364	01010000002B44D14DAC0731408C8C690135BD4740	0
840	Gyóró	9363	010100000057D7570D78053140D7DEA7AAD0BE4740	0
841	Dénesfa	9365	010100000098DAF74D060831403F332D5679BA4740	0
842	Himod	9362	0101000000B81677CDF5013140F1E0DD8085C24740	0
843	Vitnyéd	9371	010100000087AEFA12E0FA3040BDE5EAC726CB4740	0
844	Hövej	9361	0101000000FD31AD4D63053140144031B264C64740	0
845	Répcelak	9653	010100000078EBA122F3033140C2F0B677B2B54740	0
846	Répceszemere	9375	0101000000A5051ECEB2F930402651D43EC2B64740	0
847	Iván	9374	0101000000325294F029E930405C5A0D897BB84740	0
848	Csáfordjánosfa	9375	0101000000C5419D4DA2F3304050F003464DB54740	0
849	Csér	9375	01010000009688015CDAEE30405652DD126FB54740	0
850	Csapod	9372	010100000043F2DFCD64ED304090CB6E1C67C24740	0
851	Pusztacsalád	9373	010100000016061B8D32E730400420EEEA55BE4740	0
852	Ebergőc	9451	01010000001FBC7669C3CF30409E84888A27C84740	0
853	Lövő	9461	0101000000814A4B9B60C830408BBB8B4171C04740	0
854	Nemeskér	9471	01010000005A51DE228BCD304099EE1A99ECBD4740	0
855	Újkér	9472	010100000004C8D0B183D03040B7B3AF3C48BB4740	0
856	Völcsej	9462	0101000000DD56C4FA50C3304016F88A6EBDBF4740	0
857	Sopronhorpács	9463	0101000000C179CC9B1EBD30404BDB0940EDBD4740	0
858	Und	9464	0101000000FB63100EACB130402028B7ED7BBE4740	0
859	Egyházasfalu	9473	01010000004276830DF4C33040D9F4FB5987BB4740	0
860	Zsira	9476	0101000000359314FD46AE304011C3B3A95FBA4740	0
861	Szakony	9474	0101000000206926CE40B73040CA59338D81B64740	0
862	Répcevis	9475	010100000035199F138CAC3040AA7B09BA62B84740	0
863	Gyalóka	9474	0101000000CD8F64FB35B230405EF23FF9BBB84740	0
864	Ágfalva	9423	0101000000791AD58E87833040096A9D5D63D84740	0
865	Fertőboz	9493	0101000000CD2B8D4E4CB33040264CBD1358D14740	0
866	Fertőhomok	9492	01010000007F52488D64C430407094618154CF4740	0
867	Fertőszéplak	9436	0101000000B4D9A21694D53040DA3C0E83F9CE4740	0
868	Osli	9354	010100000018FE1D9B2E133140F0B1AA14F1D14740	0
869	Acsalag	9168	0101000000A013E74DEA323140AFDF5D786FD64740	0
870	Maglóca	9169	01010000003EE53D737B463140306475ABE7D44740	0
871	Kunsziget	9184	0101000000B520EFB0E4833140BE1CD198A4DE4740	0
872	Mecsér	9176	010100000028999CDA197A3140DDE45C2FF2E54740	0
873	Károlyháza	9182	01010000000116F9F543583140838769DFDCE64740	0
874	Cakóháza	9165	01010000003080F0A1444931400F03A7881DD94740	0
875	Dunaremete	9235	01010000003D601E32E56F3140DE9E31DD35F04740	0
876	Kisbodak	9234	0101000000E758390F826B31405637CDF1C0F24740	0
877	Harka	9422	0101000000402FDCB9309A3040B3C2E3912ED14740	0
878	Vének	9062	0101000000E71835046CC231402D5679A7A7DE4740	0
879	Várbalog	9243	010100000016F1E7251012314003F7F2F1BFEA4740	0
880	Dunaalmás	2545	01010000009E961FB8CA5532403F582140E1DD4740	0
881	Várkesző	8523	0101000000AD95BF31BA5031404354E1CFF0B64740	0
882	Egyházaskesző	8523	01010000007D03931B4554314086E464E256B54740	0
883	Marcaltő	8532	0101000000ED0099E7D25D314000A2050DA2B74740	0
884	Nemesgörzsöny	8522	0101000000C3781739555C314012781673C6B24740	0
885	Malomsok	8533	0101000000CE7D288705653140638A28DCE1B94740	0
886	Kislőd	8446	0101000000C7873485299F31400AE12C8084924740	0
887	Ajka	8400	0101000000615FA1C5088F31403288B432868D4740	0
888	Devecser	8460	01010000008FDE701FB96F3140AD8A7093518D4740	0
889	Cserszegtomaj	8372	0101000000D00F2384473B31402DE34B4D27674740	0
890	Balatonszőlős	8230	010100000076DEC66647D4314059E59D9ED27B4740	0
891	Balatonakarattya	8172	010100000091138145D9243240625AE55311834740	0
892	Várpalota	8100	0101000000A6B6D4415E2332407A7077D66E994740	0
893	Pétfürdő	8105	01010000004689A768F61E3240D3AA4CE779944740	0
894	Öskü	8191	01010000009118F329B61232403602F1BA7E944740	0
895	Csór	8041	0101000000AC504942C74132405874EB353D9A4740	0
896	Olaszfalu	8414	0101000000A5CD829A6BE83140A684BB0E309F4740	0
897	Zirc	8420	0101000000B80952842FDF3140232C2AE274A14740	0
898	Berhida	8181	0101000000453A4DB049223240744A9B05358E4740	0
899	Herend	8440	0101000000D59DDD1099C031405973DB1901914740	0
900	Rédics	8978	01010000000837BE9B137C3040A9B6E56DB64E4740	0
901	Lenti	8960	010100000056D9D2FE6289304084B30012F24F4740	0
902	Nagykanizsa	8800	01010000005E4DF96B0DFE3040016FDCBD373A4740	0
903	Zalaszentgrót	8790	0101000000AC36FFAF3A143140DE318683CE784740	0
904	Peresznye	9734	010100000081E21126D6A530407F6374E558B64740	0
905	Kőszeg	9730	0101000000EDF549496A8A3040BABA08F8DAB14740	0
906	Bük	9737	0101000000CDE9B298D8C03040D2F5E91D13B14740	0
907	Celldömölk	9500	01010000007655FBCFF52631408C0464F904A14740	0
908	Vasvár	9800	0101000000E327C412C5CC3040D57036C247864740	0
909	Szentgotthárd	9970	0101000000E8AB9AD65C463040403C0103F7794740	0
910	Buzsák	8695	0101000000281312C4D4933140F61E78C608534740	0
911	Táska	8696	0101000000B5711F14EF853140809076ED1C4F4740	0
912	Bátonyterenye	3070	0101000000758588E5E0D333401D97CC0C76FF4740	0
913	Pásztó	3060	01010000001B16FE6728B333403DD0AF52E6F54740	0
914	Kisbér	2870	010100000071D0B936AF0732407858F2C2E7BF4740	0
915	Oroszlány	2840	010100000029F85C5C9950324059A89086AEBE4740	0
916	Bodajk	8053	010100000013D4F02DAC3B324013A4085F4EA94740	0
917	Lepsény	8132	010100000065E5F27A8B3E3240BFAA69CD457F4740	0
918	Mezőszentgyörgy	8133	0101000000643B84961A463240BD5301F73C7F4740	0
919	Enying	8130	0101000000AFE9E687B63E32400A86CEC6A5764740	0
920	Záhony	4625	01010000007EFFE6C5892D3640AB37B41204344840	0
921	Rohod	4563	0101000000F3774A62A422364040CC142983034840	0
922	Baktalórántháza	4561	010100000000A370E25014364004B97A04EDFF4740	0
923	Kemecse	4501	0101000000220C4D2377CC3540838362D0AE084840	0
924	Demecser	4516	01010000003D85B762DAEC3540BDC85FB58D0E4840	0
925	Tiszakarád	3971	0101000000B289271653B8354088A647AEF6194840	0
926	Nagyhalász	4485	01010000005A70F55267C235405713FA4FED104840	0
927	Ibrány	4484	0101000000E91B87B0D0B53540C9570229B10F4840	0
928	Kékcse	4494	01010000007A8A1C226E02364048A5D8D138204840	0
929	Tiszakanyár	4493	0101000000679F22E241F6354022D45636BD1F4840	0
930	Dombrád	4492	0101000000C257CFA4A8EC35401B907351E31C4840	0
931	Rakamaz	4465	01010000007B5E3B623E7A3540D61C2098A30F4840	0
932	Tiszalök	4450	0101000000FB1AEEC8FD5F3540ECE291D332024840	0
933	Szorgalmatos	4441	010100000060FCD9345B5E3540D1B58A598AFE4740	0
934	Tiszavasvári	4440	01010000002A3009BC385E3540BADDCB7D72FA4740	0
935	Nagykálló	4320	01010000005CCAF962EFD7354006836BEEE8EF4740	0
936	Hajdúhadház	4242	0101000000C57652BA4FAB35403E1416269DD74740	0
937	Újfehértó	4244	0101000000C7E4C3A2D8AE35408778DAD083E64740	0
938	Nyírmihálydi	4363	0101000000BA1050864FF73540F56ADB8BC3DD4740	0
939	Nyírlugos	4371	0101000000B71A2323B10A36409CD9531795D84740	0
940	Kisléta	4325	0101000000A387EB62E4003640A89F81A2C3EA4740	0
941	Nyírbogát	4361	0101000000F2A66CA2E00F36403CCBE2B496E64740	0
942	Nyírbátor	4300	010100000049055FE2D9213640EED0B01875EB4740	0
943	Nyírgyulaj	4311	0101000000484D60DFF31636401EFF058200F14740	0
944	Máriapócs	4326	0101000000DEEBFF779F0636406A6EE0698DF04740	0
945	Mátészalka	4700	0101000000307F2A13235236407664F6C319FA4740	0
946	Csenger	4765	010100000025C56C6EF1AD3640B7369E190EEB4740	0
947	Nagyecsed	4355	0101000000A1EF13AC16633640DB0E57186CEE4740	0
948	Szakoly	4234	010100000016F88A6EBDE635407EFCA5457DE14740	0
949	Balkány	4233	01010000009341A49531DC354062855B3E92E24740	0
950	Fehérgyarmat	4900	01010000002821A2E2498436408FF4B3A217FE4740	0
951	Mándok	4644	010100000084752D6BAC303640EDC330163C294840	0
952	Eperjeske	4646	0101000000B8EE41638136364002CD316A082C4840	0
953	Nyírtelek	4461	010100000012AB9A7BA3A13540061E296C50014840	0
954	Vásárosnamény	4800	0101000000483140A209503640CB694FC939104840	0
955	Ócsa	2364	0101000000060C37853A3B33400533A6608DA64740	0
956	Vecsés	2220	01010000003FA253A1CB433340D65D8F7868B44740	0
957	Üllő	2225	0101000000DDF2EC4D675833409F3D97A949B14740	0
958	Monor	2200	01010000001488E821647233400AB144B126AD4740	0
959	Pilis	2721	01010000000AE18739F78B33409D30BCED9DA44740	0
960	Albertirsa	2730	010100000046072461DF9C3340CB147310749F4740	0
961	Gyömrő	2230	0101000000842C0B26FE643340EC2FBB270FB64740	0
962	Maglód	2234	01010000000E02E1F9FB5B3340657A7885F4B84740	0
963	Pécel	2119	0101000000FF147DF43C58334042F4FF05DDBE4740	0
964	Kistarcsa	2143	010100000049FD50C47D433340000AE4C8B9C54740	0
965	Nagykáta	2760	010100000023C8F77B18C03340937CDB02F8B44740	0
966	Tura	2194	0101000000E4F159434E983340A7E8482EFFCD4740	0
967	Örkény	2377	010100000096C4A39E4F6E334063F030ED9B904740	0
968	Hernád	2376	0101000000385AC4663668334078EFA83121954740	0
969	Jászjákóhalma	5121	01010000006107848C36FD3340BA41FEE3CEC24740	0
970	Jászapáti	5130	01010000005809CCF918243440025E0B1FB6C14740	0
971	Adács	3292	0101000000F82E4A75A6F93340FED64E9484D84740	0
972	Jászárokszállás	5123	0101000000C0ACF5EA88FA33404134A95780D24740	0
973	Jászfényszaru	5126	010100000017C9682E81B733409B6D1393DCC84740	0
974	Abádszalók	5241	010100000006F75ED78A99344080780206EEBC4740	0
975	Túrkeve	5420	0101000000DCB529C35DBC344073E1F6BAFB8D4740	0
976	Újszász	5052	01010000003DF60E12FD1134406B4B789D68A44740	0
977	Kerecsend	3396	0101000000810F142E9A5834405F76F464A3E54740	0
978	Ostoros	3326	0101000000FF1A5AAEC86D3440622019BCF9EE4740	0
979	Szilvásvárad	3348	01010000006FCF98EE1A6334400CB501333A0D4840	0
980	Bélapátfalva	3346	010100000006F8C9AC3959344029B4ACFBC7064840	0
981	Kisköre	3384	0101000000AEA305C3147E3440E5E14E33EEBF4740	0
982	Lőrinci	3021	0101000000CDC17D2E64AD334024B2B4F8B9DE4740	0
983	Bükkszenterzsébet	3257	0101000000F7651F1ACC27344007C60B337E064840	0
984	Pétervására	3250	0101000000D6F72BAE3B193440AF55270C6F024840	0
985	Polgár	4090	0101000000735E08DE351D35403507AD2C76EF4740	0
986	Hajdúböszörmény	4220	010100000051D20D5E05823540E6BCB502F9D54740	0
987	Hajdúsámson	4251	0101000000660AE764F3C035405B728170AACC4740	0
988	Vámospércs	4287	0101000000FD602A4712E6354028AC9EDD6BC34740	0
989	Nyíradony	4254	0101000000546DDC07C5E7354036A6CC727ED84740	0
990	Hajdúnánás	4080	0101000000ADF314DE8A6D354041A5A54D30EC4740	0
991	Hajdúdorog	4087	0101000000609CAEDD2C803540B225506969E84740	0
992	Tiszacsege	4066	010100000030E8CE5D5CFE34408771924149D94740	0
993	Derecske	4130	0101000000273A819F27923540E4C3471F4EAD4740	0
994	Berettyóújfalu	4100	01010000009555C7E0178935405A023ADDC39C4740	0
995	Komádi	4138	01010000003B527DE7177D35402085460B2B804740	0
996	Nádudvar	4181	0101000000E1777874C82835404E7ADFF8DAB64740	0
997	Monostorpályi	4275	010100000031A479B6FDC535400382EFECE1B24740	0
998	Létavértes	4281	0101000000606C6B555CE0354029649DE051B14740	0
999	Balmazújváros	4060	010100000024665133FF5735401CE9B1D249CE4740	0
1000	Csongrád	6640	0101000000A9E793CB35273440C2D19F47D65A4740	0
1001	Sándorfalva	6762	010100000095ACD4FDAD1A34400C3A2174D02E4740	0
1002	Mindszent	6630	010100000038F581E49D2F34403831242713434740	0
1003	Kistelek	6760	0101000000474E70FB2FFB33403D878D0D383C4740	0
1004	Ópusztaszer	6767	0101000000F172C7516F1034405FA40689A33F4740	0
1005	Szentes	6600	0101000000BCD12236B341344005A0F60082534740	0
1006	Tiszaújváros	3580	0101000000418AF0E5F40B3540518946D2C9F64740	0
1007	Szerencs	3900	0101000000621D7D827A333540AC938ECDE9144840	0
1008	Alsózsolca	3571	0101000000392DD38ACAE134400CAEB9A3FF084840	0
1009	Szikszó	3800	0101000000A97812C770ED3440B6EC5A8CCB194840	0
1010	Encs	3860	01010000007534B33B491F3540F5B23742502A4840	0
1011	Sárospatak	3950	0101000000A02CC60AC8903540DD19B7E22C294840	0
1012	Sátoraljaújhely	3980	0101000000BCC73E6DF9A735403F822C55B3324840	0
1013	Szendrő	3752	01010000000AFBD1CB83BB3440A2968B9D95334840	0
1014	Putnok	3630	0101000000CB94206D2D6F3440C17FA955AA254840	0
1015	Borsodnádasd	3671	0101000000448D9D4BCC3E3440F9C73148B00F4840	0
1016	Mezőkövesd	3400	0101000000ED20C033EB90344058AD4CF8A5E74740	0
1017	Mezőcsát	3450	010100000032CB9E0436E73440FF678302A5E84740	0
1018	Abaújszántó	3881	0101000000C666ECF07C2F3540789961A3AC234840	0
1019	Cigánd	3973	01010000000B3895568DE335407ABB6FC67A214840	0
1020	Szuhogy	3734	0101000000A35291AFA9AC34403BE86DC72F314840	0
1021	Rudabánya	3733	0101000000795E85EF589F3440DF6E490ED82F4840	0
1022	Gyomaendrőd	5500	0101000000158035BD7AD33440FFBE3566C8774740	0
1023	Csorvás	5920	01010000000FF857EAB4D53440D7964BF443514740	0
1024	Tótkomlós	5940	0101000000F716201B92BC3440BAFEB858AC344740	0
1025	Mezőhegyes	5820	010100000007184CB2C4D13440AC5B98E02F284740	0
1026	Mezőkovácsháza	5800	0101000000E490C31671EC3440417452A923344740	0
1027	Sarkad	5720	0101000000AE2E02BE36623540105F8143035F4740	0
1028	Körösladány	5516	01010000003615F3BDD0133540DF98AFDC1C7B4740	0
1029	Vésztő	5530	01010000004463377D8742354080040F1D4C764740	0
1030	Battonya	5830	0101000000BD83E9C59A05354047BB1B5597244740	0
1031	Békés	5630	0101000000135A7B44F1213540F3B4577AC8624740	0
1032	Dévaványa	5510	01010000009213DCFE4BF63440756CA92803844740	0
1033	Elek	5742	0101000000A31E4718AB40354060915F3FC4434740	0
1034	Kétegyháza	5741	010100000051BB044C852F3540E1C27064D4454740	0
1035	Füzesgyarmat	5525	0101000000F39B78BDEA353540AAC3C029628D4740	0
1036	Szentlőrinc	7940	01010000007A8EC87729FD31401827BEDA51054740	0
1037	Sellye	7960	01010000001D249FB2F5D931404ECD8A4DD0EF4640	0
1038	Pécsvárad	7720	010100000045A1C096B26B3240242DF07096144740	0
1039	Kerekegyháza	6041	0101000000D399208F857B3340E68A9CCFCA774740	0
1040	Szabadszállás	6080	0101000000C44E67DDF53833407F36CD9607704740	0
1041	Izsák	6070	010100000089343B9C0A5C3340BCE7C07284664740	0
1042	Akasztó	6221	01010000007069EB96D33433408ACFF81972584740	0
1043	Kiskőrös	6200	010100000055ACD0F69E483340AD2F12DA724F4740	0
1044	Soltvadkert	6230	0101000000CDB3ED0FEF643340008DD2A57F4A4740	0
1045	Császártöltés	6239	0101000000E7841ACFB12D3340DCF0603024364740	0
1046	Hajós	6344	0101000000B81FF0C0001E334021BBC106FA324740	0
1047	Baja	6500	0101000000089E31827CF33240D278D8FAD8164740	0
1048	Felsőszentiván	6447	01010000000E7679292B303340150AC7E2ED184740	0
1049	Tataháza	6451	0101000000B5FF5C8F1D4D3340CC063EAB71164740	0
1050	Bácsalmás	6430	0101000000B11FBD3CF85433402BCC310F4F104740	0
1051	Jánoshalma	6440	010100000080C86CDAD652334000C1C1830B264740	0
1052	Kiskunhalas	6400	010100000083E8FF0BBA7B33403D8D6AC7C3364740	0
1053	Kiskunmajsa	6120	01010000007E09CB8E43BD3340025658BACC3E4740	0
1054	Kiskunfélegyháza	6100	0101000000789961A3ACD9334071A47DBD0C5B4740	0
1055	Lajosmizse	6050	0101000000DD51ADCFE68E33404D9F1D705D834740	0
1056	Lakitelek	6065	01010000003BDCB353180034405298F738D36F4740	0
1057	Tiszakécske	6060	0101000000DE42B2DBC21A3440B263C8563C774740	0
1058	Tompa	6422	01010000009D55551E938933406BFFB91E3B1A4740	0
1059	Kajdacs	7051	010100000072AF82CE5A9E324074ACF7C033484740	0
1060	Medina	7057	01010000006FAAA404B3A432403F373465A73C4740	0
1061	Dunaegyháza	6323	010100000056C9117C1DF4324024BAC216166B4740	0
1062	Nyárlőrinc	6032	0101000000C528BE90C4DF33407CB4DDA9256E4740	0
1063	Tiszakürt	5471	0101000000C929F004B12034406F4A79AD84714740	0
1064	Tiszaug	6064	010100000087495DD7D40E34401678DD11046D4740	0
1065	Tiszainoka	5464	0101000000C85B53C5F9263440C7F9F609FB734740	0
1066	Cibakháza	5462	0101000000564046E5CB343440CD0B0B49C17A4740	0
1067	Sükösd	6346	0101000000D4484BE5EDFE324074CEF4B7A9244740	0
1068	Fajsz	6352	01010000000349337106EC32409631F43E44354740	0
1069	Homokmégy	6341	0101000000870A1F5BE0123340FFAB3363763E4740	0
1070	Miske	6343	0101000000E4A320D335083340FC32BD699F384740	0
1071	Drágszél	6342	01010000005AA1A3B0E609334080ED050BCC3B4740	0
1072	Újtelek	6337	0101000000465ACFB5D40E33409B5F8374674B4740	0
1073	Szakmár	6336	0101000000A9C0C9367013334006E3964517474740	0
1074	Ordas	6335	01010000005CD6B3D606F33240FE124C906C514740	0
1075	Géderlak	6334	010100000018004FFFFEE932408B8DD4D6E34D4740	0
1076	Uszód	6332	0101000000304F4244C5E73240805E5DBAEE484740	0
1077	Foktő	6331	0101000000E5EC9DD156EB3240145333B5B6434740	0
1078	Dunaszentbenedek	6333	0101000000FE60E0B9F7E432403FC978EF034C4740	0
1079	Soltszentimre	6223	01010000003689E6A672493340040E57BDB2624740	0
1080	Kaskantyú	6211	01010000009811836511633340B4C1D375F2554740	0
1081	Csengőd	6222	0101000000E24515B47F4433409E3935E1A85B4740	0
1082	Tabdi	6224	010100000036E26EB5F34E33402AC8CF46AE574740	0
1083	Fülöpszállás	6085	0101000000C8AB1853553D3340E02D90A0F8684740	0
1084	Páhi	6075	010100000090BDDEFDF1623340FFDB76EB465B4740	0
1085	Mikebuda	2736	010100000060257A747E9D334086D4A35F11944740	0
1086	Őcsény	7143	0101000000ED0E290648C232405E38C604EB274740	0
1087	Decs	7144	0101000000EA341CE093C232408BE65CE564244740	0
1088	Sárpilis	7145	01010000003B1C5DA5BBBD3240D291B7B7B61F4740	0
1089	Várdomb	7146	010100000088026CF6F6AF3240CDC01259B51F4740	0
1090	Csávoly	6448	0101000000744B06DBE32433409EEA909BE1184740	0
1091	Mélykút	6449	010100000073D30BE313613340B3DE5E888B1B4740	0
1092	Kisszállás	6421	0101000000493B246BC37D33407B794B83EC234740	0
1093	Kehidakustány	8784	0101000000B876A2242418314018C68267E76B4740	0
1094	Felsőpáhok	8380	01010000008FC29A6FE92731404DFE82386A644740	0
1095	Röszke	6758	01010000004890A56A1609344016759C91F7174740	0
1096	Kelebia	6423	0101000000AC7DF090189B3340B97DA02644194740	0
1097	Kemenesmagasi	9522	010100000011548D5E0D3631408D8EF51E78AA4740	0
1098	Vönöck	9516	01010000002837401F1B2931400B24CDC419A84740	0
1099	Kemenesszentmárton	9521	0101000000992A1895D4293140FC8BA03193A54740	0
1100	Tokorcs	9561	01010000000CC803368C193140671F758588A24740	0
1101	Nagysimonyi	9561	01010000003D0CAD4ECE10314053B70E69AFA14740	0
1102	Sitke	9671	01010000007358D06A3706314037FDD98F149F4740	0
1103	Pirtó	6414	01010000008A4050C9946E334021393EFFE2414740	0
1104	Lókút	8425	0101000000799A2732CEDC3140DE431DB1719A4740	0
1105	Hárskút	8442	0101000000F4A21B0698D03140EB7827FAD7974740	0
1106	Eplény	8413	010100000094D4AEAEAFEA3140600C9BB7A09A4740	0
1107	Márkó	8441	01010000006CEDD8637DD03140F981AB3C818F4740	0
1108	Balatonfüred	8230	010100000010AD156D8EE33140532058FA757A4740	0
1109	Pénzesgyőr	8426	0101000000B2A7D37080C931405AD8D30E7F9D4740	0
1110	Bakonybél	8427	0101000000D5D8147E5FBA31405174136BA7A04740	0
1111	Nagygyimót	8551	0101000000C6D2D1BBC28C3140F96FB9556BAB4740	0
1112	Béb	8565	0101000000E2B1FA7EC5993140BA1A344F09AC4740	0
1113	Bakonykoppány	8571	010100000017D3F13DC8AF31404ABD022C4DAA4740	0
1114	Csabrendek	8474	010100000007205AD0204A31405F7935E5AF814740	0
1115	Nyirád	8454	0101000000E2163D015E74314046459C4EB2804740	0
1116	Halimba	8452	01010000000EBBEF181E89314067CD340642844740	0
1117	Mike	7512	0101000000784A62A472883140D451C4D8F81E4740	0
1118	Szigetszentmárton	2318	0101000000C37A489D25F5324049C8F610439D4740	0
1119	Tóalmás	2252	01010000001245926AE9A93340B9A2395739C14740	0
1120	Érsekhalma	6348	0101000000B916D286681F3340C778DED7922C4740	0
1121	Nemesnádudvar	6345	0101000000F5A7435D5A0D3340D5C7E8256B2B4740	0
1122	Karakószörcsök	8491	010100000015B9F138564931401EC539EAE8904740	0
1123	Kerta	8492	0101000000123933B044463140F5AC5A88C4944740	0
1124	Iszkáz	8493	0101000000A015BDF8474C3140942F682101954740	0
1125	Tüskevár	8477	0101000000CFA9BFB91A50314098796121298F4740	0
1126	Apácatorna	8477	010100000043CB15399F4B314023731BC3528E4740	0
1127	Veszprémgalsa	8475	0101000000D55F0A6A53443140983B8E7AE38B4740	0
1128	Szentimrefalva	8475	0101000000FEAFDFB831483140FD14C78157894740	0
1129	Kisberzseny	8477	0101000000DC63E94317443140F591A520898D4740	0
1130	Dáka	8592	0101000000CA73D8D8806D314049809A5AB6A44740	0
1131	Vid	8484	0101000000D7B331C04F563140D15D1267459B4740	0
1132	Nagyalásony	8484	010100000054FAAEAD445B3140F1A952697A9D4740	0
1133	Somlószőlős	8483	0101000000C6585CD2075B3140AB532F0961964740	0
1134	Kup	8595	0101000000737275B6367731400F2FE301C09F4740	0
1135	Pápakovácsi	8596	0101000000E03B20BF6D7C3140EEC220FAFFA14740	0
1136	Nóráp	8591	0101000000B4B9201109753140AD52D55F0AA34740	0
1137	Bakonypölöske	8457	0101000000D3286E26F07C3140C30078FAF79A4740	0
1138	Noszlop	8456	0101000000C0ED64CB4D7531407819B446F3964740	0
1139	Nemeshany	8471	0101000000D3F6AFAC345D314037B75384E5884740	0
1140	Káptalanfa	8471	01010000004199EBD91858314098E546EC6E884740	0
1141	Gyepükaján	8473	0101000000348C71B4995331406207DF45A9854740	0
1142	Sümegprága	8351	0101000000B655FFD6044731405EE27E7676784740	0
1143	Bazsi	8352	0101000000EF66576B723E31409DC717A364774740	0
1144	Zalaszántó	8353	0101000000011CD6AFCF39314065C39ACAA2714740	0
1145	Apátvarasd	7720	0101000000563BD400EF7A3240DEDEDA2ED9174740	0
1146	Lovászhetény	7720	0101000000CC142983597932404DD7135D17144740	0
1147	Erdősmecske	7723	01010000007A8D5DA27A8332407BBFD18E1B164740	0
1148	Feked	7724	0101000000C81BAA73568F3240109CE9149A144740	0
1149	Szebény	7725	010100000049522D7D4396324083EB408CC6104740	0
1150	Szűr	7735	010100000003FFA556A9943240228326D3B20C4740	0
1151	Himesháza	7735	0101000000939E33B3E09132405F0839EFFF0A4740	0
1152	Véménd	7726	0101000000FEBF4582049E3240245E9ECE15144740	0
1153	Palotabozsok	7727	0101000000DDF3572316A43240318D70A47D104740	0
1154	Görcsönydoboka	7728	01010000005770896D9CA0324010BEE60B10094740	0
1155	Somberek	7728	010100000083DBDAC2F3A83240FC6AB356590A4740	0
1156	Székelyszabar	7737	01010000008A50B692679A324078279F1EDB054740	0
1157	Erdősmárok	7735	01010000000A815CE2C88B324042B115342D074740	0
1158	Geresdlak	7733	010100000077DCF0BBE98632405F69CF1BDD0D4740	0
1159	Maráza	7733	01010000007A8D5DA27A833240DA0C26B49B094740	0
1160	Fazekasboda	7732	010100000038031203137C3240B71D64A3BD0F4740	0
1161	Nagypall	7731	0101000000E15927D30D7532401469D1F187124740	0
1162	Várgesztes	2824	0101000000748C75BBA865324082A4F4F175BC4740	0
1163	Csetény	8417	010100000024C5B6FB0BFF3140ED5575A098A84740	0
1164	Szőc	8452	01010000007D282C4C3A83314008550F3DCE824740	0
1165	Öcs	8292	010100000096C6D402209D31400A86730D33804740	0
1166	Pula	8291	0101000000AB56CB42E0A531401FF87365AB7F4740	0
1167	Nagyvázsony	8291	010100000066B33401D0B231405C655C27E47D4740	0
1168	Tótvázsony	8246	01010000008A6E62ED94C931403F42830310814740	0
1169	Dánszentmiklós	2735	01010000003B623E6A5D8E334071B092EA969A4740	0
1170	Pusztavacs	2378	010100000050172994857F3340809F71E140964740	0
1171	Tatárszentgyörgy	2375	010100000047E92D79975E3340CB2665F7898A4740	0
1172	Káva	2215	010100000028D2FD9C829633400E2263FF86AD4740	0
1173	Pánd	2214	01010000009D329298FBA13340BB53F0CAE4AC4740	0
1174	Tápióbicske	2764	010100000079245E9ECEAF334030CE29125DAE4740	0
1175	Farmos	2765	0101000000E620E86855D93340818010244AAE4740	0
1176	Vámosgyörk	3291	010100000018BE74498BED3340A5BDC11726D74740	0
1177	Nagymányok	7355	0101000000390CE6AF90753240033054B428244740	0
1178	Pusztahencse	7038	01010000002CDFE98486B832401F89F260E64B4740	0
1179	Györköny	7045	010100000090A8AB96CFB1324031218BD937514740	0
1180	Keszőhidegkút	7062	0101000000B366BF492E6C32404673092C254E4740	0
1181	Belecska	7061	0101000000509951E2296A32406A1327F73B524740	0
1182	Nagybörzsöny	2634	01010000008FC360FE0AD33240AE3720F8CEF74740	0
1183	Horvátzsidány	9733	0101000000E8644E3C0CA03040A11A8A9697B44740	0
1184	Csősz	8122	0101000000545CB0AFD06A3240E9F2E670AD844740	0
1185	Soponya	8123	0101000000F965D58CB1743240404A91216C814740	0
1186	Sáregres	7014	0101000000234E27D9EA9832408B40AB8207644740	0
1187	Bogyiszló	7132	01010000009D3E4C0C13D1324005300A270E314740	0
1188	Fehérvárcsurgó	8052	010100000040EC962E0E4432400459AA6631A54740	0
1189	Iszkaszentgyörgy	8043	0101000000FD2C3B69864B324013BC7C467D9E4740	0
1190	Kincsesbánya	8044	01010000006D05A8041F463240144EC1D0D9A14740	0
1191	Söréd	8072	0101000000411CDAB6DE473240C0ED64CB4DA94740	0
1192	Nagytarcsa	2142	0101000000C8563C9A8F4833400A93F30F6CC34740	0
1193	Hantos	2434	01010000003B83D08B24B332400AEC7B1EED7F4740	0
1194	Aszófő	8241	0101000000912A8A5759D5314025D698C6E5764740	0
1195	Pusztavám	8066	01010000003C4ED1915C3A3240E253A5D2F4B64740	0
1196	Bakonysárkány	2861	0101000000D31742CEFB1932405D37A5BC56B94740	0
1197	Döbrönte	8597	0101000000811B73E83E8C31406D640DCD2B9D4740	0
1198	Csesznek	8419	0101000000B99BF1C7FEE13140FC7E202F5AAD4740	0
1199	Bakonyszentkirály	8430	0101000000136EE81CF2E131404E0EFA2D95AE4740	0
1200	Bag	2191	0101000000606B0080AD7A334044728D2A1ED14740	0
1201	Nézsa	2618	0101000000A59828E7304C3340A67B421B25EC4740	0
1202	Alsópetény	2617	01010000007082CA53B13E33400AF5F411F8EF4740	0
1203	Romhány	2654	010100000054E9825550423340424871E9F3F54740	0
1204	Legénd	2619	0101000000E9375D60A04F3340C8DC6BF761F04740	0
1205	Szátok	2656	0101000000CE24A078843B3340C0E8F2E670FA4740	0
1206	Németbánya	8581	010100000086A0B48185A531402C0483B57B9B4740	0
1207	Bakonyjákó	8581	01010000003F9D3C766199314022C1F979F89C4740	0
1208	Tevel	7181	0101000000E4A837FE9F74324086200725CC344740	0
1209	Szárliget	2067	0101000000D8A83DDB597E32401ED9017C5CC24740	0
1210	Újbarok	2066	0101000000E94999D4D08E324062FC8FA740BD4740	0
1211	Vértessomló	2823	01010000003F8F519E795D3240681F2BF86DC14740	0
1212	Kutas	7541	0101000000D49343D5F9733140CACFFC20812A4740	0
1213	Beleg	7543	010100000081DE65D01A693140D6A8876874284740	0
1214	Szólád	8625	0101000000A137CB1B16D7314050B9D3E7B4644740	0
1215	Teleki	8626	0101000000B8CF85EC17D33140CE9C3FB7E1624740	0
1216	Nagycsepely	8628	0101000000575F5D15A8D53140156F641EF95F4740	0
1217	Kötcse	8627	010100000045285BC933DC3140E1FBD1263D604740	0
1218	Kalocsa	6300	0101000000EBADDC6685FB32407E384888F2424740	0
1219	Bátya	6351	0101000000A1478C9E5BF43240F788E29F633E4740	0
1220	Kaposmérő	7521	0101000000D96212899DB43140F2F0F9BC3D2E4740	0
1221	Inke	8724	01010000008C4F5CE910333140C7A3AF7B86324740	0
1222	Iharosberény	8725	0101000000B652639D851C31406781D140872E4740	0
1223	Pogányszentpéter	8728	0101000000012FD8B221103140E4C8B9032B314740	0
1224	Siófok	8600	010100000006C2A96ADD0D32404A777C201E744740	0
1225	Sántos	7479	0101000000EE0D19EA0BE2314006B243A10A2C4740	0
1226	Boldogasszonyfa	7937	01010000006E313F3734D73140782BA62D09174740	0
1227	Bőszénfa	7475	010100000065E3C116BBD931403FA07DF66D1D4740	0
1228	Bocska	8776	010100000092D8A49185EA30402CCC8CC8C1464740	0
1229	Bagod	8992	0101000000BF21F9EF66BE304081C586133D704740	0
1230	Hagyárosbörönd	8992	01010000003BBE62B25DB430403781334289744740	0
1231	Hegyhátsál	9915	0101000000BCD5CE8B6EA43040DFA5D425E37A4740	0
1232	Katafa	9915	0101000000E85C9BD722A13040C735F405E37C4740	0
1233	Veszprém	8200	010100000031900CDEFCE9314087F0790FE18B4740	0
1234	Ipolydamásd	2631	0101000000DDCC8D8E50D43240125B30A7BAEB4740	0
1235	Kóspallag	2625	01010000008B60D2CE1FEF3240A2E018B8F2EF4740	0
1236	Márianosztra	2629	010100000015EFB6C13FDF324082BFA959B1EE4740	0
1237	Perőcsény	2637	0101000000BF0A952474DC324050A0997164FF4740	0
1238	Pócsa	7756	0101000000690BBE1F6D7832404EC23BAF67F44640	0
1239	Borjád	7756	01010000000142356FE677324060A28B97B8F74640	0
1240	Töttös	7755	01010000004D9C8136DE8A324035B8AD2D3CF54640	0
1241	Nagynyárád	7784	0101000000543A58FFE794324067E20CB4F1F84640	0
1242	Dunaszekcső	7712	0101000000FF21FDF675C232404150244EDD0A4740	0
1243	Dunafalva	6513	01010000008966F915C6C532401DA78D8FBB0A4740	0
1244	Nagykozár	7741	01010000001468661CD95132406195C10765084740	0
1245	Szálka	7121	01010000006DEC6D8ECEA23240326C393C29234740	0
1246	Sárkeresztes	8051	0101000000499AE4EC425A3240F8495A9654A04740	0
1247	Magyaralmás	8071	0101000000A28D6D63FD523240320B4856D9A54740	0
1248	Bosta	7811	01010000007B71981E033632403AA28C028EF94640	0
1249	Szalánta	7811	0101000000A7ADB607C63C32405B3920AE41F94640	0
1250	Túrony	7811	0101000000ECDD1FEF553B32405888B3C7B0F34640	0
1251	Zók	7671	0101000000FB873E69F21832403145B9347E014740	0
1252	Bicsérd	7671	01010000009919EC3CE01432400F588341E3024740	0
1253	Kaposszerdahely	7476	010100000020FD4003FBC131402F8A1EF818294740	0
1254	Szenna	7477	0101000000F30B65975EBB3140BCDE477F79274740	0
1255	Patca	7477	01010000005D7C1BAC49B93140BB31F3D36E244740	0
1256	Szilvásszentmárton	7477	0101000000CA00AB7E00B931400A0ED4CED5224740	0
1257	Zselickisfalud	7477	010100000035BB4967BBBB3140B58AFED0CC224740	0
1258	Nagymágocs	6622	01010000000CE0D2D62D7B3440D625998BAE4A4740	0
1259	Szentbalázs	7472	0101000000D6DE4CF15DE5314001F73C7FDA284740	0
1260	Oszkó	9825	0101000000631A97BBE0DF30401268B0A9F3854740	0
1261	Hegyhátszentpéter	9821	0101000000300620FF16D0304024045031737D4740	0
1262	Győrvár	9821	01010000005C01857AFAD63040F419506F467E4740	0
1263	Pácsony	9823	0101000000CB4A9352D0D930405973DB1901824740	0
1264	Petőmihályfa	9826	01010000001DDEBDED53C9304025726660897D4740	0
1265	Olaszfa	9824	0101000000AB08371955E23040B8F589F2BB814740	0
1266	Andrásfa	9811	01010000008550EFF329CB3040AEFB7DB5597B4740	0
1267	Bükkösd	7682	01010000007519A31A9BFE3140E58FB3FA340E4740	0
1268	Helesfa	7683	01010000006281AFE8D6F93140A786472C730B4740	0
1269	Pécsbagota	7951	01010000008E2BE400B01232405FEA8C94D2FE4640	0
1270	Szabadszentkirály	7951	0101000000BD59DEB0C80A3240B9556BBCCF004740	0
1271	Gerde	7951	010100000047DB42A1AF06324023B836F9D2FE4640	0
1272	Királyegyháza	7953	0101000000C2CC2D63F9F73140888ACCB799FF4640	0
1273	Gersekarát	9813	0101000000A504B3F803BE304018C627AE747D4740	0
1274	Cserkút	7673	0101000000A391CF2B9E223240843F68E2C2094740	0
1275	Boda	7672	0101000000049E6AE33E0C32401A0E9590590A4740	0
1276	Csonkamindszent	7940	0101000000EDDBA4FD6AF73140A4CE92B6A7064740	0
1277	Kacsóta	7940	010100000087495DD7D4F43140AF6C301EEF044740	0
1278	Szentdénes	7913	01010000003D19D29794ED314009A87004A9004740	0
1279	Katádfa	7914	0101000000635D818D90DE314010B45DFCC8FF4640	0
1280	Bánfa	7914	010100000095F3C5DE8BE13140614557337CFF4640	0
1281	Rózsafa	7914	010100000071E2AB1DC5E3314073B8567BD8024740	0
1282	Nyugotszenterzsébet	7912	010100000015BE631D33E931406938656EBE094740	0
1283	Botykapeterd	7900	0101000000B85A272EC7DD31405AA3795B44064740	0
1284	Nagypeterd	7912	01010000008A0453CDACE53140F1A1444B1E064740	0
1285	Nagyváty	7912	01010000008253C48E6BEE31409A8933D0C6074740	0
1286	Dencsháza	7915	010100000088B9A46ABBD531400CD759E322FF4640	0
1287	Szentegát	7915	0101000000CF5AC0BAE0D23140FADBF9D923FD4640	0
1288	Gyód	7668	010100000033DC25169D2D32400113B87537004740	0
1289	Hosszúhetény	7694	0101000000C08B08104F5A32403ADC589AA5144740	0
1290	Kővágószőlős	7673	0101000000945EE51AB01F32400972AB7BBF0A4740	0
1291	Bakonya	7675	0101000000B1378CDD9914324005D957C3EA0A4740	0
1292	Kővágótöttös	7675	01010000001E62CD12AE193240B1D93631C90A4740	0
1293	Magyarhertelend	7394	010100000068F3EE7ECB2632407E5C76E338184740	0
1294	Kisasszond	7523	01010000006255736F34A431402F9ADF7A5E2A4740	0
1295	Gige	7527	0101000000D4676215CA9B3140250DC9247E264740	0
1296	Pálmajor	7561	0101000000EA97E370419131400F7D772B4B314740	0
1297	Pécsudvard	7762	010100000060747973B84632405EEFA3BF3C014740	0
1298	Szemely	7763	0101000000CEF45CF0B35332409CDF30D120014740	0
1299	Vörs	8711	0101000000900F1F7D38453140C505FB0A2D554740	0
1300	Főnyed	8732	01010000005BF6DA221F423140D673D2FBC6504740	0
1301	Szegerdő	8732	0101000000F43BA81F2F473140D51F065F3D514740	0
1302	Tikos	8731	01010000005E62D119BD4931405B11908A5A514740	0
1303	Hollád	8731	010100000054573ECBF34E314049F4328AE5514740	0
1304	Sávoly	8732	0101000000EB707495EE443140B0F5566EB34B4740	0
1305	Somogysámson	8733	0101000000CDD3145C074C3140434D3E87434B4740	0
1306	Szőkedencs	8736	0101000000CACE914BD23F31404E41237DFF464740	0
1307	Csákány	8735	01010000008F2D1565804531403F236CD333454740	0
1308	Somogyzsitfa	8734	0101000000196A5E1FE74B3140FD0EEAC7CB464740	0
1309	Gadány	8716	0101000000E344AADED0643140D6389B8E00424740	0
1310	Kelevíz	8714	0101000000048B68E0EC6B31404B66AB819C424740	0
1311	Mesztegnyő	8716	010100000038FD3449876C3140977E784C93404740	0
1312	Hosszúvíz	8716	0101000000C396C39382713140A0F595AC2F424740	0
1313	Libickozma	8707	0101000000D0532E9E8B88314056D636C5E3424740	0
1314	Újvárfalva	7436	0101000000A133C40CE89231406ADE718A8E374740	0
1315	Somogysárd	7435	01010000007A765490FA98314064254113BC344740	0
1316	Varászló	8723	0101000000F148BC3C9D3731400938DFE3A7374740	0
1317	Somogyszentpál	8705	010100000064D23A0554793140558F8F7120524740	0
1318	Gyugy	8692	01010000007912222A9EAE3140805FC88F9D584740	0
1319	Bálványos	8614	01010000003B08F0CCBAF33140E702F2800D644740	0
1320	Lulla	8660	010100000018963FDF160632405028FA3207654740	0
1321	Torvaj	8660	010100000012859675FF0A32406F826F9A3E624740	0
1322	Sérsekszőlős	8660	0101000000C5A464DE4F043240887FD8D2A3614740	0
1323	Kapoly	8671	010100000028FF493261F831409CBC6D4B895D4740	0
1324	Kánya	8667	01010000007AAFB55263113240E8E0F48997594740	0
1325	Tengőd	8668	0101000000E5E90198D7183240911A248E86594740	0
1326	Bábonymegyer	8658	0101000000817FA54E9B1E3240DEE0B0D936604740	0
1327	Nyim	8612	010100000024E0C61CBA1B32406D3CD862B7664740	0
1328	Nagyberény	8656	01010000008B23C5B6FB29324060F8D2252D664740	0
1329	Ádánd	8653	0101000000A6947C917527324063E87D88B26D4740	0
1330	Siójut	8652	0101000000AF473C3487233240CE9DAA8C90704740	0
1331	Balatonszabadi	8651	0101000000ABB184B531223240C5F3082417724740	0
1332	Somogyegres	8666	0101000000116A2B9BDE06324012E456F77E564740	0
1333	Zics	8672	010100000098DF6932E3F931408B1FBEA7CD564740	0
1334	Bedegkér	8666	01010000009373BDC85F0F324004DE6EEE54534740	0
1335	Nágocs	8674	01010000004029A44632F531400E0753DED8544740	0
1336	Miklósi	8669	010100000063A8D4360FFF3140435C9434DA524740	0
1337	Kára	7285	010100000065A1421ABA0232400FB56D18054F4740	0
1338	Gadács	7276	0101000000DA5FD10891013240EEAAAC12D1444740	0
1339	Somogyszil	7276	01010000002D81EF9128FF3140572CD90CCB424740	0
1340	Bonnya	7281	01010000003FDE509DB3E631409363FC451A4C4740	0
1341	Kisbárapáti	7282	0101000000F5335074B8DD314071D355702E4D4740	0
1342	Fiad	7282	0101000000F2C17CC38ED631403F202B5327514740	0
1343	Felsőmocsolád	7456	0101000000458AB78432D3314019F90670C4494740	0
1344	Ecseny	7457	0101000000C15DAC5E34DA31409098EA138A464740	0
1345	Polány	7458	01010000005947FA59D1C53140AB93331477474740	0
1346	Gamás	8685	0101000000435E6ADF37C33140AF1E9CF4634F4740	0
1347	Somogygeszti	7455	010100000099EF856E9BC831404811BE9C7E424740	0
1348	Alsóbogát	7443	0101000000E8829FDDC6BF3140252CE0545A414740	0
1349	Edde	7443	01010000009995928A6BB73140C4B70B282F434740	0
1350	Somogyjád	7443	010100000090D0E00044B7314006DF8F36E93E4740	0
1351	Várda	7442	0101000000DA5141EA1BBD31405B0C795FF03A4740	0
1352	Magyaregres	7441	010100000032152C1F93C63140EA72EF86D93A4740	0
1353	Hács	8694	01010000009D329298FBAF31408E739B70AF524740	0
1354	Kisberény	8693	01010000003D08A63FA0A83140BEDA519CA3514740	0
1355	Zselickislak	7400	01010000000BBD59DEB0CC3140253E7782FD274740	0
1356	Simonfa	7474	0101000000E2A5400BAED2314014C7269E58244740	0
1357	Kaposgyarmat	7473	010100000028F5C0221AE231409F8B2BD3D4234740	0
1358	Hedrehely	7533	0101000000256C89A6FDA63140FEF9111A1C194740	0
1359	Visnye	7533	010100000087CA75093DAD31403E4162BB7B184740	0
1360	Kőkút	7530	010100000066344D33389331407695A42199184740	0
1361	Rinyabesenyő	7552	01010000002CA0504F1F853140444882154C154740	0
1362	Homokszentgyörgy	7537	0101000000C87663E6A79131406133C005D90E4740	0
1363	Szenta	8849	01010000008CCA3CA87A2C3140AD84EE9238204740	0
1364	Bolhás	7517	0101000000CFDA6D179A453140327216F6B4214740	0
1365	Kaszó	7564	01010000003F94C3825639314058C6866EF6284740	0
1366	Somogycsicsó	8726	01010000000CD98A47F3213140668A94C1AC274740	0
1367	Csurgónagymarton	8840	0101000000E3CE3B04441531400283A44FAB254740	0
1368	Iharos	8726	010100000043F0AE69941831404FA84CD64D2B4740	0
1369	Porrogszentkirály	8858	010100000023C78CA6690A3140882D3D9AEA224740	0
1370	Porrog	8858	0101000000F8359204E108314021AB0084B4244740	0
1371	Porrogszentpál	8858	01010000009072E60DE6033140E085ADD9CA244740	0
1372	Somogybükkösd	8858	01010000000AD05BE102FD3040CF9959F047264740	0
1373	Őrtilos	8854	0101000000153CE0151CED3040A959565007244740	0
1374	Zákány	8852	0101000000DB5DB1D018F33040DFE6E84C35204740	0
1375	Zákányfalu	8853	01010000008B130434B6F23040E525A4DA4C234740	0
1376	Gyékényes	8851	0101000000D7FBE82F4F023140259C71755B1E4740	0
1377	Segesd	7562	0101000000394DFAD6E2583140BBB4E1B0342D4740	0
1378	Nemeskisfalud	8717	0101000000BA5A385A1F5E314055826A285A384740	0
1379	Szenyér	8717	0101000000BA3885F0C35E3140313B3025373B4740	0
1380	Nagyszakácsi	8739	0101000000764364A2525231400D778945673E4740	0
1381	Mezőcsokonya	7434	0101000000AAA0FDA3CAA5314086764EB340374740	0
1382	Somodor	7454	01010000007E0860B994D7314091C31671F03C4740	0
1383	Szentgáloskér	7465	0101000000F73FC05AB5E13140555689682A404740	0
1384	Kazsok	7274	010100000005E09F5225F63140EEC0EF952F3D4740	0
1385	Büssü	7273	010100000092E11D8590F6314084A91C49383A4740	0
1386	Patalom	7463	0101000000FFCC203EB0EB3140712596EF74394740	0
1387	Gölle	7272	0101000000C4510317750332409245F5317A384740	0
1388	Kisgyalán	7279	0101000000F943D8953BFA31403EF89A2F40364740	0
1389	Fonó	7271	0101000000E0C3808010F43140749593F540334740	0
1390	Kaposhomok	7261	0101000000021FCDA2C1EB3140218F858D572E4740	0
1391	Kaposkeresztúr	7258	0101000000CADE52CE17F731402FAF12E2802A4740	0
1392	Kercseliget	7256	0101000000C83FD8CE9C103240E112DB38BD294740	0
1393	Rinyakovácsi	7527	01010000003B843B61D3983140E140481630244740	0
1394	Kisbajom	7542	010100000058D1D50C5F7D3140274BADF71B274740	0
1395	Nagykorpád	7545	0101000000B22C98F8A37431401C85DA2560214740	0
1396	Vásárosbéc	7926	010100000039AB4F83B3B931406E2585C31C174740	0
1397	Magyarlukafa	7925	010100000015CCF33BA8C13140927307567A154740	0
1398	Somogyhárságy	7925	0101000000298128F3EAC531409240834D9D144740	0
1399	Somogyhatvan	7921	0101000000F96FB9556BB631407FAD0100B60D4740	0
1400	Merenye	7981	01010000004E8B0B51CFB231409E077767ED084740	0
1401	Patapoklosi	7923	0101000000B01F628385BF3140DE12CA0C65094740	0
1402	Tótszentgyörgy	7981	01010000000A95C9BAC9B7314087904EB8B2064740	0
1403	Nagydobsza	7985	01010000005FB12BD269AA3140F8E8C36977044740	0
1404	Kisdobsza	7985	0101000000F7521D177AA731406AE9C028F7034740	0
1405	Pettend	7980	0101000000A185048C2EB331407F390E1714004740	0
1406	Gyöngyösmellék	7972	01010000009F9916ABBCB331400CAD4ECE50FE4640	0
1407	Nemeske	7981	0101000000BBC50D0929B731409C525E2BA1024740	0
1408	Kistamási	7981	01010000005ADF1B9EB9B83140F54E609566014740	0
1409	Molvány	7981	0101000000D8ABD914D9BE31402F06C545A4034740	0
1410	Szörény	7976	0101000000DDC6B0D4C4AE3140FD93AE4FEFFB4640	0
1411	Felsőszentmárton	7968	0101000000B8CCE9B298B43140A7DA5D5617ED4640	0
1412	Drávakeresztúr	7967	01010000009977E62F3EC23140C6014FB571EB4640	0
1413	Markóc	7967	0101000000FE0E45813EC3314014DC59057BEE4640	0
1414	Bogdása	7966	010100000061FBC9181FCA314077F35487DCEF4640	0
1415	Drávaiványi	7960	01010000003DC21F3471D13140F74663A362EC4640	0
1416	Drávasztára	7960	01010000008578245E9ED23140EEAF1EF7ADE94640	0
1417	Sósvertike	7960	01010000006486D73F99DC3140507E9C7AEEEA4640	0
1418	Zaláta	7839	01010000006D40DF71E5E331402A3E99DAADE74640	0
1419	Kemse	7839	01010000009FFAACD799E93140BD7CA13660E94640	0
1420	Piskó	7838	0101000000B2F105D26AEF31405C284F0FC0E74640	0
1421	Vejti	7838	01010000007BCCF6D7E1F63140D1EF56F1A1E74640	0
1422	Lúzsok	7838	01010000007D6F78E68AF1314093E8C0CD3DEB4640	0
1423	Csányoszró	7964	01010000002BE6D65A4EE831400919C8B3CBF04640	0
1424	Nagycsány	7838	01010000003851A62C9EF13140629346167AEF4640	0
1425	Kákics	7958	0101000000164D672783DB314065726A6798F34640	0
1426	Marócsa	7960	0101000000A0A4C00298D03140C5CB2E7315F54640	0
1427	Endrőc	7973	0101000000AEA53627E5C431408800964B99F64640	0
1428	Bürüs	7973	0101000000C73BD1BF6EC23140C8B19A536EFB4640	0
1429	Várad	7973	01010000001A65A2ADEFBE314062C0ED64CBFC4640	0
1430	Hirics	7838	0101000000AD79443B5DFE3140393EFFE2BEE94640	0
1431	Vajszló	7838	0101000000F7AC6BB41CFC3140F33D23111AEE4640	0
1432	Besence	7838	0101000000F718517F62F731408F0BBDB497F24640	0
1433	Gilvánfa	7954	0101000000064DA665FFF531409E7EABD09BF54640	0
1434	Magyarmecske	7954	010100000098384DFAD6F63140434EA95CF2F84640	0
1435	Gyöngyfa	7954	0101000000555C6622B6F3314043CDEBE3FCFA4640	0
1436	Sumony	7960	01010000009D2743FA92EA3140389B3347FBFB4640	0
1437	Magyartelek	7954	0101000000A5F622DA8EFB314097642EBA06F94640	0
1438	Kisasszonyfa	7954	01010000002234828DEB01324031A880C52BF94640	0
1439	Ózdfalu	7836	01010000001EE9C2FEA105324012A7EE25E8F64640	0
1440	Páprád	7838	0101000000EFA42A12B8023240FBFC9C2743F24640	0
1441	Sámod	7841	0101000000A57D18C6820932401F2A32DF66ED4640	0
1442	Baranyahídvég	7841	01010000008318E8DA17063240E38FFD874FEC4640	0
1443	Kisszentmárton	7841	0101000000922639BB1006324029CFBC1C76E94640	0
1444	Adorjás	7841	0101000000499572086610324040941E3CC9EC4640	0
1445	Cún	7843	01010000007EA42D53381132405B295F2BFCE74640	0
1446	Szaporca	7843	0101000000C985144DB11A3240E547FC8A35E84640	0
1447	Tésenfa	7843	010100000094DA8B683B1E324094EAF1310EE84640	0
1448	Drávapiski	7843	01010000000FED6305BF193240D3F544D785EB4640	0
1449	Kórós	7841	0101000000C44E67DDF5143240DCF29194F4EE4640	0
1450	Bogádmindszent	7836	0101000000B03C484F910B3240ED2C7AA702F44640	0
1451	Téseny	7834	0101000000C41FEAE3460C32404D63207475F94640	0
1452	Velény	7951	0101000000D5720C6DA50C324002B3E7D77BFD4640	0
1453	Baksa	7834	0101000000EC3F7CAA54183240B3EE1F0BD1FA4640	0
1454	Tengeri	7834	01010000007FCF59B09E163240A3128DA493F64640	0
1455	Kisdér	7814	01010000008EC1D4E0C7203240B545E39A4CF84640	0
1456	Hegyszentmárton	7837	0101000000D32C75351E173240191B5F20ADF34640	0
1457	Siklósbodony	7814	0101000000DFD1B5E5121F3240067C235FAEF44640	0
1458	Babarcszőlős	7814	01010000006AFAEC80EB223240D162844B22F34640	0
1459	Ócsárd	7814	0101000000FE486CD2C8263240174E2DB6A4F74640	0
1460	Görcsöny	7833	0101000000C6F4296CAB223240F2C1210A1CFC4640	0
1461	Aranyosgadány	7671	0101000000E26DEF64811E3240CF9D054603014740	0
1462	Pogány	7666	0101000000BF2B82FFAD4232406412E456F7FD4640	0
1463	Peterd	7766	0101000000DB5E1CA6C75C3240201CFD7964FC4640	0
1464	Pécsdevecser	7766	010100000094FCE31824623240B1AB240DC9FA4640	0
1465	Kiskassa	7766	0101000000FD39BB6BBF653240B72D252603FA4640	0
1466	Somogyviszló	7924	010100000016A8209AD4C33140CFD666086C0E4740	0
1467	Basal	7923	010100000089F1F510E8C7314005F060D56A094740	0
1468	Mozsgó	7932	0101000000B78A0FFD24D831401E824F18390E4740	0
1469	Szentlászló	7936	0101000000111148D3EAD531407DEE5FB422144740	0
1470	Ibafa	7935	01010000006E0C4B4DCCEA3140B7291E17D5134740	0
1471	Almáskeresztúr	7932	0101000000B334A61600E53140252367614F0F4740	0
1472	Dinnyeberki	7683	01010000007626231DD4F431401F8FCF1A720C4740	0
1473	Horváthertelend	7935	0101000000F5E10FF571ED31404DC34BCBA3164740	0
1474	Csebény	7935	01010000008414973ECFEC314055F42CAD2B184740	0
1475	Szágy	7383	0101000000E73A8DB454F2314003C1D2AF631C4740	0
1476	Tormás	7383	0101000000430A54B593FD3140108C2892541D4740	0
1477	Baranyaszentgyörgy	7383	0101000000480BE1E2F20332402EAD86C43D1F4740	0
1478	Gödre	7386	01010000002304F57700F931403F654689A7244740	0
1479	Baranyajenő	7384	0101000000F209D9791B0B3240556D927AAA224740	0
1480	Mindszentgodisa	7391	0101000000A327C00BB612324028BDCA35601D4740	0
1481	Palé	7370	0101000000C40AB77C2413324053A2DB018D214740	0
1482	Oroszló	7370	010100000005F1CBAA191F324040868E1D541C4740	0
1483	Szilvás	7811	0101000000BB6477DC4B3332407C2766BD18FB4640	0
1484	Szőke	7833	01010000001199A8948D2F3240E400B0F0E4FA4640	0
1485	Szava	7813	01010000007D14BF73392D3240AABB0DC578F34640	0
1486	Garé	7812	0101000000809FCC9AB3313240C3EA347799F54640	0
1487	Bisse	7811	0101000000C531DCCA5C423240AB83729131F44640	0
1488	Csarnóta	7811	0101000000E4D06C68143832400F536C1679F24640	0
1489	Rádfalva	7817	010100000037A5619DCF1F3240C1B057B329EE4640	0
1490	Kistótfalu	7768	0101000000C5C32055B94F3240F70C970B4BF44640	0
1491	Márfa	7817	0101000000E08F91A2842F3240C16158B4EFED4640	0
1492	Diósviszló	7817	0101000000AB1386B7BD293240AD2B0BCB44F04640	0
1493	Drávacsehi	7849	0101000000E8FDDA55A32A3240489A8933D0E74640	0
1494	Drávacsepely	7846	01010000005187156EF92232402A8826F50AEA4640	0
1495	Matty	7854	01010000002AD2B30F6843324046DA7C128EE54640	0
1496	Alsószentmárton	7826	010100000074BC5D8A064E324011F637B23CE54640	0
1497	Drávapalkonya	7850	0101000000FF83FEF8012E324009EEF60FD8E64640	0
1498	Ipacsfa	7847	0101000000F87AAD3A61343240690D94CACAEA4640	0
1499	Kásád	7827	0101000000DB9953138E66324029D3C32BA4E34640	0
1500	Siklósnagyfalu	7823	0101000000361C3B4D0B5D3240F26A6FA6F8E84640	0
1501	Old	7824	0101000000D6F95C120C5A32403F027FF8F9E44640	0
1502	Egyházasharaszti	7824	010100000054556820965532400CD17C2997E74640	0
1503	Kisharsány	7800	0101000000C4CB7800305D32407661B5430DEE4640	0
1504	Vokány	7768	01010000009E44847F115632409C757C6AABF44640	0
1505	Kistapolca	7823	01010000002F63546353623240F3F631303CE94640	0
1506	Nagytótfalu	7800	01010000003B8501F0F4573240FD29FAE879EE4640	0
1507	Illocska	7775	01010000008C4D863EB38532408942CBBA7FE64640	0
1508	Lapáncsa	7775	0101000000152A49E878803240A217A4CFFDE84640	0
1509	Nagyharsány	7822	0101000000FB928D075B66324057056A3178EC4640	0
1510	Beremend	7827	0101000000C83D02243F6F32401976734C71E44640	0
1511	Ivánbattyán	7772	0101000000653B3A09006B3240553CE41C2BF44640	0
1512	Márok	7774	0101000000DAB6DE252781324020306A5265F04640	0
1513	Kislippó	7775	0101000000FEDC8607838732401CE7DB27ECE94640	0
1514	Magyarbóly	7775	0101000000D92A1C9CE37D3240F7BAFBD291EB4640	0
1515	Lippó	7781	0101000000B7CAB84EC8913240D48041D2A7EE4640	0
1516	Sárok	7781	01010000009D09F258D89C324030CDBE3CAEEB4640	0
1517	Ivándárda	7781	0101000000B123C44B26973240BC35FAE29CEA4640	0
1518	Kisjakabfalva	7773	0101000000C8331E5B856F3240469B3E9699F24640	0
1519	Sátorhely	7785	0101000000D8AA1386B7A132400CAB1D6A80F84640	0
1520	Udvar	7718	01010000003365F1ACEEA832405F16C90D75F34640	0
1521	Majs	7783	010100000090C18A53AD9932400660A86851F44640	0
1522	Bezedek	7782	01010000008CD992551196324020CF2EDFFAEE4640	0
1523	Babarc	7757	0101000000E01C6448048D32402FA699EE75004740	0
1524	Szajk	7753	0101000000741AB336D78832400BA1DEE753FE4640	0
1525	Versend	7752	01010000005224045031833240AC20617369FF4640	0
1526	Monyoród	7751	010100000093DC065A267A32408F5D58ED50014740	0
1527	Kátoly	7661	01010000000B11CBC1C773324008D451C4D8074740	0
1528	Berkesd	7664	0101000000B3D36AA39568324015AA9B8BBF094740	0
1529	Pereked	7664	0101000000025A0410885F3240B94780E4E70B4740	0
1530	Szellő	7661	010100000091D10149D87532400E3B42BC64094740	0
1531	Máriakéménd	7663	0101000000FC7E202F5A763240613832EAB5034740	0
1532	Lánycsók	7759	010100000040571124A59F32409D5ECE119E004740	0
1533	Kisnyárád	7759	01010000009BD31BA496903240C04B5FBEAB044740	0
1534	Liptód	7757	010100000040CFB0620284324094F59B89E9054740	0
1535	Zengővárkony	7720	0101000000300043458B6E3240B04C09D2D6154740	0
1536	Óbánya	7695	01010000006C34CA445B693240BE17BA6D3A1C4740	0
1537	Mecseknádasd	7695	0101000000C9EEB897EA763240B386414FB91C4740	0
1538	Hidas	7696	0101000000BC2429441B7F3240C042418413214740	0
1539	Martonfa	7720	01010000002EA5D35F545F324088FCE9F5DD0E4740	0
1540	Szilágy	7664	0101000000120654EEF4673240DAAA24B20F0D4740	0
1541	Erzsébet	7661	01010000007D8857A368753240DFBF7971E20C4740	0
1542	Kékesd	7661	01010000000483B57B037932403F47F5E7EC0C4740	0
1543	Nagyhajmás	7343	010100000007E68D38094A3240F3114251EA2F4740	0
1544	Kisbudmér	7756	0101000000EF7F3628507232402D00321933F54640	0
1545	Szalatnak	7334	0101000000C62BB583B647324099FAD40C04254740	0
1546	Mekényes	7344	0101000000E89A6E7E68553240EB025E66D8314740	0
1547	Bár	7711	01010000008692C9A99DB73240CBBC55D7A1064740	0
1548	Ófalu	7695	01010000007DE31016BA873240EFAA07CC431C4740	0
1549	Nagybudmér	7756	01010000005C99A6BEE2713240A59993BCDFF74640	0
1550	Homorúd	7716	0101000000D1CDFE40B9C93240AB121BE20EFE4640	0
1551	Okorág	7957	01010000004747286CF5DF3140DD9156218AF64640	0
1552	Vékény	7333	01010000003B04E9BD8C573240F805AA3583224740	0
1553	Köblény	7334	0101000000F18C6C9D6E4D3240B5A4A31CCC254740	0
1554	Meződ	7370	010100000081CD3978261A3240F71E2E39EE244740	0
1555	Vázsnok	7370	0101000000BB93F4D5FA1F3240AEB1F09AFC214740	0
1556	Jágónak	7357	0101000000F1E890E56E173240771ECB715D284740	0
1557	Kaposszekcső	7361	0101000000E98B738A44213240AAD95E66332A4740	0
1558	Csikóstőttős	7341	0101000000772167ABDC273240015D4590942B4740	0
1559	Kapospula	7251	0101000000816ACDA0EB18324035F169A917304740	0
1560	Nak	7215	01010000007BE871CE3E0D3240F521B946153D4740	0
1561	Lápafő	7214	0101000000D3139678400F324061E8C715CD414740	0
1562	Várong	7214	010100000048540328A10B32407AFAAD426F434740	0
1563	Szakcs	7213	0101000000A8B118D0661C3240D4484BE5ED444740	0
1564	Dalmand	7211	01010000008FB0034246313240EE47E581233F4740	0
1565	Nagyszokoly	7097	010100000098CC672F9135324048B599547E5C4740	0
1566	Magyarkeszi	7098	0101000000ECE52D0DB23932409F718687D55F4740	0
1567	Fürged	7087	0101000000A9A67FA4E34F3240F43C6EAE505C4740	0
1568	Felsőnyék	7099	01010000007912222A9E4A32406ED113E005654740	0
1569	Ozora	7086	010100000036882018516632409D06561F59604740	0
1570	Gyulaj	7227	010100000075FBF6BF6D4B324094A69C8AAF404740	0
1571	Lengyel	7184	0101000000888384285F5E3240356FE6A100304740	0
1572	Mucsfa	7185	0101000000E723DF5B476B324012C138B8742D4740	0
1573	Kisvejke	7183	0101000000D29B40C7FD6932408289E4D0C7304740	0
1574	Nagyvejke	7186	0101000000ECC3D55CC9713240CDB5C3BA4C304740	0
1575	Györe	7352	01010000008AF5FC1F166632400805A568E5254740	0
1576	Váralja	7354	0101000000C703DBD2B46D324053C6641646224740	0
1577	Kismányok	7356	010100000028C1D1448E793240153026A204234740	0
1578	Cikó	7161	010100000024EB15BB228F32401CD3139678204740	0
1579	Mőcsény	7163	010100000029E78BBD17973240CBC232912D214740	0
1580	Bátaapáti	7164	010100000017B1F446529932406CDBE67C671C4740	0
1581	Mórágy	7165	0101000000A661F88898A432407EC9213DA01B4740	0
1582	Grábóc	7162	01010000005841672D609B32401E75CF1500254740	0
1583	Alsónána	7147	010100000077418EF7F4A832408479347ADA1F4740	0
1584	Kakasd	7122	01010000007C53A236BB9732403B87D79A522C4740	0
1585	Alsónyék	7148	0101000000489858CFFFBB32400C6F7B270B1A4740	0
1586	Szakály	7192	0101000000A61AACEE4762324084413E8D20434740	0
1587	Mucsi	7195	010100000020DE29D31E65324094788A66AF364740	0
1588	Csöde	8999	0101000000533CD3F0D28A30404ED4D2DC0A6B4740	0
1589	Zalabaksa	8971	01010000003A84E0A7608D3040F2536694785A4740	0
1590	Magyarföld	8973	0101000000E6FC5E549C6A304021C610A562634740	0
1591	Ramocsa	8973	010100000085178E31C1723040337BEAA232634740	0
1592	Felsőszenterzsébet	8973	01010000009FBAA8CC837430400A87399C54604740	0
1593	Alsószenterzsébet	8973	01010000005F341AAF2F7A30401A7332CC645F4740	0
1594	Kerkakutas	8973	0101000000879A32816C813040D971683634614740	0
1595	Kozmadombja	8988	01010000001962ABBAFD8C30407CFC941925624740	0
1596	Kálócfa	8988	0101000000B1D52F229B8F3040008C67D0D0604740	0
1597	Szentgyörgyvölgy	8975	0101000000AAFEF79628693040808EA042BF5C4740	0
1598	Nemesnép	8976	0101000000235BA7DB237530406467C00FBD594740	0
1599	Lendvajakabfa	8977	0101000000CC84BAA35A713040AFD172A087564740	0
1600	Baglad	8977	0101000000335D3E48057C3040CED1996A1C574740	0
1601	Resznek	8977	01010000003BAD365A697930406CC0D65BB9544740	0
1602	Bödeháza	8969	010100000094BCDF0D0E67304092C4DCFF11524740	0
1603	Belsősárd	8978	010100000071BF8DDEBA7830404411F7FD40524740	0
1604	Zalaszombatfa	8969	0101000000B0AA5E7EA771304079F87CDE9E514740	0
1605	Szijártóháza	8969	0101000000E7C2ED75F76F3040B69DB64604514740	0
1606	Gáborjánháza	8969	010100000076244D72766B304046065ED2BD504740	0
1607	Külsősárd	8978	010100000006C0D3BF7F7C3040D14CE60E51504740	0
1608	Kerkabarabás	8971	0101000000BBA0191FC18E304088FF2A76EA564740	0
1609	Lendvadedes	8978	0101000000DD7E541E38823040CE8DE9094B4A4740	0
1610	Gosztola	8978	01010000000757E5E72B8730409483D904184B4740	0
1611	Lovászi	8878	01010000007FDFBF79718E3040C800F50B1B474740	0
1612	Kerkateskánd	8879	01010000003238EFA42A9230406CCABA2473494740	0
1613	Szécsisziget	8879	01010000006041F56ADB9730406A95AAFE52494740	0
1614	Tormafölde	8876	0101000000A0DDC60B8E9730409AD832CF00454740	0
1615	Tornyiszentmiklós	8877	0101000000447122556F8E3040DF6124C511424740	0
1616	Dobri	8874	0101000000A52C431CEB9430402E56D4601A424740	0
1617	Kerkaszentkirály	8874	0101000000F0BCF9B259943040D71C7B5116404740	0
1618	Csörnyeföld	8873	0101000000B271B32E24A23040556B6116DA3F4740	0
1619	Iklódbördőce	8958	010100000059688C7B989C30406AEC5C62764D4740	0
1620	Csömödér	8957	010100000000E48409A3A33040FC5EF9E2414E4740	0
1621	Páka	8956	01010000003EF89A2F40A63040840F255AF24B4740	0
1622	Hernyék	8957	0101000000CC9E5FEF59A43040977329AE2A534740	0
1623	Kissziget	8957	0101000000D0C831A369AA304070F893E7B04F4740	0
1624	Ortaháza	8954	010100000072F8495A96AE3040A6A43D14BB4F4740	0
1625	Zebecke	8957	0101000000A6118EB4AFAF30406C5622F543524740	0
1626	Csertalakos	8951	01010000003A50F1C9D4B23040DF0841FD1D524740	0
1627	Pördefölde	8956	01010000008CE6B79ED7B43040FD512F53EE4A4740	0
1628	Kányavár	8956	010100000047CDB2823AAE3040DC7E9EAB52494740	0
1629	Maróc	8888	010100000064E3665D48AA3040222A9EC431464740	0
1630	Lispeszentadorján	8888	0101000000B29C84D217B23040E53796C162454740	0
1631	Lasztonya	8887	0101000000461E2D735FB73040473A03232F474740	0
1632	Bázakerettye	8887	0101000000411A040C81BA30408DCE9E701B434740	0
1633	Kiscsehi	8888	010100000067CB03A271AC3040555C6622B6424740	0
1634	Szentmargitfalva	8872	0101000000091B9E5E29A930408B9F6B04873F4740	0
1635	Muraszemenye	8872	01010000009B00C3F2E79F3040537F187CF53C4740	0
1636	Murarátka	8868	01010000008FA850DD5CAC30408995760F753A4740	0
1637	Zajk	8868	010100000054E9825550B83040FB73D190F13D4740	0
1638	Kistolmács	8868	010100000098512CB7B4C0304014D44BE71E3E4740	0
1639	Borsfa	8885	010100000085B762DA92C830401B8CC7FB27404740	0
1640	Valkonya	8885	0101000000F0EA0BD759CF30402B9A18DC20404740	0
1641	Bánokszentgyörgy	8891	01010000009AAAC5F18DC8304018755204DD454740	0
1642	Várfölde	8891	0101000000CA92944FEAC23040016E162F16474740	0
1643	Nova	8948	0101000000A0DDC60B8EAD304092F01879B4574740	0
1644	Pusztaapáti	8986	010100000026B094C0419C3040AA944330B3614740	0
1645	Keménfa	8995	0101000000FFD2FDF73BA330407396A3117D6B4740	0
1646	Zalaháshágy	8997	01010000007155D97745A030409F5CAED925724740	0
1647	Vaspör	8998	01010000001F204E16ADA4304098C51FA056754740	0
1648	Zalaboldogfa	8992	0101000000FA7FD59123C530403608CE740A734740	0
1649	Kiskutas	8911	01010000002BF697DD93CB30409C4DEC46C4744740	0
1650	Nagykutas	8911	01010000005782209B3FCD30404F8AFB3493764740	0
1651	Lakhegy	8913	0101000000C9B5FC1B0FD530405167EE21E1794740	0
1652	Kispáli	8912	01010000000D33349E08D43040D7D0178C5B744740	0
1653	Nagypáli	8912	0101000000D3C66C2464D7304021448D9D4B744740	0
1654	Egervár	8913	0101000000D7A0D4038BDA304020521DBCC0774740	0
1655	Gősfa	8913	0101000000F56E87E17EDB30403CDEE4B7E87A4740	0
1656	Vasboldogasszony	8914	01010000006BE6DA615DDE3040B1E6B63302794740	0
1657	Zalaszentiván	8921	0101000000C96B6F01B2E53040D52DF13625724740	0
1658	Alibánfa	8921	0101000000421658B6C5EB304058045A153C714740	0
1659	Pethőhenye	8921	0101000000E6F10FB633EB304075875E903E704740	0
1660	Nemesapáti	8923	0101000000F9201510A4F230404315489A896F4740	0
1661	Alsónemesapáti	8924	010100000017EBC0DE69EF3040DF20B5E44C6D4740	0
1662	Kemendollár	8931	010100000029F51BDC8CF13040C9772975C9734740	0
1663	Pókaszepetk	8932	010100000025694826F1F73040DED6CC107D764740	0
1664	Zalaistvánd	8932	010100000077BCC96FD1F93040ADF0D35D7E754740	0
1665	Gyűrűs	8932	01010000009F8F32E202FE30406946F58C33714740	0
1666	Vöckönd	8931	01010000004C3E2C8A0DF4304070044E5BC8714740	0
1667	Orbányosfa	8935	0101000000842E3C8ACEFB304023AFBD05C86C4740	0
1668	Kisbucsa	8926	0101000000FF113C7430F13040586F795160684740	0
1669	Bezeréd	8934	0101000000D14CE60E51033140FBFC9C27436F4740	0
1670	Padár	8935	0101000000882359D130043140E025DD3B0F6D4740	0
1671	Almásháza	8935	0101000000C79860DD1D0C31400FC5D3E1D76B4740	0
1672	Kallósd	8785	0101000000CA598E46F40F3140A4BCA0CF916F4740	0
1673	Dötk	8799	0101000000479F45A5C7013140B115342DB1784740	0
1674	Pakod	8799	010100000083F5245580FE30403C4F97207E7A4740	0
1675	Zalabér	8798	01010000002C34C63D4C073140F017B325AB7C4740	0
1676	Batyk	8797	0101000000990F087426093140B5C6FBCCB47E4740	0
1677	Zalavég	8792	010100000097040363D806314047E7FC14C7804740	0
1678	Türje	8796	0101000000A609DB4FC61A3140E5FE34FFF97D4740	0
1679	Szalapa	8341	01010000006891ED7C3F253140A43A7881ED7E4740	0
1680	Kisvásárhely	8341	0101000000CBF1AF8ADC323140E322ADE75A7F4740	0
1681	Mihályfa	8341	0101000000F53F0AE8CF303140A1AF6A5A737D4740	0
1682	Óhíd	8342	0101000000567A127DE32A31408D806500037B4740	0
1683	Kisgörbő	8356	010100000098A432C51C283140A4575E4DF9774740	0
1684	Sümegcsehi	8357	0101000000F53CC967C337314082D0D5B1A5784740	0
1685	Döbröce	8357	0101000000EB8ABE277B303140165BF745F8774740	0
1686	Nagygörbő	8356	0101000000E2C0F572E92D314006EF50B92E774740	0
1687	Zalaszentlászló	8788	0101000000E39A4C26B81C31404C2D003219704740	0
1688	Sénye	8788	010100000009652B79862231406EC6C4419D724740	0
1689	Vindornyaszőlős	8355	0101000000DA6DBCE0782731409F330E9A02734740	0
1690	Vindornyalak	8353	0101000000358AF6C2AE3131405744A8AD6C714740	0
1691	Zalaköveskút	8354	01010000004051D9B0A6243140CFBD874B8E6C4740	0
1692	Vindornyafok	8354	0101000000766C04E2752D3140B7F704E4A66D4740	0
1693	Karmacs	8354	0101000000F96A47718E2C3140C1142F60136B4740	0
1694	Nemesbük	8371	01010000004DC2E0F5F4243140840200112C694740	0
1695	Rezi	8373	01010000002BC0779B37383140F1E72510C06B4740	0
1696	Várvölgy	8316	01010000008857A3682F4C31405E83BEF4F66E4740	0
1697	Vállus	8316	01010000001E6CB1DB674D3140BB004576EF6B4740	0
1698	Nemespátró	8857	0101000000F95F538C980031402580513871294740	0
1699	Liszó	8831	010100000019E25817B7013140AAACB717E22E4740	0
1700	Surd	8856	010100000025A314BE08F83040444074F7EF284740	0
1701	Belezna	8855	0101000000D4B3C5DA84F030409953B8D4F7294740	0
1702	Fityeház	8835	01010000005981C6F1E8E73040D79AF749FF2F4740	0
1703	Murakeresztúr	8834	0101000000DCF0603024E0304062FC8FA7402E4740	0
1704	Semjénháza	8862	0101000000839C9C46FFD830408F07115FDC324740	0
1705	Molnári	8863	0101000000D8BF46EDD9D430400E0176244D314740	0
1706	Szepetnek	8861	010100000036FBA82B44E63040FBBB2D477E374740	0
1707	Eszteregnye	8882	0101000000A1FFD42E5CE230405D28AAC8323C4740	0
1708	Rigyác	8883	01010000005F5331DF0BDD30404D24E2F7803B4740	0
1709	Petrivente	8866	0101000000569BFF571DD730404992318859384740	0
1710	Tótszentmárton	8865	01010000009CC5E63E94CD3040A4EA0DAD04364740	0
1711	Tótszerdahely	8864	010100000052499D8026CC3040CE273CB203334740	0
1712	Oltárc	8886	01010000005F398C930CD430401A52A0AA9D434740	0
1713	Bucsuta	8893	01010000007F1FC48487D53040973D642541484740	0
1714	Szentliszló	8893	01010000008ED4319D8CD230405F6864462E4A4740	0
1715	Pusztamagyaród	8895	0101000000245DD83FF4D130400391EAE0054D4740	0
1716	Szentpéterfölde	8953	0101000000D0550449E9C130400A25389AC84E4740	0
1717	Pusztaederics	8946	010100000025D698C6E5CC3040A774B0FECF514740	0
1718	Pusztaszentlászló	8896	0101000000566BBCCF4CD730406BE2D3522F514740	0
1719	Gutorfölde	8951	010100000007FD964A89BC3040CB8866F915524740	0
1720	Tófej	8946	01010000005A4D32CDCFCC3040A139A1C673554740	0
1721	Szentkozmadombja	8947	01010000005AEC9BA0F2C230401AB9139106574740	0
1722	Zalatárnok	8947	0101000000BA17F3CEFCC13040FBF6BF6DB7594740	0
1723	Baktüttös	8946	010100000035C9343FA3D13040AEA47098C3594740	0
1724	Barlahida	8948	0101000000875682209BB33040A36F777BB55B4740	0
1725	Petrikeresztúr	8984	0101000000B7C2AA306CB930408F09E7093A5E4740	0
1726	Ormándlak	8983	01010000008A952C825AC1304018D9846A39614740	0
1727	Lickóvadamos	8981	0101000000AC30C73C3CC53040182DF64D505F4740	0
1728	Söjtör	8897	010100000018343EDD8ADA3040B9D62835C5554740	0
1729	Börzönce	8772	0101000000C68DB68542E330400DC9247E204A4740	0
1730	Pálfiszeg	8990	0101000000F69A1E1494BA3040C19D55B0D7634740	0
1731	Böde	8991	0101000000F761180B9EB730404C773293036B4740	0
1732	Hottó	8991	0101000000CBFA287EE7C03040D9E50066636C4740	0
1733	Bocfölde	8943	0101000000207FC40A12D8304033C005D9B2634740	0
1734	Csatár	8943	01010000003101648D1FDD30400D0A39A572634740	0
1735	Nemeshetés	8928	01010000008FFAEB1516EA3040037EE8DDB3664740	0
1736	Búcsúszentlászló	8925	0101000000FEA1F4E049EE3040329EF7B5E4644740	0
1737	Nemessándorháza	8925	01010000002ADC97D821F33040EAEE95D464644740	0
1738	Misefa	8935	01010000008485EEEDF1FB3040E1E35D3F0E674740	0
1739	Nemesrádó	8915	010100000029626C7C81FE3040B1659E019A634740	0
1740	Zalaigrice	8761	01010000006967E2676D023140DBB639DF995F4740	0
1741	Tilaj	8782	0101000000395DBB59280C3140B72572C119674740	0
1742	Gétye	8762	0101000000A5D8D138D41131402E8AC33EA6614740	0
1743	Bókaháza	8741	010100000035DA05DE241B3140FD778E1205634740	0
1744	Szentgyörgyvár	8393	01010000009A4B6029812131404A8AD9DCE2604740	0
1745	Alsópáhok	8394	010100000051D5A997842C31401F752ACF72614740	0
1746	Zalaszentmárton	8764	0101000000053CC49A25103140D8FAD813135A4740	0
1747	Esztergályhorváti	8742	0101000000216CC207C01B3140544DB5BBAC594740	0
1748	Zalavár	8392	01010000006B4CE37217283140DFA63FFB91554740	0
1749	Egeraracsa	8765	01010000000F3B9D75D713314078D503E621564740	0
1750	Dióskál	8764	01010000000D045CEBE60D3140A88306AC66564740	0
1751	Balatonmagyaród	8753	0101000000A12A4B19DD2C3140720F536C164C4740	0
1752	Pölöskefő	8773	0101000000CDDB227A63F23040C4AE9234244D4740	0
1753	Gelse	8774	0101000000D9EDB3CA4CFD3040C62D8B2E144D4740	0
1754	Kacorlak	8773	01010000000F18DAEF3FF430400042DAB573494740	0
1755	Magyarszerdahely	8776	010100000095607138F3EF304089C1B28817474740	0
1756	Magyarszentmiklós	8776	0101000000D4AB12769BEF30403B5C61B0D1444740	0
1757	Fűzvölgy	8777	0101000000FEB4F6E39BF030400C3D62F4DC424740	0
1758	Hosszúvölgy	8777	0101000000D72835C52DEE30400C2DA17197414740	0
1759	Homokkomárom	8777	0101000000B3E3D06C68EA30404453D1B3B4404740	0
1760	Újudvar	8778	0101000000D28BDAFD2AFC30404BB1A371A8444740	0
1761	Nagybakónak	8821	01010000002669A3DF630B31402D0B81B79B464740	0
1762	Zalaújlak	8822	0101000000208F2AD4E4133140A8154B36C3474740	0
1763	Csapi	8756	0101000000E23D079623163140C7B205291D444740	0
1764	Kisrécse	8756	0101000000EE9EF29EB90F3140CD1BCCCB06404740	0
1765	Nagyrécse	8756	0101000000E4E59FCF360D3140DB7FAEC78E3E4740	0
1766	Galambok	8754	0101000000A4784B283320314061BDF671D9424740	0
1767	Sand	8824	01010000009E62D520CC1F3140527C218903364740	0
1768	Miháld	8825	0101000000F908466F02213140BC5B59A2B3394740	0
1769	Pat	8825	010100000083161230BA2E3140A9CD4939A9384740	0
1770	Gelsesziget	8774	0101000000520C906802FD3040D6743DD175484740	0
1771	Újiráz	4146	0101000000A4124317795A3540A70EA8ED157E4740	0
1772	Csökmő	4145	01010000004FEED2E17C4B35400CEC8C4A45844740	0
1773	Darvas	4144	0101000000394778D6C9563540D955ED3FD78C4740	0
1774	Vekerd	4143	010100000043F3EFE9A0673540C83AC1A3328C4740	0
1775	Magyarhomorog	4137	01010000007429AE2AFB8A3540272F3201BF824740	0
1776	Körösszakál	4136	01010000008055E4C6E39835401A0923AC7C824740	0
1777	Körösszegapáti	4135	01010000002761F07A7AA2354058079B9548854740	0
1778	Berekböszörmény	4116	010100000053D048DFFFAE35408FFBFB3152884740	0
1779	Told	4117	0101000000DB3521AD31A43540165DCDF0558F4740	0
1780	Mezősas	4134	01010000008A0E379666913540C81DDBD7268E4740	0
1781	Mezőpeterd	4118	0101000000E9103812689E354034EC415255954740	0
1782	Váncsod	4119	010100000054D7EB27ADA33540A0D7E95102994740	0
1783	Bojt	4114	010100000085741D4F70BC3540A5074F3283984740	0
1784	Esztár	4124	010100000002E43A7C88C63540BF89D7AB7EA44740	0
1785	Hencida	4123	01010000004605F3FC0EB2354005F1CBAA19A04740	0
1786	Gáborján	4122	0101000000352905DD5EA83540B0517BB6B39E4740	0
1787	Szentpéterszeg	4121	010100000094CF3CCAD29E3540BDB89E32489E4740	0
1788	Konyár	4133	0101000000B31D9D0480AC3540CBFE2F8D15A94740	0
1789	Tépe	4132	01010000006F2D93E178923540BB3F83F2E3A84740	0
1790	Bakonszeg	4164	010100000066A60FB8097235402BC9F08E42984740	0
1791	Zsáka	4142	0101000000277623E29C6F35401D1142F630914740	0
1792	Furta	4141	010100000079A235502A7535401A01704793904740	0
1793	Nagyrábé	4173	0101000000307A13E8B8513540E21236F22F9A4740	0
1794	Bihartorda	4174	0101000000A1478C9E5B5A35404EF04DD3679B4740	0
1795	Bihardancsháza	4175	0101000000E0867368EC503540DF8211A04B9D4740	0
1796	Biharnagybajom	4172	01010000006580553F803A35401DA1B0D52F9B4740	0
1797	Sárrétudvari	4171	010100000092D8A49185303540FC04AB459F9E4740	0
1798	Szerep	4163	010100000046B247A819243540CED1996A1C9D4740	0
1799	Báránd	4161	0101000000FCF785FCD8393540100533A660A54740	0
1800	Tetétlen	4184	01010000005B5CE333D94D3540B7E0FBD126A84740	0
1801	Sáp	4176	01010000001ABDBFE6C15A3540D9DC877258A04740	0
1802	Földes	4177	010100000094782FAD3C5D35408CC11E6EE2A44740	0
1803	Hortobágy	4071	01010000003BEDDFAB0C273540F6589F1793CA4740	0
1804	Nagyhegyes	4064	0101000000EE28290BBA5835403FB78608EEC44740	0
1805	Ebes	4211	010100000024624A24D17D3540411C357051BC4740	0
1806	Hajdúszovát	4212	010100000073ABD6789F793540BC0FF6DCF8B14740	0
1807	Hajdúbagos	4273	0101000000EB1A2D077AAA354050D147CFE3B14740	0
1808	Sáránd	4272	0101000000003F3E7CF49F3540D9C23DE0CBB44740	0
1809	Mikepércs	4271	0101000000CDFF50D5A9A13540DE8BD42071B84740	0
1810	Újszentmargita	4065	010100000065D87278521A35404FE3834314DD4740	0
1811	Folyás	4090	0101000000513FB9B76C223540029EB47059E74740	0
1812	Görbeháza	4075	0101000000295316CFEA3C3540C0FE356ACFE84740	0
1813	Újtikos	4096	01010000008A332B80CE2B3540CAE59A5D52F54740	0
1814	Tiszagyulaháza	4097	0101000000FBD63D682C243540559EE51EB7F84740	0
1815	Álmosd	4285	0101000000B4E32B26DBFB3540EF1417EC2BB54740	0
1816	Kokad	4284	01010000005C85DE2C6FEE3540611C5C3AE6B34740	0
1817	Bagamér	4286	01010000002775B80CEEFD3540508A56EE05B94740	0
1818	Újléta	4288	0101000000FB70355772E03540E16822C731BB4740	0
1819	Nyírábrány	4264	0101000000C45675FB5105364010A0956A55C64740	0
1820	Nyírmártonfalva	4263	010100000099FB9A9B25E73540C2548E249CCA4740	0
1821	Nyíracsád	4262	0101000000DDC13EF0E7F835408516235C12CD4740	0
1822	Fülöp	4266	010100000048A9DFE0660E364018714BF5AECC4740	0
1823	Bocskaikert	4241	01010000004B5B5CE333A935409C6C0377A0D24740	0
1824	Pilisszentlélek	0	0101000000F7393E5A9CD73240E4068DAA70DD4740	0
1825	Bakóca	7393	0101000000A2E6502BF1FF314039317FE0851A4740	0
1826	Kisbeszterce	7391	0101000000BF6EC78AD0083240F180B229571A4740	0
1827	Újsolt	6321	01010000007F72CA92EF1E33406C9B3D2BC46F4740	0
1828	Dunatetétlen	6325	010100000011757A39471833407A2E9D20FB604740	0
1829	Harta	6326	0101000000C435882018073340B130E994EC584740	0
1830	Öregcsertő	6311	01010000004D43F9275D1B33400E805DF2E4414740	0
1831	Imrehegy	6238	0101000000A74FBC14684D33403C8ACE8D443E4740	0
1832	Rém	6446	0101000000555E3CCD132533406BE399E1501F4740	0
1833	Borota	6445	0101000000D17C29972139334088DDD2C501224740	0
1834	Kéleshalom	6444	010100000035A781D547483340F673547FCE2E4740	0
1835	Érsekcsanád	6347	01010000009A2E7A5D75FB3240C160EDDE40204740	0
1836	Dusnok	6353	0101000000541B9C887EF53240529E7939EC314740	0
1837	Szeremle	6512	0101000000377F5D972BE132403D505DAF9F124740	0
1838	Bátmonostor	6528	0101000000B26895F48BED324011E6D1E8690D4740	0
1839	Vaskút	6521	0101000000ADE3535B45FC32403BAC70CB470E4740	0
1840	Nagybaracska	6527	0101000000D8182AB5CDE73240B36554747F054740	0
1841	Csátalja	6523	0101000000DC813AE5D1F132400DB55CECAC044740	0
1842	Gara	6522	01010000001822A7AFE7093340043DD4B661044740	0
1843	Dávod	6524	01010000002573D13538EC32407D9D8A0A8BFF4640	0
1844	Hercegszántó	6525	0101000000E449D23593EF324090C18A53ADF94640	0
1845	Bácsszentgyörgy	6511	01010000006054F76D2D0A334018552BB8C4FC4640	0
1846	Madaras	6456	0101000000F1506FA186423340548D5E0D50074740	0
1847	Katymár	6455	0101000000D0E16B19BA353340FFA2BA6F6B044740	0
1848	Bácsborsód	6454	0101000000CABED0C88C2833407BC7DFAC770C4740	0
1849	Bácsbokod	6453	0101000000262488A9E3273340B732970AE00F4740	0
1850	Mátételke	6452	010100000066EC95C338473340FB2C85F6A0144740	0
1851	Kunbaja	6435	010100000069064C3B906C33403EE136644D0B4740	0
1852	Csikéria	6424	01010000005AB741EDB778334027B04A3327104740	0
1853	Bácsszőlős	6425	010100000027F33405D76B3340A2725D424F114740	0
1854	Zsana	6411	0101000000CB4DD4D2DCA83340513D88539C304740	0
1855	Harkakötöny	6136	010100000045550218859B334024319CC6513B4740	0
1856	Csólyospálos	6135	010100000007CD53C2B8D63340C658011995354740	0
1857	Kömpöc	6134	0101000000EB3A545392DD3340FEE60F17CA3B4740	0
1858	Pálmonostora	6112	010100000079DF9D21C1F1334018A2F9522E504740	0
1859	Petőfiszállás	6113	0101000000B4EACE6E88DC3340D5C7E8256B4F4740	0
1860	Jászszentlászló	6133	0101000000B88DAB36A4C2334022F9EF66B2484740	0
1861	Szank	6131	010100000081AF8D1DF9AC3340E657738060464740	0
1862	Móricgát	6132	01010000002A2966738BAF334053A813758B4F4740	0
1863	Gátér	6111	0101000000895DDBDB2DF533404859750C7E574740	0
1864	Bugac	6114	010100000078AA8DFBA0AE3340F49D04DB2D584740	0
1865	Bugacpusztaháza	6114	0101000000AD8ACB4CC4A233408DB85BEDBC594740	0
1866	Fülöpjakab	6116	01010000001CD6AFCFF7B8334027367A90F95E4740	0
1867	Kunszállás	6115	0101000000C7F7205F9DC03340AE9921FA5A614740	0
1868	Jakabszállás	6078	0101000000CD9EBAA8CC993340C8D4B89278614740	0
1869	Helvécia	6034	0101000000B80EC4680C9F334047F24BB32F6B4740	0
1870	Ballószög	6035	0101000000481053C7CF9133405D818D90266E4740	0
1871	Fülöpháza	6042	010100000087A8C29FE17133404FF8B6AA36724740	0
1872	Ágasegyháza	6076	01010000002092C60D64723340D0F1D1E28C6B4740	0
1873	Orgovány	6077	0101000000302DEA93DC793340A1CDBBFB2D604740	0
1874	Tiszaalpár	6066	0101000000C040102043FD334044087E0A36694740	0
1875	Szentkirály	6031	0101000000688C7B9862EB334046DC52BDEB754740	0
1876	Kunadacs	6097	0101000000F5EC03DA674B3340AF04F7A8647A4740	0
1877	Kunbaracs	6043	01010000004377A4558866334024EEB1F4A17E4740	0
1878	Kunpeszér	6096	010100000003C7AF69EF473340C15CE6CF12884740	0
1879	Ladánybene	6045	0101000000D9DB1C9DA9743340CD9F257E7B844740	0
1880	Felsőlajos	6055	01010000005A5C2DC1F37E3340F4EF445A74884740	0
1881	Bócsa	6235	01010000002DC4341D4B7B3340FE1B6ACA044F4740	0
1882	Tázlár	6236	0101000000222C746F8F833340D0E1106047464740	0
1883	Nagytőke	6612	0101000000B6EBEFB61C493440B52968A4EF604740	0
1884	Fábiánsebestyén	6625	0101000000298183AC5D7334408001CE9C3F564740	0
1885	Eperjes	6624	0101000000585E4DF96B8F3440AAE27CA0CB5A4740	0
1886	Derekegyház	6621	0101000000E9D89CDE205B3440FEC2E1BB834A4740	0
1887	Szegvár	6635	010100000061E28FA2CE3834402B7F6374E54A4740	0
1888	Csanytelek	6647	0101000000C309F1ED021A344097B4988EEF4D4740	0
1889	Felgyő	6645	0101000000266F8099EF1C34409619805715554740	0
1890	Tömörkény	6646	0101000000216EF36B900A344040660C18C94E4740	0
1891	Pusztaszer	6769	0101000000D1BEA89322FC334066D3B6065B464740	0
1892	Baks	6768	01010000008C6BD7DF6D1B344009AF134D56464740	0
1893	Mártély	6636	010100000020EC14AB063D3440B81FF0C0003C4740	0
1894	Dóc	6766	01010000001CA0EA460E233440F3AA73B10E384740	0
1895	Balástya	6764	0101000000B8FAFBD698033440CB811E6ADB354740	0
1896	Forráskút	6793	01010000005E995C31C8E83340BAA69B1FDA2E4740	0
1897	Üllés	6794	0101000000FD22B2593FD9334045532C6D272B4740	0
1898	Bordány	6795	0101000000788F7DDAF2EB3340845E24592C294740	0
1899	Szatymaz	6763	0101000000F93482E8A40A3440829A1029BC2B4740	0
1900	Zsombó	6792	0101000000FE65529ED4F83340BBAEA93D362A4740	0
1901	Ferencszállás	6774	0101000000CF126404545A3440C1012D5DC11B4740	0
1902	Zákányszék	6787	0101000000E3E88596D0E23340B4C46FAF71234740	0
1903	Maroslele	6921	010100000037FB03E5B657344070743A353C224740	0
1904	Klárafalva	6773	010100000015B24EF0A8523440D259C1CAFC1B4740	0
1905	Óföldeák	6923	01010000006FDCBD37E16F3440312B6FA2F1254740	0
1906	Apátfalva	6931	0101000000274BADF71B933440D003C4C9A2164740	0
1907	Földeák	6922	0101000000E8C880A2687E34402EBF1DF2E0284740	0
1908	Nagylak	6933	01010000006EADE584BFB5344082678C20DF154740	0
1909	Magyarcsanád	6932	0101000000C438C9A0249C34401F9F909DB7154740	0
1910	Csanádpalota	6913	0101000000E7FD7F9C30B9344010525CFA3C1F4740	0
1911	Kövegy	6912	0101000000F380689C3CAF344042D0D1AA961C4740	0
1912	Pitvaros	6914	01010000003BE4C17174BC34403115D16520294740	0
1913	Királyhegyes	6911	0101000000D2FE0758AB9C3440FEFCAD539B224740	0
1914	Nagyér	6917	01010000003057F5A8AEBA3440B9E8BF62682F4740	0
1915	Ásotthalom	6783	01010000002E9FF6A5C8C73340BCF55091F9184740	0
1916	Csanádalberti	6915	0101000000165DCDF055B534401FFBB4E5B7294740	0
1917	Ambrózfalva	6916	01010000006C96CB46E7BA3440758AFAC9BD2C4740	0
1918	Pusztamérges	6785	0101000000057B5DD08CAF3340F5EA2D2F0A2A4740	0
1919	Csengele	6765	0101000000E43A7C88FCDD3340C206FAFA10454740	0
1920	Ruzsa	6786	010100000098FC4FFEEEBF3340F287557204254740	0
1921	Öttömös	6784	0101000000C1A673EA6FAE3340D80E46EC13244740	0
1922	Dombegyház	5836	01010000002D9386BFCB213540D6D127A8972B4740	0
1923	Kisdombegyház	5837	010100000000B49C3A451935403C99C981682F4740	0
1924	Magyardombegyház	5838	01010000000D897B2C7D123540DFAFB8EE9C304740	0
1925	Dombiratos	5745	0101000000331D95F6611E3540C3DE1F4A0F364740	0
1926	Kevermes	5744	01010000000C74ED0BE82D35407571C0536D354740	0
1927	Lőkösháza	5743	0101000000CE86A17A103B3540520C906802374740	0
1928	Nagykamarás	5751	010100000083FE9D488B1E35400384C5973F3C4740	0
1929	Almáskamarás	5747	01010000006A1904B1C7173540D85EB0C0FC3A4740	0
1930	Magyarbánhegyes	5667	010100000096F8927CDBF63440ADC9AE0F463A4740	0
1931	Végegyháza	5811	01010000005DA3E5400FDF344014BA015592314740	0
1932	Kardoskút	5945	0101000000ADB4D66196B3344027FD18CE903F4740	0
1933	Kaszaper	5948	01010000000AA6F512BED2344017BB7D56993A4740	0
1934	Pusztaföldvár	5919	010100000067C581A158CE344077DDB64A0B444740	0
1935	Nagybánhegyes	5668	0101000000A9CB18D5D8E63440CB7564F6C33A4740	0
1936	Medgyesegyháza	5666	01010000001DE32FD230073540F6B292FBC23F4740	0
1937	Medgyesbodzás	5663	010100000002846ADECCF53440B88E160C53424740	0
1938	Pusztaottlaka	5665	010100000033709B04CA013540CA7C51CC8B444740	0
1939	Csabaszabadi	5609	010100000016084CF102F434400BC2CBC28D494740	0
1940	Csanádapáca	5662	0101000000D1F2F22A21E23440A4784B2833444740	0
1941	Gerendás	5925	0101000000D9171A9991DB34400F95EB127A4C4740	0
1942	Újkígyós	5661	01010000006992B30B610635407C050E0D304C4740	0
1943	Szabadkígyós	5712	01010000006A1A6F86761335407D8E345DF44C4740	0
1944	Telekgerendás	5675	0101000000F8F3B74E6DF4344090E7E912C4544740	0
1945	Kétsoprony	5674	0101000000CD599F724CE234403A8B83F00D5C4740	0
1946	Hunya	5555	01010000002F9397EB23D83440B62FA017EE674740	0
1947	Kamut	5673	0101000000EF7618EEB7FB344041D47D0052614740	0
1948	Murony	5672	010100000009C1AA7AF90935406A4BC22A83614740	0
1949	Kardos	5552	0101000000042560CF32B83440598D806500664740	0
1950	Örménykút	5556	0101000000F9F13C5D82BC34400B73CCC3536A4740	0
1951	Gádoros	5932	01010000003CBF28417F9934403EE7131ED9554740	0
1952	Csárdaszállás	5621	0101000000279FC321C0EE34407D1464BAC66E4740	0
1953	Köröstarcsa	5622	0101000000ABD84E4AF70535401D90847D3B704740	0
1954	Bélmegyer	5643	0101000000B9837DE0CF2D354020B3B3E89D6F4740	0
1955	Okány	5534	010100000094E1D3F7755935405D29159EE1724740	0
1956	Tarhos	5641	0101000000D70AE42373363540896A0025F4674740	0
1957	Sarkadkeresztúr	5731	010100000085A636829E6135401087B6AD77674740	0
1958	Doboz	5624	010100000003A4479DCA3D354035CB0AEA005E4740	0
1959	Kötegyán	5725	010100000018265305A37A35400CE544BB0A5E4740	0
1960	Újszalonta	5727	01010000009639025DA07D3540493CEAF9E4674740	0
1961	Méhkerék	5726	010100000055940156FD7235400C6A09432E634740	0
1962	Mezőgyán	5732	01010000007599F5BDE18535406490BB08536F4740	0
1963	Geszt	5734	0101000000150E7338A99435400911154FE2704740	0
1964	Zsadány	5537	01010000007C0F971C777C354020B58993FB754740	0
1965	Körösújfalu	5536	0101000000BB75A334406635405B07077B137B4740	0
1966	Biharugra	5538	0101000000FD42D9A557983540D4540559057C4740	0
1967	Körösnagyharsány	5539	0101000000AF7D5C76E3A435400053AB54F5804740	0
1968	Csabacsűd	5551	01010000004042DEBC82A63440D06ADCF698694740	0
1969	Ecsegfalva	5515	01010000006FB081BE3EEC34409DEBA0B71D934740	0
1970	Kertészsziget	5526	0101000000C45A21510D1035404A0856D5CB934740	0
1971	Bucsa	5527	010100000056702EB429FF344029A215CE249A4740	0
1972	Almamellék	7934	01010000004743215DC7DF31405C2D663A2A144740	0
1973	Ároktő	3467	0101000000164D672783F134405046A68D34DD4740	0
1974	Tiszadorogma	3466	0101000000E88E5951DEDC34408C56A4784BD74740	0
1975	Tiszabábolna	3465	0101000000E9BF6268D0CF3440CBE08332E8D74740	0
1976	Tiszavalk	3464	010100000062E75C401EC034401F01929F43D84740	0
1977	Négyes	3463	0101000000D813B8D0F0B33440DBBD816ED4D94740	0
1978	Borsodivánka	3462	0101000000F72AE8AC05A834401E2D735F73D94740	0
1979	Egerlövő	3461	01010000001FC253234F9F34402FBE688F17DC4740	0
1980	Szentistván	3418	010100000025CADE52CEA934409ED55D34BFE24740	0
1981	Mezőnagymihály	3443	010100000007AA903C21BB34409191FD3DC2E74740	0
1982	Gelej	3444	01010000006C41EF8D21C63440A051BAF42FEA4740	0
1983	Mezőkeresztes	3441	010100000085398B2837B13440D1402C9B39EA4740	0
1984	Mezőnyárád	3421	010100000099261186A6AD3440F6F708EBB5ED4740	0
1985	Tiszakeszi	3458	010100000091F2936A9FFE344031C6D166E6E44740	0
1986	Tiszatarján	3589	010100000078A27FDD44003540046B4194D4EA4740	0
1987	Hejőkürt	3588	01010000007670B03731FE34409ECE15A584ED4740	0
1988	Oszlár	3591	0101000000EE3B2B0E0C093540F6D1A92B9FEF4740	0
1989	Tiszapalkonya	3587	0101000000CE667A2EF80D3540BDB66DCE77F14740	0
1990	Nemesbikk	3592	0101000000CE812F9633F734409F84E3439AF14740	0
1991	Hejőbába	3593	010100000042CC2555DBF134406794D343D9F34740	0
1992	Hejőpapi	3594	010100000072DCCE6339E83440BADD2637E5F24740	0
1993	Igrici	3459	0101000000D0CE0E5DF5E13440546529A3DBEE4740	0
1994	Hejőszalonta	3595	01010000000E1DF11AAAE034407B0B900D49F84740	0
1995	Hejőkeresztúr	3597	01010000006C98A1F144E23440E12E562F1AFB4740	0
1996	Nagycsécs	3598	0101000000DD555925A2F33440349B6CA8BDFA4740	0
1997	Szakáld	3596	0101000000D5D8147E5FE8344047BB1B5597F84740	0
1998	Muhi	3552	0101000000B5D2B540CCED344080B4A44863FD4740	0
1999	Ónod	3551	01010000004271112917EA3440BDBD101725004840	0
2000	Sajópetri	3573	01010000001DBF0177EAE334400445E2D4BD044840	0
2001	Sajólád	3572	0101000000D18A146F09E7344039E9222AF9054840	0
2002	Kistokaj	3553	0101000000BC6EB65E78D6344011829F820D054840	0
2003	Bükkaranyos	3554	010100000057321180C9C73440B5CB12F81EFE4740	0
2004	Harsány	3555	0101000000219C059090BD344059E02BBAF5FB4740	0
2005	Borsodgeszt	3426	0101000000A5187B8A77B1344085F9E1D693FA4740	0
2006	Vatta	3431	010100000082A7357282BD3440F8054F7C10F64740	0
2007	Bükkábrány	3422	0101000000F4F2E093F3AE3440C56FAF71A2F14740	0
2008	Csincse	3442	010100000033219C0590C4344003ACFA01B4F14740	0
2009	Sály	3425	0101000000E8AD7081BAA93440A064BCF781F94740	0
2010	Kács	3424	0101000000F70A66A77A9D3440B0F902C46EFA4740	0
2011	Kisgyőr	3556	01010000008459B2744FB03440DCF4673F52014840	0
2012	Bükkszentkereszt	3557	0101000000DF967E784CA13440AE6DE580B8084840	0
2013	Répáshuta	3559	0101000000241B5943F38634405DE96B4C3E064840	0
2014	Bogács	3412	010100000005EE8A2A0D88344077DE2120BAF34740	0
2015	Taktakenéz	3924	0101000000266431FB863735401A2C41EB86064840	0
2016	Prügy	3925	0101000000257FE662C23E3540A62325E2520A4840	0
2017	Taktabáj	3926	0101000000BD3AC780EC4F35400DC51D6FF2074840	0
2018	Csobaj	3927	0101000000A26B15B3145735408698A66329064840	0
2019	Tiszatardos	3928	0101000000DDCEBEF220613540C037972C38054840	0
2020	Tiszaladány	3929	010100000096D3F94BE669354048F3114251084840	0
2021	Taktaszada	3921	010100000040D2F1E20E2D35405FD8F5662F0E4840	0
2022	Bekecs	3903	01010000009B6AD212D02B3540546B065D67134840	0
2023	Legyesbénye	3904	0101000000CDA156E24B2635400B010A3F82144840	0
2024	Mezőzombor	3931	01010000006FC8F5A56D4235403FCF55A98F134840	0
2025	Mád	3909	010100000003DDA85F33463540E1568B998E184840	0
2026	Rátka	3908	01010000007EDC2340F23935402E01F8A7541B4840	0
2027	Tállya	3907	0101000000373811FDDA3A354054EBB3B9201E4840	0
2028	Golop	3906	01010000009EE7F4616230354055826A285A1E4840	0
2029	Monok	3905	0101000000457F0D2D572635402DDD13DA281B4840	0
2030	Felsődobsza	3847	01010000009DD43CEC2A1335400DCF0138AC204840	0
2031	Hernádkércs	3846	01010000001A1A4F04710C3540AB2006BAF61E4840	0
2032	Szentistvánbaksa	3844	01010000003DA94077930735409D3BB0D2931C4840	0
2033	Nagykinizs	3844	0101000000A7FCB506000A3540618907944D1E4840	0
2034	Kiskinizs	3843	0101000000CFC364051A09354087B8832227204840	0
2035	Megyaszó	3718	0101000000BD512B4CDF0D354079701C1DFC174840	0
2036	Alsódobsza	3717	01010000007FAFD7AA130035406A882AFC19174840	0
2037	Sóstófalva	3716	01010000003767E9AFFCFC3440ED551AE725144840	0
2038	Újcsanálos	3716	01010000009F58A7CAF70035405D22CD0EA7114840	0
2039	Gesztely	3715	0101000000B1845A7803F73440C3EAD9BD260D4840	0
2040	Onga	3562	01010000003843BB54B6E934408FCEAF9C730F4840	0
2041	Arnót	3713	0101000000A5773B0CF7DB34405F8DFD7623114840	0
2042	Sajópálfala	3714	0101000000F24AEDA06DD834409C757C6AAB144840	0
2043	Viss	3956	010100000012C0CDE2C580354024647B88A11B4840	0
2044	Sárazsadány	3942	0101000000B836F9D2807E354079A8120AB6214840	0
2045	Bodrogolaszi	3943	0101000000167B794B83843540F495F6BCD1244840	0
2046	Györgytarló	3954	0101000000F00687CDB6A13540B2B7393A531A4840	0
2047	Vajdácska	3961	010100000048B599547EA7354097749483D9284840	0
2048	Alsóberecki	3985	0101000000DB5CEB41F7AF3540EBED85B8282C4840	0
2049	Felsőberecki	3985	0101000000EB950DC6E3B135403A43CC800E2E4840	0
2050	Karos	3962	0101000000F862395332BE35403A6B01EB822A4840	0
2051	Bodroghalom	3987	01010000007EAB75E272B4354096F8927CDB264840	0
2052	Tiszacsermely	3972	01010000000A75A26EB1CC3540CE6E2D93E11D4840	0
2053	Karcsa	3963	01010000001D6F97A201CB354030FFD76FDC274840	0
2054	Pácin	3964	010100000067E1A1DE42D535403F558506622A4840	0
2055	Nagyrozvágy	3965	01010000008A73D4D171EB3540E4A7CC28F12B4840	0
2056	Kisrozvágy	3965	0101000000824D428E52F0354032CFA513642C4840	0
2057	Semjén	3974	01010000009D05EB49AAF83540921FF12BD62C4840	0
2058	Lácacséke	3967	01010000007A86151340FE3540D78A91802C2F4840	0
2059	Ricse	3974	01010000009C7F057AF2F83540F96C78D55E294840	0
2060	Révleányvár	3976	010100000044FD8925400A36408CC5CAC39D294840	0
2061	Dámóc	3978	01010000001144CCDBC708364006D671FC50304840	0
2062	Zemplénagárd	3977	0101000000E633EA6BA711364030C3352D672E4840	0
2063	Erdőbénye	3932	0101000000E96A86AF0A5B3540F7EEEAB01D224840	0
2064	Sima	3881	0101000000E14F430A544D3540BF315FB939264840	0
2065	Baskó	3881	010100000007ACC1A0F1553540E29414B3B92A4840	0
2066	Erdőhorváti	3935	010100000066C5CB2E736D3540748A9F104B284840	0
2067	Komlóska	3937	01010000006BE1687D8076354031A2A30BA02B4840	0
2068	Háromhuta	3936	0101000000A5225F533169354007F7B990FD2F4840	0
2069	Hercegkút	3958	01010000006493FC885F8735404C91D7DE022B4840	0
2070	Makkoshotyka	3959	01010000009542C5DDC58435404FBB4ED99F2D4840	0
2071	Vágáshuta	3992	010100000023CCFE8A468A3540CCC86A042C364840	0
2072	Kovácsvágás	3992	0101000000007A75E9BA873540AC9223F83A3A4840	0
2073	Nagyhuta	3994	01010000005BECF659657E35405A56ABC0DA364840	0
2074	Kishuta	3994	0101000000336A6391CB7A35402F70D4658C394840	0
2075	Bózsva	3994	010100000005A73E90BC7735402CE63114C13C4840	0
2076	Füzérradvány	3993	0101000000BA980B0165863540C48E6BE80B3E4840	0
2077	Vilyvitány	3991	010100000057D7FC530590354090AB47D04E3F4840	0
2078	Mikóháza	3989	0101000000D567BDCE3C973540D78C672B8A3B4840	0
2079	Alsóregmec	3989	01010000008A5F0C40FE9D35400A606F078F3B4840	0
2080	Felsőregmec	3989	0101000000C43F6CE9D19A35409A44BDE0D33E4840	0
2081	Nyíri	3998	01010000000ED940BAD870354076E8AA2F01404840	0
2082	Füzérkomlós	3997	0101000000218436EFEE733540868A1645B4414840	0
2083	Füzérkajata	3994	01010000006D31E47DC17F35401D4762388D424840	0
2084	Pusztafalu	3995	01010000009C58969E9F7C3540FD5470D3FA454840	0
2085	Füzér	3996	010100000018A8D60CBA7435402E35E785E0444840	0
2086	Hollóháza	3999	0101000000071DBE96A169354093C6681D55454840	0
2087	Pányok	3898	0101000000DF5339ED295935407130E58DDD434840	0
2088	Abaújvár	3898	01010000004E19EE128B503540BCA13A6755434840	0
2089	Zsujta	3897	0101000000E08F91A28447354069A78BB910404840	0
2090	Tornyosnémeti	3877	01010000006375502E32403540BA9F53909F424840	0
2091	Hidasnémeti	3876	0101000000B00E362B913A354037E0F3C308404840	0
2092	Hernádszurdok	3875	0101000000E477E45993343540B187F6B1823D4840	0
2093	Vizsoly	3888	0101000000D1A11D8189373540C32D1F4949314840	0
2094	Arka	3885	0101000000EB596B836E4035405B608F89942D4840	0
2095	Abaújkér	3882	0101000000C1CAFCFE28333540407EDBB86A274840	0
2096	Abaújalpár	3882	0101000000AA937DA1913B3540536A40CE45274840	0
2097	Boldogkőújfalu	3884	01010000008F064BD0BA3D35409163EB19C2284840	0
2098	Gibárt	3854	0101000000C5E74EB0FF283540C8B7D2C66C284840	0
2099	Bükkmogyorósd	3648	01010000006794D343D95A3440DCC1E33675104840	0
2100	Csernely	3648	0101000000DE44E33F935734407BDB4C8578124840	0
2101	Lénárddaróc	3648	0101000000AD985B6B395F34405D24A3B904134840	0
2102	Sáta	3659	01010000000FAD5FFAA8643440A068C306B0174840	0
2103	Nekézseny	3646	0101000000F67013FFC16D3440AC85FEAE74154840	0
2104	Mályinka	3645	0101000000837BAF6BC57E34408D672B8AB2134840	0
2105	Dédestapolcsány	3643	010100000017D7F84CF67B344082ED163724174840	0
2106	Uppony	3622	0101000000292504ABEA6F34402816AEFD531B4840	0
2107	Borsodbóta	3658	01010000009E3B664579653440E56F8CAE1C1B4840	0
2108	Járdánháza	3664	01010000009603E21A44403440948F93782F144840	0
2109	Arló	3663	0101000000A9482AF812413440F71F990E9D164840	0
2110	Farkaslyuk	3608	0101000000C42BA4575E4F34402B508BC1C3174840	0
2111	Borsodszentgyörgy	3623	0101000000476D872B0C3434406D44E68013184840	0
2112	Domaháza	3627	01010000002705CC327A1A34403933B04456174840	0
2113	Kissikátor	3627	010100000087EC7200B3213440BCF781F5C9184840	0
2114	Hangony	3626	010100000062E3B0EA62333440EB56CF49EF1C4840	0
2115	Sajómercse	3656	0101000000C4F473F9C56934405FF0694E5E1F4840	0
2116	Királd	3657	0101000000D7D3580C686334408892DAD5F51F4840	0
2117	Sajónémeti	3652	010100000005C7C09547623440E69315C3D5224840	0
2118	Sajópüspöki	3653	0101000000F756C96C355834408632F90BE2234840	0
2119	Hét	3655	0101000000DF73BBF2B463344063E5E14E33244840	0
2120	Bánréve	3654	01010000004FE042C3075B34404318E4D308264840	0
2121	Serényfalva	3729	010100000017E64EFA8C633440FEDC2B4E10284840	0
2122	Sajóvelezd	3656	01010000002BCE62731F763440E133C813F7224840	0
2123	Dubicsány	3635	01010000001395B2B1B77D344083A7EBE467244840	0
2124	Bánhorváti	3642	01010000003CE8C880A2803440F54BC45BE71C4840	0
2125	Nagybarca	3641	0101000000B541DC8B1E86344020E57162591F4840	0
2126	Varbó	3778	01010000000536E7E0999E3440A1664815C5144840	0
2127	Parasznya	3777	01010000007931DEA007A4344093AB58FCA6154840	0
2128	Radostyán	3776	01010000007EFCA5457DA63440A6E5513B0D174840	0
2129	Kondó	3775	0101000000318793EAF1A33440BD8A8C0E48184840	0
2130	Sajólászlófalva	3773	0101000000448D9D4BCCAC344084D151B3AC174840	0
2131	Sajókápolna	3773	01010000000BCFF00B54AF3440EC9C0BC803194840	0
2132	Berente	3704	01010000002BCE62731FAA34403CF14174AD1D4840	0
2133	Sajóivánka	3720	01010000000CC1BBA651943440A52199C40F224840	0
2134	Vadna	3636	0101000000D421DC099B8E3440FB18BD642D234840	0
2135	Sajókaza	3720	0101000000278EF2823E95344057EC2FBB27244840	0
2136	Sajógalgóc	3636	01010000004D0460F2F58734402D8BD35AE2254840	0
2137	Sajóbábony	3792	0101000000419F234D17BD3440312592E865164840	0
2138	Sajókeresztúr	3791	0101000000E66A7583B2C63440FB80F6D9B7154840	0
2139	Sajóecseg	3793	01010000007D72B96697C63440863B17467A184840	0
2140	Sajóvámos	3712	0101000000E5284014CCD434403AA6385849174840	0
2141	Sajósenye	3712	0101000000B0DFB831E2D13440CA03ECFE0C194840	0
2142	Boldva	3794	01010000001C1DA1B0D5C9344002284696CC1B4840	0
2143	Aszaló	3841	01010000008D15EB0A6CF43440D4E9E51CE11C4840	0
2144	Alsóvadász	3811	01010000002D663A2AEDE73440FEB8FDF2C91E4840	0
2145	Homrogd	3812	0101000000BBEF181EFBE93440E3C798BB96234840	0
2146	Kázsmárk	3831	010100000067BF492E5AF93440499AE4EC42234840	0
2147	Léh	3832	0101000000DC23E53801FB344035046CAC69254840	0
2148	Monaj	3812	0101000000601C018173EF34403CE9335651274840	0
2149	Halmaj	3842	0101000000DA9255116E0035406FD4AF19851F4840	0
2150	Csobád	3848	0101000000E12E562F1A073540EF8C5B7116244840	0
2151	Rásonysápberencs	3833	01010000007FCAE7CBC1FE34402FE296EA5D274840	0
2152	Detek	3834	010100000041DA5ABADD0435407F7676E8AA2A4840	0
2153	Beret	3834	01010000000D4BA88537063540AD05AC0B2E2C4840	0
2154	Baktakék	3836	010100000015EBAFB21107354059654BFB8B2E4840	0
2155	Ináncs	3851	0101000000E860A2E650113540091FA56D57244840	0
2156	Hernádszentandrás	3852	0101000000B38BB333961835407C6E579EF6244840	0
2157	Pere	3853	01010000002B155454FD1E3540765BD88981244840	0
2158	Hernádbűd	3853	0101000000BB833353B5223540DDF18178B8254840	0
2159	Forró	3849	0101000000CA32C4B12E163540B8D38CFB45294840	0
2160	Méra	3871	0101000000491F042ED9263540FAF19716F52D4840	0
2161	Szalaszend	3863	01010000008733BF9A03203540630333F0ED314840	0
2162	Novajidrány	3872	01010000004BC22A830F2C35400F6E217EB4334840	0
2163	Garadna	3873	01010000004A928C41CC2C3540BE6C3B6D8D354840	0
2164	Hernádvécse	3874	0101000000D60E90792E2B35402B35D65988384840	0
2165	Fulókércs	3864	010100000069965F611C1B35403E9061BAB5364840	0
2166	Fáj	3865	0101000000765E190A8E13354065FB35FEE9354840	0
2167	Fancsal	3855	0101000000A370E250641035408D351257842D4840	0
2168	Alsógagy	3837	0101000000A52199C40F0635408576F3F9CD334840	0
2169	Gagyapáti	3837	0101000000BC2A06FEA6003540A7576F7951344840	0
2170	Selyeb	3809	0101000000FBC33B65DAF3344026EB26E77A2B4840	0
2171	Kupa	3813	01010000009532045B80E9344033ED516E912A4840	0
2172	Nyésta	3809	01010000006B5B3920AEF33440EBEB5454582F4840	0
2173	Felsővadász	3814	0101000000D5B6BCCD76EA34400AB952CF822F4840	0
2174	Tomor	3787	0101000000B0D1CD59FAE13440DD51ADCFE6294840	0
2175	Hegymeg	3786	0101000000CE661F7585DC3440F3DD52735E2A4840	0
2176	Lak	3786	01010000008DD0CFD4EBDE3440034AF9FF272C4840	0
2177	Ziliz	3794	0101000000F9742B3A48CA3440C185860F36204840	0
2178	Borsodszirák	3796	01010000000F9A5DF756C43440CA7B8B3D6A214840	0
2179	Nyomár	3795	0101000000233EC10F18D13440506F46CD57234840	0
2180	Hangács	3795	0101000000FD8117224CD4344082DB24500E254840	0
2181	Múcsony	3744	0101000000B60E0EF626AE34409C0425BB88224840	0
2182	Szuhakálló	3731	0101000000E6481DD3C9A6344095511B8B5C244840	0
2183	Kurityán	3732	0101000000881C1142F69E3440529ACDE330284840	0
2184	Felsőnyárád	3721	0101000000ECEB0AC73D993440ABD3DC651A2A4840	0
2185	Jákfalva	3721	01010000009615D4015A923440A25813B0C22A4840	0
2186	Dövény	3721	01010000008623A35E4B8B344004F2DBC6552C4840	0
2187	Felsőkelecsény	3722	0101000000D3E6EE29EF973440352FE296EA2D4840	0
2188	Ormosbánya	3743	0101000000E2390087F5A534403151CE61082B4840	0
2189	Izsófalva	3741	0101000000AB83729131A734404C474AC4A5274840	0
2190	Rudolftelep	3742	01010000009DF8C500E4AB3440CFBA46CB81274840	0
2191	Damak	3780	01010000001475E61E12D234409D1B89867B284840	0
2192	Balajt	3780	0101000000C720C19EC0C934403447567E19294840	0
2193	Ládbesenyő	3780	01010000002D4B2A093FC9344053AD2AA0F52B4840	0
2194	Szendrőlád	3751	0101000000285E0AB4E0BE3440910C39B69E2B4840	0
2195	Abod	3753	010100000053E1197E81CA34400E54217942324840	0
2196	Galvács	3752	01010000002F6585C723C734402F23AB11B0354840	0
2197	Szakácsi	3786	01010000007F08BB7207DD3440974341DFCC304840	0
2198	Irota	3786	01010000004258326C39E0344081AF8D1DF9324840	0
2199	Gadna	3815	0101000000ABECBB22F8ED34404C87F31549334840	0
2200	Abaújlak	3815	0101000000ADF0D35D7EF43440BB08F8DAD8334840	0
2201	Abaújszolnok	3809	010100000028FC08B254F934400CC9C9C4AD2F4840	0
2202	Felsőgagy	3837	0101000000A0D16751E90335403E8CB564FA364840	0
2203	Csenyéte	3837	0101000000459671F8490A354003869B429D374840	0
2204	Gagyvendégi	3816	01010000000A7D55D39AF9344000659D3B0B374840	0
2205	Gagybátor	3817	0101000000577C9E9A26F33440788DA72F95374840	0
2206	Rakaca	3825	0101000000DAF2DB210FE234408E1AB8A8BB3A4840	0
2207	Rakacaszend	3826	010100000006E6327F96D634404747286CF53A4840	0
2208	Meszes	3754	0101000000948444DAC6CB3440F2B62D2526384840	0
2209	Szalonna	3754	0101000000E17A14AE47BD3440F24C1E053E394840	0
2210	Martonyi	3755	0101000000A7E8482EFFC334403F1F65C4053C4840	0
2211	Alsótelekes	3735	0101000000A0D2D22698A734407EB72F568A344840	0
2212	Felsőtelekes	3735	0101000000955FABA9D1A23440C25A6BDE27344840	0
2213	Alsószuha	3726	01010000007AE46ABF1081344072DC291DAC2F4840	0
2214	Zádorfalva	3726	01010000003A18FBDC1A7C34406BC7C33181314840	0
2215	Kelemér	3728	0101000000B74DA72B8E6D344037A38BF2712D4840	0
2216	Gömörszőlős	3728	0101000000D8DFC8F2646D34407F7A7DF7D82F4840	0
2217	Szuhafő	3726	01010000006D7B16DFAB7334405EDE776748344840	0
2218	Trizs	3724	01010000008DABDBEA837E34408AF8985995364840	0
2219	Ragály	3724	01010000002C62D8614C843440827B54B252344840	0
2220	Imola	3725	0101000000549A8356168D3440127E4EE6C4354840	0
2221	Kánó	3735	010100000037DA160A7D9934407C5E961BB1364840	0
2222	Égerszög	3757	0101000000EAF7B30EFD953440D012BFBDC6384840	0
2223	Teresztenye	3757	010100000005E7429BD29A3440B8EC6BB823394840	0
2224	Szőlősardó	3757	010100000092FAFC416EA034402BFDDF6CCE384840	0
2225	Varbóc	3756	01010000007B91BF6A1BA534400B5AED06763B4840	0
2226	Szinpetri	3761	0101000000FAFF82EEDC9F3440AE9FFEB3E63D4840	0
2227	Jósvafő	3758	01010000004E9DA27E728D34408D0E48C2BE3D4840	0
2228	Aggtelek	3759	01010000000EF9C2BF638134401B457B61D73B4840	0
2229	Szin	3761	0101000000503AEC191DA9344045A973FB9B3F4840	0
2230	Szögliget	3762	0101000000328E36339FAC34401A85C9F907434840	0
2231	Bódvarákó	3764	01010000006E5EE68585BC3440A62325E252414840	0
2232	Bódvaszilas	3763	010100000064B5543948BB34405BFFF85CB7444840	0
2233	Komjáti	3765	01010000002C28B110C2C2344061EB0896D9454840	0
2234	Tornaszentandrás	3765	01010000001865918197C63440E2653C0098424840	0
2235	Tornabarakony	3765	0101000000FDB6CC8EF9D13440D237691A143F4840	0
2236	Debréte	3825	01010000002E31E076B2DD3440701CC242F73F4840	0
2237	Viszló	3825	01010000008782BE993DE33440DCDCF357233F4840	0
2238	Tornanádaska	3767	010100000059901C9F7FC934403FDB0F1DA7474840	0
2239	Bódvalenke	3768	0101000000C5E97F14D0CD34409C64F55844454840	0
2240	Hidvégardó	3768	01010000008F11F52796D63440AF7C96E7C1474840	0
2241	Becskeháza	3768	01010000007EE19524CFD534404AEEB089CC434840	0
2242	Tornaszentjakab	3769	0101000000A692A6E617DE3440E8B6E974C5424840	0
2243	Pamlény	3821	0101000000C3F6EEEAB0ED344021054F21573F4840	0
2244	Szászfa	3821	01010000001EB0613C39F13440E0DFFB766D3C4840	0
2245	Keresztéte	3821	010100000068C240214CF334405836188FF73F4840	0
2246	Krasznokvajda	3821	0101000000F7EA3E5B62F834406AD322EC253C4840	0
2247	Perecse	3821	01010000009E8E119A6EFB3440BFA7284D39404840	0
2248	Büttös	3821	010100000094032CA85E013540F6BAA0191F3D4840	0
2249	Kány	3821	01010000009D1B89867B03354005F3FC0EEA414840	0
2250	Litka	3866	01010000001E47BDF1FF0E354058C51B99473A4840	0
2251	Szemere	3866	01010000002BA391CF2B1A3540D31ADE077B3B4840	0
2252	Pusztaradvány	3874	01010000001196671481223540B5FCC0559E3B4840	0
2253	Hernádpetri	3874	010100000019E3C3EC652935400D9DE8047E3D4840	0
2254	Szigetvár	7900	010100000089851046A2CC3140F1845E7F12064740	0
2255	Vigántpetend	8294	01010000009C1551137DA03140A1815836737B4740	0
2256	Gálosfa	7473	01010000001C3CB8E0B1E2314086B07504CB204740	0
2257	Hajmás	7473	0101000000E542E55FCBE731406E2585C31C234740	0
2258	Ostffyasszonyfa	9512	010100000011A4F732F60A3140D69C723BEAA94740	0
2259	Csönge	9513	01010000005517F032C31031404A5A965412AD4740	0
2260	Kenyeri	9514	0101000000AF93FAB2B41731407C3A68C06AB14740	0
2261	Remeteszőlős	2090	01010000001D9430D3F6EB324036902E36ADC74740	0
2262	Solymár	2083	0101000000A61B727D69EF3240530F2CA281CB4740	0
2263	Kesztölc	2517	0101000000F7DDBE5829CC3240F4BD2B2746DB4740	0
2264	Csolnok	2521	0101000000B0236992B3B732403B06BF68EAD84740	0
2265	Mezőszemere	3378	0101000000A6A84423E98434407AAB09FDA7DF4740	0
2266	Hajmáskér	8192	0101000000C862F60DA70332407EE200FA7D924740	0
2267	Nagyesztergár	8415	010100000081D31632B2E731404C546F0D6CA34740	0
2268	Dudar	8416	0101000000B1CA3B3DA5F131405665DF15C1A74740	0
2269	Szápár	8423	01010000008E41823D81093240227DA4D299A84740	0
2270	Bakonycsernye	8056	0101000000790778D2C21532409DDE20B5E4A84740	0
2271	Csánig	9654	0101000000893F2F8100063140826A285A5EB74740	0
2272	Nick	9652	010100000013C259000905314035F33F5475B34740	0
2273	Uraiújfalu	9651	010100000085F87601E5FB3040B153AC1A84AF4740	0
2274	Vámoscsalád	9665	01010000001123DF008EF8304037B75384E5B14740	0
2275	Vasegerszeg	9661	010100000072553431B8EB3040E0CA23C9BDAF4740	0
2276	Hegyfalu	9631	0101000000DA92B0CAE0E130407E68305750AD4740	0
2277	Zsédeny	9635	01010000007DFCEFD297E730400B2769FE98AB4740	0
2278	Jákfa	9643	01010000006FBD01C177F43040FA55CA7C51AB4740	0
2279	Rábapaty	9641	0101000000AE275F7589ED30403D93A23AC2A64740	0
2280	Sótony	9681	01010000004A928C41CCF23040809076ED1C994740	0
2281	Ikervár	9756	0101000000844DF80038E5304093212290A69A4740	0
2282	Nyőgér	9682	0101000000469561DC0DF03040B6ECB5453E974740	0
2283	Bögöt	9612	01010000008BAFD1CD59D430404F8B660A42A04740	0
2284	Porpác	9612	01010000005A958E835CCD304016197849F79E4740	0
2285	Bejcgyertyános	9683	0101000000D94F10864BEC3040AEB4311B09934740	0
2286	Csobánka	2014	0101000000E0B5F0619BF73240CD1DA27664D24740	0
2287	Tompaládony	9662	0101000000E6142EF53DE230408B411658B6B04740	0
2288	Bő	9625	01010000005CF40478C1D03040F118D46D3FAF4740	0
2289	Mesterháza	9662	01010000003F259D3704DD3040F3BDD06DD3AF4740	0
2290	Bajánsenye	9944	0101000000D788601C5C623040693DD7529B664740	0
2291	Kercaszomor	9945	010100000005717907D3593040B488CD6CFC644740	0
2292	Kerkáskápolna	9944	0101000000957F2DAF5C6D3040114B6F2475644740	0
2293	Magyarszombatfa	9946	01010000004E5656E421573040EF7783C366614740	0
2294	Velemér	9946	010100000054A86E2EFE5C3040FCFB3152945E4740	0
2295	Bakonytamási	8555	01010000008328A95D5DBB3140AEB195E189B44740	0
2296	Pápateszér	8556	010100000011E9126976B23140B7781D160FB14740	0
2297	Bakonyszentiván	8557	01010000005BFB4C07FCAB3140E7B1C11D03B24740	0
2298	Csót	8558	0101000000D4DE967E789A31407A7A5B9F28AE4740	0
2299	Ugod	8564	0101000000EEE7B92AF59931400278B06AB5A84740	0
2300	Bakonyszücs	8572	0101000000FD6838656EAE3140DABA8A7BE2AB4740	0
2301	Kölked	7717	0101000000A0AF0FA100B43240ABE39DE85FF94640	0
2302	Kémes	7843	0101000000CC0E4CC9CD1932408458479FA0E94640	0
2303	Drávaszerdahely	7847	01010000000ABB287AE02932400BF379200DEB4640	0
2304	Kovácshida	7847	0101000000C1C8CB9A582E32407DFDB561B9EA4640	0
2305	Gordisa	7853	0101000000DB036333763C32405A9C31CC09E64640	0
2306	Drávaszabolcs	7851	01010000008B37328FFC353240F903D48A25E74640	0
2307	Regenye	7833	0101000000C5F8D5C1662B324098B89F9D1DFC4640	0
2308	Bögöte	9675	01010000001241E6142E0B31408F06A6892D8B4740	0
2309	Sajtoskál	9632	0101000000575C1C959BDA3040504BBDB89EB34740	0
2310	Táborfalva	2381	0101000000FC7A74D99E7B3340662FDB4E5B8D4740	0
2311	Závod	7182	010100000072FE2614226A3240B6FBB03962324740	0
2312	Lajoskomárom	8136	0101000000350C1F1153563240C27D2E64BF6B4740	0
2313	Mezőkomárom	8137	010100000070C7E589314A32406E81A90B1D6A4740	0
2314	Szabadhídvég	8138	0101000000D82725A9F1473240BE51860552694740	0
2315	Kisláng	8156	0101000000CF08803B9A623240A604696BE97A4740	0
2316	Mátyásdomb	8134	0101000000418D316601593240503AEC191D764740	0
2317	Bugyi	2347	01010000005101E610272633403B376DC6699C4740	0
2318	Apaj	2345	0101000000C43CD0AF52163340337DC04D908E4740	0
2319	Balotaszállás	6412	0101000000D8B0F03F43893340337F96F8ED2C4740	0
2320	Zalaszentjakab	8827	0101000000204C400235213140308FEB95683E4740	0
2321	Szabás	7544	0101000000A3C222D0AA72314077DDB64A0B254740	0
2322	Alsószölnök	9983	0101000000CD508138B43330402782DD55B4764740	0
2323	Szakonyfalu	9983	01010000004CD82379533A3040768C2B2E8E764740	0
2324	Apátistvánfalva	9982	010100000009F42E83D6403040CF143AAFB1724740	0
2325	Orfalu	9982	010100000094DA8B683B44304035B39602D2704740	0
2326	Farkasfa	9981	01010000004D158C4AEA5030407AAB09FDA7734740	0
2327	Ispánk	9941	010100000064CE33F625713040E9EEDF617F6E4740	0
2328	Kisrákos	9936	0101000000D4C622974980304070F0E082C76D4740	0
2329	Viszák	9932	01010000001448E4164E7F3040C68E215BF1704740	0
2330	Csákánydoroszló	9919	0101000000771AC4622F8130404688E1D9D47C4740	0
2331	Gasztony	9952	010100000053D3895F0C74304081FAE0C6777B4740	0
2332	Rábagyarmat	9961	0101000000B6662B2FF96B3040438CD7BCAA784740	0
2333	Rátót	9951	010100000021D335EE286D3040508F6D19707B4740	0
2334	Vasszentmihály	9953	0101000000A9AB96CF4D683040E0956E5C107C4740	0
2335	Nemesmedves	9953	0101000000AF2C2C13D96630408FB05EFBB87F4740	0
2336	Csörötnek	9962	0101000000C8F4DFDE905D30402A3927F6D0794740	0
2337	Magyarlak	9962	0101000000142BFE4A42593040CDA7339CD7794740	0
2338	Rönök	9954	01010000002E872705275C3040379902E32A7D4740	0
2339	Daraboshegy	9917	0101000000F33B4D66BC913040141A2DACC07A4740	0
2340	Halogy	9917	01010000001ACEEB3EB68F30406A89F08A3B7C4740	0
2341	Nádasd	9915	010100000013375D05E79C30406DB4D25A877B4740	0
2342	Pinkamindszent	9922	0101000000FE20DCAEE17B3040815369D5F8844740	0
2343	Szentpéterfa	9799	0101000000FDB0941BFB7A3040F372D87DC78B4740	0
2344	Harasztifalu	9784	0101000000CE86A17A108D304043FDD3B25A864740	0
2345	Nagykölked	9784	0101000000C7F9F609FB8D3040E5B0A0D56E884740	0
2346	Rádóckölked	9784	01010000004589F1F5109630403250BE45CC894740	0
2347	Narda	9793	0101000000BC49C2741076304067AE1DD6659E4740	0
2348	Felsőcsatár	9794	0101000000B1524145D5713040C3C9479C5F9B4740	0
2349	Vaskeresztes	9795	0101000000243DB1F3DB723040C9AEB48CD4984740	0
2350	Horvátlövő	9796	0101000000053CC49A2576304003942B6112974740	0
2351	Pornóapáti	9796	010100000072135A7B447730401555BFD2F9934740	0
2352	Nárai	9797	01010000007BE29414B38D30404ABD5DE5BF984740	0
2353	Tiszabecs	4951	01010000007C314A86D2CF3640541454F9430C4840	0
2354	Kispalád	4956	0101000000A899A4E837D63640B9A81611C5024840	0
2355	Magosliget	4953	0101000000A03EB8F1DDDC3640E22E0CA2FF064840	0
2356	Uszka	4952	010100000082C41B3E8EDB36403E78EDD286094840	0
2357	Rozsály	4971	0101000000C5B1892716CD364066738BAF2CF64740	0
2358	Méhtelek	4975	0101000000115C40C3F6D836405F5A796E46F74740	0
2359	Garbolc	4976	01010000004B66AB819CDC364017A6A5A8E9F84740	0
2360	Nagyhódos	4977	0101000000C9AF1F6283D93640A9047A9741FB4740	0
2361	Kishódos	4977	01010000003EC5BB6DF0D53640D921FE614BFC4740	0
2362	Zsarolyán	4961	01010000000B0A83328D96364073CAEDA87BF94740	0
2363	Jánkmajtis	4741	010100000070FB2F2130A636402359767753F84740	0
2364	Csegöld	4742	0101000000CD08CAC8B4AF364085DF974407F34740	0
2365	Csengersima	4743	0101000000A0D4A8D1F5BA3640AD9685C0DBEE4740	0
2366	Gacsály	4972	01010000002EDE3422BDC13640931E865627F74740	0
2367	Zajta	4974	0101000000D248957208CC3640E481C8224DF44740	0
2368	Császló	4973	010100000059E02BBAF5B836402D1098E205F54740	0
2369	Kisnamény	4737	010100000072E71D02A2B13640B1941BFB48FA4740	0
2370	Csaholc	4967	0101000000890C063296BA36403530A8250CFE4740	0
2371	Mánd	4942	0101000000B7483547B19B364057FEC6E8CAFF4740	0
2372	Nemesborzova	4942	010100000008FDF103FCA13640A7C931FE22FF4740	0
2373	Vámosoroszi	4966	0101000000F03092E288AE3640017C0107FEFE4740	0
2374	Túrricse	4968	010100000041142752F5C23640B273E492F4FC4740	0
2375	Tisztaberek	4969	01010000006571FF91E9CA3640DABA8A7BE2FA4740	0
2376	Nagyszekeres	4962	0101000000300F99F2219C3640BC48579F61FB4740	0
2377	Kisszekeres	4963	0101000000EBD511D1F9A236401D1C919499FC4740	0
2378	Penyige	4941	0101000000C85EEFFE789136403F462F59CBFF4740	0
2379	Milota	4948	010100000091BF0F62C2C7364055EC7948420D4840	0
2380	Tiszacsécse	4947	0101000000D9767F619EBE3640DD94F25A090E4840	0
2381	Tiszakóród	4946	01010000004FC12B932BB636405EC367469A0D4840	0
2382	Túristvándi	4944	01010000009F7422C154A5364055BDFC4E93064840	0
2383	Kömörő	4943	010100000086C20C326E973640DEF7B9EBB6034840	0
2384	Fülesd	4964	0101000000314514EEF0AC36408CB73AA528034840	0
2385	Kölcse	4965	01010000003FB61B333FB7364035FFF9C78C064840	0
2386	Sonkád	4954	01010000007813D78C67BF3640C64FE3DEFC064840	0
2387	Botpalád	4955	01010000002B42FBA24ECE3640508E0244C1034840	0
2388	Nagyar	4922	0101000000F036CA55878D36400CDB60F250074840	0
2389	Szatmárcseke	4945	0101000000FCF95BA736A136407E5DE1B8E70A4840	0
2390	Tarpa	4931	01010000002CE79CE96F873640B6B52A2E330D4840	0
2391	Tivadar	4921	01010000001B8524B37A833640236F14B424084840	0
2392	Kisar	4921	01010000005861E932EB833640371EC76A4E074840	0
2393	Jánd	4841	010100000035A84764695F364006E973FFA20E4840	0
2394	Gulács	4842	0101000000C4C02962C777364020B41EBE4C0B4840	0
2395	Hetefejércse	4843	01010000009F65CC13BE7736400BF20E4B5E104840	0
2396	Csaroda	4844	0101000000C79A36887B75364019541B9C88144840	0
2397	Márokpapi	4932	0101000000C9C1B68F268236402000828307134840	0
2398	Beregsurány	4933	0101000000D8C7F951C38B364072E4DC8195144840	0
2399	Beregdaróc	4934	0101000000888961E2EA8736400CE313573A194840	0
2400	Gelénes	4935	010100000092F6F532407236404FDA65097C194840	0
2401	Vámosatya	4936	01010000007BB5EDC561683640AA91A7F633194840	0
2402	Tiszaszalka	4831	0101000000E0E302869B5036402BECB314DA174840	0
2403	Tiszavid	4832	01010000000C01C0B1674B364008FAB083EF184840	0
2404	Tiszaadony	4833	0101000000520E6613604A36404DADAD8ED21C4840	0
2405	Barabás	4937	01010000000D7CFB29446E3640141ED9017C1D4840	0
2406	Lónya	4836	0101000000D082AB973A4536407D3F355EBA284840	0
2407	Mátyus	4835	010100000017C2209F464836401C8414973E244840	0
2408	Tiszakerecseny	4834	010100000082C06FE8D24C3640E555E7621D214840	0
2409	Kisvarsány	4811	01010000008651B5824B4C36400BC2CBC28D124840	0
2410	Nagyvarsány	4812	0101000000431F2C6343473640B87878CF81144840	0
2411	Gyüre	4813	01010000008DDB1E73544436408D7DC9C683164840	0
2412	Aranyosapáti	4634	0101000000717D0EE2B9413640B4B4AE2C2C1B4840	0
2413	Tuzsér	4623	0101000000C93EC8B2601E364077418EF7F42B4840	0
2414	Tiszamogyorós	4645	01010000007FC40A12363B364028E3CE3B04294840	0
2415	Mezőladány	4641	01010000009FDA2AD20E39364029E78BBD17234840	0
2416	Újkenéz	4635	01010000007CF8E8C36939364002542756FC1F4840	0
2417	Benk	4643	01010000008B3D6A02FB3A36404458439891264840	0
2418	Zsurk	4627	0101000000BDCA3560EB3736408767AE788F344840	0
2419	Tiszaszentmárton	4628	01010000005651723DC03B3640D32C75351E304840	0
2420	Tápiógyörgye	2767	01010000002C8194D8B5F3334037B68DF5C3AA4740	0
2421	Tápiószele	2766	01010000007031F5A919E033404675DFD682AA4740	0
2422	Tápiószőlős	2769	01010000007A8D5DA27AD533405F4F2AD0DDA54740	0
2423	Újszilvás	2768	01010000004FDA0A5009EA33407A200D0286A24740	0
2424	Jászboldogháza	5144	010100000039B12C3D3FFF3340B85DC36746AF4740	0
2425	Jánoshida	5143	0101000000D3D226987B0E3440E728514024B14740	0
2426	Nábrád	4911	0101000000C38F7B0448723640FB1B599EAC004840	0
2427	Kérsemjén	4912	01010000008FE62384A26A3640AB76F28EF8024840	0
2428	Panyola	4913	010100000033816CA34B653640AA2FA6F4A7054840	0
2429	Olcsvaapáti	4914	010100000072D24554F259364019BD642D4F0B4840	0
2430	Olcsva	4826	0101000000EF13515D0A533640C33357BC470B4840	0
2431	Ópályi	4821	01010000005D97D013855236408EC8772975FF4740	0
2432	Nagydobos	4823	0101000000CC7D7214204E36407A5B9F28BF064840	0
2433	Szamoskér	4721	0101000000B862DA92B06A364027B6CC3340024840	0
2434	Szamosszeg	4824	010100000095496826735D36402220BAFB77054840	0
2435	Kocsord	4751	0101000000D35746D9116336402D149FF133F84740	0
2436	Győrtelek	4752	010100000012C946D6D07036401B310E89D6F64740	0
2437	Géberjén	4754	0101000000F321A81ABD74364062331BBF4BF74740	0
2438	Fülpösdaróc	4754	0101000000818010244A7A36408F368E588BF84740	0
2439	Ököritófülpös	4755	0101000000318FA1084E8236405FECBDF8A2F54740	0
2440	Rápolt	4756	01010000000A86730D338E364040D8CE9C9AF54740	0
2441	Hermánszeg	4735	0101000000A7A503A3DC9F364028F62BF8C8F34740	0
2442	Szamossályi	4735	0101000000E700C11C3D9C3640C2A7943204F44740	0
2443	Szamosújlak	4734	0101000000B1CAE083329636402CC203B97AF54740	0
2444	Gyügye	4733	01010000007AC2B755B59136409E02058310F64740	0
2445	Cégénydányád	4732	0101000000E6AF90B9328C36401D0C2BCBC6F74740	0
2446	Szamostatárfalva	4746	010100000097BE219E36AA364066F6798CF2EF4740	0
2447	Szamosbecs	4745	01010000006366FA809BB03640A0A86C5853EE4740	0
2448	Komlódtótfalu	4765	0101000000E0754710F8B336409928E73004EC4740	0
2449	Ura	4763	0101000000C0249529E69A3640F8EF0BF9B1E84740	0
2450	Tyukod	4762	0101000000F028DF7D9F8D364087191A4F04ED4740	0
2451	Csengerújfalu	4764	0101000000F2A43B3E109F364033839D071CE74740	0
2452	Pátyod	4766	01010000005A7CAFC67E9D36401C391CA732EF4740	0
2453	Porcsalma	4761	01010000009D77ADCE7B913640A73BF482F4F04740	0
2454	Szamosangyalos	4767	0101000000803FA14385A73640CC2A6C06B8EF4740	0
2455	Mérk	4352	0101000000786F568EDA603640CBF8F71917E44740	0
2456	Fábiánháza	4354	010100000096AA590CC35A3640A000E54A98EC4740	0
2457	Nyírcsaholy	4356	01010000000E46915ACD5536404A68267387F34740	0
2458	Mohács	7700	0101000000DED7929F9EAE3240FE309D3127FF4640	0
2459	Jenő	8146	0101000000CCCA9B68FC3F324066A3737E8A8D4740	0
2460	Nádasdladány	8145	010100000054AD8559683D32402AABE97AA2914740	0
2461	Sárkeszi	8144	0101000000E9DD0EC3FD483240AF377BB141944740	0
2462	Perkupa	3756	0101000000E7C41EDAC7B034403D62F4DC423C4840	0
2463	Kemenesmihályfa	9511	01010000003D5EEDCD141D314085AEE9E687A44740	0
2464	Kemenessömjén	9517	01010000003F9C76E73F223140FE501F37B2A54740	0
2465	Boba	9542	0101000000269419CAE42F3140E9C193CCA0974740	0
2466	Egyházashetye	9554	01010000008879A05FA51E3140CE3C1460B3954740	0
2467	Köcsk	9553	0101000000F4D25E8E681A3140B08971A36D984740	0
2468	Kemeneskápolna	9553	01010000006A77FEA3251B3140D9486D3D9E9A4740	0
2469	Mesteri	9551	01010000001BC693933F16314076D377C8DE9C4740	0
2470	Vásárosmiske	9552	010100000053094FE8F50F3140A6FC5A4D8D9A4740	0
2471	Nemeskocs	9542	01010000007B473250BE2F3140677B99CD88994740	0
2472	Paloznak	8229	0101000000538D0354DDF03140C4149B45DE7D4740	0
2473	Lovas	8228	01010000001E9D048074F53140E63686A5267F4740	0
2474	Felsőörs	8227	0101000000FF2C4C95DEF331409710BDD6EF814740	0
2475	Hont	2647	01010000000D65F217C4FD3240351E11F868064840	0
2476	Felsőpakony	2363	010100000016CE24A0783C334002DB1C42F0AB4740	0
2477	Alsónémedi	2351	0101000000FFD0CC936B2A3340B23E2F2647A84740	0
2478	Mogyoród	2146	0101000000CC290131093D33401FA74302A1CC4740	0
2479	Köveskál	8274	0101000000C48833750D9B3140A1C5ADDDD1704740	0
2480	Kővágóörs	8254	0101000000ABF53416039A31400107A348AD6C4740	0
2481	Kékkút	8254	0101000000515BD9F4568F3140B69CF0B7E26C4740	0
2482	Salföld	8256	010100000004DBD2B4D58C31406EC1525DC06A4740	0
2483	Pilisjászfalu	2080	01010000004BCEE4F626CB32401C171FB0BCD34740	0
2484	Szigetmonostor	2015	0101000000F7DE292ED81933404D03F51C47D84740	0
2485	Tahitótfalu	2021	01010000009C69C2F6931533407E75B05989E04740	0
2486	Pócsmegyer	2017	0101000000C758B78B7A183340CC1EB292A0DB4740	0
2487	Leányfalu	2016	01010000003381C75CBE16334051BEA08504DC4740	0
2488	Majosháza	2339	0101000000E5DB16C0EFFE3240723C5574DAA14740	0
2489	Áporka	2338	01010000003B0AC677180333405395B6B8C69D4740	0
2490	Káptalantóti	8283	010100000072906B9E7E833140DCEE8A85C66C4740	0
2491	Gyulakeszi	8286	0101000000716B77B4167B3140DCED1FB0176F4740	0
2492	Szentbékkálla	8281	01010000004F8182418890314010FD7F4177714740	0
2493	Mindszentkálla	8282	0101000000C1560916878D3140174A8160E96F4740	0
2494	Poroszló	3388	0101000000C4549F50F4A734408D9CE0F65FD24740	0
2495	Kovácsszénája	7678	0101000000B67A9807FA1B32408B12995E07164740	0
2496	Nyírmada	4564	010100000088CCA66D0D303640284696CCB1084840	0
2497	Magyarpolány	8449	0101000000A93C7084FB8B3140DF30766792954740	0
2498	Rózsaszentmárton	3033	0101000000D3E6EE29EFBD3340F13D6D9E34E44740	0
2499	Gyöngyöstarján	3036	01010000004111E6D1E8DD3340DD7FBFF3E6E74740	0
2500	Gyöngyösoroszi	3211	0101000000194BA2A87DE43340D9D53FE31DEA4740	0
2501	Nagyréde	3214	0101000000EDBD535CB0D93340A93C7084FBE14740	0
2502	Ecséd	3013	010100000024456458C5C53340B1C5C958C8DD4740	0
2503	Petőfibánya	3023	01010000008177F2E9B1B33340CE86A17A10E24740	0
2504	Zagyvaszántó	3031	01010000008DD47B2AA7AB3340AC53E57B46E34740	0
2505	Gyöngyöspata	3035	01010000000540CBA953CA334029136D7D47E84740	0
2506	Szűcsi	3034	0101000000AAC3C02962C333401460B3B7EFE64740	0
2507	Szurdokpüspöki	3064	0101000000B0AF75A911B233408505F7031EED4740	0
2508	Jobbágyi	3063	010100000091F0BDBF41AD33401CD544FA48EA4740	0
2509	Apc	3032	0101000000E7CEA7E90EB133406217A0C8EEE54740	0
2510	Monostorapáti	8296	0101000000FC523F6F2A8E31403E97040363764740	0
2511	Sülysáp	2241	0101000000306D93E57F853340406E1A3625BA4740	0
2512	Tápiószecső	2251	0101000000FD9BBC6D4B9B3340DDBAF660ADB94740	0
2513	Buj	4483	01010000006552431B80A53540A7A1FC93AE0C4840	0
2514	Karakó	9547	0101000000DBF7A8BF5E333140BDD2E8C4D48E4740	0
2515	Jánosháza	9545	01010000009A3798970D2A31408B87F71C588F4740	0
2516	Sárpentele	0	01010000007005B930775C3240F53A9803F3944740	0
2517	Hidegkút	8247	0101000000E20CB4F116D431404068E2C226804740	0
2518	Zselicszentpál	7474	010100000085798F334DD23140BDDAF6E230274740	0
2519	Cserénfa	7472	0101000000E053EF5F0FE23140AB025A5FC9274740	0
2520	Leányvár	2518	0101000000F25B19F961C5324038ED73C641D74740	0
2521	Piliscsév	2519	0101000000FD2C3B6986D13240EC6CC83F33D64740	0
2522	Vérteskethely	2859	01010000008A366C00DB1432403D1FAF5120BE4740	0
2523	Császár	2858	01010000001F268689AB2332407CA9E9C42FC04740	0
2524	Dad	2854	0101000000509F2E9CB5393240B76E394D55C24740	0
2525	Bokod	2855	0101000000BC0FF6DCF83D3240C2B68F2628BF4740	0
2526	Nagykarácsony	2425	0101000000DE825B2D66C63240CD9948C4EF6E4740	0
2527	Szeghalom	5520	01010000002F2A4E5A5D2B3540CAA8328CBB824740	0
2528	Pellérd	7831	01010000008D9B1A683E273240C4C1943776044740	0
2529	Alap	7011	01010000002EB4CE5378AF32402179420AF9664740	0
2530	Bakonykúti	8046	0101000000E75608ABB132324004464DAA6C9F4740	0
2531	Balinka	8055	010100000059479FA05E3032401586127706A84740	0
2532	Baracs	2426	0101000000A5901AC9D4DD324026CEE561FC744740	0
2533	Füle	8157	0101000000967A1684F23E324057433DD8BD864740	0
2534	Isztimér	8045	0101000000E1E7644E3C32324073F38DE89EA34740	0
2535	Nagyveleg	8065	01010000008335CEA6231C3240406260C20DAE4740	0
2536	Vajta	7041	01010000009642209738AA32403CE41C2BE75B4740	0
2537	Dég	8135	01010000004912842BA07232408A3BDEE4B76F4740	0
2538	Igar	7015	010100000048EAF307B983324064ECDF5053634740	0
2539	Daruszentmiklós	2423	0101000000052BF3FBA3D832406348A9DFE06D4740	0
2540	Kisapostag	2428	0101000000D49EED2CD5EE3240E091C20655724740	0
2541	Nagylók	2435	0101000000C675429E13A532400D8AE6012C7D4740	0
2542	Úrhida	8142	01010000008D7857E2A6553240B5464E70FB904740	0
2543	Moha	8042	01010000000CEA5BE674553240879B9D561B9F4740	0
2544	Óbarok	2063	0101000000B2721E04D3913240F3DF281EBCBE4740	0
2545	Atkár	3213	0101000000CE9C3FB7E1E3334063BF828F1CDC4740	0
2546	Átány	3371	0101000000694D98D5E05C344071D701C6E9CE4740	0
2547	Bátor	3336	0101000000BDF0941F02443440139CFA40F2FE4740	0
2548	Balaton	3347	0101000000E4B21BC7594E3440CBCAE5F5160C4840	0
2549	Bekölce	3343	010100000016DC0F786046344008CE740A4D0A4840	0
2550	Mikekarácsonyfa	8949	01010000006DE525FF93B130401AA20A7F86544740	0
2551	Zalamerenye	8747	010100000068DB7A979C183140BDC85FB58D494740	0
2552	Zalasárszeg	8756	01010000008D4BB09355143140FD6662BA103F4740	0
2553	Zalaszentbalázs	8772	010100000005734FB230EB30408CC3F418404B4740	0
2554	Kálmáncsa	7538	01010000006E693524EE9D3140747B4963B4084740	0
2555	Somogyvámos	8699	0101000000CBC05CE6CFAE314023426D65D3484740	0
2556	Rábahídvég	9777	0101000000C078060DFDBD3040233C90AB47894740	0
2557	Tekenye	8793	01010000004A0048B76F1F3140FA473A5EDC7A4740	0
2558	Ecseg	3053	010100000012A9C4D0459A33401AC40776FCF24740	0
2559	Alsótold	3069	01010000009BAC510FD1983340DE78D21D1FFA4740	0
2560	Kozárd	3053	01010000006166E954439E334024AE08A3FEF44740	0
2561	Felsőtold	3067	01010000003134E895FC9B3340396AE0A2EEFB4740	0
2562	Garáb	3067	0101000000C044172F71A3334076DD00D825FD4740	0
2563	Hollókő	3176	0101000000C044172F71973340B30D373BADFF4740	0
2564	Nagylóc	3175	0101000000A725B1FF959233404962EEFF88044840	0
2565	Magyarnándor	2694	0101000000C375D6B848593340BB922E47D9FB4740	0
2566	Cserháthaláp	2694	0101000000B3A5FDC522603340A868F68AB8FD4740	0
2567	Cserhátsurány	2676	010100000073B1B3322B6D3340DE1CAED51EFD4740	0
2568	Szanda	2697	0101000000B0B618F2BE70334096BEC6E4C3F64740	0
2569	Terény	2696	010100000080E0E0C10571334056197C5006F94740	0
2570	Mohora	2698	0101000000381A1B159356334001DC2C5E2CFF4740	0
2571	Csitár	2673	010100000003AAC99DE36D3340127C1D82F4064840	0
2572	Bérbaltavár	9831	0101000000D9D2FE6211F830405771F4424B814740	0
2573	Kétbodony	2655	01010000009C6B98A1F148334088FB2367BCF74740	0
2574	Szente	2655	0101000000A81E69705B49334099897D5DE1FB4740	0
2575	Debercsény	2694	01010000001E2AD725F4503340598AE42B81FB4740	0
2576	Csehimindszent	9834	010100000040999020A6F430403DED951EF2854740	0
2577	Mikosszéplak	9835	0101000000D635FF5481F93040DB7A979C24844740	0
2578	Csehi	9833	01010000009A7CB3CD8DF130402C0BCB44B6844740	0
2579	Csipkerek	9836	0101000000BAFD4D83FDF030401357DF0A72894740	0
2580	Kám	9841	01010000003C9DD09096E13040B43FAB274E8D4740	0
2581	Felsőpetény	2611	01010000008E3F51D9B0323340AF997CB3CDF14740	0
2582	Varsány	3178	0101000000EFB14F5B7E7D3340B7C887EAF7044840	0
2583	Rimóc	3177	01010000008D73E5FDC9873340A5598FB1C9044840	0
2584	Nógrádsipek	3179	0101000000E670523D3E803340C9A4D0C31A014840	0
2585	Ludányhalászi	3188	010100000037829E1738863340F338B12C3D114840	0
2586	Nógrádszakál	3187	010100000049861C5BCF863340B887CE7C18174840	0
2587	Litke	3186	0101000000D949D8124D993340ACE28DCC231B4840	0
2588	Keléd	9549	01010000001B0FB6D8ED1D314008ED3081B6894740	0
2589	Inárcs	2365	0101000000FF87050830543340BCBE203361A14740	0
2590	Kakucs	2366	01010000009E8834E0E25D33406950D955ED9E4740	0
2591	Árpádhalom	6623	0101000000FD231D2FEE8C3440397F130A114F4740	0
2592	Acsád	9746	010100000036B45C91F3BB30406222EF6657A94740	0
2593	Vasasszonyfa	9744	01010000001EBD8685FFAB304085043175FCA74740	0
2594	Salköveskút	9742	01010000006BC1E677F5B1304024FDACE8C5A54740	0
2595	Vasszilvágy	9747	0101000000C780ECF5EEBF3040414F5EBFBBA64740	0
2596	Csepreg	9735	0101000000E5BDC51E35B530408A22A46E67B34740	0
2597	Kiszsidány	9733	0101000000D0DD640A8CA33040D9486D3D9EB44740	0
2598	Gór	9625	0101000000E774B405DFCD30405D2D1CAD0FAE4740	0
2599	Meszlen	9745	010100000010655EFD8EB33040E2186E652EAA4740	0
2600	Pusztacsó	9739	0101000000BD31A946549F304081C75CBE9AAA4740	0
2601	Kőszegpaty	9739	010100000022E758390FA63040388600E0D8A94740	0
2602	Tömörd	9738	01010000002394089E8CAD30402FB3BE373CAE4740	0
2603	Nemescsó	9739	0101000000279710BDD69D30404BBE2374E1AC4740	0
2604	Csököly	7526	010100000006A799492F913140C5BF19468B264740	0
2605	Tiszanána	3385	01010000002A68A4EF7F87344023AF18BF3AC74740	0
2606	Sarud	3386	0101000000C59E8724C49834402345099F52CB4740	0
2607	Újlőrincfalva	3387	0101000000A7A7D94D3A993440D61FBCD122D04740	0
2608	Ólmod	9733	01010000008E210038F696304050CCD5EA06B54740	0
2609	Őrimagyarósd	9933	0101000000534953F30B893040FFB4AC5681714740	0
2610	Hegyhátszentjakab	9934	0101000000822C55B3188C3040EAC42F06206F4740	0
2611	Kemestaródfa	9923	01010000008F64A07C8B843040F49FDA858B7F4740	0
2612	Magyarnádalja	9909	0101000000382D78D157883040E2AB1DC539814740	0
2613	Halastó	9814	01010000008404D6BB89AF3040BE1248895D794740	0
2614	Nagymizdó	9913	01010000005E1498A9A4A730402AE109BDFE7E4740	0
2615	Szarvaskend	9913	01010000007B27B04A33AD30404516C49B907E4740	0
2616	Magyarszecsőd	9912	0101000000042967DE60A63040E5A37B8CA8844740	0
2617	Telekes	9812	0101000000C9FDB38B0EC530405C261EABEF784740	0
2618	Döbörhegy	9914	010100000014371378CCB33040B760A92EE07E4740	0
2619	Ivánc	9931	0101000000BF677FFB957F304010DC92663D784740	0
2620	Szaknyér	9934	010100000019F89B9A158730405F62878CA26E4740	0
2621	Szőce	9935	01010000001CCAF55BE091304058F50368A5714740	0
2622	Felsőmarác	9918	0101000000AABBB20B0685304074A213F879774740	0
2623	Sárfimizdó	9813	010100000024B149230BB730401CEDB8E177784740	0
2624	Kondorfa	9943	0101000000B3FB445497643040307D5468C5724740	0
2625	Hegyhátszentmárton	9931	0101000000F2785A7EE07A30402439AAE4AD774740	0
2626	Molnaszecsőd	9912	01010000002C561EEE34AD304054D5BAC3DC854740	0
2627	Egyházashollós	9781	0101000000D981CEFF06B23040119C44CE0C874740	0
2628	Nemesrempehollós	9782	0101000000EC10A4F732AE3040BB33C97ECC8B4740	0
2629	Püspökmolnári	9776	01010000005574DA09E5CB30408E226B0DA58B4740	0
2630	Dozmat	9791	01010000000AB7216BB2833040F261F6B2ED9D4740	0
2631	Bucsu	9792	010100000073A895F8927E30401781B1BE81A14740	0
2632	Bozsok	9727	0101000000E6A3D6451B7D30406D48ED8F41A94740	0
2633	Velem	9726	0101000000E7BC10BC6B7E3040351A0AE93AAC4740	0
2634	Kőszegszerdahely	9725	01010000009279E40F06843040E7C017CB99AB4740	0
2635	Cák	9725	010100000020FAA4C97B83304073F4F8BD4DAD4740	0
2636	Sorokpolány	9773	0101000000A87EEF80FCAC3040492C29779F914740	0
2637	Torony	9791	010100000093BC84549B8730404A86D2CDB49E4740	0
2638	Sé	9789	01010000007F390E17148D30405D6A29C5339F4740	0
2639	Sorkikápolna	9774	0101000000FE124C906CB33040FED071DAF8914740	0
2640	Gyanógeregye	9774	010100000009B5954D6FC330404186E9D6C68F4740	0
2641	Sorkifalud	9774	0101000000D542249E47C03040B829D489BA904740	0
2642	Nemeskolta	9775	0101000000C07EE3C688C5304090F7AA9509924740	0
2643	Táplánszentkereszt	9761	01010000003C4ED1915CB23040593673486A994740	0
2644	Tanakajd	9762	0101000000E607AEF204BC30407D1FB3582F984740	0
2645	Vasszécseny	9763	0101000000C993FF2499C43040CB3049C043974740	0
2646	Csempeszkopács	9764	010100000032C85D8429CE3040B6F5D37FD6934740	0
2647	Vép	9751	010100000023F609A018B93040426B346F8B9D4740	0
2648	Bozzai	9752	01010000002AFD29FAE8C33040A279A5D1899A4740	0
2649	Nemesbőd	9749	010100000030664B5645BC3040C8B7D2C66CA24740	0
2650	Vát	9748	010100000068DB7A979CC630409BFF571D39A44740	0
2651	Kenéz	9752	0101000000462CBD91D4C9304088FF2A76EA994740	0
2652	Perenye	9722	01010000006D6EF195E5923040DBAA7F6B82A54740	0
2653	Gyöngyösfalu	9723	0101000000283806AE3C963040B403AE2B66A84740	0
2654	Kőszegdoroszló	9725	0101000000F467E498D18A3040D87F9D9B36AC4740	0
2655	Lukácsháza	9724	01010000001B907351E39430409D24A7C013AB4740	0
2656	Vassurány	9741	01010000003EE0CB8E9EB43040094C4CBCA8A44740	0
2657	Tormásliget	9736	010100000025BE24DFB6C6304091E22DA1CCB64740	0
2658	Lócs	9634	01010000003CC1FEEBDCD0304007657506A1B34740	0
2659	Iklanberény	9634	0101000000C54A1641ADCD30408FA850DD5CB64740	0
2660	Alsóújlak	9842	0101000000372A81DE65DA304092BEFF45868A4740	0
2661	Rum	9766	0101000000F926F2C92FD83040FCB1FFF0A9904740	0
2662	Meggyeskovácsi	9757	01010000007DEC2E5052DE30408E3ADFF4D3944740	0
2663	Pecöl	9754	010100000033969F0A6ED43040F316597C549A4740	0
2664	Megyehíd	9754	0101000000AF0D709C6FD73040FEA325451A9B4740	0
2665	Szeleste	9622	010100000065D295BEC6D430409F083DF60EA84740	0
2666	Ölbő	9621	01010000005171773128DC304018EC866D8BA64740	0
2667	Pósfa	9636	01010000008664B7859DDA3040ACDB453DE9A94740	0
2668	Répceszentgyörgy	9623	01010000009A3E3BE0BAD8304003D8DBC1E3AC4740	0
2669	Szemenye	9685	010100000037D8405F1FE8304059A725B1FF8C4740	0
2670	Hosszúpereszteg	9676	0101000000B5CD435CEF0531400097B66E398C4740	0
2671	Nemeskeresztúr	9548	0101000000C90B44AA833131401A266431FB8B4740	0
2672	Egervölgy	9684	010100000054C2B8C08AE8304029DCE1653C8F4740	0
2673	Káld	9673	010100000031314C5C7D0B314041C17BFDFF944740	0
2674	Gérce	9672	01010000000AC9B898550431402EE6E786A69B4740	0
2675	Vashosszúfalu	9674	0101000000CEBBFB2D4B0F31403ACFD8976C8E4740	0
2676	Duka	9556	0101000000D3B4D5F6C01C3140A9FD310807904740	0
2677	Borgáta	9554	010100000096ABC4E17114314085F46FF2B6944740	0
2678	Kamond	8469	010100000061AA99B514343140491A9249FC924740	0
2679	Nemesládony	9663	0101000000AB01EF891AE33040872062DE3EB34740	0
2680	Nagygeresd	9664	01010000006F1D2D18A6EE30408FDA69108BB24740	0
2681	Mersevát	9531	010100000063B323D577343140D63BDC0E0DA54740	0
2682	Szergény	9523	010100000065283806AE443140334C12F010AA4740	0
2683	Törtel	2747	01010000009F292AD148F03340B3976DA7AD8F4740	0
2684	Dabronc	8345	0101000000AC263E2DF52A314072E1404816844740	0
2685	Gógánfa	8346	01010000000E7C56E3B62F3140B0CA85CABF824740	0
2686	Ukk	8347	0101000000BAE5D99BCE3631400B557B2299854740	0
2687	Jászkarajenő	2746	01010000008A48032E7E113440F7D33549E2864740	0
2688	Zalaerdőd	8344	0101000000AC962A0769243140BDEA5CAC03874740	0
2689	Hetyefő	8344	0101000000E4EE18C341293140FBAE08FEB7854740	0
2690	Lesencefalu	8318	010100000022E17B7F8358314006B8C5A1236C4740	0
2691	Nemesvita	8311	0101000000CB6A15585B5E314029BE90C481694740	0
2692	Lesencetomaj	8318	010100000018C627AE745C31404171B66FA46D4740	0
2693	Hegymagas	8265	01010000006674F684DB6E3140CC9DF419AB6A4740	0
2694	Raposka	8300	0101000000D1668B5A506C31404D5EAE8F986C4740	0
2695	Csépa	5475	01010000001F44D72A66213440B6B52A2E33674740	0
2696	Badacsonytördemic	8263	010100000037154E7743793140FC034070F0674740	0
2697	Nemesgulács	8284	01010000004B1FBAA0BE7B314055850662D96A4740	0
2698	Balatonhenye	8275	0101000000F610E8A7939D314059350873BB744740	0
2699	Monoszló	8273	01010000004F6A792F08A43140DF02644392734740	0
2700	Tagyon	8272	0101000000DEF1DC312BAE314089FA134B80734740	0
2701	Szentantalfa	8272	0101000000F5B97FD18AAC31403DC1B45EC2744740	0
2702	Szentjakabfa	8272	010100000056EEAAAC12AD31405E9214A28D774740	0
2703	Balatoncsicsó	8272	0101000000ED7B79A63CAB314093324EE89A764740	0
2704	Óbudavár	8272	01010000004582A966D6B03140E2BB838E0C784740	0
2705	Mencshely	8271	01010000003B2BB35252B33140C037972C38794740	0
2706	Vöröstó	8291	010100000036BBA4202EB93140D476B8C2607C4740	0
2707	Barnag	8291	010100000005D61643DEBF31408005D5AB6D7D4740	0
2708	Nemesvámos	8248	01010000001DCFC2F92FDF3140FD5DE9C605874740	0
2709	Veszprémfajsz	8248	01010000007A8956934CE53140AFD2382FA9844740	0
2710	Szentkirályszabadja	8225	0101000000893952C774F83140F39A0DE83B874740	0
2711	Zalahaláp	8308	010100000017EFC7ED977531405034B4A61E754740	0
2712	Csajág	8163	010100000042A2BF86962F3240252EB6FFB7854740	0
2713	Küngös	8162	01010000001911D610662C32407ED9870673884740	0
2714	Tiszasas	5474	01010000007B7F283D781434404065A1421A694740	0
2715	Szelevény	5476	010100000069E9656F84323440080264E8D8664740	0
2716	Nagyrév	5463	0101000000A9143B1A87243440D72DA7A90A794740	0
2717	Tiszajenő	5094	0101000000E6289BCD3E2434405BF51494FD834740	0
2718	Tiszavárkony	5092	010100000029DDA7F45D2D3440FE8F5DB3A6884740	0
2719	Mezőhék	5453	0101000000A1FE0EA03A6334407DBFE2BA737F4740	0
2720	Vezseny	5093	0101000000F17739364C38344019051C9D4E844740	0
2721	Rákócziújfalu	5084	0101000000D1990F632D43344035705177AF874740	0
2722	Mesterszállás	5452	01010000002C76453A4D6E34404D614AC9177A4740	0
2723	Kisunyom	9772	0101000000493547B137A430404732F504D3924740	0
2724	Zsennye	9766	0101000000536BABA3F4D03040836275F5748E4740	0
2725	Megyer	8348	0101000000FFE66AD03C31314047D6D0BCD2874740	0
2726	Zalameggyes	8348	010100000027B38BB33338314038E5C061588A4740	0
2727	Zalaszegvár	8476	010100000084EC61D45A3931400561B8848D8C4740	0
2728	Hosztót	8475	0101000000BD40A43A783D314034B7E79E1A8B4740	0
2729	Bodorfa	8471	0101000000089DC6ACCD573140B9B94269B9894740	0
2730	Kissomlyó	9555	0101000000B18BA2073E1A3140793C2D3F70924740	0
2731	Kemenespálfa	9544	0101000000D97BF1457B2C31406404543882914740	0
2732	Nagypirit	8496	01010000005888B3C7B03931401796E425A4994740	0
2733	Külsővat	9532	0101000000AD1402B9C439314021E692AAEDA54740	0
2734	Kiscsősz	8494	010100000006459847A34731400E84640113994740	0
2735	Somlójenő	8478	01010000001E3D34E2B85A31407FEF80FCB68F4740	0
2736	Somlóvásárhely	8481	01010000002A7E422C51603140A9F7544E7B8F4740	0
2737	Somlóvecse	8484	0101000000A663CE33F6593140D26D2EA3FD984740	0
2738	Doba	8482	010100000040EA65CA3D613140DAC298993E954740	0
2739	Kispirit	8496	0101000000B136C64E783D3140991BC2E73D994740	0
2740	Csögle	8495	01010000009C19FD68384131409BFB500E0B9C4740	0
2741	Adorjánháza	8497	0101000000942EFD4B523D3140D90352071E9F4740	0
2742	Nemesszalók	9533	010100000074362E2D344D314049FB7A1920A34740	0
2743	Kisszőlős	8483	010100000043BAE9E0AA543140BE2374E151994740	0
2744	Dabrony	8485	0101000000B532E197FA533140B1E07EC0039F4740	0
2745	Nyárád	8512	010100000065D30094755C314036960BF038A44740	0
2746	Borszörcsök	8479	0101000000A19D78735D673140411B6FE12F914740	0
2747	Oroszi	8458	01010000006555849B8C6A31402C4BCF4FCC934740	0
2748	Pápasalamon	8594	01010000009DB415A0126C314003C1D2AF639D4740	0
2749	Marcalgergelyi	9534	0101000000F209D9791B4531408BBE277BF0A74740	0
2750	Vinár	9535	0101000000123933B0444831406B33A9FCC6A74740	0
2751	Mihályháza	8513	0101000000FEF3346090563140FA68CC7FA3A74740	0
2752	Pápadereske	8593	01010000002F3608CE74663140DE019EB470A54740	0
2753	Mezőlak	8514	0101000000CFEE35A90D5F3140F616C5611FAA4740	0
2754	Békás	8515	0101000000AC55BB26A4593140E1EEACDD76AA4740	0
2755	Pusztamiske	8455	01010000006E5974A1A87231400714A05C09884740	0
2756	Kolontár	8468	01010000007BF1EAC149793140164B917C258B4740	0
2757	Úrkút	8409	010100000029441BDBC6A43140E12879758E8A4740	0
2758	Litér	8196	01010000001973D712F20132409FB0C403CA8C4740	0
2759	Ganna	8597	0101000000EA20544E208731409E5099AC9B9D4740	0
2760	Adásztevel	8561	010100000073052516428A3140FE5767C6ECA64740	0
2761	Nagytevel	8562	0101000000F56ADB8BC39031405B96AFCBF0A54740	0
2762	Szentgál	8444	01010000008E14DBEE2FBC3140D010E912698E4740	0
2763	Csehbánya	8445	010100000015FDA19927AF314059F9653046974740	0
2764	Farkasgyepű	8582	01010000009FB7674C77A131403BC8467B179A4740	0
2765	Bánd	8443	0101000000D92B877192C7314020F532E59E8F4740	0
2766	Homokbödöge	8563	0101000000DBB05C250E973140E5F7EC6FBFA64740	0
2767	Borzavár	8428	0101000000D8576831C2D331406BC9F49551A54740	0
2768	Porva	8429	0101000000ACA8C1340CD13140F3A908DC5FA74740	0
2769	Bakonyoszlop	8418	01010000004CAD52D55FEC31408F3C6B1217AC4740	0
2770	Sóly	8193	0101000000721019FB37083240AE6763809F904740	0
2771	Királyszentistván	8195	0101000000BFD2F9F02C0B324008872870FC8D4740	0
2772	Vilonya	8194	0101000000B1E72109B10F3240D4A8763C1C8E4740	0
2773	Bakonynána	8422	0101000000BAB65CA21FF83140E8F7FD9B17A44740	0
2774	Tés	8109	0101000000BAFF7EE7CD0732406A6803B001A14740	0
2775	Jásd	8424	01010000003F6EBF7CB2063240677C04A337A44740	0
2776	Papkeszi	8183	0101000000EC905154EC143240E3E9F06B7F8A4740	0
2777	Nyáregyháza	2723	01010000000DB55CECAC8033409505B8C5A1A14740	0
2778	Vasad	2211	0101000000A374E95F92663340CFBEF2203DA94740	0
2779	Csévharaszt	2212	010100000068D608B3BF6E3340CD1A61F657A64740	0
2780	Bénye	2216	010100000055CF937C368A3340AFB48CD47BAD4740	0
2781	Csemő	2713	0101000000BD55D7A19AB23340DA88CC01278F4740	0
2782	Tápiószentmárton	2711	010100000005871744A4BE33407F50172994AB4740	0
2783	Tószeg	5091	0101000000AAF3A8F8BF25344022179CC1DF8C4740	0
2784	Rákóczifalva	5085	010100000055C2137AFD3B34405A06E6327F8B4740	0
2785	Kengyel	5083	0101000000648918C0A55734401B272AC01C8C4740	0
2786	Kétpó	5411	01010000008DE7D8E66B7B34404014CC9882894740	0
2787	Zagyvarékas	5051	0101000000F168E388B52034407818497144A24740	0
2788	Tiszatenyő	5082	01010000001FE4ABD3376134404819710168914740	0
2789	Tiszapüspöki	5211	0101000000EE9B56653A513440D06F4EDB759B4740	0
2790	Csataszög	5064	0101000000C999DCDE24623440C6C37B0E2CA44740	0
2791	Szászberek	5053	01010000005E49F25CDF173440ADB2A5FDC5A74740	0
2792	Besenyszög	5071	0101000000F8325184D441344080CBAD5AE3A54740	0
2793	Hunyadfalva	5063	01010000007D303A6A965F3440833C71EFD0A74740	0
2794	Kuncsorba	5412	0101000000FE028B0D278E3440A0104B146B904740	0
2795	Nagykörű	5065	0101000000CBBF9657AE733440E02D90A0F8A24740	0
2796	Örményes	5222	0101000000C5D27602509134409198A0866F984740	0
2797	Kőtelek	5062	0101000000F90BE2A8816F3440330A93F30FAB4740	0
2798	Tiszabő	5232	0101000000F39A0DE83B7C3440F3DB210F8EA74740	0
2799	Pilisszentiván	2084	0101000000BB1B55979DE53240C2734A9B05CE4740	0
2800	Simaság	9633	01010000007D9AEED00BD8304085668D30FBB54740	0
2801	Kemeneshőgyész	8516	01010000005D6BEF53554C31408B659F6C6FAD4740	0
2802	Nagyacsád	8521	010100000028D1370E615F3140F7E461A1D6AE4740	0
2803	Magyargencs	8517	0101000000CCA7D8E2644A3140783CD285FDAF4740	0
2804	Vanyola	8552	01010000009E51A9C8D798314028DF22E648B14740	0
2805	Lovászpatona	8553	0101000000DEA925C22BA2314085251E5036B84740	0
2806	Nagydém	8554	0101000000DEFF6C50A0AC3140E5BA849E28B84740	0
2807	Réde	2886	01010000000DE02D90A0EA3140337BEAA232B74740	0
2808	Ácsteszér	2887	010100000077FC72C1740132403FDAA447F8B34740	0
2809	Bakonybánk	2885	0101000000F1A0D9756FE73140EAD6C633C3BB4740	0
2810	Bársonyos	2883	0101000000A2DDD737E6EB3140E003858B26C14740	0
2811	Bakonyszombathely	2884	0101000000270692C19BF53140156F641EF9BC4740	0
2812	Kerékteleki	2882	0101000000A7FB4A3151F03140EB81A0EDE2C14740	0
2813	Ászár	2881	010100000056140A6C290132407C7BD7A02FC14740	0
2814	Tárkány	2945	01010000004145D5AF74003240BA93991C88CB4740	0
2815	Csép	2946	0101000000E3C6889F5A1032406E5397E71CCA4740	0
2816	Vaszar	8542	010100000032AB77B81D843140700E322482B34740	0
2817	Gecse	8543	01010000005AD020AA958631409F77BEFAD3B84740	0
2818	Súr	2889	0101000000D91C8C7D6E073240F612190C64AF4740	0
2819	Csatka	2888	01010000005372F3322FFA31402A5778978BB04740	0
2820	Aka	2862	01010000004F2734A4E511324048AEF60BD1B34740	0
2821	Ete	2947	0101000000526342CC251332402F14556419C44740	0
2822	Nagyigmánd	2942	0101000000C42632738113324076F2333F48D14740	0
2823	Kömlőd	2853	01010000002A4712CEB842324020764B1707C64740	0
2824	Szákszend	2856	0101000000051B32795E2B3240AA3CCB3D6EC64740	0
2825	Kocs	2898	01010000002B80CE49943632409A1D4E0581CD4740	0
2826	Kecskéd	2852	01010000001B255415BF4E32408B016D0613C34740	0
2827	Környe	2851	01010000001220F939F454324024FC411317C64740	0
2828	Ecser	2233	010100000086B4215A86513340C03E3A75E5B84740	0
2829	Mende	2235	010100000083FE9D488B743340CC18D5D814B74740	0
2830	Gomba	2217	0101000000D4371F8DF987334048A3A76D68AF4740	0
2831	Úri	2244	01010000007B0789FE1A8633401B0FB6D8EDB44740	0
2832	Tápióság	2253	01010000005F52C6095DA133402851E56A1AB34740	0
2833	Kóka	2243	01010000003C44EDC8A294334062049EC59CBE4740	0
2834	Dány	2118	0101000000EC12D55B038D33400F97C1BDD7C24740	0
2835	Zsámbok	2116	01010000000F4F65074B9B33400F9E640685C54740	0
2836	Vácszentlászló	2115	010100000039F471C861893340B8CE1A1769C94740	0
2837	Hévízgyörk	2192	010100000022A1D22DE08433400091D9B4ADD04740	0
2838	Galgahévíz	2193	01010000006EE1D4624B8E33409397EB23A6CF4740	0
2839	Szentlőrinckáta	2255	010100000090053BB47EC13340837EF0EBD1C24740	0
2840	Jászfelsőszentgyörgy	5111	01010000003F5B62C0EDCA33408D5E0D501AC14740	0
2841	Boldog	3016	0101000000CC2F39A407B233400CEDF71FF4CC4740	0
2842	Pusztamonostor	5125	0101000000CE3C1460B3CB334082E90F28F6C64740	0
2843	Jászágó	5124	0101000000985AA5AABFDA334012818F66D1CB4740	0
2844	Jászalsószentgyörgy	5054	01010000004B2E104E551734404154D0A398AF4740	0
2845	Jászladány	5055	0101000000B1694A57552A34401A5822ABB6AE4740	0
2846	Alattyán	5142	01010000007D3958A42E0C344067028FB97CB64740	0
2847	Jászkisér	5137	010100000072EC8FE67E373440D1C54BDCCFBA4740	0
2848	Jásztelek	5141	010100000012047E4397003440E59A02999DBD4740	0
2849	Visznek	3293	010100000065BF93BB74083440E5057D8E34D24740	0
2850	Erk	3295	010100000099B2785677133440C28476F3F9CD4740	0
2851	Jászszentandrás	5136	0101000000EF456A90382C3440217DEE5FB4CA4740	0
2852	Jászivány	5135	01010000009ACA47F7183F34408B845BE3D8C24740	0
2853	Pély	3381	0101000000DFED30DC6F573440EB707495EEBE4740	0
2854	Tarnaszentmiklós	3382	0101000000273C574A8561344001AB7E00ADC34740	0
2855	Hevesvezekény	3383	01010000002762B6099C5B34407080F4A853C74740	0
2856	Zaránk	3296	010100000063F261516C1A344051E2CEE04AD24740	0
2857	Boconád	3368	010100000083ADC89EF32F3440C4B70B282FD24740	0
2858	Tiszasüly	5061	010100000035FCB8478064344044E856BE1DB24740	0
2859	Tiszaroff	5234	01010000001500E31934703440433A3C84F1B24740	0
2860	Tiszabura	5235	0101000000824C7CFF30753440DE4D017A2BB94740	0
2861	Tiszagyenda	5233	01010000001F45420015833440B691A1197AB04740	0
2862	Kömlő	3372	010100000035B2D073B0713440B7692222EBCC4740	0
2863	Tomajmonostora	5324	0101000000BC44509033B43440E1849DBD8EB74740	0
2864	Tiszaderzs	5243	0101000000499EEBFB70A43440CC553DAAABC14740	0
2865	Tiszaszentimre	5322	0101000000008E3D7B2EB9344007EBFF1CE6BE4740	0
2866	Tiszaörs	5362	0101000000421A5FC5F3D134402C38729307C14740	0
2867	Naszály	2899	01010000001FBDE13E724332409202B0A657D94740	0
2868	Nagysáp	2524	01010000000D16F3188A9A324063409BC184D74740	0
2869	Bajót	2533	0101000000F82C1911D68E3240B328ECA2E8DC4740	0
2870	Mogyorósbánya	2535	01010000002B645353379A32403291D26C1EDD4740	0
2871	Pári	7091	010100000016359886E1413240A1FBCD1F2E4A4740	0
2872	Nőtincs	2610	01010000007C40457AF6233340B2ACEA9BEAF04740	0
2873	Ősagárd	2610	010100000099E6673403323340D255BABBCEED4740	0
2874	Szécsénke	2692	0101000000B61F3A4E1B553340442C071FEFF34740	0
2875	Kisecset	2655	0101000000D58E8763024F33409666A9ABF1F74740	0
2876	Kálló	2175	010100000030F7240BF37D3340C4E68821DEDF4740	0
2877	Erdőkürt	2176	01010000001D0AFA66F67633401403C9E0CDE24740	0
2878	Heréd	3011	0101000000EC6CC83F33A23340975FBCD529DA4740	0
2879	Erdőtarcsa	2177	01010000008A5CCBBFF18A3340BEC51E3581E14740	0
2880	Nagykökényes	3012	0101000000028640892A9933404DD64DCEF5DD4740	0
2881	Palotás	3042	0101000000B961CA7674983340B336D77AD0E54740	0
2882	Csány	3015	01010000001CF0F96184D43340711C78B5DCD24740	0
2883	Hort	3014	0101000000732B84D558C83340D1915CFE43D84740	0
2884	Vanyarc	2688	01010000005947FA59D1733340219B3F016FE94740	0
2885	Bér	3045	0101000000C6D2D1BBC28033405CAF44FBB3EE4740	0
2886	Szirák	3044	010100000027B0EF79B4873340348694FA0DEA4740	0
2887	Kisbágyon	3046	010100000044561234C195334078D1579066E94740	0
2888	Buják	3047	0101000000BF164F988B8B3340C1A26CDB41F14740	0
2889	Szarvasgede	3051	0101000000EA77616BB6A43340B644D37E10E94740	0
2890	Csécse	3052	01010000004589F1F510A033406A1904B1C7EE4740	0
2891	Gyöngyössolymos	3231	01010000000C46DBE7E7EE33402DBA505491E84740	0
2892	Parádsasvár	3242	0101000000CEC7B5A162FA3340D94933CCBFF44740	0
2893	Karácsond	3281	010100000089A6FD20DC063440279309AEA8DC4740	0
2894	Visonta	3271	01010000000D66B8A6E50634408BC3995FCDE34740	0
2895	Nagyfüged	3282	0101000000A98D452E931A3440513EF3284BD74740	0
2896	Tarnaméra	3284	0101000000085A8121AB273440A2E6F5717ED34740	0
2897	Tarnazsadány	3283	0101000000CE29125D61293440699C3C1BA8D64740	0
2898	Nagyút	3357	01010000002A615C60452C3440AFE9414129DC4740	0
2899	Halmajugra	3273	01010000009A44189A460E3440A8E0F08288E14740	0
2900	Ludas	3274	0101000000868D57C5C01734404649A35DE0DD4740	0
2901	Detk	3275	01010000007016E5886B193440D0D8F225AFDF4740	0
2902	Tarnabod	3369	0101000000BF06E9CEB8393440BDCBA0359AD74740	0
2903	Kompolt	3356	01010000007959130B7C3D344061DEE34C13DF4740	0
2904	Kál	3350	01010000007147EE9F5D42344085A5CBACEFDD4740	0
2905	Egerfarmos	3379	01010000003DDBFEF04E893440613F7A79F0DB4740	0
2906	Parád	3240	0101000000432B4190CD073440F1FBEDA133F64740	0
2907	Kisnána	3264	0101000000D09A1F7F69253440E126A3CA30ED4740	0
2908	Tarnaszentmária	3331	0101000000D6BB896BC6333440A7A32DF87EF04740	0
2909	Sirok	3332	010100000067A494C61E323440463FBF9426F74740	0
2910	Egerszólát	3328	01010000008D800A4790443440C28AAE66F8F14740	0
2911	Demjén	3395	01010000008AB2124E6655344001F6D1A92BEA4740	0
2912	Egerszalók	3394	0101000000EF607AB1E65234401A31B3CF63EF4740	0
2913	Novaj	3327	0101000000242136FD7E7A344071D52B1B8CED4740	0
2914	Bököny	4231	0101000000961F5D11A1C0354065598BAABADD4740	0
2915	Geszteréd	4232	0101000000EDD79DEE3CC735406646E460DBE14740	0
2916	Érpatak	4245	01010000000CA947BF22C23540ED9FA70183E74740	0
2917	Biri	4235	0101000000038DE3D1D7D9354051B52792F9E74740	0
2918	Kálmánháza	4434	01010000006C257497C49335403EB6C079CCEF4740	0
2919	Penészlek	4267	010100000063580FA9B324364082BA922E47D14740	0
2920	Nyírgelse	4362	0101000000A43DB901FAF83540D7F6764B72E14740	0
2921	Nyírbéltek	4372	0101000000D6CF51FD3921364090BB085394D94740	0
2922	Encsencs	4374	0101000000284FB4064A1D3640B5C6A01342DF4740	0
2923	Ömböly	4373	0101000000C279275591363640C9DEF714A5D94740	0
2924	Piricse	4375	010100000041EEC792DE263640D6FD0868C7E24740	0
2925	Nyírpilis	4376	0101000000850C3F93582F3640694183A856E44740	0
2926	Bátorliget	4343	010100000081DDFAFA6B453640F325AF29EBE04740	0
2927	Terem	4342	0101000000C8B60C384B473640439A67DB1FE64740	0
2928	Vállaj	4351	010100000092054CE0D66136409B6AD212D0E14740	0
2929	Kállósemjén	4324	0101000000C05AB56B42F03540AA6D799BEDED4740	0
2930	Pócspetri	4327	01010000009701672959FE3540C0A84995CDF04740	0
2931	Nyírvasvári	4341	01010000000D78F41A16303640864666E4E2E84740	0
2932	Nyírcsászári	4331	0101000000E090FC77332D36404AB4E4F1B4EE4740	0
2933	Nyírkáta	4333	01010000001A44B5D2B53E36407F15E0BBCDEE4740	0
2934	Tiborszállás	4353	0101000000393F6AB86D683640439836774FE84740	0
2935	Tereske	2652	0101000000F306F3B2813133403084F7B072F94740	0
2936	Pusztaberki	2658	01010000006D2C7299E429334064BF380202FD4740	0
2937	Csesztve	2678	0101000000DA20EE450F4733404B11CFC8D6014840	0
2938	Herencsény	2677	0101000000EB45A3F1FA783340213EB0E3BFFC4740	0
2939	Cserhátszentiván	3066	010100000041DBC58F8C943340AFB085C54DF84740	0
2940	Kutasó	3066	0101000000CA445BDFD18A3340A564DE4F32F94740	0
2941	Iliny	2675	0101000000C0DF79F3656D33406416EB6525044840	0
2942	Nógrádmegyer	3132	01010000007D64294822A033407DF8437DDC084840	0
2943	Sóshartyán	3131	01010000000EE665039FAD33409D35D31808094840	0
2944	Endrefalva	3165	01010000008970DDDE7F933340D10DA8925C104840	0
2945	Piliny	3134	01010000006F9AE3816D9933408AEF1F668A114840	0
2946	Szécsényfelfalu	3135	0101000000EB8B84B69C913340F82D84E684124840	0
2947	Magyargéc	3133	0101000000C091E5C9DA99334079BC7FE2B60A4840	0
2948	Karancsság	3163	010100000054B252F7B7A833401DBBFA67BC0E4840	0
2949	Ságújfalu	3162	01010000009CBF098508AE3340019DEEE1370D4840	0
2950	Szalmatercs	3163	0101000000EE87E98C39A3334056C675429E0F4840	0
2951	Egyházasgerge	3185	01010000003F2EBB719CA533400262122EE4164840	0
2952	Mihálygerge	3184	0101000000994121A754A2334002261532FC184840	0
2953	Mátraszőlős	3068	0101000000BD91D49D82B33340779DB23FF5F84740	0
2954	Sámsonháza	3074	0101000000A53AD33A60B933400C5C1E6B46FE4740	0
2955	Tar	3073	010100000000D8CA958BBE33404F858950B6F94740	0
2956	Mátraverebély	3077	0101000000487254C95BC73340582BC9F08EFC4740	0
2957	Dorogháza	3153	0101000000D2FA00497DE633404F35C4C25AFE4740	0
2958	Szuha	3154	01010000002E24BB2DECEA33407A4F8AFB34FD4740	0
2959	Mátramindszent	3155	01010000000FFE8F5DB3EE33403FBD63C279FD4740	0
2960	Nagybárkány	3075	0101000000C0B8AF5EA0B333404F513FB9B7FF4740	0
2961	Kisbárkány	3075	01010000008E80C0B975AF334036DDFCD016024840	0
2962	Lucfalva	3129	0101000000C16966D24BB133409192C3CCE3034840	0
2963	Márkháza	3075	01010000002B23E47272B73340DC758071BA014840	0
2964	Nagykeresztúr	3129	0101000000E77BFC9419B93340E674FE92F9044840	0
2965	Vizslás	3128	01010000001BED5D2805D2334065CD7E935C064840	0
2966	Kazár	3127	01010000001BF1097EC0DA3340C6A52A6D71064840	0
2967	Etes	3136	0101000000AB7D95D7A5B733405193CFE1100E4840	0
2968	Karancskeszi	3183	0101000000CE435CEFEDB23340C83E6DF9ED144840	0
2969	Karancsalja	3181	010100000032DB5F877BC03340C8E64FC01B114840	0
2970	Karancslapujtő	3182	0101000000089BF00170BC3340953B7D4E8B134840	0
2971	Nemti	3152	0101000000FA3D569522E633406F57F9AFBD004840	0
2972	Mátraterenye	3145	0101000000B3EBDE8AC4F233401CF0541BF7034840	0
2973	Mátraszele	3142	0101000000A35698BED7E43340DC63E94317074840	0
2974	Mátranovák	3143	0101000000873A072A3EFB33404C46DFEEF6044840	0
2975	Bárna	3126	0101000000278AEB7310EF3340A5F5B704E00C4840	0
2976	Cered	3123	0101000000155EDD0C92F7334012F8C3CF7F124840	0
2977	Karancsberény	3137	01010000007094BC3AC7BE33404BA2A87D84174840	0
2978	Bodony	3243	0101000000ED3E6C8E18063440C23AE9D89CF84740	0
2979	Szilaspogony	3125	01010000002AD1483AB9053440DB183BE1250F4840	0
2980	Recsk	3245	0101000000A405C314401C3440CB5BBFAAC4F74740	0
2981	Mátraderecske	3246	01010000000AA0185932153440E12879758EF94740	0
2982	Szajla	3334	01010000002601C5234C243440CDDC8D4F12FB4740	0
2983	Terpes	3334	010100000024C09FD0A1263440FCC165BA7CFC4740	0
2984	Egerbakta	3321	0101000000883BCDB85F4A3440036DBC85BFF74740	0
2985	Ivád	3248	010100000044E27904920F3440BCFCF3D9A6024840	0
2986	Erdőkövesd	3252	0101000000860FDBCCD719344080F854A934054840	0
2987	Váraszó	3254	0101000000F8D96DBCE01C34402CD670917B074840	0
2988	Kisfüzes	3256	0101000000B0202812A7203440DDB6EF517FFE4740	0
2989	Bükkszék	3335	0101000000204432E4D82C34403E7B2E5393FE4740	0
2990	Fedémes	3255	0101000000EEAE58688C2F34407795FFDA0B044840	0
2991	Tarnalelesz	3258	01010000001158946D3B2E3440B378B13044074840	0
2992	Szentdomonkos	3259	0101000000BEFFEACC9833344027A3CA30EE084840	0
2993	Istenmezeje	3253	0101000000D70C1588430D34404974E0E69E0A4840	0
2994	Zabar	3124	0101000000AB3BBB21320B34408F26CDD545114840	0
2995	Hevesaranyos	3322	01010000000C3F389F3A3C3440204B7A7313014840	0
2996	Egerbocs	3337	01010000001FA6D82CF2423440F27A30293E034840	0
2997	Szúcs	3341	01010000004721C9ACDE3F34400EE3C9C91F064840	0
2998	Egercsehi	3341	0101000000652CE45B69413440A930B610E4064840	0
2999	Mónosbél	3345	0101000000DF98AFDC1C5634407CFDFFEED3044840	0
3000	Mikófalva	3344	0101000000D8D3B3C5DA5034402C02AD0A1E074840	0
3001	Bükkszentmárton	3346	0101000000D9FF4AF8EF533440CF1C48CD0D094840	0
3002	Felsőtárkány	3324	01010000008558A258136A34408ED36B0E6BFC4740	0
3003	Nagyvisnyó	3349	010100000041553B79476C3440E0D91EBDE1114840	0
3004	Tiszadob	4456	0101000000D80C7041B62A35400E09298936014840	0
3005	Tiszadada	4455	0101000000EBB01DE7913C35409694BBCFF1034840	0
3006	Nagycserkesz	4445	0101000000D0C4854DAE8D3540D0B4C4CA68FB4740	0
3007	Tiszaeszlár	4464	0101000000231C695F2F753540368F68A78B044840	0
3008	Tiszanagyfalu	4463	0101000000423168D773783540A5710399F80B4840	0
3009	Gávavencsellő	4471	0101000000A68E9FD7E9973540ECA529029C144840	0
3010	Tiszabercel	4474	010100000004E621533EA635406DC5A3F908144840	0
3011	Paszab	4475	01010000002C239AE557AA3540867BC0971D124840	0
3012	Szabolcs	4467	0101000000E61D4C2FD67E3540AD6301B8FE154840	0
3013	Balsa	4468	0101000000DBDBD20F8F893540BFE3254921164840	0
3014	Tiszatelek	4487	0101000000A68691B98DCB354059B043EB97184840	0
3015	Napkor	4552	010100000095EC7D4F51DE354069AD68739CF84740	0
3016	Nyírpazony	4531	01010000007480BB4791CC3540954FEA268CFD4740	0
3017	Nyírtura	4532	0101000000F67F69AC58D53540624D6551D8014840	0
3018	Sényő	4533	010100000025A24E2FE7E03540EF2C8BD35A004840	0
3019	Nyírbogdány	4511	010100000068C240214CDF354048A9DFE066074840	0
3020	Vasmegyer	4502	01010000003416A8209AD03540D188E30A390E4840	0
3021	Kék	4515	010100000007712F7AB8E03540509F2E9CB50E4840	0
3022	Tiszarád	4503	0101000000B95CB34B0ACC3540BE333564970F4840	0
3023	Beszterec	4488	01010000008E95F32098D6354040BE840A0E144840	0
3024	Apagy	4553	010100000059445E2052EF35405B11EB43CDFA4740	0
3025	Magy	4556	0101000000EDB0D35977FB354034B33B495FF84740	0
3026	Ófehértó	4558	0101000000CA277513C60836406E934039C0F74740	0
3027	Levelek	4555	01010000003DF438679FFC3540F610E8A793FB4740	0
3028	Besenyőd	4557	0101000000A2084E226702364012E04FE850FB4740	0
3029	Nyírtét	4554	010100000048E6ECF88AEB3540D7B8A3A42C014840	0
3030	Nyíribrony	4535	0101000000A88A4E3BA1F6354054C14DEBDB014840	0
3031	Székely	4534	0101000000FCFCF7E0B5EF3540D923D40CA9074840	0
3032	Gégény	4517	0101000000F376DF8CF5F23540BC0E304ED7124840	0
3033	Nyírkércs	4537	0101000000B1F5B127260C36405B689DA7F0014840	0
3034	Ramocsaháza	4536	010100000085D272FB40FD3540A6CFB3FE3B054840	0
3035	Laskod	4543	01010000005C27E439110B36406355CE28A7064840	0
3036	Nyírjákó	4541	0101000000B2DE03CF1813364073D13538B6034840	0
3037	Petneháza	4542	010100000091860959CC143640B8F072C751074840	0
3038	Berkesz	4521	010100000011C7BAB88DFA3540212D848BCB0B4840	0
3039	Nyírtass	4522	010100000090E2772EE7053640198CB6CFCF0E4840	0
3040	Nyírkarász	4544	0101000000F82E4A75A61936401FB4684B670C4840	0
3041	Gyulaháza	4545	01010000002263FF869A1C36408CE8E802A8114840	0
3042	Szabolcsbáka	4547	0101000000417D70E3BB2336409698C2DE1F144840	0
3043	Nyírderzs	4332	010100000028FC08B254293640B20D81C8C7F24740	0
3044	Kántorjánosi	4335	010100000001BF4692202636403E6E090ACDF74740	0
3045	Hodász	4334	01010000006872D64C63343640550CA1945AF54740	0
3046	Őr	4336	0101000000CA3269F8BB2E3640286AC427F8FC4740	0
3047	Nyírmeggyes	4722	0101000000E5AE6F719E4336404E8061F9F3F44740	0
3048	Jármi	4337	0101000000B309302C7F4036408C03F92356FC4740	0
3049	Papos	4338	01010000004147AB5AD23F3640678D30FB2BFE4740	0
3050	Vaja	4562	01010000003C54AE4BE82B36407B42C06BE1FF4740	0
3051	Pusztadobos	4565	0101000000B71ECF786C3936406CE289C514074840	0
3052	Nyírparasznya	4822	0101000000D55E9F94A4463640AF7F322141034840	0
3053	Ilk	4566	01010000005CA4F55C4B3B3640D08E650B520F4840	0
3054	Gemzse	4567	01010000008F064BD0BA3136406C5F402FDC114840	0
3055	Pátroha	4523	0101000000B7C2AA306CFD354071EC342D0C164840	0
3056	Ajak	4524	0101000000E75DABF35E0D3640908BC5CAC3164840	0
3057	Anarcs	4546	01010000005C994B05701A3640E2A0CE26D1164840	0
3058	Rétközberencs	4525	0101000000D6C743DFDD023640BB213251291A4840	0
3059	Pap	4631	0101000000A39641107B2436402A60F18A961B4840	0
3060	Szabolcsveresmart	4496	0101000000DC25169DD1053640A372B8FBC1254840	0
3061	Döge	4495	0101000000C7478B33861136400163224A20214840	0
3062	Fényeslitke	4621	0101000000892D98535D193640727ACD61AD224840	0
3063	Komoró	4622	01010000009BFCBBE3B91D3640DBB1C7FABC264840	0
3064	Nyírlövő	4632	0101000000AB894F4BBD2E3640B0517BB6B3194840	0
3065	Lövőpetri	4633	0101000000CC1F7821C23236404A9462EC29174840	0
3066	Tornyospálca	4642	010100000095319985D12D36404177932930224840	0
3067	Győröcske	4625	0101000000D3197332CC2636408894B08053314840	0
3068	Annavölgy	2529	01010000005A9654127EAA32400B2A053818D94740	0
3069	Tolmács	2657	0101000000810871E5EC1B334016FFD2FDF7F64740	0
3070	Bokor	3066	0101000000323CF6B3588A33404D0A3DAC81F74740	0
3071	Rákóczibánya	3151	010100000006BAF605F4DE3340D6C97443AE034840	0
3072	Tákos	4845	0101000000EFBF3A33666D36408D1F741AB3134840	0
3073	Kótaj	4482	01010000005F268A90BAB5354025F14D2E21064840	0
3074	Újdombrád	4491	0101000000818F66D1E0DD3540984D8061F9184840	0
3075	Jéke	4611	01010000005D65129AC9263640742497FF901E4840	0
3076	Darnó	4737	01010000002C0A606F07A936406CFCD357A1FA4740	0
3077	Mátraszentimre	3235	010100000058326C393CE13340C314408C6BF44740	0
3078	Pálosvörösmart	3261	0101000000F10CBF40B5FE33405E2A36E675E84740	0
3079	Kerekharaszt	3009	01010000002CFA9EECC19F3340F73FC05AB5D44740	0
3080	Egeralja	8497	010100000036E0980A963D3140523937B7539E4740	0
3081	Sáska	8308	0101000000C1334690EF793140659016C2C5774740	0
3082	Hegyesd	8296	01010000001C052DC9A685314070EA03C93B754740	0
3083	Kisapáti	8284	0101000000ACA8667B997731404947DEDEDA6B4740	0
3084	Ceglédbercel	2737	01010000005514AFB2B6AD334044C59338869B4740	0
3085	Drávatamási	7979	0101000000E1BC93AA48923140E481C8224DF84640	0
3086	Sárszentmihály	8143	0101000000B418E19288533240E447A1D1C2934740	0
3087	Zalagyömörő	8349	0101000000ED0F94DBF6393140AC39403047824740	0
3088	Városföld	6033	01010000005E4D9EB29AC23340F52C08E57D684740	0
3089	Bakonyság	8557	0101000000712DA40DD1A6314038BF61A241B34740	0
3090	Ősi	8161	0101000000573728AB333032403F9D3C7661924740	0
3091	Rigács	8348	0101000000E6C0BC1127373140D408A2934A884740	0
3092	Uzsa	8321	0101000000FC8BA031935631401C727D699B724740	0
3093	Gic	8435	010100000071DD3939E8BF31405D67E84427B74740	0
3094	Nyársapát	2712	0101000000B8CA13083BCD3340CB170F4AF38C4740	0
3095	Csénye	9611	010100000029FC636BC7DE30401217DBFF5B9E4740	0
3096	Chernelházadamonya	9624	010100000026D98FB9D7D6304048AE51C543AE4740	0
3097	Rábatöttös	9766	01010000005675A09806CF30405D46FB69ED904740	0
3098	Mosonudvar	9246	0101000000A03715A9303A31405688FD54CBEB4740	0
3099	Ómassa	3517	01010000002CE45B696388344056C09888120E4840	0
3100	Márokföld	8976	0101000000CBA3761AC47030400D3F9358AD5B4740	0
3101	Vasalja	9921	0101000000148B29A2708330406AE4A9FD8C814740	0
3102	Kőröstetétlen	2745	01010000004667F4FE9A053440D7F445E7A18C4740	0
3103	Abony	2740	01010000008319AE693901344062388DA328984740	0
3104	Nagytilaj	9832	01010000001E6FF25B74F63040347FF1B1607D4740	0
3105	Zalaszentlőrinc	8921	01010000003EF669CB6FE3304085DE2C6F58754740	0
3106	Zubogy	3723	0101000000318EDB792C9334409023E70EAC304840	0
3107	Püski	9235	0101000000AEDE3C30DB67314004F9235690F14740	0
3108	Regöly	7193	0101000000DBEC5921F6633240C74D68ED114A4740	0
3109	Békéssámson	5946	010100000035B8AD2D3C9F3440E64240193E354740	0
3110	Becsehely	8866	01010000003E4569CAA9CA3040D94F10864B394740	0
3111	Tornakápolna	3761	0101000000829D51A9C89D34401576ACAD333B4840	0
3112	Kunfehértó	6413	01010000001A9826B6CC693340C119FCFD622E4740	0
3113	Tarnaörs	3294	0101000000945ADE0B820D3440BB3E181D35CC4740	0
3114	Gencsapáti	9721	0101000000435B295F2B9830400494E1D3F7A44740	0
3115	Szentpéterúr	8762	0101000000BD48B258D409314038A7EDBA12614740	0
3116	Kübekháza	6755	01010000003E6BC889C04634409A2FE53224134740	0
3117	Kisigmánd	2948	0101000000467FC39F3C19324019ED4CFCACD34740	0
3118	Kisújszállás	5310	0101000000ABDF96D931C13440665C829DAC9B4740	0
3119	Szarvaskő	3323	01010000005586713788543440C10E52A687FE4740	0
3120	Péteri	2209	0101000000984B4FFD28693340AE98B624ACB14740	0
3121	Alacska	3779	0101000000712DA40DD1A634405A40B2CA961B4840	0
3122	Dunaújváros	2400	0101000000095A379490F03240D0F81972C77B4740	0
3123	Monorierdő	2213	0101000000D5004AE8D37F33407C9F05FC75A74740	0
3124	Kéked	3899	0101000000C765DCD44059354027BD6F7CED454840	0
3125	Máriahalom	2527	01010000009F1C058882B53240DEC199A95AD04740	0
3126	Sárisáp	2523	01010000003F8C101E6DAE32400660A86851D64740	0
3127	Úny	2528	0101000000FAE472CD2EBD3240B45318004FD24740	0
3128	Döröske	9913	0101000000F185240E34B23040D13C80457E814740	0
3129	Szombathely	9700	0101000000BF7D1D38679E3040B77471C0539D4740	0
3130	Kurd	7226	010100000057276728EE50324058F1FC5877394740	0
3131	Söpte	9743	0101000000BE7E2D54A3A6304072439D0315A44740	0
3132	Csokvaomány	3647	01010000004B1641ADB35F3440AECCA50238154840	0
3133	Szolnok	5000	01010000005D209CAAD6313440A033695375964740	0
3134	Mánfa	7304	0101000000358AF6C2AE3D3240268DD13AAA144740	0
3135	Lesenceistvánd	8319	0101000000F30EA6176B5C3140FC2B75DA646F4740	0
3136	Taliándörögd	8295	01010000003985F0C39C91314076BC6EB65E7D4740	0
3137	Kapolcs	8294	010100000015A529A7E29B3140E350BF0B5B7A4740	0
3138	Szihalom	3377	010100000046B01644497B3440429770E82DE34740	0
3139	Tiszabezdéd	4624	0101000000BD0743780F273640F49BD3765D2E4840	0
3140	Dunaszentpál	9175	0101000000C61DCAABCE8131403A5F47776BE34740	0
3141	Belegrád	0	0101000000EC70CF4E61F23440A842F284140B4840	0
3142	Galgamácsa	2183	0101000000D5D3A299826233403E40F7E5CCD84740	0
3143	Mátraballa	3247	0101000000EEFCEC91170534402D9CFFB2D6FD4740	0
3144	Nagyszénás	5931	01010000002AE8514C39AC34407DD6EBCCF3554740	0
3145	Tunyogmatolcs	4731	0101000000D1240C5E4F75364045A79D503EFC4740	0
3146	Csibrák	7225	010100000059D9E32ABB573240071DBE96A13B4740	0
3147	Maklár	3397	0101000000315BB22AC2693440548550EFF3E64740	0
3148	Balatonszárszó	8624	01010000007C07E4B78DD53140FBF900EEC3694740	0
3149	Nemesszentandrás	8925	01010000003826D588AAF130407665BC523B634740	0
3150	Tardona	3644	0101000000F4D9A61DA3873440C7968A32C0154840	0
3151	Biharkeresztes	4110	0101000000165685611BB83540A8469EDACF904740	0
3152	Téglás	4243	010100000015CF34BCB4AC3540F24EF4AF9BDB4740	0
3153	Körmösdpuszta	4135	0101000000FF9DA34401953540C19F2B5B358A4740	0
3154	Kecel	6237	0101000000A84F17CEDA403340F5A276BF0A434740	0
3155	Zánka	8251	0101000000AE8ED25BF2AE3140BD569D30BC6F4740	0
3156	Balogunyom	9771	0101000000BCA71721E1A6304020B24813EF934740	0
3157	Kétújfalu	7975	01010000004FADBEBA2AB6314002DC87179FFB4640	0
3158	Selymes	0	0101000000364DE9AA8A6A33408B074AC09E454740	0
3159	Kistiszahát	0	0101000000F0C000C287D63540E35DE454211C4840	0
3160	Ozmánbük	8998	0101000000F06B2409C2AB3040B5A107E34C764740	0
3161	Bakópuszta	2678	01010000009F292AD1484C334078279F1EDB014840	0
3162	Dobaipuszta	0	0101000000F509455FE672354077137CD3F47A4740	0
3163	Kocsér	2755	0101000000830DF4F521EC33403278F3AF40804740	0
3164	Göbölyjárás	0	0101000000358CCC6D0CCD334046D49F5802AF4740	0
3165	Fischerbócsa	6235	01010000009186AE9F5989334044B060D1634F4740	0
3166	Ongaújfalu	0	0101000000479C0425BBE8344063974D25A8124840	0
3167	Kispáhi	0	010100000077B17AD168663340ACDB453DE95D4740	0
3168	Kisvid	0	01010000000F2D0D5762493140ADA6464321414740	0
3169	Erdőszéplak	0	0101000000B9ED314745AA334071CC0DE1F3534740	0
3170	Tölgyeszögtanya	0	0101000000EEDDD5613B023640378364A659224840	0
3171	Tiszahát	0	01010000000E3D1867C2C935404194D4AEAE194840	0
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plans (id, name, description, sku, price, type, duration_in_hours, balance_to_add, visible, created_at, boosts_first_place, stripe_price_id, stripe_product_id) FROM stdin;
1	Nincs aktív csomagod	Nincs aktív csomagod	default	0	time based subscription	0	0	f	2021-04-28 14:23:38.139415	f		
2	3 havi csomag	Mester szolgáltatás csomag 3 hónap	CSOM-1	9900	time based subscription	2190	0	f	2021-04-28 14:23:38.141872	f		
3	6 havi csomag	Mester szolgáltatás csomag 6 hónap	CSOM-2	14940	time based subscription	4380	0	f	2021-04-28 14:23:38.143682	f		
4	12 havi csomag	Mester szolgáltatás csomag 6 hónap	CSOM-3	23880	time based subscription	8760	0	f	2021-04-28 14:23:38.14533	f		
5	Alap egyenleg csomag	7000 Ft egyenleg feltöltés	ALAP-1	7000	balance	0	7000	t	2021-04-28 14:23:38.147607	f		
6	6 havi alap csomag	6 havi mester szolgáltatás csomag	ALAP-2	17940	time based subscription	4380	0	t	2021-04-28 14:23:38.149085	f		
7	12 havi alap csomag	12 havi mester szolgáltatás csomag	ALAP-3	29880	time based subscription	8760	0	t	2021-04-28 14:23:38.15021	f		
8	Prémium egyenleg csomag	20 000 ft prémium egyenleg	PREMIUM-1	20000	balance	0	20000	t	2021-04-28 14:23:38.15174	t		
9	3 havi prémium csomag	3 havi prémium mester szolgáltatás csomag	PREMIUM-2	24990	time based subscription	2160	0	t	2021-04-28 14:23:38.152924	t		
\.


--
-- Data for Name: profession; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profession (id, name, category, aliases, priority) FROM stdin;
4	Esztegályos	1	Alkatrészgyártás, CNC esztergályos, Fém megmunkálás	0
5	Fűtés szerelő	1	Kazán javítás, Cirkó javítás, Fűtés szerelés	0
6	Lakatos	1	Ajtó javítás, Zár javítás, Zárszerelés	0
8	Gázvezeték szerelő	1	Gázvezeték szerelés, Gázvezeték kiépítés	0
9	Hőszigetelés	1		0
11	Kivitelezés	1		0
12	Térkövezés	1		0
13	Nyílászáró és árnyékolástechnikai szerelő	1	Ablakcsere, Ajtócsere, Üvegezés, Ablakszigetelés, Redőny szerelés, Redőny készítés, Árnyékoló szerelés, Szúnyogháló szerelés	0
14	Belsőépítész	1		0
15	Statikus	1		0
16	Épületgépész	1	Fűtés kiépítés, Vízvezeték kiépítés, Vízvezeték szerelés. radiátor csere, konvektor csere	0
17	Napelem-, napkollektor rendszer kiépítés	1		0
19	Építész	1		0
20	Műszaki ellenőr	1		0
21	Földmérő	1		0
22	Földmunka	1		0
26	Riasztó szerelő	2	Riasztók szerelés, riasztó javítás, riasztó telepítés	0
27	Kamerarendszer telepítő	2	Kamera szerelés, kamera javítás, kamera rendszer telepítés	0
28	Háztartási gép szerelő	2	Mosógép szerelés, Mikró szerelés, Hűtőgép szerelés, Mosogatógép szerelés	0
29	Kéményseprő	2		0
30	Takarítás	2	Ablaktisztítás, Takarítás	0
31	TV szerelő	2		0
32	Kárpitos	2	Kárpittisztítás, Kárpitjavítás	0
33	Lakberendező	2		0
34	Öntözőrendszer telepítő	2		0
35	Garázskapu szerelő	2	Kapu szerelés, Garázskapu szerelés	0
36	Kertész	2	Dísznövénykertész	0
37	Hűtő-, klíma- és hőszivattyú berendezés-szerelő	2	Hűtő szerelés, Klíma szerelés, Hőszivattyú szerelés	0
38	Bejárónő	2		0
39	Állatorvos	2		0
40	Kertigép szerelő	2		0
41	Elektromos gép- és készülékszerelő	2		0
42	Adótanácsadás	3		0
43	Könyvelés	3		0
44	Pénzügyi tanácsadás	3		0
45	Közjegyző	3		0
46	Ügyvéd	3	Jogi tanácsadás, Okiratszerkesztés, Jogi védelem, Jogi képviselet	0
47	Jogász	3	Jogtanácsos, Bíra	0
48	Befektetési tanácsadás	3		0
49	Biztosítási ügynök	3		0
50	Értékesítési munkatárs	3		0
51	Pályázatírás	3		0
52	Online marketing	3		0
53	Egyéb	3		0
54	Belgyógyász	4		0
55	Természetgyógyász	4		0
56	Laboráns	4		0
57	Nővér	4		0
58	Ápoló	4		0
59	Optikus	4		0
60	Szociális munkás	4		0
61	Terapeuta	4		0
62	Bőrgyógyász	4		0
63	Gyermekorvos	4		0
64	Gyógypedagógus	4		0
65	Gyógytornász	4		0
66	Masszázs	4		0
67	Csontkovács	4		0
68	Fogorvos	4		0
69	Jóga oktatás	4		0
70	Személyi edző	4		0
71	Szájsebész	4		0
72	Kozmetikus	4		0
73	Műkörmös	4		0
74	Pszichiáter	4		0
75	Fodrász	4		0
76	Borbély	4		0
77	Dietetikus	4		0
78	Pszichológus	4		0
79	Aneszteziológus	4		0
80	Füll-orr-gégész	4		0
81	Endokrinológus	4		0
82	Kardiológus	4		0
83	Onkológus	4		0
84	Urulógus	4		0
85	Sebész	4		0
86	Ideggyógyáz	4		0
87	Szemész	4		0
88	Szakaszisztens	4		0
89	Fogtechnikus	4		0
90	Gyógyszerész	4		0
91	Gyógyszertári asszisztens	4		0
92	Látszerész	4		0
93	Informatikus	5		0
94	Honlapkészítő	5	Honlapkészítés, Honlapkarbantartás	0
95	Számítógépszerelő	5	Számítógép javítás, Laptop javítás, Adatmentés, Operációs rendszer telepítés	0
96	Programozó	5	Programozás, Szoftverfejlesztés, Applikációfejlesztés	0
97	Webfejlesztő	5	 Frontend, Backend, Fullstack	0
98	Mobil app fejlesztő	5		0
99	Rendszergazda	5		0
100	Nyomató szerelés	5	Szkenner szerelés, Nyomtató szerelés, Nyomtató szervizelés	0
101	Telefonszerelés	5		0
102	Adatrögzítés	5		0
103	Telefonszerelés	5		0
104	PLC programozó	5		0
105	Számítógépes műszaki rajzoló	5		0
106	Egyéb informatika, számítástechnika	5		0
107	Autófényezés	6		0
108	Autófóliázás	6		0
109	Autószerelés	6		0
110	Autókozmetika	6		0
25	Generálkivitelező	1		0
2	Ács	1	Tetőfedés, szigetelés, zsaluzás, állványozás	96
24	Burkoló	1		94
111	Autómentés	6		0
112	Autóüvegezés	6		0
113	Gumiszervizelés	6		0
114	Motorkerékpár szerelés	6		0
115	Karosszérialakatos	6		0
116	Kárpittisztítás	6		0
117	Autóvillamossági szerelő	6		0
118	Szélvédőjavítás	6		0
119	Kerékpár szerelő	6		0
120	Műanyag hegesztő	6		0
121	Egyéb autó, motor, kerékpár	6		0
122	Futár	7		0
123	Fuvarozás	7	Belföldi fuvarozás, Nemzetközi fuvarozás	0
124	Költöztetés	7		0
125	Személyszállítás	7		0
126	Raktárrozás	7		0
127	Lomtalanítás	7		0
128	Diszpécser	7		0
129	Vásárlás, szállítás	7		0
130	Törmelék elszállítás	7		0
131	Élelmiszer kiszállítás	7		0
132	Egyéb szállítás, fuvarozás	7		0
133	Nyelvtanár	8		0
134	Fizika tanár	8		0
135	Fordító	8		0
136	Magántanár	8		0
137	Magyar tanár	8		0
138	Matematika tanár	8		0
139	Német tanár	8		0
140	Francia tanár	8		0
141	Spanyol tanár	8		0
142	Olasz tanár	8		0
143	Orosz tanár	8		0
144	Tanár	8		0
145	Óvónő	8		0
146	Kémia tanár	8		0
147	Bébiszitter	8		0
148	Angol tanár	8		0
149	Könyvtáros	8		0
150	Csecsemő és gyermekápoló	8		0
151	Óvodai dajka	8		0
152	Egyéb oktatás	8		0
153	Hostess	9		0
154	Pincér	9		0
155	Recepciós	9		0
156	Pultos	9		0
157	Felszolgáló	9		0
158	Szakács	9		0
159	Rendzvényszervező	9		0
160	Idegenvezető	9		0
161	Utazásszervező	9		0
162	Tolmács	9		0
163	Esküvőszervező	9		0
164	Bűvész	9		0
165	Szobalány	9		0
166	Fényképész	9		0
167	Videós	9		0
168	Hentes	9		0
169	Pék	9		0
170	Látványtervező	9		0
171	Animátor	9		0
172	DJ	9		0
173	Zenész	9		0
174	Cukrász	9		0
175	Konyhai kisegítő	9		0
176	Pirotechnikus	9		0
177	Táncos	9		0
178	Újságíró	10		0
179	Biztonsági őr	10		0
180	Ékszerész	10		0
181	Rovarirtás	10		0
182	Bolti eladó	10		0
183	Bőrdíszműves	10		0
184	Tetoválás	10		0
185	Üzemeltetés	10		0
186	Becsüs	10		0
187	Boltvezető	10		0
188	Cipész	10		0
189	Designer	10		0
190	CNC gépkezelő	10		0
191	Élelmezésvezető	10		0
192	Hegesztő	10		0
193	Könyvkötő	10		0
194	Sírkő készítő	10		0
195	Kutyakozmetikus	10		0
196	Méhész	10		0
197	Molnár	10		0
198	Órás	10		0
199	Vegyész	10		0
200	Szabó	10		0
201	Varrónő	10		0
202	Vízimentő	10		0
203	Ügyfélszolgálatos	10		0
204	Favágó	10		0
205	Gravírozás	10		0
206	Árufeltöltés	10		0
207	Egyéb fizikai munka	10		0
208	Titkárnő	10		0
209	Rágcsálóírtás	10		0
210	Mérnök	10		0
211	Asszisztens	10		0
212	Búvár	10		0
213	Alpinista	10		0
214	Jegyellenőr	10		0
215	Kulcsmásolás	10		0
216	Anyagmozgatás	10		0
217	Nehézgépkezelő	10		0
218	Műszerész	10		0
219	Egyéb mesterség	10		0
18	Vízvezeték szerelés	1	Duguláselhárítás	0
220	Beton szállítás	7	Beton gyártás	0
7	Festő	1	Festés, tapétázás, gipszkartonozás	70
10	Villanyszerelő	1	Hálózat felújítás, Hálózat javítás, Hibaelhárítás, Elektromos készülékeke bekötése, Mérőhely kialakítás	99
3	Asztalos	1	Bútorkészítés, Bútorszerelés, Bútorfelújítás, Bútorasztalos	95
1	Kőműves	1	Burkolás, Homlokzatalakítás, Szigetelés, Vakolás, Felújítás, Betonozás, Zsaluzás, Falazás	98
221	 Ingatlan értékbecslő	2		0
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, email_verified, profile_pic, phone) FROM stdin;
2	Patrik Bajusz	bajusz.patrik@gmail.com	f	https://lh3.googleusercontent.com/a-/AOh14Giz6xvyfOUla8Sn3Q6P5eoT3zpKurB6Nns4ggY61Q	+36301741451
1	Máté Bajusz	bajszmate99@gmail.com	f	https://lh5.googleusercontent.com/-G4B3_iRyUlM/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucmEgpuoJB4gQZfbq-7TXzbWjTgErg/photo.jpg	+3630123456
41	Balázs Hornyák	kicsikis@gmail.com	f	https://lh3.googleusercontent.com/a-/AOh14GgIob8fWkUop5II-wMLPMX9KO7POC0-1cnXMiXycQ=s96-c	
3	Patrik Bajusz	avenger9637@gmail.com	f	https://lh3.googleusercontent.com/a-/AOh14Ghk9C7dujwqxC2ahpWHhqWvVPBDd_aV1StV-DIC	+36309124773
4	bakjanos	pelda@example.com	f	https://s.gravatar.com/avatar/9b5db3c77675759a9f3b96461635bfb4?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fba.png	
49	Barta Valentin	bartavalentin99@gmail.com	f	https://lh3.googleusercontent.com/a-/AOh14GjWAPML3r4Au-00OQDaO7JkMHi29qc0psb5Weevag=s96-c	
73	Bello Hello	thisisrocketleague1999@gmail.com	f	https://lh6.googleusercontent.com/-eMSknTquHUo/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuckii3yLDer5b6_bdrDmN7PcLGRZSQ/s96-c/photo.jpg	
74	Patrik Bajusz	bajusz.patrik@mestertkeresek.hu	f	https://lh6.googleusercontent.com/-7FBgdSkqbQU/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucl8pMw4Yp9RDfQxagxtWf5lk7d2ug/s96-c/photo.jpg	
71	Marketing Mestertkeresek	marketing@mestertkeresek.hu	f	https://lh3.googleusercontent.com/-Z8JUo3zo9QI/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuckgkxehJfOAt2MzkZklolVfAMSBbw/s96-c/photo.jpg	+36301234567
5	acsolunk	pelda@example.com	f	https://s.gravatar.com/avatar/a17182b8a4b50de01e6bacb59f54309f?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fin.png	
6	Debrecen HR	pelda@example.com	f	https://lh3.googleusercontent.com/-H1RjkPWhN9g/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucm7raN93NFB6m3ZBQkw0ZCe1Ip-WA/photo.jpg	
7	Sándor Oláh	pelda@example.com	f	https://lh3.googleusercontent.com/a-/AOh14GhGzu74KYE2k0OFgSyCUMR0tme58FffL14Mzk6bIg	
8	fekete.mt	pelda@example.com	f	profil-kepek/fb5b3daf-e49c-4dc4-9e67-6a7ea11f3d4d.jpg	
9	Tibor Szilber	pelda@example.com	f	https://lh3.googleusercontent.com/a-/AOh14GhEcQLDbSUnPO7Cz9g8yRuZdVdrUvSQRjjFGufc	
10	Tibor Bódis	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3711090572254097&height=50&width=50&ext=1603162871&hash=AeS0PDZG-F2LlQmX	
11	ti-bowelding	pelda@example.com	f	https://s.gravatar.com/avatar/0e575314027895e03ce42b02b12c51f0?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fti.png	
12	maxelectric81	pelda@example.com	f	https://s.gravatar.com/avatar/f62a55ef50f1fa51ac58afc3a63efedf?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fma.png	
14	valkomate	pelda@example.com	f	https://s.gravatar.com/avatar/9a23721dfdcd13f242eb3ceb7d9784a2?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fme.png	
15	Andrea Varju	pelda@example.com	f	https://lh4.googleusercontent.com/-BHPiBm-X-f4/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucm1WXE5NrT0vA2uPmHyHcIB-6I_hg/photo.jpg	
16	Kivitelezés Bau	pelda@example.com	f	https://lh5.googleusercontent.com/-EZ28CHKjzxw/AAAAAAAAAAI/AAAAAAAAAAA/AMZuuckZGIECLklt_rujng7ZdwiD_9TODQ/photo.jpg	
47	Krupják József	pelda@example.com	f	profil-kepek/b6c0a681-7b07-4b88-aeb1-ab4199854fa7.jpg	
17	bolacsek	pelda@example.com	f	https://s.gravatar.com/avatar/5b37e6ddeede5a9e7659b75c624c32d2?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fbo.png	
18	horzoli75	pelda@example.com	f	https://s.gravatar.com/avatar/3dff3b77eb2dd498fb4b3d866ba6d58c?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fho.png	
19	Daniel Kónya	pelda@example.com	f	https://eu.ui-avatars.com/api/?name=Danie+Konya	
20	kungfucsiga	pelda@example.com	f	https://s.gravatar.com/avatar/71f519859ed51f58d88de0a953b832e6?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fku.png	
21	Томас Рудокас	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3464902716888725&height=50&width=50&ext=1603481338&hash=AeRHSar3AgCCt9bq	
22	Patrik Mulató	pelda@example.com	f	https://lh3.googleusercontent.com/a-/AOh14GhjrGzq8GX423UfuMu0IF6HJtXUt6Ba_fwXp7Nf	
23	Péter Simkó	pelda@example.com	f	https://lh4.googleusercontent.com/-ts28MBaHkOM/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucnd5dS3T0ZCRJkdEmIhCZoB8yH-RQ/photo.jpg	
24	mesterur	pelda@example.com	f	https://s.gravatar.com/avatar/b06181ead99974ab0efcba8e0c29ca92?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fme.png	
25	papod	pelda@example.com	f	https://s.gravatar.com/avatar/a5c06eb997472eb71002325c98548d10?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fko.png	
26	István Láczó	pelda@example.com	f	https://lh6.googleusercontent.com/-_muIh5lRmdA/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucmkVSZYV0qgvK5o2rk9A0l57AhY5g/photo.jpg	
27	Frenky Max	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=4421200064618828&height=50&width=50&ext=1603829009&hash=AeR5t4pkQpjM3Ok6	
28	marcell	pelda@example.com	f	https://s.gravatar.com/avatar/46e08cfadcaab366a602f03e27f46944?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fma.png	
29	Akos Szelle	pelda@example.com	f	https://lh3.googleusercontent.com/a-/AOh14GiKPaS3VdFu8r9VvkXDRS7PhtMINf2wDdNetXfvyw	
30	Attila Péter Nehéz	pelda@example.com	f	profil-kepek/3cbc7409-f6d8-4837-b738-15bf5be85a3e.jpg	
31	Jónás Sándornè	pelda@example.com	f	profil-kepek/155c7869-c388-49fc-9331-a3364335b889.jpg	
32	Máté Bajusz	pelda@example.com	f	https://lh4.googleusercontent.com/-Eq-gZziZm9Y/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucnAdfrFj6PbkQ5jZRXzY1PIFQiJ1A/s96-c/photo.jpg	
33	Sándor Daragó	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=1996767650454348&height=50&width=50&ext=1606155510&hash=AeTnPLhFaF7jq_2ikG4	
34	gabortoth05	pelda@example.com	f	https://s.gravatar.com/avatar/f5dbcffacf186c409410a51657a4205d?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fga.png	
35	Dániel Tasi	pelda@example.com	f	https://lh3.googleusercontent.com/a-/AOh14Ggd0ervHpkKq24byuTMFD02SnoUpBjkV1jVW6ORyQ=s96-c	
36	Leó Kukár	pelda@example.com	f	https://lh6.googleusercontent.com/-xMsi67xBPPw/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucnM4uorvJ-uWDPxbiPdJbCyOrAFMA/s96-c/photo.jpg	
37	Balaton Antenna szerviz	pelda@example.com	f	https://lh3.googleusercontent.com/a-/AOh14Gjj-eJOnPKmKEkUaU7b8woL_vm8embwXD7eil-w=s96-c	
38	Teszt Balázs	pelda@example.com	t	https://s.gravatar.com/avatar/c78eb44d7947977fbc365810008ca6e3?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fin.png	+36301234567
39	teszt	pelda@example.com	f	https://s.gravatar.com/avatar/ba2d09c54e66fa79106f67b79743f626?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fte.png	
40	Nagy Krisztian	pelda@example.com	f	https://s.gravatar.com/avatar/742423cb075793653f0f57ca24bf1545?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fna.png	
42	ferenc	pelda@example.com	f	https://s.gravatar.com/avatar/271ddb4ced13e32b01f970e1e895cde2?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fli.png	
43	Attila Borbély	pelda@example.com	f	https://lh4.googleusercontent.com/-ML4ctFrjFdQ/AAAAAAAAAAI/AAAAAAAAAAA/AMZuucl1uD6mgJ1oj4asThPEbo8yrQbSig/s96-c/photo.jpg	
44	Imre Tamás	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=2830786227141912&height=50&width=50&ext=1606451434&hash=AeQOYeOO_9TlKSwUkos	
45	István Bodor	pelda@example.com	f	https://lh3.googleusercontent.com/a-/AOh14GgUeGgghIRqJW-DjXeICn-RF-Ezl0aRWI55OQUtMw=s96-c	
46	Ilia János	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3421378641275700&height=50&width=50&ext=1606488685&hash=AeQZ8Rs0LyUtHYWf4JU	
48	mezogergo	pelda@example.com	f	https://s.gravatar.com/avatar/af6515f635d14983396d71e0a0754554?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fme.png	
50	bendiegynagy	pelda@example.com	f	https://s.gravatar.com/avatar/14f1abfaeb86e1ea9bd3d93a093a0493?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fbe.png	
51	Dormány Dániel	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3082391898532729&height=50&width=50&ext=1606557204&hash=AeS2da5WjiEFue9aK8I	
52	vnorby	pelda@example.com	f	https://s.gravatar.com/avatar/fcec8394fc94e8de8c3eb56f8181c801?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fvn.png	
53	Krisztián Bacsák	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3660800450639077&height=50&width=50&ext=1606576266&hash=AeSVB1qH8rDdQHYtzac	
54	urpeter0	pelda@example.com	f	https://s.gravatar.com/avatar/640925cd6bb0ef03899729e2ae0a3640?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fur.png	
55	Vill Pala	pelda@example.com	f	profil-kepek/b7ccd6d3-4cda-49be-bf83-84c367063951.jpg	
56	Bohn Gábor	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3446403798787680&height=50&width=50&ext=1606631583&hash=AeRO7LGpuBDEb8oGsuw	
57	benji78	pelda@example.com	f	https://s.gravatar.com/avatar/745e9b0ed41d617e7db16c498b74bace?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fbe.png	
58	roland	pelda@example.com	f	https://s.gravatar.com/avatar/411846c2c3698bd40c7abd5b80349f2f?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fjo.png	
59	Tamás Farkas	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3379642748791937&height=50&width=50&ext=1606718078&hash=AeT2T7Cz17NtRoCykaE	
60	bavar	pelda@example.com	f	https://s.gravatar.com/avatar/e36614aee9b39e043786c6e31f7da795?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fba.png	
61	esztikboy-87	pelda@example.com	f	https://s.gravatar.com/avatar/2a517bae60d53e4d27de54d37aeb4681?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fcu.png	
62	morvai72	pelda@example.com	f	https://s.gravatar.com/avatar/44ccbe57e2dfe17b4ff2634b87ac106a?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fmo.png	
63	Gábor Cseresnyés	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=4787923291280965&height=50&width=50&ext=1606832508&hash=AeS8zuLrr4Y9UjjpCfk	
64	misi	pelda@example.com	f	https://s.gravatar.com/avatar/7f68d3a195991b86ceef55354918cde2?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Ffa.png	
65	Csóka Károly	pelda@example.com	f	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=3480384188675506&height=50&width=50&ext=1606848920&hash=AeSV4b1-fRVbTeNkTSc	
66	robert	pelda@example.com	f	https://s.gravatar.com/avatar/c463476d1f59db3e1b450182133b47fd?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fbi.png	
67	barionteszt	pelda@example.com	f	https://s.gravatar.com/avatar/c0fadf6f2cc4096ca0888a54a7be5974?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fmy.png	
68	sorijev	pelda@example.com	f	https://s.gravatar.com/avatar/069f3a914d2568e8d90a0e591297a667?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fso.png	
69	Janos Bajusz	pelda@example.com	f	profil-kepek/3e9763d0-c10e-4b99-aef2-d6a58b9dec5f.jpg	
70	csabi71	pelda@example.com	f	https://s.gravatar.com/avatar/82a00d80040f6933c5710414f613ab2a?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fcs.png	
72	Aszti Peti	asztipeti1215@gmail.com	f	https://s.gravatar.com/avatar/078d2193bc0f9c5a6e5c8417d47c72fb?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fas.png	
75	András Kovács	pelda@example.com	f	profil-kepek/6832ae85-febf-4533-8a44-6b8e6e565b75.jpg	+36301741451
78	Baluka Teszt	rajeser880@onzmail.com	f	profil-kepek/53622d36-f01a-4b11-96af-cfbe01c1a8d7.jpg	
\.


--
-- Data for Name: worker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.worker (id, user_id, name, phone, email, location, description, website, drop_off_fee, profile_pic, joined, highlight, visible, priority, zip, payed_plan, url, location_id, inspected, business_activities, registration_number, can_issue_invoice) FROM stdin;
61	78	Hornyák Balázs	+36204416868	rajeser880@onzmail.com		Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vel eros nec felis convallis sodales venenatis ut nibh....		10000		2021-01-19	f	f	99	0	f	hornyak-balazs-webfejleszto	104	f		123-456-78	f
12	14	Valkó Máté László EV	+36123456789	pelda@example.com	Budapest	Üdvözöljük! Vállalkozásunk több, mint 5 év alapult, több mint 10 év tapasztalattal, elégedett ügyfelekkel, cégekkel nyújtunk megoldást bármilyen informatikai problémára, irodai folyamatok optimalizálására, adatelemzésre. 		0		2020-09-20	t	t	0	0	t	valko-mate-laszlo-ev-programozo-webfejleszto-rendszergazda	141	f			f
20	27	Frenky 	+36123456789	pelda@example.com	Dabas 	Nincs lehetetlen...  Pontosan, precízen, rugalmasan. Ha elromlott, vagy karban tartanád. Álmodd meg acélból én kivitelezem. IKEA - össze rakom.		0		2020-09-27	f	f	0	0	f	frenky-lakatos-kertigep-szerelo-motorkerekpar-szereles-vasarlas-szallitas	227	f			f
23	30	NAP-TEAM szerviz	+36123456789	pelda@example.com	Budapest, X.	Segítünk pc 🖥 , laptop💻 hibák megoldásában,garanciával, rövid határidővel, otthon és az irodában kiszállással is! Ezen kívül készpénzért megvásároljuk alkatrészeit, laptopját, pc-jét. Javítás ígénylése otthonában, X.ker, XIX.ker, XVIII.ker. Honlap és árak: https://www.nap-team.hu		0		2020-10-05	t	t	0	0	t	nap-team-szerviz-szamitogepszerelo-egyeb-informatika-szamitastechnika	141	f			f
38	61	Ricsák Róbert Attila 	+36123456789	pelda@example.com	Győr	Több éves szakmai múlttal ,tapasztalattal vállalom családi házak esztrik, valamint stiropol hőszigetelő beton készitését valamint teraszok, járdák keszítését is. Megbízható precíz munka, gyors kivitelezés, szakmai tanácsadás!!!		0		2020-10-31	t	t	0	0	t	ricsak-robert-attila-komuves	105	t			t
39	63	Cseresnyés Gábor	+36123456789	pelda@example.com	Nagykanizsa	Épületek villanyszerelését vállalom rövid határidővel garanciával korrekt áron!		0		2020-11-01	f	t	0	0	t	cseresnyes-gabor-villanyszerelo	902	f			f
40	64	Farkas Mihály	+36123456789	pelda@example.com	Budapest	Üdvözlöm Farkas mihály vagyok több éves szakmai gyakorlattal térkövezést kőműves munkát vállalok. 		0		2020-11-01	f	t	0	0	t	farkas-mihaly-komuves-hoszigeteles-terkovezes	141	f			f
41	57	Deák Benjámin	+36123456789	pelda@example.com	Hajduhadhaz	Asztalos munkák nyilászárok, bútorok gyártása javítása, galériák készítése.		0		2020-11-01	f	t	0	0	t	deak-benjamin-asztalos	936	f			f
48	49	Tré-fa Bt	+36123456789	bartavalentin99@gmail.com	Miskolc	Informatika, szoftverfejlesztes		2500		2020-11-12	f	f	0	0	f	tefa-bt	104	f			f
49	70	Csaba Szücs ev	+36123456789	pelda@example.com	Dunakeszi	Kedves leendő Ügyfelek! Akár azonnali kezdéssel vállalunk szobafestést, mázolást, tisztasági festést, glettelést ,újépítésű ház és kerítés festést, kisebb gipszkartonozási munkákat, butor festést. Kisebb munkák esetében is hívjon bizalommal. Amit nyújtunk: - ingyenes felmérés, tanácsadás, figyelembe véve az ügyfél igényeit (ár-érték arány) - pontos, tiszta munkavégzés- számla adás megfizethető árak.		0		2020-11-13	f	t	0	0	f	csaba-szucs-ev-festo	199	t			t
52	73	Villany Pisti	+36123456789	thisisrocketleague1999@gmail.com	Miskolc	asd vagypl asd a;a  .és aasd dsa		0		2020-12-01	f	t	0	0	t	hervoly-mark-e-v-informatikus-szamitogepszerelo-egyeb-informatika	104	f			f
62	2	Angyal Ferenc	+36301741451	bajusz.patrik@gmail.com		SZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEG		0		2021-03-22	f	t	0	0	t	apad-fasza-villanyszerelo-muszaki-ellenor	2311	f			f
56	1	Bajusz Máté ev.	+36309828187	bajszmate99@gmail.com		dasdasdl;kad;asdaskldl;asdklal;sd		0		2021-01-18	f	f	0	0	f	bajusz-mate-ev-acs	141	t			t
8	8	Fekete Máté E.V.	+36123456789	pelda@example.com	Szolnok	Fekete Máté egészségügyi gázmester vagyok.  Ha meggyűlne a bajod a rágcsálókkal vagy a rovarokkal, akkor keress bizalommal!		0		2020-09-19	t	t	0	0	t	fekete-mate-e-v-rovarirtas-ragcsaloirtas	3133	t			t
51	72	Aszalos petike	+36306543221	asztipeti1215@gmail.com	Miskolc	Sziasziasziasziasziasziasziaszia		5000		2020-12-01	f	t	0	0	t	pothurszki-laszlo-ev-festo	104	f			f
3	4	Helyben-Távban Könyvelőiroda Kft.	+36123456789	pelda@example.com	Budapest	Kérem, CSAK AKKOR KÉRJEN könyvelési vagy tanácsadási ÁRAJÁNLATOT, ha a munkához nem várja el a személyes jelenlétet.  Mi majdnem minden ügyfelet elfogadunk, mert van elég kapacitásunk, viszont a havi anyagokat emailben vagy más elektronikus úton várjuk, az esetlegesen papíron meglévőket mobillal lefényképezve vagy beszkennelve - a teendőit ugyanígy kapja vissza. Emellett gyorspostával is küldheti az anyagokat, ha vállalja annak a havi 2000 Ft-os költségét. Több városban irodával is jelen vagyunk (Budapest, Tatabánya, Komárom, Bakonybél, Nagyigmánd), így itt a hagyományos, papíros megoldás is működhet.  KATÁS vállalkozást 6600 Ft-tól, más egyéni vállalkozást 8800 Ft-tól, kft-t havi 14500 Ft-tól könyvelünk, ezek a díjak az induló, legkisebb forgalomra érvényesek.		0		2020-09-12	t	t	0	0	t	helyben-tavban-konyveloiroda-kft-konyveles	141	t			t
4	7	Oláh Sándor Mustangsan Bt.	+36123456789	pelda@example.com	Miskolc	Villanyszerelés Miskolc A Mustangsan Bt.-ben a Miskolc-Nyíregyháza-Debrecen háromszögben foglalkozunk erősáramú kivitelezéssel, lakossági és ipari környezetben egyaránt. Igények szerint projekt jelleggel is szoktunk kivitelezni. 10+ év tapasztalattal végezzük a dolgunk, rendelkezünk Regisztrált (Főleg ELMŰ-ÉMÁSZ) szerelő, Érintésvédelmi szabványossági felülvizsgáló és Építőipari kivitelező (Ez E-napló szempontjából fontos) titulussal is.   Az online felületeink még elég kezdetlegesek, a referenciák pedig a képtárban várják a rendszerezést és a feltöltést, de elérhetőek vagyunk.    Villanyszerelést, Elektromos Kivitelezést, Érintésvédelmi Szabványossági Felülvizsgálatot, Szerelői Ellenőrzést  és Ipartechnológiai Kivitelezést, Javítást, Átalakítást egyaránt vállalunk.		0		2020-08-30	t	t	0	0	t	olah-sandor-mustangsan-bt-villanyszerelo-napelem-napkollektor-rendszer-kiepites	104	t			t
5	5	Ácsolunk Építőipari Kft.	+36123456789	pelda@example.com	Dunakeszi	Szeretettel üdvözlöm!  Csóka Tihamér vagyok, az Ácsolunk Építőipari Kft. tulajdonosa és ügyvezetője.  Ács, bádogos, tetőfedő, lakatos, kőműves, térkövezés, homlokzatszigetelés, gipszkartonos munkák teljes körű kivitelezése.		0		2020-09-12	t	t	0	0	t	acsolunk-epitoipari-kft-komuves-acs-lakatos-hoszigeteles-kivitelezes-terkovezes	3172	t			t
10	12	Kiss Péter	+36123456789	pelda@example.com	Dunaharaszti	Villanyszerelést vállalok.		0		2020-09-20	f	t	0	0	t	kiss-peter-villanyszerelo-informatikus	611	f			f
13	15	Orcsik Imre	+36123456789	pelda@example.com	Tatabánya	30 éves szakmai tapasztalattal munkát vállalok.		1000		2020-09-20	f	t	0	0	t	orcsik-imre-festo	794	f			f
14	16	Kivitelezés Duna Bau	+36123456789	pelda@example.com	Budapest 	Elkötelezett szakembereimmel az építés,felújítás,átalakítás teljes palettáján értéket építünk.		0		2020-09-20	t	t	0	0	t	kivitelezes-duna-bau-komuves-festo-hoszigeteles-villanyszerelo-terkovezes	141	t			t
16	18	HoPá cleaning 	+36123456789	pelda@example.com	Pápa 	Üdvözlöm! Egyéni vállalkozóként takarítással és ózonos fertőtlenítéssel foglalkozok. Lakások, családi házak, irodák, közintézmények, apartmanok, nyaralók, lépcsőházak egyszeri nagytakarítása, fertőtlenítő takarítása, vagy rendszeres takarítása, illetve ózonos fertőtlenítése és szagtalanítása, valamint autóktól a buszokig klímával együtt történő ózonos fertőtlenítése és szagtalanítása. 		0		2020-09-21	t	t	0	0	t	hopa-cleaning-takaritas	534	f			f
17	19	Somogy Gép-Szer Kft	+36123456789	pelda@example.com	Balatonlelle	Vállaljuk lakó és ipari ingatlanok teljes kivitelezését		0		2020-09-21	f	t	0	0	t	somgy-gep	348	f			f
19	24	Green-klíma	+36123456789	pelda@example.com	Szeged	Klímák értékesítése, telepítése, karbantartása. Forgalmazott klíma márkák: Polar, Bosch, Midea, Gree.Mitsubishi, Samsung, Panasonic, L-G, Daikin,  Villanyszerelés Háztartási gép javítás Nagy konyhai hűtőszekrények javítása, karbantartása 		2500		2020-09-26	t	t	0	0	t	green-klima-villanyszerelo-haztartasi-gep-szerelo-huto-klima-es-hoszivattyu	74	f			f
21	28	Márk Marcell Ádám	+36123456789	pelda@example.com	Budapest	Marci vagyok és a ház körül bármi apró gondot megoldok! 		0		2020-09-28	f	t	0	0	t	mark-marcell-adam-asztalos-villanyszerelo-vizvezetek-szereles	141	f			f
24	31	Szaki Szaki	+36123456789	pelda@example.com	Bágyogszovát	Megbízható csapata határidőre, az elképzeléseknek megfelelően végzi el az elvállalt munkát.    Rendelkezésre állunk magánszemélyek és cégek számára egyaránt, főleg kisebb kivitelezési munkák gyors, pontos elvégzését vállaljuk.      Vállalunk ajtó, ablak beépítés családi ház építés lakásfelújítás tetőtér beépítés hőszigetelés gipszkartonozás hagyományos köporos szinezés   szobafestés burkolás tisztasági festés homlokzatfestés bontás kézi erővel, géppel lakó és nem lakó épület kivitelezése   vakolás gipszkarton szerelés száraz építés beton fúrás, vágás, szögbelövés mélyalapozás tetőszerkezet építés, ácsolás térkő lerakás viacolor lerakás  		5000		2020-10-06	f	f	0	0	f	szaki-szaki-komuves-terkovezes	702	f			f
25	33	Daragó Sándor	+36123456789	pelda@example.com	Budapest	2009 óta foglalkozom weboldal fejlesztéssel és karbantartással. Szeretem a kihívásokat és folyamatosan fejlesztem magam, hogy mindig képben legyek a legújabb megoldásokkal és teendekkel.		0		2020-10-24	t	t	0	0	t	darago-sandor-online-marketing-honlapkeszito-programozo-webfejleszto-adatrogzites	141	f			f
26	37	Hargi-Sat és Társa Kft.	+36123456789	pelda@example.com	Balaton	Földi és műholdas antenna és antenna rendszerek szerelése javítása telepítése .		9500		2020-10-26	t	t	0	0	t	hargi-sat-es-tarsa-kft-villanyszerelo	2548	f			f
28	34	Tóth Gábor	+36123456789	pelda@example.com	Budapest	Vállalom weboldalak tervezését, kivitelezését.		3000		2020-10-26	t	t	0	0	t	toth-gabor-honlapkeszito-programozo-webfejleszto	141	t			t
29	45	Bodor István	+36123456789	pelda@example.com	Tárnok	Új és meglévő épületek, lakások, házak villanyszerelését, karbantartását felújítását, javítását vállalom garanciával, elérhető áron! 		0		2020-10-28	f	t	0	0	t	bodor-istvan-villanyszerelo	191	f			f
31	46	Ilia János	+36123456789	pelda@example.com	Dunaújváros	Szép napot mindenkinek! Felújítani szeretne, keressen bizalommal! Reális és megfizethető áron vállalok fő profilként;  -Lakások, házak festését, kültéri homlokzat színezést. -Tapétázás. -Mázolás -Lazúrozás, Lakkozás kül- és beltérben. -Régi fa ajtók, ablakok butorok felújítása. -Gipszkarton szerelés -Fémszerkezetek korrózióvédelme -Térburkolás -Parkettacsiszolás, -lakkozás Dunaújvárosi vállalkozó.  Tel.: 06704331301 Email: iliajanos@gmail.com		0		2020-10-28	t	t	0	0	t	ilia-janos-festo	3122	f			f
32	47	Krupják és Fia BT	+36123456789	pelda@example.com	Baracs	Víz Gáz Fűtés szerelésel foglalkozunk. 30 éves szakmai tapasztalattal. Januárban 8 év után jöttem haza Svájcbol és azóta ithon állunk az ügyfelek szolgálatára. 		0		2020-10-28	t	t	0	0	t	krupjak-es-fia-bt-futes-szerelo-gazvezetek-szerelo-vizvezetek-szereles	2532	t	villanyszerelés; egyéb villanyszerelés;		t
33	54	Úr Péter	+36123456789	pelda@example.com	Mátészalka	Vállalom meglévő lakó és melléképületek villamos felújítását,új épületek villamos kivitelezését,napelemes rendszer telepítését, hibák feltárását és javítását.ingyenes árajánlat adással és kiszállásal.		0		2020-10-29	t	t	0	0	t	ur-peter-villanyszerelo	945	f			f
34	55	Palakovics Ákos	+36123456789	pelda@example.com	Tatabánya	Üdvözlöm főként lakossági villanyszereléssel hibakereséssel javítással és lakóépületek részleges vagy teljes elektromos felújításával. Riasztók,kaputelefonok,elektromos kapunyitók,kamerarendszerek javításával és telepítésével foglalkozunk.Ha valamiben segítségére lehetünk keressen bizalommal.		0		2020-10-29	t	t	0	0	t	palakovics-akos-villanyszerelo-futar-elelmiszer-kiszallitas	794	t			t
35	59	Farkas Tamás	+36123456789	pelda@example.com	Jánossomorja	Cégünk Épületgépészeti munkával foglalkozik. Főbb tevékenységeink családi és társasházak komplett Víz-Gáz-fűtés ,Szelőzés és Klíma szerelése. 		0		2020-10-31	t	t	0	0	t	farkas-tamas-gazvezetek-szerelo-epuletgepesz	706	f			f
36	58	Joós Roland 	+36123456789	pelda@example.com	Pécs 	Szép jó napot! Hobbim a szakmám . Munkáimról képek a közösségi oldalon , Lakás&Házfelújitás A-Z-ig itt láthatóak .		0		2020-10-31	f	t	0	0	t	joos-roland-burkolo	10	f			f
37	60	Varga Balázs István ev.	+36123456789	pelda@example.com	Budapest, Pest megye	Tisztelt érdeklödő!  Egyéni vállalkozóként, alanyi áfamentesen vállalok lakossági területen villamos hálózatok hibaelhárítását és felújítását. A telefonszámom 10 éve ugysnaz és nem szándékozom megváltoztatni		8000		2020-10-30	t	t	0	0	t	varga-balazs-istvan-ev-villanyszerelo	141	f			f
\.


--
-- Data for Name: worker_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.worker_comments (comment, rating, date, owner_id, worker_id) FROM stdin;
.	5	2020-12-20	3	4
\.


--
-- Data for Name: worker_plan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.worker_plan (id, worker_id, status, active, plan_valid_until, plan_id, first_place_booster, first_place_booster_valid_until, social_ads, social_ads_valid_until, balance, stripe_subscription_id) FROM stdin;
2	4	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
3	3	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
4	20	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
5	5	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
6	13	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
7	37	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
8	39	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
9	40	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
10	38	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
11	41	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
12	8	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
13	16	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
14	12	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
15	19	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
16	10	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
17	21	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
18	17	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
19	14	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
20	25	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
21	23	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
22	24	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
23	26	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
24	28	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
25	29	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
26	32	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
27	31	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
28	33	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
29	34	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
30	35	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
31	36	Nincs aktív csomag	f	2020-11-11	1	f	2020-11-11	f	2020-11-11	0	
35	48	Nincs aktív csomag	t	2021-02-12	2	f	2020-11-12	f	2020-11-12	0	
36	49	Nincs aktív csomag	f	2020-11-13	1	f	2020-11-13	f	2020-11-13	0	
38	51	Nincs aktív csomag	t	2021-03-01	2	f	2020-12-01	f	2020-12-01	0	
39	52	Nincs aktív csomag	t	2021-03-01	2	f	2020-12-01	f	2020-12-01	0	
1	62	Nincs aktív csomag	t	2021-03-22	8	f	2021-03-22	f	2021-03-22	16900	
46	61	Nincs aktív csomag	f	2021-10-29	3	t	2021-05-29	f	2021-04-29	0	
41	56	Nincs aktív csomag	f	2022-04-29	4	f	2021-04-29	f	2021-04-29	5000	sub_JIMqgv9aiJw38D
\.


--
-- Data for Name: workers_professions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workers_professions (worker, profession) FROM stdin;
4	17
4	10
3	43
5	2
5	1
5	25
5	9
5	11
5	6
5	12
61	97
56	199
8	181
8	209
62	10
10	10
10	93
12	99
12	96
12	97
13	7
14	19
14	16
14	24
14	7
14	25
14	9
14	1
14	15
14	12
14	18
14	10
16	30
17	18
17	5
19	37
19	28
19	41
19	10
20	6
20	40
20	114
20	129
20	192
21	10
21	18
21	3
23	95
23	106
24	1
24	12
25	52
25	94
25	96
25	97
25	102
26	10
28	94
28	96
28	97
29	10
31	7
32	5
32	8
32	18
33	10
34	10
34	122
34	131
35	16
35	8
36	24
37	10
38	1
39	10
40	9
40	12
40	1
41	3
48	93
49	7
51	172
52	10
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
1	my_new_topo	26986	0.5	f
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: edge_data_edge_id_seq; Type: SEQUENCE SET; Schema: my_new_topo; Owner: postgres
--

SELECT pg_catalog.setval('my_new_topo.edge_data_edge_id_seq', 1, false);


--
-- Name: face_face_id_seq; Type: SEQUENCE SET; Schema: my_new_topo; Owner: postgres
--

SELECT pg_catalog.setval('my_new_topo.face_face_id_seq', 1, false);


--
-- Name: layer_id_seq; Type: SEQUENCE SET; Schema: my_new_topo; Owner: postgres
--

SELECT pg_catalog.setval('my_new_topo.layer_id_seq', 1, false);


--
-- Name: node_node_id_seq; Type: SEQUENCE SET; Schema: my_new_topo; Owner: postgres
--

SELECT pg_catalog.setval('my_new_topo.node_node_id_seq', 1, false);


--
-- Name: billing_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.billing_info_id_seq', 1, false);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 1, false);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, true);


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.location_id_seq', 3172, true);


--
-- Name: plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plans_id_seq', 9, true);


--
-- Name: profession_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.profession_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: worker_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.worker_id_seq', 1, false);


--
-- Name: worker_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.worker_plan_id_seq', 1, false);


--
-- Name: edge_data edge_data_pkey; Type: CONSTRAINT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.edge_data
    ADD CONSTRAINT edge_data_pkey PRIMARY KEY (edge_id);


--
-- Name: face face_primary_key; Type: CONSTRAINT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.face
    ADD CONSTRAINT face_primary_key PRIMARY KEY (face_id);


--
-- Name: node node_primary_key; Type: CONSTRAINT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.node
    ADD CONSTRAINT node_primary_key PRIMARY KEY (node_id);


--
-- Name: relation relation_layer_id_topogeo_id_element_id_element_type_key; Type: CONSTRAINT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.relation
    ADD CONSTRAINT relation_layer_id_topogeo_id_element_id_element_type_key UNIQUE (layer_id, topogeo_id, element_id, element_type);


--
-- Name: billing_info billing_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_info
    ADD CONSTRAINT billing_info_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: profession profession_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profession
    ADD CONSTRAINT profession_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: worker_comments worker_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_comments
    ADD CONSTRAINT worker_comments_pkey PRIMARY KEY (owner_id, worker_id);


--
-- Name: worker worker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_pkey PRIMARY KEY (id);


--
-- Name: worker_plan worker_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_plan
    ADD CONSTRAINT worker_plan_pkey PRIMARY KEY (id);


--
-- Name: worker worker_url_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_url_key UNIQUE (url);


--
-- Name: workers_professions workers_professions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workers_professions
    ADD CONSTRAINT workers_professions_pkey PRIMARY KEY (worker, profession);


--
-- Name: edge_end_node_idx; Type: INDEX; Schema: my_new_topo; Owner: postgres
--

CREATE INDEX edge_end_node_idx ON my_new_topo.edge_data USING btree (end_node);


--
-- Name: edge_gist; Type: INDEX; Schema: my_new_topo; Owner: postgres
--

CREATE INDEX edge_gist ON my_new_topo.edge_data USING gist (geom);


--
-- Name: edge_left_face_idx; Type: INDEX; Schema: my_new_topo; Owner: postgres
--

CREATE INDEX edge_left_face_idx ON my_new_topo.edge_data USING btree (left_face);


--
-- Name: edge_right_face_idx; Type: INDEX; Schema: my_new_topo; Owner: postgres
--

CREATE INDEX edge_right_face_idx ON my_new_topo.edge_data USING btree (right_face);


--
-- Name: edge_start_node_idx; Type: INDEX; Schema: my_new_topo; Owner: postgres
--

CREATE INDEX edge_start_node_idx ON my_new_topo.edge_data USING btree (start_node);


--
-- Name: face_gist; Type: INDEX; Schema: my_new_topo; Owner: postgres
--

CREATE INDEX face_gist ON my_new_topo.face USING gist (mbr);


--
-- Name: node_gist; Type: INDEX; Schema: my_new_topo; Owner: postgres
--

CREATE INDEX node_gist ON my_new_topo.node USING gist (geom);


--
-- Name: edge edge_insert_rule; Type: RULE; Schema: my_new_topo; Owner: postgres
--

CREATE RULE edge_insert_rule AS
    ON INSERT TO my_new_topo.edge DO INSTEAD  INSERT INTO my_new_topo.edge_data (edge_id, start_node, end_node, next_left_edge, abs_next_left_edge, next_right_edge, abs_next_right_edge, left_face, right_face, geom)
  VALUES (new.edge_id, new.start_node, new.end_node, new.next_left_edge, abs(new.next_left_edge), new.next_right_edge, abs(new.next_right_edge), new.left_face, new.right_face, new.geom);


--
-- Name: relation relation_integrity_checks; Type: TRIGGER; Schema: my_new_topo; Owner: postgres
--

CREATE TRIGGER relation_integrity_checks BEFORE INSERT OR UPDATE ON my_new_topo.relation FOR EACH ROW EXECUTE FUNCTION topology.relationtrigger('1', 'my_new_topo');


--
-- Name: edge_data end_node_exists; Type: FK CONSTRAINT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.edge_data
    ADD CONSTRAINT end_node_exists FOREIGN KEY (end_node) REFERENCES my_new_topo.node(node_id);


--
-- Name: node face_exists; Type: FK CONSTRAINT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.node
    ADD CONSTRAINT face_exists FOREIGN KEY (containing_face) REFERENCES my_new_topo.face(face_id);


--
-- Name: edge_data left_face_exists; Type: FK CONSTRAINT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.edge_data
    ADD CONSTRAINT left_face_exists FOREIGN KEY (left_face) REFERENCES my_new_topo.face(face_id);


--
-- Name: edge_data next_left_edge_exists; Type: FK CONSTRAINT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.edge_data
    ADD CONSTRAINT next_left_edge_exists FOREIGN KEY (abs_next_left_edge) REFERENCES my_new_topo.edge_data(edge_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: edge_data next_right_edge_exists; Type: FK CONSTRAINT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.edge_data
    ADD CONSTRAINT next_right_edge_exists FOREIGN KEY (abs_next_right_edge) REFERENCES my_new_topo.edge_data(edge_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: edge_data right_face_exists; Type: FK CONSTRAINT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.edge_data
    ADD CONSTRAINT right_face_exists FOREIGN KEY (right_face) REFERENCES my_new_topo.face(face_id);


--
-- Name: edge_data start_node_exists; Type: FK CONSTRAINT; Schema: my_new_topo; Owner: postgres
--

ALTER TABLE ONLY my_new_topo.edge_data
    ADD CONSTRAINT start_node_exists FOREIGN KEY (start_node) REFERENCES my_new_topo.node(node_id);


--
-- Name: billing_info billing_info_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_info
    ADD CONSTRAINT billing_info_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: jobs jobs_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_category_fkey FOREIGN KEY (category) REFERENCES public.categories(id);


--
-- Name: jobs jobs_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.location(id);


--
-- Name: jobs jobs_profession_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_profession_fkey FOREIGN KEY (profession) REFERENCES public.profession(id);


--
-- Name: profession profession_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profession
    ADD CONSTRAINT profession_category_fkey FOREIGN KEY (category) REFERENCES public.categories(id);


--
-- Name: worker_comments worker_comments_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_comments
    ADD CONSTRAINT worker_comments_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: worker_comments worker_comments_worker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_comments
    ADD CONSTRAINT worker_comments_worker_id_fkey FOREIGN KEY (worker_id) REFERENCES public.worker(id);


--
-- Name: worker worker_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.location(id);


--
-- Name: worker_plan worker_plan_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_plan
    ADD CONSTRAINT worker_plan_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.plans(id);


--
-- Name: worker_plan worker_plan_worker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker_plan
    ADD CONSTRAINT worker_plan_worker_id_fkey FOREIGN KEY (worker_id) REFERENCES public.worker(id);


--
-- Name: worker worker_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.worker
    ADD CONSTRAINT worker_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: workers_professions workers_professions_profession_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workers_professions
    ADD CONSTRAINT workers_professions_profession_fkey FOREIGN KEY (profession) REFERENCES public.profession(id);


--
-- Name: workers_professions workers_professions_worker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workers_professions
    ADD CONSTRAINT workers_professions_worker_fkey FOREIGN KEY (worker) REFERENCES public.worker(id);


--
-- PostgreSQL database dump complete
--

