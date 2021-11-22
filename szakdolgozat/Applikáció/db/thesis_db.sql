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
    source_ip_address character varying(50) DEFAULT ''::character varying
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
102	1	682490f1-02ea-4eab-95c5-49f2f104ae09	\N	7177348a-8a32-44dd-ab6e-5be6fcc80851	598111630	completed	bank transfer	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"BMáté","tax_number":"56559583-1-25","country":"HU","region":null,"city":"Miskolc","zip":"3508","street":"Csemetekert utca 2","street_2":"","street_3":""},"payment_request_id":"682490f1-02ea-4eab-95c5-49f2f104ae09","order_number":"598111630","items":[{"name":"12 havi csomag","description":"Mester szolgáltatás csomag 12 hónap","quantity":1,"unit":"db","unit_price":23880,"item_total":23880,"sku":"CSOM-3"}],"transaction_id":"7177348a-8a32-44dd-ab6e-5be6fcc80851","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-02-26 15:33:48.12484	\N	\N
138	1	18bb39b6-861b-4284-ad15-1e295f7ec712	\N	00f82637-9aa2-44c2-88e2-7ecf975e4e1b	201274029	initiated	\N	{"payer_email":"bajszmate99@gmail.com","billing_address":{"name":"Bajusz Máté ev.","tax_number":"56559583-1-25  ","country":"HU","region":null,"city":"Budapest","zip":"1231","street":"sadsd","street_2":"","street_3":""},"payment_request_id":"18bb39b6-861b-4284-ad15-1e295f7ec712","order_number":"201274029","items":[{"name":"6 havi csomag","description":"6 havi mester szolgáltatás csomag","quantity":1,"unit":"db","unit_price":17940,"item_total":17940,"sku":"ALAP-2","stripe_price_id":"price_1IXp77FwXtu51BxSoyY2019a"}],"transaction_id":"00f82637-9aa2-44c2-88e2-7ecf975e4e1b","coupon":"","card_holder_hint":"Bajusz Máté ev.","payer_phone_number":"36309828187","payer_account_id":"56","payer_account_created":1610928000,"Discount":0}	\N	\N	f	2021-04-05 18:37:31.910187	\N	\N
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

COPY public.jobs (id, owner_email, description, due_date, category, title, phone, profession, price_min, price_max, urgent, created_at, location_id, source_ip_address) FROM stdin;
9	bajszmate99@gmail.com	Ez egy teszt nem rendes ajanlatkedes!	2021-05-06	10	Valami munka	+36301234567	2	0	0	t	2021-01-20	146	
10	bajusz5.mate@gmail.com	Teszt ajanlatkeres, vegyeszeknek.	2021-04-09	10	Vegyész		199	0	10	f	2021-03-19	146	80.99.103.169
11	bajusz5.mate@gmail.com	Ez egy teszt hirdetés. Nincs szuksegem vegyeszre.	2021-04-10	10	Vegyész		199	0	0	f	2021-03-19	146	80.99.103.169
\.


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location (id, name, zip, ranking) FROM stdin;
146	Keszthely	8360	0
1	Som	8655	0
2	Somogyapáti	7922	0
3	Patosfa	7536	0
4	Tab	8660	0
5	Sormás	8881	0
6	Hetvehely	7681	0
7	Palkonya	7771	0
8	Villánykövesd	7772	0
9	Villány	7773	0
10	Pécs	7600	0
11	Cserdi	7683	0
12	Kishajmás	7391	0
13	Egerág	7763	0
14	Szőkéd	7763	0
15	Áta	7763	0
16	Kisherend	7763	0
17	Komló	7300	0
18	Kárász	7333	0
19	Tófű	7348	0
20	Egyházaskozár	7347	0
21	Bikal	7346	0
22	Olasz	7745	0
23	Belvárdgyula	7747	0
24	Lothárd	7761	0
25	Birján	7747	0
26	Hásságy	7745	0
27	Magyarsarlós	7761	0
28	Keszü	7668	0
29	Kökény	7639	0
30	Harkány	7815	0
31	Lad	7535	0
32	Letenye	8868	0
33	Abaliget	7678	0
34	Orfű	7677	0
35	Kozármisleny	7761	0
36	Ellend	7744	0
37	Romonya	7743	0
38	Bogád	7742	0
39	Szederkény	7751	0
40	Bóly	7754	0
41	Vásárosdombó	7362	0
42	Hetes	7432	0
43	Kocsola	7212	0
44	Ságvár	8654	0
45	Szekszárd	7100	0
46	Balatonudvari	8242	0
47	Sopron	9400	0
48	Kópháza	9495	0
49	Sárvár	9600	0
50	Tapolca	8300	0
51	Okorvölgy	7681	0
52	Szentkatalin	7681	0
53	Husztót	7678	0
54	Csertő	7900	0
55	Szulimán	7932	0
56	Kaposvár	7400	0
57	Siklós	7800	0
58	Balatonakali	8243	0
59	Jászberény	5100	0
60	Eger	3300	0
61	Tokaj	3910	0
62	Debrecen	4000	0
63	Sümeg	8330	0
64	Örvényes	8242	0
65	Balatonfőkajár	8164	0
66	Mecsekpölöske	7305	0
67	Hobol	7971	0
68	Teklafalu	7973	0
69	Hencse	7532	0
70	Mágocs	7342	0
71	Jákó	7525	0
72	Hegyháthodász	9915	0
73	Komárom	2900	0
74	Szeged	6700	0
75	Tihany	8237	0
76	Algyő	6750	0
77	Makó	6900	0
78	Kiszombor	6775	0
79	Deszk	6772	0
80	Újszentiván	6754	0
81	Tiszasziget	6756	0
82	Hódmezővásárhely	6800	0
83	Domaszék	6781	0
84	Mórahalom	6782	0
85	Székkutas	6821	0
86	Orosháza	5900	0
87	Nagykőrös	2750	0
88	Kunágota	5746	0
89	Barcs	7570	0
90	Rajka	9224	0
91	Hegyeshalom	9222	0
92	Bezenye	9223	0
93	Újpetre	7766	0
94	Kecskemét	6000	0
95	Cserkeszőlő	5465	0
96	Békéscsaba	5600	0
97	Gyula	5700	0
98	Szalkszentmárton	6086	0
99	Tass	6098	0
100	Sármellék	8391	0
101	Zala	8660	0
102	Pécsely	8245	0
103	Pomáz	2013	0
104	Miskolc	3500	0
105	Győr	9000	0
106	Nyíregyháza	4400	0
107	Szentendre	2000	0
108	Budakalász	2011	0
109	Pilisszentkereszt	2098	0
110	Pilisszentlászló	2009	0
111	Öcsöd	5451	0
112	Békésszentandrás	5561	0
113	Szarvas	5540	0
114	Kondoros	5553	0
115	Székesfehérvár	8000	0
116	Solt	6320	0
117	Dunapataj	6328	0
118	Dunaszentgyörgy	7135	0
119	Pörböly	7142	0
120	Bátaszék	7140	0
121	Kiskunlacháza	2340	0
122	Dömsöd	2344	0
123	Dormánd	3374	0
124	Besenyőtelek	3373	0
125	Füzesabony	3390	0
126	Mezőtárkány	3375	0
127	Tiszafüred	5350	0
128	Tiszaszőlős	5244	0
129	Egyek	4069	0
130	Kunszentmárton	5440	0
131	Tiszaföldvár	5430	0
132	Martfű	5435	0
133	Cegléd	2700	0
134	Szajol	5081	0
135	Törökszentmiklós	5200	0
136	Fegyvernek	5231	0
137	Kenderes	5331	0
138	Karcag	5300	0
139	Berekfürdő	5309	0
140	Kunmadaras	5321	0
141	Budapest	0	0
142	Zalaapáti	8741	0
143	Pacsa	8761	0
144	Zalaszentmihály	8936	0
145	Pölöske	8929	0
3172	Országos	0	0
147	Hévíz	8380	0
148	Verőce	2621	0
149	Kismaros	2623	0
150	Dömös	2027	0
151	Pilismarót	2028	0
152	Pilisvörösvár	2085	0
153	Ráckeve	2300	0
154	Lórév	2309	0
155	Budajenő	2093	0
156	Telki	2089	0
157	Tököl	2316	0
158	Csömör	2141	0
159	Gödöllő	2100	0
160	Budaörs	2040	0
161	Patak	2648	0
162	Dejtár	2649	0
163	Ipolyvece	2669	0
164	Drégelypalánk	2646	0
165	Érsekvadkert	2659	0
166	Nagyoroszi	2645	0
167	Rétság	2651	0
168	Budakeszi	2092	0
169	Vértesszőlős	2837	0
170	Diósd	2049	0
171	Érd	2030	0
172	Sukoró	8096	0
173	Pákozd	8095	0
174	Velence	2481	0
175	Kápolnásnyék	2475	0
176	Gárdony	2483	0
177	Nagykovácsi	2094	0
178	Előszállás	2424	0
179	Alsószentiván	7012	0
180	Cece	7013	0
181	Simontornya	7081	0
182	Tolnanémedi	7083	0
183	Pincehely	7084	0
184	Paks	7030	0
185	Bikács	7043	0
186	Nagydorog	7044	0
187	Bölcske	7025	0
188	Madocsa	7026	0
189	Gyönk	7064	0
190	Varsád	7067	0
191	Tárnok	2461	0
192	Vác	2600	0
193	Kisszékely	7082	0
194	Páty	2071	0
195	Biatorbágy	2051	0
196	Sóskút	2038	0
197	Pusztazámor	2039	0
198	Fót	2151	0
199	Dunakeszi	2120	0
200	Zalaegerszeg	8900	0
201	Százhalombatta	2440	0
202	Ercsi	2451	0
203	Martonvásár	2462	0
204	Ráckeresztúr	2465	0
205	Tordas	2463	0
206	Gyúró	2464	0
207	Ártánd	4115	0
208	Bedő	4128	0
209	Nagykereki	4127	0
210	Kismarja	4126	0
211	Pocsaj	4125	0
212	Hosszúpályi	4274	0
213	Nagyszékely	7085	0
214	Szakadát	7071	0
215	Diósberény	7072	0
216	Miszla	7065	0
217	Udvari	7066	0
218	Horpács	2658	0
219	Borsosberény	2644	0
220	Bánk	2653	0
221	Szendehely	2640	0
222	Sárszentlőrinc	7047	0
223	Kölesd	7052	0
224	Kistormás	7068	0
225	Németkér	7039	0
226	Kerepes	2144	0
227	Dabas	2370	0
228	Újhartyán	2367	0
229	Újlengyel	2724	0
230	Gerjen	7134	0
231	Fadd	7133	0
232	Tolna	7130	0
233	Fácánkert	7136	0
234	Sióagárd	7171	0
235	Piliscsaba	2081	0
236	Dorog	2510	0
237	Tokodaltáró	2532	0
238	Tokod	2531	0
239	Tát	2534	0
240	Esztergom	2500	0
241	Felsőnána	7175	0
242	Nyergesújfalu	2536	0
243	Lábatlan	2541	0
244	Tata	2890	0
245	Hőgyész	7191	0
246	Kalaznó	7194	0
247	Ács	2941	0
248	Gönyű	9071	0
249	Süttő	2543	0
250	Neszmély	2544	0
251	Dunaszentmiklós	2897	0
252	Szomód	2896	0
253	Tardos	2834	0
254	Baj	2836	0
255	Vértestolna	2833	0
256	Tarján	2831	0
257	Héreg	2832	0
258	Bajna	2525	0
259	Epöl	2526	0
260	Gyermely	2821	0
261	Szomor	2822	0
262	Tinnye	2086	0
263	Perbál	2074	0
264	Tök	2073	0
265	Zsámbék	2072	0
266	Mány	2065	0
267	Csabdi	2064	0
268	Bicske	2060	0
269	Herceghalom	2053	0
270	Veresegyház	2112	0
271	Erdőkertes	2113	0
272	Őrbottyán	2162	0
273	Csomád	2161	0
274	Vácrátót	2163	0
275	Göd	2131	0
276	Sződ	2134	0
277	Sződliget	2133	0
278	Csörög	2135	0
279	Vácduka	2167	0
280	Váchartyán	2164	0
281	Kisnémedi	2165	0
282	Püspökszilágy	2166	0
283	Váckisújfalu	2185	0
284	Iklad	2181	0
285	Vácegres	2184	0
286	Szada	2111	0
287	Domony	2182	0
288	Aszód	2170	0
289	Hatvan	3000	0
290	Bonyhád	7150	0
291	Báta	7149	0
292	Kisoroszi	2024	0
293	Rád	2613	0
294	Penc	2614	0
295	Keszeg	2616	0
296	Kosd	2612	0
297	Galgagyörk	2681	0
298	Püspökhatvan	2682	0
299	Acsa	2683	0
300	Nógrádsáp	2685	0
301	Csővár	2615	0
302	Galgaguta	2686	0
303	Bercel	2687	0
304	Nógrádkövesd	2691	0
305	Becske	2693	0
306	Szirmabesenyő	3711	0
307	Szob	2628	0
308	Zebegény	2627	0
309	Nagymaros	2626	0
310	Visegrád	2025	0
311	Dunabogdány	2023	0
312	Szokolya	2624	0
313	Berkenye	2641	0
314	Nógrád	2642	0
315	Balassagyarmat	2660	0
316	Ipolyszög	2660	0
317	Szügy	2699	0
318	Nógrádmarcal	2675	0
319	Patvarc	2668	0
320	Őrhalom	2671	0
321	Hugyag	2672	0
322	Szécsény	3170	0
323	Kishartyán	3161	0
324	Salgótarján	3100	0
325	Somoskőújfalu	3121	0
326	Gyöngyös	3200	0
327	Kápolna	3355	0
328	Feldebrő	3352	0
329	Aldebrő	3353	0
330	Tófalu	3354	0
331	Vécs	3265	0
332	Domoszló	3263	0
333	Verpelét	3351	0
334	Markaz	3262	0
335	Abasár	3261	0
336	Ipolytarnóc	3138	0
337	Emőd	3432	0
338	Nyékládháza	3433	0
339	Mályi	3434	0
340	Felsőzsolca	3561	0
341	Zamárdi	8621	0
342	Szántód	8622	0
343	Kőröshegy	8617	0
344	Balatonendréd	8613	0
345	Balatonföldvár	8623	0
346	Balatonszemes	8636	0
347	Balatonőszöd	8637	0
348	Balatonlelle	8638	0
349	Balatonboglár	8630	0
350	Látrány	8681	0
351	Visz	8681	0
352	Ordacsehi	8635	0
353	Fonyód	8640	0
354	Balatonfenyves	8646	0
355	Balatonmáriafürdő	8647	0
356	Balatonberény	8649	0
357	Balatonszentgyörgy	8710	0
358	Balatonújlak	8712	0
359	Balatonkeresztúr	8648	0
360	Kéthely	8713	0
361	Marcali	8700	0
362	Tapsony	8718	0
363	Somogyszob	7563	0
364	Ötvöskónyi	7511	0
365	Nagyatád	7500	0
366	Gyenesdiás	8315	0
367	Vonyarcvashegy	8314	0
368	Balatongyörök	8313	0
369	Balatonederics	8312	0
370	Szigliget	8264	0
371	Badacsonytomaj	8258	0
372	Ábrahámhegy	8256	0
373	Balatonrendes	8255	0
374	Révfülöp	8253	0
375	Balatonszepezd	8252	0
376	Csopak	8229	0
377	Alsóörs	8226	0
378	Balatonalmádi	8220	0
379	Balatonfűzfő	8175	0
380	Balatonkenese	8174	0
381	Balatonvilágos	8171	0
382	Sajószentpéter	3770	0
383	Kazincbarcika	3700	0
384	Heves	3360	0
385	Tenk	3359	0
386	Erdőtelek	3358	0
387	Nagytálya	3398	0
388	Andornaktálya	3399	0
389	Edelény	3780	0
390	Kereki	8618	0
391	Pusztaszemes	8619	0
392	Igal	7275	0
393	Ráksi	7464	0
394	Andocs	8675	0
395	Magyaratád	7463	0
396	Somogyaszaló	7452	0
397	Törökbálint	2045	0
398	Verseg	2174	0
399	Kartal	2173	0
400	Egyházasdengeleg	3043	0
401	Héhalom	3041	0
402	Csokonyavisonta	7555	0
403	Rinyaújlak	7556	0
404	Görgeteg	7553	0
405	Lábod	7551	0
406	Somogyaracs	7584	0
407	Babócsa	7584	0
408	Komlósd	7582	0
409	Péterhida	7582	0
410	Darány	7988	0
411	Szulok	7539	0
412	Drávagárdony	7977	0
413	Kastélyosdombó	7977	0
414	Zádor	7976	0
415	Potony	7977	0
416	Lakócsa	7918	0
417	Tótújfalu	7918	0
418	Szentborbás	7918	0
419	Drávafok	7967	0
420	Istvándi	7987	0
421	Kadarkút	7530	0
422	Bárdudvarnok	7478	0
423	Kaposújlak	7522	0
424	Jászdózsa	5122	0
425	Pilisborosjenő	2097	0
426	Üröm	2096	0
427	Isaszeg	2117	0
428	Valkó	2114	0
429	Szomolya	3411	0
430	Tard	3416	0
431	Cserépfalu	3413	0
432	Bükkzsérc	3414	0
433	Cserépváralja	3417	0
434	Noszvaj	3325	0
435	Tibolddaróc	3423	0
436	Háromfa	7585	0
437	Mernye	7453	0
438	Somogytúr	8683	0
439	Somogybabod	8684	0
440	Osztopán	7444	0
441	Pamuk	8698	0
442	Somogyvár	8698	0
443	Öreglak	8697	0
444	Lengyeltóti	8693	0
445	Szőlősgyörök	8692	0
446	Karád	8676	0
447	Somogymeggyes	8673	0
448	Bernecebaráti	2639	0
449	Tésa	2636	0
450	Vámosmikola	2635	0
451	Ipolytölgyes	2633	0
452	Letkés	2632	0
453	Pilisszántó	2095	0
454	Zalkod	3957	0
455	Bodrogkeresztúr	3916	0
456	Timár	4466	0
457	Kenézlő	3955	0
458	Kemence	2638	0
459	Tarcal	3915	0
460	Szegi	3918	0
461	Szegilong	3918	0
462	Bodrogkisfalud	3917	0
463	Olaszliszka	3933	0
464	Vámosújfalu	3941	0
465	Tolcsva	3934	0
466	Hernádkak	3563	0
467	Hernádnémeti	3564	0
468	Bőcs	3574	0
469	Berzék	3575	0
470	Sajóhídvég	3576	0
471	Köröm	3577	0
472	Girincs	3578	0
473	Kiscsécs	3578	0
474	Kesznyéten	3579	0
475	Sajóörös	3586	0
476	Sajószöged	3599	0
477	Tiszalúc	3565	0
478	Taktaharkány	3922	0
479	Vászoly	8245	0
480	Dörgicse	8244	0
481	Szabadegyháza	2432	0
482	Gyöngyöshalász	3212	0
483	Filkeháza	3994	0
484	Pálháza	3994	0
485	Telkibánya	3896	0
486	Gönc	3895	0
487	Göncruszka	3894	0
488	Vilmány	3891	0
489	Fony	3893	0
490	Korlát	3886	0
491	Hernádcéce	3887	0
492	Boldogkőváralja	3885	0
493	Mogyoróska	3893	0
494	Regéc	3893	0
495	Hejce	3892	0
496	Seregélyes	8111	0
497	Zichyújfalu	8112	0
498	Sárosd	2433	0
499	Perkáta	2431	0
500	Kulcs	2458	0
501	Rácalmás	2459	0
502	Adony	2457	0
503	Pusztaszabolcs	2490	0
504	Besnyő	2456	0
505	Beloiannisz	2455	0
506	Iváncsa	2454	0
507	Baracska	2471	0
508	Szentmártonkáta	2254	0
509	Kunhegyes	5340	0
510	Tiszaigar	5361	0
511	Nagyiván	5363	0
512	Lovasberény	8093	0
513	Pátka	8092	0
514	Csákvár	8083	0
515	Pázmánd	2476	0
516	Vereb	2477	0
517	Nadap	8097	0
518	Vál	2473	0
519	Kajászó	2472	0
520	Vértesacsa	8089	0
521	Alcsútdoboz	8087	0
522	Felcsút	8086	0
523	Tabajd	8088	0
524	Etyek	2091	0
525	Gánt	8082	0
526	Mór	8060	0
527	Zámoly	8081	0
528	Csókakő	8074	0
529	Csákberény	8073	0
530	Vértesboglár	8085	0
531	Bodmér	8080	0
532	Szár	2066	0
533	Polgárdi	8154	0
534	Pápa	8500	0
535	Körmend	9900	0
536	Ják	9798	0
537	Egyházasrádóc	9783	0
538	Felsőszölnök	9985	0
539	Hajdúszoboszló	4200	0
540	Kaba	4183	0
541	Püspökladány	4150	0
542	Mezőtúr	5400	0
543	Mezőberény	5650	0
544	Szabadbattyán	8151	0
545	Kőszárhegy	8152	0
546	Tác	8121	0
547	Kisvárda	4600	0
548	Ózd	3600	0
549	Diósjenő	2643	0
550	Tét	9100	0
551	Győrszemere	9121	0
552	Zimány	7471	0
553	Orci	7461	0
554	Rinyaújnép	7584	0
555	Bakháza	7585	0
556	Rinyaszentkirály	7513	0
557	Tarany	7514	0
558	Bolhó	7586	0
559	Heresznye	7587	0
560	Vízvár	7588	0
561	Bélavár	7589	0
562	Somogyudvarhely	7515	0
563	Berzence	7516	0
564	Csurgó	8840	0
565	Dunavecse	6087	0
566	Dúzs	7224	0
567	Döbrököz	7228	0
568	Dombóvár	7200	0
569	Attala	7252	0
570	Csoma	7253	0
571	Szabadi	7253	0
572	Nagyberki	7255	0
573	Mosdós	7257	0
574	Baté	7258	0
575	Taszár	7261	0
576	Kaposfő	7523	0
577	Kiskorpád	7524	0
578	Nagybajom	7561	0
579	Böhönye	8719	0
580	Vése	8721	0
581	Nemesdéd	8722	0
582	Nemesvid	8738	0
583	Somogysimonyi	8737	0
584	Zalakomár	8751	0
585	Zalakaros	8749	0
586	Garabonc	8747	0
587	Nagyrada	8746	0
588	Zalaszabar	8743	0
589	Orosztony	8744	0
590	Kerecseny	8745	0
591	Kilimán	8774	0
592	Alsórajk	8767	0
593	Felsőrajk	8767	0
594	Pötréte	8767	0
595	Hahót	8771	0
596	Szigetcsép	2317	0
597	Szigetújfalu	2319	0
598	Kunszentmiklós	6090	0
599	Apostag	6088	0
600	Dunaföldvár	7020	0
601	Nagyvenyim	2421	0
602	Mezőszilas	7017	0
603	Mezőfalva	2422	0
604	Halásztelek	2314	0
605	Szigethalom	2315	0
606	Dunavarsány	2336	0
607	Délegyháza	2337	0
608	Szigetbecse	2321	0
609	Makád	2322	0
610	Szigetszentmiklós	2310	0
611	Dunaharaszti	2330	0
612	Taksony	2335	0
613	Gyál	2360	0
614	Újireg	7095	0
615	Iregszemcse	7095	0
616	Nagykónyi	7092	0
617	Koppányszántó	7094	0
618	Értény	7093	0
619	Törökkoppány	7285	0
620	Szorosad	7285	0
621	Somogydöröcske	7284	0
622	Somogyacsa	7283	0
623	Tamási	7090	0
624	Kéty	7174	0
625	Zomba	7173	0
626	Kisdorog	7159	0
627	Harc	7172	0
628	Bonyhádvarasd	7158	0
629	Murga	7176	0
630	Szatta	9938	0
631	Becsvölgye	8985	0
632	Szilvágy	8986	0
633	Pórszombat	8986	0
634	Csesztreg	8973	0
635	Kerkafalva	8973	0
636	Nagyrákos	9938	0
637	Pankasz	9937	0
638	Felsőjánosfa	9934	0
639	Zalalövő	8999	0
640	Zalacséb	8996	0
641	Zalaszentgyörgy	8994	0
642	Kávás	8994	0
643	Boncodfölde	8992	0
644	Teskánd	8991	0
645	Gellénháza	8981	0
646	Sárhida	8944	0
647	Bak	8945	0
648	Aba	8127	0
649	Sárbogárd	7000	0
650	Sárkeresztúr	8125	0
651	Káloz	8124	0
652	Sárszentágota	8126	0
653	Németfalu	8918	0
654	Salomvár	8995	0
655	Nagylengyel	8983	0
656	Babosdöbréte	8983	0
657	Dobronhegy	8989	0
658	Milejszeg	8917	0
659	Gombosszeg	8984	0
660	Csonkahegyhát	8918	0
661	Kustánszeg	8919	0
662	Őriszentpéter	9941	0
663	Szalafő	9942	0
664	Nagykapornak	8935	0
665	Ligetfalva	8782	0
666	Zalacsány	8782	0
667	Ikrény	9141	0
668	Szilsárkány	9312	0
669	Szil	9326	0
670	Rábasebes	9327	0
671	Vág	9327	0
672	Szany	9317	0
673	Csorna	9300	0
674	Kóny	9144	0
675	Enese	9143	0
676	Dág	2522	0
677	Abda	9151	0
678	Börcs	9152	0
679	Öttevény	9153	0
680	Vámosszabadi	9061	0
681	Győrújfalu	9171	0
682	Győrzámoly	9172	0
683	Győrladamér	9173	0
684	Dunaszeg	9174	0
685	Ásványráró	9177	0
686	Hédervár	9178	0
687	Lipót	9233	0
688	Darnózseli	9232	0
689	Halászi	9228	0
690	Mosonmagyaróvár	9200	0
691	Máriakálnok	9231	0
692	Mórichida	9131	0
693	Árpás	9132	0
694	Egyed	9314	0
695	Rábacsanak	9313	0
696	Rábaszentandrás	9316	0
697	Kemenesszentpéter	8518	0
698	Pápoc	9515	0
699	Dunasziget	9226	0
700	Koroncó	9113	0
701	Rábapatona	9142	0
702	Bágyogszovát	9145	0
703	Dör	9147	0
704	Barbacs	9169	0
705	Bősárkány	9167	0
706	Jánossomorja	9241	0
707	Levél	9221	0
708	Városlőd	8445	0
709	Takácsi	8541	0
710	Gyarmat	9126	0
711	Csikvánd	9127	0
712	Tényő	9111	0
713	Écs	9083	0
714	Pannonhalma	9090	0
715	Nyúl	9082	0
716	Nagyszentjános	9072	0
717	Bábolna	2943	0
718	Bana	2944	0
719	Csömend	8700	0
720	Nikla	8706	0
721	Pusztakovácsi	8707	0
722	Somogyfajsz	8708	0
723	Bodrog	7439	0
724	Csombárd	7432	0
725	Juta	7431	0
726	Tengelic	7054	0
727	Szedres	7056	0
728	Dunakiliti	9225	0
729	Pálfa	7042	0
730	Szárazd	7063	0
731	Aparhant	7186	0
732	Izmény	7353	0
733	Szárász	7188	0
734	Hegyhátmaróc	7348	0
735	Alsómocsolád	7345	0
736	Ág	7381	0
737	Tarrós	7362	0
738	Gerényes	7362	0
739	Sásd	7370	0
740	Felsőegerszeg	7370	0
741	Varga	7370	0
742	Kisbajcs	9062	0
743	Nagybajcs	9063	0
744	Mosonszentmiklós	9154	0
745	Kimle	9181	0
746	Farád	9321	0
747	Rábatamási	9322	0
748	Jobaháza	9323	0
749	Lébény	9155	0
750	Babót	9351	0
751	Veszkény	9352	0
752	Agyagosszergény	9441	0
753	Szárföld	9353	0
754	Tékes	7381	0
755	Kisvaszar	7381	0
756	Liget	7331	0
757	Bodolyabér	7394	0
758	Magyarszék	7396	0
759	Kapuvár	9330	0
760	Szászvár	7349	0
761	Máza	7351	0
762	Magyaregregy	7332	0
763	Nagycenk	9485	0
764	Pereszteg	9484	0
765	Fertőendréd	9442	0
766	Petőháza	9443	0
767	Fertőszentmiklós	9444	0
768	Fertőd	9431	0
769	Sarród	9435	0
770	Röjtökmuzsaj	9451	0
771	Nagylózs	9482	0
772	Pinnye	9481	0
773	Sopronkövesd	9483	0
774	Fertőrákos	9421	0
775	Hidegség	9491	0
776	Hegykő	9437	0
777	Markotabödöge	9164	0
778	Rábcakapi	9165	0
779	Fehértó	9163	0
780	Győrsövényház	9161	0
781	Bezi	9162	0
782	Feketeerdő	9211	0
783	Mosonszolnok	9245	0
784	Újrónafő	9244	0
785	Tárnokréti	9165	0
786	Bőny	9073	0
787	Töltéstava	9086	0
788	Pér	9099	0
789	Mezőörs	9097	0
790	Rétalap	9074	0
791	Csém	2949	0
792	Mocsa	2911	0
793	Almásfüzitő	2931	0
794	Tatabánya	2800	0
795	Sopronnémeti	9325	0
796	Magyarkeresztúr	9346	0
797	Zsebeháza	9346	0
798	Bogyoszló	9324	0
799	Potyond	9324	0
800	Pásztori	9311	0
801	Rábapordány	9146	0
802	Mérges	9136	0
803	Rábacsécsény	9136	0
804	Rábaszentmihály	9135	0
805	Bodonhely	9134	0
806	Kisbabot	9133	0
807	Rábaszentmiklós	9133	0
808	Gyömöre	9124	0
809	Felpéc	9122	0
810	Kajárpéc	9123	0
811	Szerecseny	9125	0
812	Sokorópátka	9112	0
813	Ravazd	9091	0
814	Pázmándfalu	9085	0
815	Győrság	9084	0
816	Nyalka	9096	0
817	Táp	9095	0
818	Tápszentmiklós	9094	0
819	Tarjánpuszta	9092	0
820	Győrasszonyfa	9093	0
821	Veszprémvarsány	8438	0
822	Bakonypéterd	9088	0
823	Románd	8434	0
824	Lázi	9089	0
825	Sikátor	8439	0
826	Bakonygyirót	8433	0
827	Bakonyszentlászló	8431	0
828	Fenyőfő	8432	0
829	Győrújbarát	9081	0
830	Sobor	9315	0
831	Páli	9345	0
832	Kisfalud	9341	0
833	Mihályi	9342	0
834	Vadosfa	9346	0
835	Beled	9343	0
836	Edve	9343	0
837	Vásárosfalu	9343	0
838	Rábakecöl	9344	0
839	Cirák	9364	0
840	Gyóró	9363	0
841	Dénesfa	9365	0
842	Himod	9362	0
843	Vitnyéd	9371	0
844	Hövej	9361	0
845	Répcelak	9653	0
846	Répceszemere	9375	0
847	Iván	9374	0
848	Csáfordjánosfa	9375	0
849	Csér	9375	0
850	Csapod	9372	0
851	Pusztacsalád	9373	0
852	Ebergőc	9451	0
853	Lövő	9461	0
854	Nemeskér	9471	0
855	Újkér	9472	0
856	Völcsej	9462	0
857	Sopronhorpács	9463	0
858	Und	9464	0
859	Egyházasfalu	9473	0
860	Zsira	9476	0
861	Szakony	9474	0
862	Répcevis	9475	0
863	Gyalóka	9474	0
864	Ágfalva	9423	0
865	Fertőboz	9493	0
866	Fertőhomok	9492	0
867	Fertőszéplak	9436	0
868	Osli	9354	0
869	Acsalag	9168	0
870	Maglóca	9169	0
871	Kunsziget	9184	0
872	Mecsér	9176	0
873	Károlyháza	9182	0
874	Cakóháza	9165	0
875	Dunaremete	9235	0
876	Kisbodak	9234	0
877	Harka	9422	0
878	Vének	9062	0
879	Várbalog	9243	0
880	Dunaalmás	2545	0
881	Várkesző	8523	0
882	Egyházaskesző	8523	0
883	Marcaltő	8532	0
884	Nemesgörzsöny	8522	0
885	Malomsok	8533	0
886	Kislőd	8446	0
887	Ajka	8400	0
888	Devecser	8460	0
889	Cserszegtomaj	8372	0
890	Balatonszőlős	8230	0
891	Balatonakarattya	8172	0
892	Várpalota	8100	0
893	Pétfürdő	8105	0
894	Öskü	8191	0
895	Csór	8041	0
896	Olaszfalu	8414	0
897	Zirc	8420	0
898	Berhida	8181	0
899	Herend	8440	0
900	Rédics	8978	0
901	Lenti	8960	0
902	Nagykanizsa	8800	0
903	Zalaszentgrót	8790	0
904	Peresznye	9734	0
905	Kőszeg	9730	0
906	Bük	9737	0
907	Celldömölk	9500	0
908	Vasvár	9800	0
909	Szentgotthárd	9970	0
910	Buzsák	8695	0
911	Táska	8696	0
912	Bátonyterenye	3070	0
913	Pásztó	3060	0
914	Kisbér	2870	0
915	Oroszlány	2840	0
916	Bodajk	8053	0
917	Lepsény	8132	0
918	Mezőszentgyörgy	8133	0
919	Enying	8130	0
920	Záhony	4625	0
921	Rohod	4563	0
922	Baktalórántháza	4561	0
923	Kemecse	4501	0
924	Demecser	4516	0
925	Tiszakarád	3971	0
926	Nagyhalász	4485	0
927	Ibrány	4484	0
928	Kékcse	4494	0
929	Tiszakanyár	4493	0
930	Dombrád	4492	0
931	Rakamaz	4465	0
932	Tiszalök	4450	0
933	Szorgalmatos	4441	0
934	Tiszavasvári	4440	0
935	Nagykálló	4320	0
936	Hajdúhadház	4242	0
937	Újfehértó	4244	0
938	Nyírmihálydi	4363	0
939	Nyírlugos	4371	0
940	Kisléta	4325	0
941	Nyírbogát	4361	0
942	Nyírbátor	4300	0
943	Nyírgyulaj	4311	0
944	Máriapócs	4326	0
945	Mátészalka	4700	0
946	Csenger	4765	0
947	Nagyecsed	4355	0
948	Szakoly	4234	0
949	Balkány	4233	0
950	Fehérgyarmat	4900	0
951	Mándok	4644	0
952	Eperjeske	4646	0
953	Nyírtelek	4461	0
954	Vásárosnamény	4800	0
955	Ócsa	2364	0
956	Vecsés	2220	0
957	Üllő	2225	0
958	Monor	2200	0
959	Pilis	2721	0
960	Albertirsa	2730	0
961	Gyömrő	2230	0
962	Maglód	2234	0
963	Pécel	2119	0
964	Kistarcsa	2143	0
965	Nagykáta	2760	0
966	Tura	2194	0
967	Örkény	2377	0
968	Hernád	2376	0
969	Jászjákóhalma	5121	0
970	Jászapáti	5130	0
971	Adács	3292	0
972	Jászárokszállás	5123	0
973	Jászfényszaru	5126	0
974	Abádszalók	5241	0
975	Túrkeve	5420	0
976	Újszász	5052	0
977	Kerecsend	3396	0
978	Ostoros	3326	0
979	Szilvásvárad	3348	0
980	Bélapátfalva	3346	0
981	Kisköre	3384	0
982	Lőrinci	3021	0
983	Bükkszenterzsébet	3257	0
984	Pétervására	3250	0
985	Polgár	4090	0
986	Hajdúböszörmény	4220	0
987	Hajdúsámson	4251	0
988	Vámospércs	4287	0
989	Nyíradony	4254	0
990	Hajdúnánás	4080	0
991	Hajdúdorog	4087	0
992	Tiszacsege	4066	0
993	Derecske	4130	0
994	Berettyóújfalu	4100	0
995	Komádi	4138	0
996	Nádudvar	4181	0
997	Monostorpályi	4275	0
998	Létavértes	4281	0
999	Balmazújváros	4060	0
1000	Csongrád	6640	0
1001	Sándorfalva	6762	0
1002	Mindszent	6630	0
1003	Kistelek	6760	0
1004	Ópusztaszer	6767	0
1005	Szentes	6600	0
1006	Tiszaújváros	3580	0
1007	Szerencs	3900	0
1008	Alsózsolca	3571	0
1009	Szikszó	3800	0
1010	Encs	3860	0
1011	Sárospatak	3950	0
1012	Sátoraljaújhely	3980	0
1013	Szendrő	3752	0
1014	Putnok	3630	0
1015	Borsodnádasd	3671	0
1016	Mezőkövesd	3400	0
1017	Mezőcsát	3450	0
1018	Abaújszántó	3881	0
1019	Cigánd	3973	0
1020	Szuhogy	3734	0
1021	Rudabánya	3733	0
1022	Gyomaendrőd	5500	0
1023	Csorvás	5920	0
1024	Tótkomlós	5940	0
1025	Mezőhegyes	5820	0
1026	Mezőkovácsháza	5800	0
1027	Sarkad	5720	0
1028	Körösladány	5516	0
1029	Vésztő	5530	0
1030	Battonya	5830	0
1031	Békés	5630	0
1032	Dévaványa	5510	0
1033	Elek	5742	0
1034	Kétegyháza	5741	0
1035	Füzesgyarmat	5525	0
1036	Szentlőrinc	7940	0
1037	Sellye	7960	0
1038	Pécsvárad	7720	0
1039	Kerekegyháza	6041	0
1040	Szabadszállás	6080	0
1041	Izsák	6070	0
1042	Akasztó	6221	0
1043	Kiskőrös	6200	0
1044	Soltvadkert	6230	0
1045	Császártöltés	6239	0
1046	Hajós	6344	0
1047	Baja	6500	0
1048	Felsőszentiván	6447	0
1049	Tataháza	6451	0
1050	Bácsalmás	6430	0
1051	Jánoshalma	6440	0
1052	Kiskunhalas	6400	0
1053	Kiskunmajsa	6120	0
1054	Kiskunfélegyháza	6100	0
1055	Lajosmizse	6050	0
1056	Lakitelek	6065	0
1057	Tiszakécske	6060	0
1058	Tompa	6422	0
1059	Kajdacs	7051	0
1060	Medina	7057	0
1061	Dunaegyháza	6323	0
1062	Nyárlőrinc	6032	0
1063	Tiszakürt	5471	0
1064	Tiszaug	6064	0
1065	Tiszainoka	5464	0
1066	Cibakháza	5462	0
1067	Sükösd	6346	0
1068	Fajsz	6352	0
1069	Homokmégy	6341	0
1070	Miske	6343	0
1071	Drágszél	6342	0
1072	Újtelek	6337	0
1073	Szakmár	6336	0
1074	Ordas	6335	0
1075	Géderlak	6334	0
1076	Uszód	6332	0
1077	Foktő	6331	0
1078	Dunaszentbenedek	6333	0
1079	Soltszentimre	6223	0
1080	Kaskantyú	6211	0
1081	Csengőd	6222	0
1082	Tabdi	6224	0
1083	Fülöpszállás	6085	0
1084	Páhi	6075	0
1085	Mikebuda	2736	0
1086	Őcsény	7143	0
1087	Decs	7144	0
1088	Sárpilis	7145	0
1089	Várdomb	7146	0
1090	Csávoly	6448	0
1091	Mélykút	6449	0
1092	Kisszállás	6421	0
1093	Kehidakustány	8784	0
1094	Felsőpáhok	8380	0
1095	Röszke	6758	0
1096	Kelebia	6423	0
1097	Kemenesmagasi	9522	0
1098	Vönöck	9516	0
1099	Kemenesszentmárton	9521	0
1100	Tokorcs	9561	0
1101	Nagysimonyi	9561	0
1102	Sitke	9671	0
1103	Pirtó	6414	0
1104	Lókút	8425	0
1105	Hárskút	8442	0
1106	Eplény	8413	0
1107	Márkó	8441	0
1108	Balatonfüred	8230	0
1109	Pénzesgyőr	8426	0
1110	Bakonybél	8427	0
1111	Nagygyimót	8551	0
1112	Béb	8565	0
1113	Bakonykoppány	8571	0
1114	Csabrendek	8474	0
1115	Nyirád	8454	0
1116	Halimba	8452	0
1117	Mike	7512	0
1118	Szigetszentmárton	2318	0
1119	Tóalmás	2252	0
1120	Érsekhalma	6348	0
1121	Nemesnádudvar	6345	0
1122	Karakószörcsök	8491	0
1123	Kerta	8492	0
1124	Iszkáz	8493	0
1125	Tüskevár	8477	0
1126	Apácatorna	8477	0
1127	Veszprémgalsa	8475	0
1128	Szentimrefalva	8475	0
1129	Kisberzseny	8477	0
1130	Dáka	8592	0
1131	Vid	8484	0
1132	Nagyalásony	8484	0
1133	Somlószőlős	8483	0
1134	Kup	8595	0
1135	Pápakovácsi	8596	0
1136	Nóráp	8591	0
1137	Bakonypölöske	8457	0
1138	Noszlop	8456	0
1139	Nemeshany	8471	0
1140	Káptalanfa	8471	0
1141	Gyepükaján	8473	0
1142	Sümegprága	8351	0
1143	Bazsi	8352	0
1144	Zalaszántó	8353	0
1145	Apátvarasd	7720	0
1146	Lovászhetény	7720	0
1147	Erdősmecske	7723	0
1148	Feked	7724	0
1149	Szebény	7725	0
1150	Szűr	7735	0
1151	Himesháza	7735	0
1152	Véménd	7726	0
1153	Palotabozsok	7727	0
1154	Görcsönydoboka	7728	0
1155	Somberek	7728	0
1156	Székelyszabar	7737	0
1157	Erdősmárok	7735	0
1158	Geresdlak	7733	0
1159	Maráza	7733	0
1160	Fazekasboda	7732	0
1161	Nagypall	7731	0
1162	Várgesztes	2824	0
1163	Csetény	8417	0
1164	Szőc	8452	0
1165	Öcs	8292	0
1166	Pula	8291	0
1167	Nagyvázsony	8291	0
1168	Tótvázsony	8246	0
1169	Dánszentmiklós	2735	0
1170	Pusztavacs	2378	0
1171	Tatárszentgyörgy	2375	0
1172	Káva	2215	0
1173	Pánd	2214	0
1174	Tápióbicske	2764	0
1175	Farmos	2765	0
1176	Vámosgyörk	3291	0
1177	Nagymányok	7355	0
1178	Pusztahencse	7038	0
1179	Györköny	7045	0
1180	Keszőhidegkút	7062	0
1181	Belecska	7061	0
1182	Nagybörzsöny	2634	0
1183	Horvátzsidány	9733	0
1184	Csősz	8122	0
1185	Soponya	8123	0
1186	Sáregres	7014	0
1187	Bogyiszló	7132	0
1188	Fehérvárcsurgó	8052	0
1189	Iszkaszentgyörgy	8043	0
1190	Kincsesbánya	8044	0
1191	Söréd	8072	0
1192	Nagytarcsa	2142	0
1193	Hantos	2434	0
1194	Aszófő	8241	0
1195	Pusztavám	8066	0
1196	Bakonysárkány	2861	0
1197	Döbrönte	8597	0
1198	Csesznek	8419	0
1199	Bakonyszentkirály	8430	0
1200	Bag	2191	0
1201	Nézsa	2618	0
1202	Alsópetény	2617	0
1203	Romhány	2654	0
1204	Legénd	2619	0
1205	Szátok	2656	0
1206	Németbánya	8581	0
1207	Bakonyjákó	8581	0
1208	Tevel	7181	0
1209	Szárliget	2067	0
1210	Újbarok	2066	0
1211	Vértessomló	2823	0
1212	Kutas	7541	0
1213	Beleg	7543	0
1214	Szólád	8625	0
1215	Teleki	8626	0
1216	Nagycsepely	8628	0
1217	Kötcse	8627	0
1218	Kalocsa	6300	0
1219	Bátya	6351	0
1220	Kaposmérő	7521	0
1221	Inke	8724	0
1222	Iharosberény	8725	0
1223	Pogányszentpéter	8728	0
1224	Siófok	8600	0
1225	Sántos	7479	0
1226	Boldogasszonyfa	7937	0
1227	Bőszénfa	7475	0
1228	Bocska	8776	0
1229	Bagod	8992	0
1230	Hagyárosbörönd	8992	0
1231	Hegyhátsál	9915	0
1232	Katafa	9915	0
1233	Veszprém	8200	0
1234	Ipolydamásd	2631	0
1235	Kóspallag	2625	0
1236	Márianosztra	2629	0
1237	Perőcsény	2637	0
1238	Pócsa	7756	0
1239	Borjád	7756	0
1240	Töttös	7755	0
1241	Nagynyárád	7784	0
1242	Dunaszekcső	7712	0
1243	Dunafalva	6513	0
1244	Nagykozár	7741	0
1245	Szálka	7121	0
1246	Sárkeresztes	8051	0
1247	Magyaralmás	8071	0
1248	Bosta	7811	0
1249	Szalánta	7811	0
1250	Túrony	7811	0
1251	Zók	7671	0
1252	Bicsérd	7671	0
1253	Kaposszerdahely	7476	0
1254	Szenna	7477	0
1255	Patca	7477	0
1256	Szilvásszentmárton	7477	0
1257	Zselickisfalud	7477	0
1258	Nagymágocs	6622	0
1259	Szentbalázs	7472	0
1260	Oszkó	9825	0
1261	Hegyhátszentpéter	9821	0
1262	Győrvár	9821	0
1263	Pácsony	9823	0
1264	Petőmihályfa	9826	0
1265	Olaszfa	9824	0
1266	Andrásfa	9811	0
1267	Bükkösd	7682	0
1268	Helesfa	7683	0
1269	Pécsbagota	7951	0
1270	Szabadszentkirály	7951	0
1271	Gerde	7951	0
1272	Királyegyháza	7953	0
1273	Gersekarát	9813	0
1274	Cserkút	7673	0
1275	Boda	7672	0
1276	Csonkamindszent	7940	0
1277	Kacsóta	7940	0
1278	Szentdénes	7913	0
1279	Katádfa	7914	0
1280	Bánfa	7914	0
1281	Rózsafa	7914	0
1282	Nyugotszenterzsébet	7912	0
1283	Botykapeterd	7900	0
1284	Nagypeterd	7912	0
1285	Nagyváty	7912	0
1286	Dencsháza	7915	0
1287	Szentegát	7915	0
1288	Gyód	7668	0
1289	Hosszúhetény	7694	0
1290	Kővágószőlős	7673	0
1291	Bakonya	7675	0
1292	Kővágótöttös	7675	0
1293	Magyarhertelend	7394	0
1294	Kisasszond	7523	0
1295	Gige	7527	0
1296	Pálmajor	7561	0
1297	Pécsudvard	7762	0
1298	Szemely	7763	0
1299	Vörs	8711	0
1300	Főnyed	8732	0
1301	Szegerdő	8732	0
1302	Tikos	8731	0
1303	Hollád	8731	0
1304	Sávoly	8732	0
1305	Somogysámson	8733	0
1306	Szőkedencs	8736	0
1307	Csákány	8735	0
1308	Somogyzsitfa	8734	0
1309	Gadány	8716	0
1310	Kelevíz	8714	0
1311	Mesztegnyő	8716	0
1312	Hosszúvíz	8716	0
1313	Libickozma	8707	0
1314	Újvárfalva	7436	0
1315	Somogysárd	7435	0
1316	Varászló	8723	0
1317	Somogyszentpál	8705	0
1318	Gyugy	8692	0
1319	Bálványos	8614	0
1320	Lulla	8660	0
1321	Torvaj	8660	0
1322	Sérsekszőlős	8660	0
1323	Kapoly	8671	0
1324	Kánya	8667	0
1325	Tengőd	8668	0
1326	Bábonymegyer	8658	0
1327	Nyim	8612	0
1328	Nagyberény	8656	0
1329	Ádánd	8653	0
1330	Siójut	8652	0
1331	Balatonszabadi	8651	0
1332	Somogyegres	8666	0
1333	Zics	8672	0
1334	Bedegkér	8666	0
1335	Nágocs	8674	0
1336	Miklósi	8669	0
1337	Kára	7285	0
1338	Gadács	7276	0
1339	Somogyszil	7276	0
1340	Bonnya	7281	0
1341	Kisbárapáti	7282	0
1342	Fiad	7282	0
1343	Felsőmocsolád	7456	0
1344	Ecseny	7457	0
1345	Polány	7458	0
1346	Gamás	8685	0
1347	Somogygeszti	7455	0
1348	Alsóbogát	7443	0
1349	Edde	7443	0
1350	Somogyjád	7443	0
1351	Várda	7442	0
1352	Magyaregres	7441	0
1353	Hács	8694	0
1354	Kisberény	8693	0
1355	Zselickislak	7400	0
1356	Simonfa	7474	0
1357	Kaposgyarmat	7473	0
1358	Hedrehely	7533	0
1359	Visnye	7533	0
1360	Kőkút	7530	0
1361	Rinyabesenyő	7552	0
1362	Homokszentgyörgy	7537	0
1363	Szenta	8849	0
1364	Bolhás	7517	0
1365	Kaszó	7564	0
1366	Somogycsicsó	8726	0
1367	Csurgónagymarton	8840	0
1368	Iharos	8726	0
1369	Porrogszentkirály	8858	0
1370	Porrog	8858	0
1371	Porrogszentpál	8858	0
1372	Somogybükkösd	8858	0
1373	Őrtilos	8854	0
1374	Zákány	8852	0
1375	Zákányfalu	8853	0
1376	Gyékényes	8851	0
1377	Segesd	7562	0
1378	Nemeskisfalud	8717	0
1379	Szenyér	8717	0
1380	Nagyszakácsi	8739	0
1381	Mezőcsokonya	7434	0
1382	Somodor	7454	0
1383	Szentgáloskér	7465	0
1384	Kazsok	7274	0
1385	Büssü	7273	0
1386	Patalom	7463	0
1387	Gölle	7272	0
1388	Kisgyalán	7279	0
1389	Fonó	7271	0
1390	Kaposhomok	7261	0
1391	Kaposkeresztúr	7258	0
1392	Kercseliget	7256	0
1393	Rinyakovácsi	7527	0
1394	Kisbajom	7542	0
1395	Nagykorpád	7545	0
1396	Vásárosbéc	7926	0
1397	Magyarlukafa	7925	0
1398	Somogyhárságy	7925	0
1399	Somogyhatvan	7921	0
1400	Merenye	7981	0
1401	Patapoklosi	7923	0
1402	Tótszentgyörgy	7981	0
1403	Nagydobsza	7985	0
1404	Kisdobsza	7985	0
1405	Pettend	7980	0
1406	Gyöngyösmellék	7972	0
1407	Nemeske	7981	0
1408	Kistamási	7981	0
1409	Molvány	7981	0
1410	Szörény	7976	0
1411	Felsőszentmárton	7968	0
1412	Drávakeresztúr	7967	0
1413	Markóc	7967	0
1414	Bogdása	7966	0
1415	Drávaiványi	7960	0
1416	Drávasztára	7960	0
1417	Sósvertike	7960	0
1418	Zaláta	7839	0
1419	Kemse	7839	0
1420	Piskó	7838	0
1421	Vejti	7838	0
1422	Lúzsok	7838	0
1423	Csányoszró	7964	0
1424	Nagycsány	7838	0
1425	Kákics	7958	0
1426	Marócsa	7960	0
1427	Endrőc	7973	0
1428	Bürüs	7973	0
1429	Várad	7973	0
1430	Hirics	7838	0
1431	Vajszló	7838	0
1432	Besence	7838	0
1433	Gilvánfa	7954	0
1434	Magyarmecske	7954	0
1435	Gyöngyfa	7954	0
1436	Sumony	7960	0
1437	Magyartelek	7954	0
1438	Kisasszonyfa	7954	0
1439	Ózdfalu	7836	0
1440	Páprád	7838	0
1441	Sámod	7841	0
1442	Baranyahídvég	7841	0
1443	Kisszentmárton	7841	0
1444	Adorjás	7841	0
1445	Cún	7843	0
1446	Szaporca	7843	0
1447	Tésenfa	7843	0
1448	Drávapiski	7843	0
1449	Kórós	7841	0
1450	Bogádmindszent	7836	0
1451	Téseny	7834	0
1452	Velény	7951	0
1453	Baksa	7834	0
1454	Tengeri	7834	0
1455	Kisdér	7814	0
1456	Hegyszentmárton	7837	0
1457	Siklósbodony	7814	0
1458	Babarcszőlős	7814	0
1459	Ócsárd	7814	0
1460	Görcsöny	7833	0
1461	Aranyosgadány	7671	0
1462	Pogány	7666	0
1463	Peterd	7766	0
1464	Pécsdevecser	7766	0
1465	Kiskassa	7766	0
1466	Somogyviszló	7924	0
1467	Basal	7923	0
1468	Mozsgó	7932	0
1469	Szentlászló	7936	0
1470	Ibafa	7935	0
1471	Almáskeresztúr	7932	0
1472	Dinnyeberki	7683	0
1473	Horváthertelend	7935	0
1474	Csebény	7935	0
1475	Szágy	7383	0
1476	Tormás	7383	0
1477	Baranyaszentgyörgy	7383	0
1478	Gödre	7386	0
1479	Baranyajenő	7384	0
1480	Mindszentgodisa	7391	0
1481	Palé	7370	0
1482	Oroszló	7370	0
1483	Szilvás	7811	0
1484	Szőke	7833	0
1485	Szava	7813	0
1486	Garé	7812	0
1487	Bisse	7811	0
1488	Csarnóta	7811	0
1489	Rádfalva	7817	0
1490	Kistótfalu	7768	0
1491	Márfa	7817	0
1492	Diósviszló	7817	0
1493	Drávacsehi	7849	0
1494	Drávacsepely	7846	0
1495	Matty	7854	0
1496	Alsószentmárton	7826	0
1497	Drávapalkonya	7850	0
1498	Ipacsfa	7847	0
1499	Kásád	7827	0
1500	Siklósnagyfalu	7823	0
1501	Old	7824	0
1502	Egyházasharaszti	7824	0
1503	Kisharsány	7800	0
1504	Vokány	7768	0
1505	Kistapolca	7823	0
1506	Nagytótfalu	7800	0
1507	Illocska	7775	0
1508	Lapáncsa	7775	0
1509	Nagyharsány	7822	0
1510	Beremend	7827	0
1511	Ivánbattyán	7772	0
1512	Márok	7774	0
1513	Kislippó	7775	0
1514	Magyarbóly	7775	0
1515	Lippó	7781	0
1516	Sárok	7781	0
1517	Ivándárda	7781	0
1518	Kisjakabfalva	7773	0
1519	Sátorhely	7785	0
1520	Udvar	7718	0
1521	Majs	7783	0
1522	Bezedek	7782	0
1523	Babarc	7757	0
1524	Szajk	7753	0
1525	Versend	7752	0
1526	Monyoród	7751	0
1527	Kátoly	7661	0
1528	Berkesd	7664	0
1529	Pereked	7664	0
1530	Szellő	7661	0
1531	Máriakéménd	7663	0
1532	Lánycsók	7759	0
1533	Kisnyárád	7759	0
1534	Liptód	7757	0
1535	Zengővárkony	7720	0
1536	Óbánya	7695	0
1537	Mecseknádasd	7695	0
1538	Hidas	7696	0
1539	Martonfa	7720	0
1540	Szilágy	7664	0
1541	Erzsébet	7661	0
1542	Kékesd	7661	0
1543	Nagyhajmás	7343	0
1544	Kisbudmér	7756	0
1545	Szalatnak	7334	0
1546	Mekényes	7344	0
1547	Bár	7711	0
1548	Ófalu	7695	0
1549	Nagybudmér	7756	0
1550	Homorúd	7716	0
1551	Okorág	7957	0
1552	Vékény	7333	0
1553	Köblény	7334	0
1554	Meződ	7370	0
1555	Vázsnok	7370	0
1556	Jágónak	7357	0
1557	Kaposszekcső	7361	0
1558	Csikóstőttős	7341	0
1559	Kapospula	7251	0
1560	Nak	7215	0
1561	Lápafő	7214	0
1562	Várong	7214	0
1563	Szakcs	7213	0
1564	Dalmand	7211	0
1565	Nagyszokoly	7097	0
1566	Magyarkeszi	7098	0
1567	Fürged	7087	0
1568	Felsőnyék	7099	0
1569	Ozora	7086	0
1570	Gyulaj	7227	0
1571	Lengyel	7184	0
1572	Mucsfa	7185	0
1573	Kisvejke	7183	0
1574	Nagyvejke	7186	0
1575	Györe	7352	0
1576	Váralja	7354	0
1577	Kismányok	7356	0
1578	Cikó	7161	0
1579	Mőcsény	7163	0
1580	Bátaapáti	7164	0
1581	Mórágy	7165	0
1582	Grábóc	7162	0
1583	Alsónána	7147	0
1584	Kakasd	7122	0
1585	Alsónyék	7148	0
1586	Szakály	7192	0
1587	Mucsi	7195	0
1588	Csöde	8999	0
1589	Zalabaksa	8971	0
1590	Magyarföld	8973	0
1591	Ramocsa	8973	0
1592	Felsőszenterzsébet	8973	0
1593	Alsószenterzsébet	8973	0
1594	Kerkakutas	8973	0
1595	Kozmadombja	8988	0
1596	Kálócfa	8988	0
1597	Szentgyörgyvölgy	8975	0
1598	Nemesnép	8976	0
1599	Lendvajakabfa	8977	0
1600	Baglad	8977	0
1601	Resznek	8977	0
1602	Bödeháza	8969	0
1603	Belsősárd	8978	0
1604	Zalaszombatfa	8969	0
1605	Szijártóháza	8969	0
1606	Gáborjánháza	8969	0
1607	Külsősárd	8978	0
1608	Kerkabarabás	8971	0
1609	Lendvadedes	8978	0
1610	Gosztola	8978	0
1611	Lovászi	8878	0
1612	Kerkateskánd	8879	0
1613	Szécsisziget	8879	0
1614	Tormafölde	8876	0
1615	Tornyiszentmiklós	8877	0
1616	Dobri	8874	0
1617	Kerkaszentkirály	8874	0
1618	Csörnyeföld	8873	0
1619	Iklódbördőce	8958	0
1620	Csömödér	8957	0
1621	Páka	8956	0
1622	Hernyék	8957	0
1623	Kissziget	8957	0
1624	Ortaháza	8954	0
1625	Zebecke	8957	0
1626	Csertalakos	8951	0
1627	Pördefölde	8956	0
1628	Kányavár	8956	0
1629	Maróc	8888	0
1630	Lispeszentadorján	8888	0
1631	Lasztonya	8887	0
1632	Bázakerettye	8887	0
1633	Kiscsehi	8888	0
1634	Szentmargitfalva	8872	0
1635	Muraszemenye	8872	0
1636	Murarátka	8868	0
1637	Zajk	8868	0
1638	Kistolmács	8868	0
1639	Borsfa	8885	0
1640	Valkonya	8885	0
1641	Bánokszentgyörgy	8891	0
1642	Várfölde	8891	0
1643	Nova	8948	0
1644	Pusztaapáti	8986	0
1645	Keménfa	8995	0
1646	Zalaháshágy	8997	0
1647	Vaspör	8998	0
1648	Zalaboldogfa	8992	0
1649	Kiskutas	8911	0
1650	Nagykutas	8911	0
1651	Lakhegy	8913	0
1652	Kispáli	8912	0
1653	Nagypáli	8912	0
1654	Egervár	8913	0
1655	Gősfa	8913	0
1656	Vasboldogasszony	8914	0
1657	Zalaszentiván	8921	0
1658	Alibánfa	8921	0
1659	Pethőhenye	8921	0
1660	Nemesapáti	8923	0
1661	Alsónemesapáti	8924	0
1662	Kemendollár	8931	0
1663	Pókaszepetk	8932	0
1664	Zalaistvánd	8932	0
1665	Gyűrűs	8932	0
1666	Vöckönd	8931	0
1667	Orbányosfa	8935	0
1668	Kisbucsa	8926	0
1669	Bezeréd	8934	0
1670	Padár	8935	0
1671	Almásháza	8935	0
1672	Kallósd	8785	0
1673	Dötk	8799	0
1674	Pakod	8799	0
1675	Zalabér	8798	0
1676	Batyk	8797	0
1677	Zalavég	8792	0
1678	Türje	8796	0
1679	Szalapa	8341	0
1680	Kisvásárhely	8341	0
1681	Mihályfa	8341	0
1682	Óhíd	8342	0
1683	Kisgörbő	8356	0
1684	Sümegcsehi	8357	0
1685	Döbröce	8357	0
1686	Nagygörbő	8356	0
1687	Zalaszentlászló	8788	0
1688	Sénye	8788	0
1689	Vindornyaszőlős	8355	0
1690	Vindornyalak	8353	0
1691	Zalaköveskút	8354	0
1692	Vindornyafok	8354	0
1693	Karmacs	8354	0
1694	Nemesbük	8371	0
1695	Rezi	8373	0
1696	Várvölgy	8316	0
1697	Vállus	8316	0
1698	Nemespátró	8857	0
1699	Liszó	8831	0
1700	Surd	8856	0
1701	Belezna	8855	0
1702	Fityeház	8835	0
1703	Murakeresztúr	8834	0
1704	Semjénháza	8862	0
1705	Molnári	8863	0
1706	Szepetnek	8861	0
1707	Eszteregnye	8882	0
1708	Rigyác	8883	0
1709	Petrivente	8866	0
1710	Tótszentmárton	8865	0
1711	Tótszerdahely	8864	0
1712	Oltárc	8886	0
1713	Bucsuta	8893	0
1714	Szentliszló	8893	0
1715	Pusztamagyaród	8895	0
1716	Szentpéterfölde	8953	0
1717	Pusztaederics	8946	0
1718	Pusztaszentlászló	8896	0
1719	Gutorfölde	8951	0
1720	Tófej	8946	0
1721	Szentkozmadombja	8947	0
1722	Zalatárnok	8947	0
1723	Baktüttös	8946	0
1724	Barlahida	8948	0
1725	Petrikeresztúr	8984	0
1726	Ormándlak	8983	0
1727	Lickóvadamos	8981	0
1728	Söjtör	8897	0
1729	Börzönce	8772	0
1730	Pálfiszeg	8990	0
1731	Böde	8991	0
1732	Hottó	8991	0
1733	Bocfölde	8943	0
1734	Csatár	8943	0
1735	Nemeshetés	8928	0
1736	Búcsúszentlászló	8925	0
1737	Nemessándorháza	8925	0
1738	Misefa	8935	0
1739	Nemesrádó	8915	0
1740	Zalaigrice	8761	0
1741	Tilaj	8782	0
1742	Gétye	8762	0
1743	Bókaháza	8741	0
1744	Szentgyörgyvár	8393	0
1745	Alsópáhok	8394	0
1746	Zalaszentmárton	8764	0
1747	Esztergályhorváti	8742	0
1748	Zalavár	8392	0
1749	Egeraracsa	8765	0
1750	Dióskál	8764	0
1751	Balatonmagyaród	8753	0
1752	Pölöskefő	8773	0
1753	Gelse	8774	0
1754	Kacorlak	8773	0
1755	Magyarszerdahely	8776	0
1756	Magyarszentmiklós	8776	0
1757	Fűzvölgy	8777	0
1758	Hosszúvölgy	8777	0
1759	Homokkomárom	8777	0
1760	Újudvar	8778	0
1761	Nagybakónak	8821	0
1762	Zalaújlak	8822	0
1763	Csapi	8756	0
1764	Kisrécse	8756	0
1765	Nagyrécse	8756	0
1766	Galambok	8754	0
1767	Sand	8824	0
1768	Miháld	8825	0
1769	Pat	8825	0
1770	Gelsesziget	8774	0
1771	Újiráz	4146	0
1772	Csökmő	4145	0
1773	Darvas	4144	0
1774	Vekerd	4143	0
1775	Magyarhomorog	4137	0
1776	Körösszakál	4136	0
1777	Körösszegapáti	4135	0
1778	Berekböszörmény	4116	0
1779	Told	4117	0
1780	Mezősas	4134	0
1781	Mezőpeterd	4118	0
1782	Váncsod	4119	0
1783	Bojt	4114	0
1784	Esztár	4124	0
1785	Hencida	4123	0
1786	Gáborján	4122	0
1787	Szentpéterszeg	4121	0
1788	Konyár	4133	0
1789	Tépe	4132	0
1790	Bakonszeg	4164	0
1791	Zsáka	4142	0
1792	Furta	4141	0
1793	Nagyrábé	4173	0
1794	Bihartorda	4174	0
1795	Bihardancsháza	4175	0
1796	Biharnagybajom	4172	0
1797	Sárrétudvari	4171	0
1798	Szerep	4163	0
1799	Báránd	4161	0
1800	Tetétlen	4184	0
1801	Sáp	4176	0
1802	Földes	4177	0
1803	Hortobágy	4071	0
1804	Nagyhegyes	4064	0
1805	Ebes	4211	0
1806	Hajdúszovát	4212	0
1807	Hajdúbagos	4273	0
1808	Sáránd	4272	0
1809	Mikepércs	4271	0
1810	Újszentmargita	4065	0
1811	Folyás	4090	0
1812	Görbeháza	4075	0
1813	Újtikos	4096	0
1814	Tiszagyulaháza	4097	0
1815	Álmosd	4285	0
1816	Kokad	4284	0
1817	Bagamér	4286	0
1818	Újléta	4288	0
1819	Nyírábrány	4264	0
1820	Nyírmártonfalva	4263	0
1821	Nyíracsád	4262	0
1822	Fülöp	4266	0
1823	Bocskaikert	4241	0
1824	Pilisszentlélek	0	0
1825	Bakóca	7393	0
1826	Kisbeszterce	7391	0
1827	Újsolt	6321	0
1828	Dunatetétlen	6325	0
1829	Harta	6326	0
1830	Öregcsertő	6311	0
1831	Imrehegy	6238	0
1832	Rém	6446	0
1833	Borota	6445	0
1834	Kéleshalom	6444	0
1835	Érsekcsanád	6347	0
1836	Dusnok	6353	0
1837	Szeremle	6512	0
1838	Bátmonostor	6528	0
1839	Vaskút	6521	0
1840	Nagybaracska	6527	0
1841	Csátalja	6523	0
1842	Gara	6522	0
1843	Dávod	6524	0
1844	Hercegszántó	6525	0
1845	Bácsszentgyörgy	6511	0
1846	Madaras	6456	0
1847	Katymár	6455	0
1848	Bácsborsód	6454	0
1849	Bácsbokod	6453	0
1850	Mátételke	6452	0
1851	Kunbaja	6435	0
1852	Csikéria	6424	0
1853	Bácsszőlős	6425	0
1854	Zsana	6411	0
1855	Harkakötöny	6136	0
1856	Csólyospálos	6135	0
1857	Kömpöc	6134	0
1858	Pálmonostora	6112	0
1859	Petőfiszállás	6113	0
1860	Jászszentlászló	6133	0
1861	Szank	6131	0
1862	Móricgát	6132	0
1863	Gátér	6111	0
1864	Bugac	6114	0
1865	Bugacpusztaháza	6114	0
1866	Fülöpjakab	6116	0
1867	Kunszállás	6115	0
1868	Jakabszállás	6078	0
1869	Helvécia	6034	0
1870	Ballószög	6035	0
1871	Fülöpháza	6042	0
1872	Ágasegyháza	6076	0
1873	Orgovány	6077	0
1874	Tiszaalpár	6066	0
1875	Szentkirály	6031	0
1876	Kunadacs	6097	0
1877	Kunbaracs	6043	0
1878	Kunpeszér	6096	0
1879	Ladánybene	6045	0
1880	Felsőlajos	6055	0
1881	Bócsa	6235	0
1882	Tázlár	6236	0
1883	Nagytőke	6612	0
1884	Fábiánsebestyén	6625	0
1885	Eperjes	6624	0
1886	Derekegyház	6621	0
1887	Szegvár	6635	0
1888	Csanytelek	6647	0
1889	Felgyő	6645	0
1890	Tömörkény	6646	0
1891	Pusztaszer	6769	0
1892	Baks	6768	0
1893	Mártély	6636	0
1894	Dóc	6766	0
1895	Balástya	6764	0
1896	Forráskút	6793	0
1897	Üllés	6794	0
1898	Bordány	6795	0
1899	Szatymaz	6763	0
1900	Zsombó	6792	0
1901	Ferencszállás	6774	0
1902	Zákányszék	6787	0
1903	Maroslele	6921	0
1904	Klárafalva	6773	0
1905	Óföldeák	6923	0
1906	Apátfalva	6931	0
1907	Földeák	6922	0
1908	Nagylak	6933	0
1909	Magyarcsanád	6932	0
1910	Csanádpalota	6913	0
1911	Kövegy	6912	0
1912	Pitvaros	6914	0
1913	Királyhegyes	6911	0
1914	Nagyér	6917	0
1915	Ásotthalom	6783	0
1916	Csanádalberti	6915	0
1917	Ambrózfalva	6916	0
1918	Pusztamérges	6785	0
1919	Csengele	6765	0
1920	Ruzsa	6786	0
1921	Öttömös	6784	0
1922	Dombegyház	5836	0
1923	Kisdombegyház	5837	0
1924	Magyardombegyház	5838	0
1925	Dombiratos	5745	0
1926	Kevermes	5744	0
1927	Lőkösháza	5743	0
1928	Nagykamarás	5751	0
1929	Almáskamarás	5747	0
1930	Magyarbánhegyes	5667	0
1931	Végegyháza	5811	0
1932	Kardoskút	5945	0
1933	Kaszaper	5948	0
1934	Pusztaföldvár	5919	0
1935	Nagybánhegyes	5668	0
1936	Medgyesegyháza	5666	0
1937	Medgyesbodzás	5663	0
1938	Pusztaottlaka	5665	0
1939	Csabaszabadi	5609	0
1940	Csanádapáca	5662	0
1941	Gerendás	5925	0
1942	Újkígyós	5661	0
1943	Szabadkígyós	5712	0
1944	Telekgerendás	5675	0
1945	Kétsoprony	5674	0
1946	Hunya	5555	0
1947	Kamut	5673	0
1948	Murony	5672	0
1949	Kardos	5552	0
1950	Örménykút	5556	0
1951	Gádoros	5932	0
1952	Csárdaszállás	5621	0
1953	Köröstarcsa	5622	0
1954	Bélmegyer	5643	0
1955	Okány	5534	0
1956	Tarhos	5641	0
1957	Sarkadkeresztúr	5731	0
1958	Doboz	5624	0
1959	Kötegyán	5725	0
1960	Újszalonta	5727	0
1961	Méhkerék	5726	0
1962	Mezőgyán	5732	0
1963	Geszt	5734	0
1964	Zsadány	5537	0
1965	Körösújfalu	5536	0
1966	Biharugra	5538	0
1967	Körösnagyharsány	5539	0
1968	Csabacsűd	5551	0
1969	Ecsegfalva	5515	0
1970	Kertészsziget	5526	0
1971	Bucsa	5527	0
1972	Almamellék	7934	0
1973	Ároktő	3467	0
1974	Tiszadorogma	3466	0
1975	Tiszabábolna	3465	0
1976	Tiszavalk	3464	0
1977	Négyes	3463	0
1978	Borsodivánka	3462	0
1979	Egerlövő	3461	0
1980	Szentistván	3418	0
1981	Mezőnagymihály	3443	0
1982	Gelej	3444	0
1983	Mezőkeresztes	3441	0
1984	Mezőnyárád	3421	0
1985	Tiszakeszi	3458	0
1986	Tiszatarján	3589	0
1987	Hejőkürt	3588	0
1988	Oszlár	3591	0
1989	Tiszapalkonya	3587	0
1990	Nemesbikk	3592	0
1991	Hejőbába	3593	0
1992	Hejőpapi	3594	0
1993	Igrici	3459	0
1994	Hejőszalonta	3595	0
1995	Hejőkeresztúr	3597	0
1996	Nagycsécs	3598	0
1997	Szakáld	3596	0
1998	Muhi	3552	0
1999	Ónod	3551	0
2000	Sajópetri	3573	0
2001	Sajólád	3572	0
2002	Kistokaj	3553	0
2003	Bükkaranyos	3554	0
2004	Harsány	3555	0
2005	Borsodgeszt	3426	0
2006	Vatta	3431	0
2007	Bükkábrány	3422	0
2008	Csincse	3442	0
2009	Sály	3425	0
2010	Kács	3424	0
2011	Kisgyőr	3556	0
2012	Bükkszentkereszt	3557	0
2013	Répáshuta	3559	0
2014	Bogács	3412	0
2015	Taktakenéz	3924	0
2016	Prügy	3925	0
2017	Taktabáj	3926	0
2018	Csobaj	3927	0
2019	Tiszatardos	3928	0
2020	Tiszaladány	3929	0
2021	Taktaszada	3921	0
2022	Bekecs	3903	0
2023	Legyesbénye	3904	0
2024	Mezőzombor	3931	0
2025	Mád	3909	0
2026	Rátka	3908	0
2027	Tállya	3907	0
2028	Golop	3906	0
2029	Monok	3905	0
2030	Felsődobsza	3847	0
2031	Hernádkércs	3846	0
2032	Szentistvánbaksa	3844	0
2033	Nagykinizs	3844	0
2034	Kiskinizs	3843	0
2035	Megyaszó	3718	0
2036	Alsódobsza	3717	0
2037	Sóstófalva	3716	0
2038	Újcsanálos	3716	0
2039	Gesztely	3715	0
2040	Onga	3562	0
2041	Arnót	3713	0
2042	Sajópálfala	3714	0
2043	Viss	3956	0
2044	Sárazsadány	3942	0
2045	Bodrogolaszi	3943	0
2046	Györgytarló	3954	0
2047	Vajdácska	3961	0
2048	Alsóberecki	3985	0
2049	Felsőberecki	3985	0
2050	Karos	3962	0
2051	Bodroghalom	3987	0
2052	Tiszacsermely	3972	0
2053	Karcsa	3963	0
2054	Pácin	3964	0
2055	Nagyrozvágy	3965	0
2056	Kisrozvágy	3965	0
2057	Semjén	3974	0
2058	Lácacséke	3967	0
2059	Ricse	3974	0
2060	Révleányvár	3976	0
2061	Dámóc	3978	0
2062	Zemplénagárd	3977	0
2063	Erdőbénye	3932	0
2064	Sima	3881	0
2065	Baskó	3881	0
2066	Erdőhorváti	3935	0
2067	Komlóska	3937	0
2068	Háromhuta	3936	0
2069	Hercegkút	3958	0
2070	Makkoshotyka	3959	0
2071	Vágáshuta	3992	0
2072	Kovácsvágás	3992	0
2073	Nagyhuta	3994	0
2074	Kishuta	3994	0
2075	Bózsva	3994	0
2076	Füzérradvány	3993	0
2077	Vilyvitány	3991	0
2078	Mikóháza	3989	0
2079	Alsóregmec	3989	0
2080	Felsőregmec	3989	0
2081	Nyíri	3998	0
2082	Füzérkomlós	3997	0
2083	Füzérkajata	3994	0
2084	Pusztafalu	3995	0
2085	Füzér	3996	0
2086	Hollóháza	3999	0
2087	Pányok	3898	0
2088	Abaújvár	3898	0
2089	Zsujta	3897	0
2090	Tornyosnémeti	3877	0
2091	Hidasnémeti	3876	0
2092	Hernádszurdok	3875	0
2093	Vizsoly	3888	0
2094	Arka	3885	0
2095	Abaújkér	3882	0
2096	Abaújalpár	3882	0
2097	Boldogkőújfalu	3884	0
2098	Gibárt	3854	0
2099	Bükkmogyorósd	3648	0
2100	Csernely	3648	0
2101	Lénárddaróc	3648	0
2102	Sáta	3659	0
2103	Nekézseny	3646	0
2104	Mályinka	3645	0
2105	Dédestapolcsány	3643	0
2106	Uppony	3622	0
2107	Borsodbóta	3658	0
2108	Járdánháza	3664	0
2109	Arló	3663	0
2110	Farkaslyuk	3608	0
2111	Borsodszentgyörgy	3623	0
2112	Domaháza	3627	0
2113	Kissikátor	3627	0
2114	Hangony	3626	0
2115	Sajómercse	3656	0
2116	Királd	3657	0
2117	Sajónémeti	3652	0
2118	Sajópüspöki	3653	0
2119	Hét	3655	0
2120	Bánréve	3654	0
2121	Serényfalva	3729	0
2122	Sajóvelezd	3656	0
2123	Dubicsány	3635	0
2124	Bánhorváti	3642	0
2125	Nagybarca	3641	0
2126	Varbó	3778	0
2127	Parasznya	3777	0
2128	Radostyán	3776	0
2129	Kondó	3775	0
2130	Sajólászlófalva	3773	0
2131	Sajókápolna	3773	0
2132	Berente	3704	0
2133	Sajóivánka	3720	0
2134	Vadna	3636	0
2135	Sajókaza	3720	0
2136	Sajógalgóc	3636	0
2137	Sajóbábony	3792	0
2138	Sajókeresztúr	3791	0
2139	Sajóecseg	3793	0
2140	Sajóvámos	3712	0
2141	Sajósenye	3712	0
2142	Boldva	3794	0
2143	Aszaló	3841	0
2144	Alsóvadász	3811	0
2145	Homrogd	3812	0
2146	Kázsmárk	3831	0
2147	Léh	3832	0
2148	Monaj	3812	0
2149	Halmaj	3842	0
2150	Csobád	3848	0
2151	Rásonysápberencs	3833	0
2152	Detek	3834	0
2153	Beret	3834	0
2154	Baktakék	3836	0
2155	Ináncs	3851	0
2156	Hernádszentandrás	3852	0
2157	Pere	3853	0
2158	Hernádbűd	3853	0
2159	Forró	3849	0
2160	Méra	3871	0
2161	Szalaszend	3863	0
2162	Novajidrány	3872	0
2163	Garadna	3873	0
2164	Hernádvécse	3874	0
2165	Fulókércs	3864	0
2166	Fáj	3865	0
2167	Fancsal	3855	0
2168	Alsógagy	3837	0
2169	Gagyapáti	3837	0
2170	Selyeb	3809	0
2171	Kupa	3813	0
2172	Nyésta	3809	0
2173	Felsővadász	3814	0
2174	Tomor	3787	0
2175	Hegymeg	3786	0
2176	Lak	3786	0
2177	Ziliz	3794	0
2178	Borsodszirák	3796	0
2179	Nyomár	3795	0
2180	Hangács	3795	0
2181	Múcsony	3744	0
2182	Szuhakálló	3731	0
2183	Kurityán	3732	0
2184	Felsőnyárád	3721	0
2185	Jákfalva	3721	0
2186	Dövény	3721	0
2187	Felsőkelecsény	3722	0
2188	Ormosbánya	3743	0
2189	Izsófalva	3741	0
2190	Rudolftelep	3742	0
2191	Damak	3780	0
2192	Balajt	3780	0
2193	Ládbesenyő	3780	0
2194	Szendrőlád	3751	0
2195	Abod	3753	0
2196	Galvács	3752	0
2197	Szakácsi	3786	0
2198	Irota	3786	0
2199	Gadna	3815	0
2200	Abaújlak	3815	0
2201	Abaújszolnok	3809	0
2202	Felsőgagy	3837	0
2203	Csenyéte	3837	0
2204	Gagyvendégi	3816	0
2205	Gagybátor	3817	0
2206	Rakaca	3825	0
2207	Rakacaszend	3826	0
2208	Meszes	3754	0
2209	Szalonna	3754	0
2210	Martonyi	3755	0
2211	Alsótelekes	3735	0
2212	Felsőtelekes	3735	0
2213	Alsószuha	3726	0
2214	Zádorfalva	3726	0
2215	Kelemér	3728	0
2216	Gömörszőlős	3728	0
2217	Szuhafő	3726	0
2218	Trizs	3724	0
2219	Ragály	3724	0
2220	Imola	3725	0
2221	Kánó	3735	0
2222	Égerszög	3757	0
2223	Teresztenye	3757	0
2224	Szőlősardó	3757	0
2225	Varbóc	3756	0
2226	Szinpetri	3761	0
2227	Jósvafő	3758	0
2228	Aggtelek	3759	0
2229	Szin	3761	0
2230	Szögliget	3762	0
2231	Bódvarákó	3764	0
2232	Bódvaszilas	3763	0
2233	Komjáti	3765	0
2234	Tornaszentandrás	3765	0
2235	Tornabarakony	3765	0
2236	Debréte	3825	0
2237	Viszló	3825	0
2238	Tornanádaska	3767	0
2239	Bódvalenke	3768	0
2240	Hidvégardó	3768	0
2241	Becskeháza	3768	0
2242	Tornaszentjakab	3769	0
2243	Pamlény	3821	0
2244	Szászfa	3821	0
2245	Keresztéte	3821	0
2246	Krasznokvajda	3821	0
2247	Perecse	3821	0
2248	Büttös	3821	0
2249	Kány	3821	0
2250	Litka	3866	0
2251	Szemere	3866	0
2252	Pusztaradvány	3874	0
2253	Hernádpetri	3874	0
2254	Szigetvár	7900	0
2255	Vigántpetend	8294	0
2256	Gálosfa	7473	0
2257	Hajmás	7473	0
2258	Ostffyasszonyfa	9512	0
2259	Csönge	9513	0
2260	Kenyeri	9514	0
2261	Remeteszőlős	2090	0
2262	Solymár	2083	0
2263	Kesztölc	2517	0
2264	Csolnok	2521	0
2265	Mezőszemere	3378	0
2266	Hajmáskér	8192	0
2267	Nagyesztergár	8415	0
2268	Dudar	8416	0
2269	Szápár	8423	0
2270	Bakonycsernye	8056	0
2271	Csánig	9654	0
2272	Nick	9652	0
2273	Uraiújfalu	9651	0
2274	Vámoscsalád	9665	0
2275	Vasegerszeg	9661	0
2276	Hegyfalu	9631	0
2277	Zsédeny	9635	0
2278	Jákfa	9643	0
2279	Rábapaty	9641	0
2280	Sótony	9681	0
2281	Ikervár	9756	0
2282	Nyőgér	9682	0
2283	Bögöt	9612	0
2284	Porpác	9612	0
2285	Bejcgyertyános	9683	0
2286	Csobánka	2014	0
2287	Tompaládony	9662	0
2288	Bő	9625	0
2289	Mesterháza	9662	0
2290	Bajánsenye	9944	0
2291	Kercaszomor	9945	0
2292	Kerkáskápolna	9944	0
2293	Magyarszombatfa	9946	0
2294	Velemér	9946	0
2295	Bakonytamási	8555	0
2296	Pápateszér	8556	0
2297	Bakonyszentiván	8557	0
2298	Csót	8558	0
2299	Ugod	8564	0
2300	Bakonyszücs	8572	0
2301	Kölked	7717	0
2302	Kémes	7843	0
2303	Drávaszerdahely	7847	0
2304	Kovácshida	7847	0
2305	Gordisa	7853	0
2306	Drávaszabolcs	7851	0
2307	Regenye	7833	0
2308	Bögöte	9675	0
2309	Sajtoskál	9632	0
2310	Táborfalva	2381	0
2311	Závod	7182	0
2312	Lajoskomárom	8136	0
2313	Mezőkomárom	8137	0
2314	Szabadhídvég	8138	0
2315	Kisláng	8156	0
2316	Mátyásdomb	8134	0
2317	Bugyi	2347	0
2318	Apaj	2345	0
2319	Balotaszállás	6412	0
2320	Zalaszentjakab	8827	0
2321	Szabás	7544	0
2322	Alsószölnök	9983	0
2323	Szakonyfalu	9983	0
2324	Apátistvánfalva	9982	0
2325	Orfalu	9982	0
2326	Farkasfa	9981	0
2327	Ispánk	9941	0
2328	Kisrákos	9936	0
2329	Viszák	9932	0
2330	Csákánydoroszló	9919	0
2331	Gasztony	9952	0
2332	Rábagyarmat	9961	0
2333	Rátót	9951	0
2334	Vasszentmihály	9953	0
2335	Nemesmedves	9953	0
2336	Csörötnek	9962	0
2337	Magyarlak	9962	0
2338	Rönök	9954	0
2339	Daraboshegy	9917	0
2340	Halogy	9917	0
2341	Nádasd	9915	0
2342	Pinkamindszent	9922	0
2343	Szentpéterfa	9799	0
2344	Harasztifalu	9784	0
2345	Nagykölked	9784	0
2346	Rádóckölked	9784	0
2347	Narda	9793	0
2348	Felsőcsatár	9794	0
2349	Vaskeresztes	9795	0
2350	Horvátlövő	9796	0
2351	Pornóapáti	9796	0
2352	Nárai	9797	0
2353	Tiszabecs	4951	0
2354	Kispalád	4956	0
2355	Magosliget	4953	0
2356	Uszka	4952	0
2357	Rozsály	4971	0
2358	Méhtelek	4975	0
2359	Garbolc	4976	0
2360	Nagyhódos	4977	0
2361	Kishódos	4977	0
2362	Zsarolyán	4961	0
2363	Jánkmajtis	4741	0
2364	Csegöld	4742	0
2365	Csengersima	4743	0
2366	Gacsály	4972	0
2367	Zajta	4974	0
2368	Császló	4973	0
2369	Kisnamény	4737	0
2370	Csaholc	4967	0
2371	Mánd	4942	0
2372	Nemesborzova	4942	0
2373	Vámosoroszi	4966	0
2374	Túrricse	4968	0
2375	Tisztaberek	4969	0
2376	Nagyszekeres	4962	0
2377	Kisszekeres	4963	0
2378	Penyige	4941	0
2379	Milota	4948	0
2380	Tiszacsécse	4947	0
2381	Tiszakóród	4946	0
2382	Túristvándi	4944	0
2383	Kömörő	4943	0
2384	Fülesd	4964	0
2385	Kölcse	4965	0
2386	Sonkád	4954	0
2387	Botpalád	4955	0
2388	Nagyar	4922	0
2389	Szatmárcseke	4945	0
2390	Tarpa	4931	0
2391	Tivadar	4921	0
2392	Kisar	4921	0
2393	Jánd	4841	0
2394	Gulács	4842	0
2395	Hetefejércse	4843	0
2396	Csaroda	4844	0
2397	Márokpapi	4932	0
2398	Beregsurány	4933	0
2399	Beregdaróc	4934	0
2400	Gelénes	4935	0
2401	Vámosatya	4936	0
2402	Tiszaszalka	4831	0
2403	Tiszavid	4832	0
2404	Tiszaadony	4833	0
2405	Barabás	4937	0
2406	Lónya	4836	0
2407	Mátyus	4835	0
2408	Tiszakerecseny	4834	0
2409	Kisvarsány	4811	0
2410	Nagyvarsány	4812	0
2411	Gyüre	4813	0
2412	Aranyosapáti	4634	0
2413	Tuzsér	4623	0
2414	Tiszamogyorós	4645	0
2415	Mezőladány	4641	0
2416	Újkenéz	4635	0
2417	Benk	4643	0
2418	Zsurk	4627	0
2419	Tiszaszentmárton	4628	0
2420	Tápiógyörgye	2767	0
2421	Tápiószele	2766	0
2422	Tápiószőlős	2769	0
2423	Újszilvás	2768	0
2424	Jászboldogháza	5144	0
2425	Jánoshida	5143	0
2426	Nábrád	4911	0
2427	Kérsemjén	4912	0
2428	Panyola	4913	0
2429	Olcsvaapáti	4914	0
2430	Olcsva	4826	0
2431	Ópályi	4821	0
2432	Nagydobos	4823	0
2433	Szamoskér	4721	0
2434	Szamosszeg	4824	0
2435	Kocsord	4751	0
2436	Győrtelek	4752	0
2437	Géberjén	4754	0
2438	Fülpösdaróc	4754	0
2439	Ököritófülpös	4755	0
2440	Rápolt	4756	0
2441	Hermánszeg	4735	0
2442	Szamossályi	4735	0
2443	Szamosújlak	4734	0
2444	Gyügye	4733	0
2445	Cégénydányád	4732	0
2446	Szamostatárfalva	4746	0
2447	Szamosbecs	4745	0
2448	Komlódtótfalu	4765	0
2449	Ura	4763	0
2450	Tyukod	4762	0
2451	Csengerújfalu	4764	0
2452	Pátyod	4766	0
2453	Porcsalma	4761	0
2454	Szamosangyalos	4767	0
2455	Mérk	4352	0
2456	Fábiánháza	4354	0
2457	Nyírcsaholy	4356	0
2458	Mohács	7700	0
2459	Jenő	8146	0
2460	Nádasdladány	8145	0
2461	Sárkeszi	8144	0
2462	Perkupa	3756	0
2463	Kemenesmihályfa	9511	0
2464	Kemenessömjén	9517	0
2465	Boba	9542	0
2466	Egyházashetye	9554	0
2467	Köcsk	9553	0
2468	Kemeneskápolna	9553	0
2469	Mesteri	9551	0
2470	Vásárosmiske	9552	0
2471	Nemeskocs	9542	0
2472	Paloznak	8229	0
2473	Lovas	8228	0
2474	Felsőörs	8227	0
2475	Hont	2647	0
2476	Felsőpakony	2363	0
2477	Alsónémedi	2351	0
2478	Mogyoród	2146	0
2479	Köveskál	8274	0
2480	Kővágóörs	8254	0
2481	Kékkút	8254	0
2482	Salföld	8256	0
2483	Pilisjászfalu	2080	0
2484	Szigetmonostor	2015	0
2485	Tahitótfalu	2021	0
2486	Pócsmegyer	2017	0
2487	Leányfalu	2016	0
2488	Majosháza	2339	0
2489	Áporka	2338	0
2490	Káptalantóti	8283	0
2491	Gyulakeszi	8286	0
2492	Szentbékkálla	8281	0
2493	Mindszentkálla	8282	0
2494	Poroszló	3388	0
2495	Kovácsszénája	7678	0
2496	Nyírmada	4564	0
2497	Magyarpolány	8449	0
2498	Rózsaszentmárton	3033	0
2499	Gyöngyöstarján	3036	0
2500	Gyöngyösoroszi	3211	0
2501	Nagyréde	3214	0
2502	Ecséd	3013	0
2503	Petőfibánya	3023	0
2504	Zagyvaszántó	3031	0
2505	Gyöngyöspata	3035	0
2506	Szűcsi	3034	0
2507	Szurdokpüspöki	3064	0
2508	Jobbágyi	3063	0
2509	Apc	3032	0
2510	Monostorapáti	8296	0
2511	Sülysáp	2241	0
2512	Tápiószecső	2251	0
2513	Buj	4483	0
2514	Karakó	9547	0
2515	Jánosháza	9545	0
2516	Sárpentele	0	0
2517	Hidegkút	8247	0
2518	Zselicszentpál	7474	0
2519	Cserénfa	7472	0
2520	Leányvár	2518	0
2521	Piliscsév	2519	0
2522	Vérteskethely	2859	0
2523	Császár	2858	0
2524	Dad	2854	0
2525	Bokod	2855	0
2526	Nagykarácsony	2425	0
2527	Szeghalom	5520	0
2528	Pellérd	7831	0
2529	Alap	7011	0
2530	Bakonykúti	8046	0
2531	Balinka	8055	0
2532	Baracs	2426	0
2533	Füle	8157	0
2534	Isztimér	8045	0
2535	Nagyveleg	8065	0
2536	Vajta	7041	0
2537	Dég	8135	0
2538	Igar	7015	0
2539	Daruszentmiklós	2423	0
2540	Kisapostag	2428	0
2541	Nagylók	2435	0
2542	Úrhida	8142	0
2543	Moha	8042	0
2544	Óbarok	2063	0
2545	Atkár	3213	0
2546	Átány	3371	0
2547	Bátor	3336	0
2548	Balaton	3347	0
2549	Bekölce	3343	0
2550	Mikekarácsonyfa	8949	0
2551	Zalamerenye	8747	0
2552	Zalasárszeg	8756	0
2553	Zalaszentbalázs	8772	0
2554	Kálmáncsa	7538	0
2555	Somogyvámos	8699	0
2556	Rábahídvég	9777	0
2557	Tekenye	8793	0
2558	Ecseg	3053	0
2559	Alsótold	3069	0
2560	Kozárd	3053	0
2561	Felsőtold	3067	0
2562	Garáb	3067	0
2563	Hollókő	3176	0
2564	Nagylóc	3175	0
2565	Magyarnándor	2694	0
2566	Cserháthaláp	2694	0
2567	Cserhátsurány	2676	0
2568	Szanda	2697	0
2569	Terény	2696	0
2570	Mohora	2698	0
2571	Csitár	2673	0
2572	Bérbaltavár	9831	0
2573	Kétbodony	2655	0
2574	Szente	2655	0
2575	Debercsény	2694	0
2576	Csehimindszent	9834	0
2577	Mikosszéplak	9835	0
2578	Csehi	9833	0
2579	Csipkerek	9836	0
2580	Kám	9841	0
2581	Felsőpetény	2611	0
2582	Varsány	3178	0
2583	Rimóc	3177	0
2584	Nógrádsipek	3179	0
2585	Ludányhalászi	3188	0
2586	Nógrádszakál	3187	0
2587	Litke	3186	0
2588	Keléd	9549	0
2589	Inárcs	2365	0
2590	Kakucs	2366	0
2591	Árpádhalom	6623	0
2592	Acsád	9746	0
2593	Vasasszonyfa	9744	0
2594	Salköveskút	9742	0
2595	Vasszilvágy	9747	0
2596	Csepreg	9735	0
2597	Kiszsidány	9733	0
2598	Gór	9625	0
2599	Meszlen	9745	0
2600	Pusztacsó	9739	0
2601	Kőszegpaty	9739	0
2602	Tömörd	9738	0
2603	Nemescsó	9739	0
2604	Csököly	7526	0
2605	Tiszanána	3385	0
2606	Sarud	3386	0
2607	Újlőrincfalva	3387	0
2608	Ólmod	9733	0
2609	Őrimagyarósd	9933	0
2610	Hegyhátszentjakab	9934	0
2611	Kemestaródfa	9923	0
2612	Magyarnádalja	9909	0
2613	Halastó	9814	0
2614	Nagymizdó	9913	0
2615	Szarvaskend	9913	0
2616	Magyarszecsőd	9912	0
2617	Telekes	9812	0
2618	Döbörhegy	9914	0
2619	Ivánc	9931	0
2620	Szaknyér	9934	0
2621	Szőce	9935	0
2622	Felsőmarác	9918	0
2623	Sárfimizdó	9813	0
2624	Kondorfa	9943	0
2625	Hegyhátszentmárton	9931	0
2626	Molnaszecsőd	9912	0
2627	Egyházashollós	9781	0
2628	Nemesrempehollós	9782	0
2629	Püspökmolnári	9776	0
2630	Dozmat	9791	0
2631	Bucsu	9792	0
2632	Bozsok	9727	0
2633	Velem	9726	0
2634	Kőszegszerdahely	9725	0
2635	Cák	9725	0
2636	Sorokpolány	9773	0
2637	Torony	9791	0
2638	Sé	9789	0
2639	Sorkikápolna	9774	0
2640	Gyanógeregye	9774	0
2641	Sorkifalud	9774	0
2642	Nemeskolta	9775	0
2643	Táplánszentkereszt	9761	0
2644	Tanakajd	9762	0
2645	Vasszécseny	9763	0
2646	Csempeszkopács	9764	0
2647	Vép	9751	0
2648	Bozzai	9752	0
2649	Nemesbőd	9749	0
2650	Vát	9748	0
2651	Kenéz	9752	0
2652	Perenye	9722	0
2653	Gyöngyösfalu	9723	0
2654	Kőszegdoroszló	9725	0
2655	Lukácsháza	9724	0
2656	Vassurány	9741	0
2657	Tormásliget	9736	0
2658	Lócs	9634	0
2659	Iklanberény	9634	0
2660	Alsóújlak	9842	0
2661	Rum	9766	0
2662	Meggyeskovácsi	9757	0
2663	Pecöl	9754	0
2664	Megyehíd	9754	0
2665	Szeleste	9622	0
2666	Ölbő	9621	0
2667	Pósfa	9636	0
2668	Répceszentgyörgy	9623	0
2669	Szemenye	9685	0
2670	Hosszúpereszteg	9676	0
2671	Nemeskeresztúr	9548	0
2672	Egervölgy	9684	0
2673	Káld	9673	0
2674	Gérce	9672	0
2675	Vashosszúfalu	9674	0
2676	Duka	9556	0
2677	Borgáta	9554	0
2678	Kamond	8469	0
2679	Nemesládony	9663	0
2680	Nagygeresd	9664	0
2681	Mersevát	9531	0
2682	Szergény	9523	0
2683	Törtel	2747	0
2684	Dabronc	8345	0
2685	Gógánfa	8346	0
2686	Ukk	8347	0
2687	Jászkarajenő	2746	0
2688	Zalaerdőd	8344	0
2689	Hetyefő	8344	0
2690	Lesencefalu	8318	0
2691	Nemesvita	8311	0
2692	Lesencetomaj	8318	0
2693	Hegymagas	8265	0
2694	Raposka	8300	0
2695	Csépa	5475	0
2696	Badacsonytördemic	8263	0
2697	Nemesgulács	8284	0
2698	Balatonhenye	8275	0
2699	Monoszló	8273	0
2700	Tagyon	8272	0
2701	Szentantalfa	8272	0
2702	Szentjakabfa	8272	0
2703	Balatoncsicsó	8272	0
2704	Óbudavár	8272	0
2705	Mencshely	8271	0
2706	Vöröstó	8291	0
2707	Barnag	8291	0
2708	Nemesvámos	8248	0
2709	Veszprémfajsz	8248	0
2710	Szentkirályszabadja	8225	0
2711	Zalahaláp	8308	0
2712	Csajág	8163	0
2713	Küngös	8162	0
2714	Tiszasas	5474	0
2715	Szelevény	5476	0
2716	Nagyrév	5463	0
2717	Tiszajenő	5094	0
2718	Tiszavárkony	5092	0
2719	Mezőhék	5453	0
2720	Vezseny	5093	0
2721	Rákócziújfalu	5084	0
2722	Mesterszállás	5452	0
2723	Kisunyom	9772	0
2724	Zsennye	9766	0
2725	Megyer	8348	0
2726	Zalameggyes	8348	0
2727	Zalaszegvár	8476	0
2728	Hosztót	8475	0
2729	Bodorfa	8471	0
2730	Kissomlyó	9555	0
2731	Kemenespálfa	9544	0
2732	Nagypirit	8496	0
2733	Külsővat	9532	0
2734	Kiscsősz	8494	0
2735	Somlójenő	8478	0
2736	Somlóvásárhely	8481	0
2737	Somlóvecse	8484	0
2738	Doba	8482	0
2739	Kispirit	8496	0
2740	Csögle	8495	0
2741	Adorjánháza	8497	0
2742	Nemesszalók	9533	0
2743	Kisszőlős	8483	0
2744	Dabrony	8485	0
2745	Nyárád	8512	0
2746	Borszörcsök	8479	0
2747	Oroszi	8458	0
2748	Pápasalamon	8594	0
2749	Marcalgergelyi	9534	0
2750	Vinár	9535	0
2751	Mihályháza	8513	0
2752	Pápadereske	8593	0
2753	Mezőlak	8514	0
2754	Békás	8515	0
2755	Pusztamiske	8455	0
2756	Kolontár	8468	0
2757	Úrkút	8409	0
2758	Litér	8196	0
2759	Ganna	8597	0
2760	Adásztevel	8561	0
2761	Nagytevel	8562	0
2762	Szentgál	8444	0
2763	Csehbánya	8445	0
2764	Farkasgyepű	8582	0
2765	Bánd	8443	0
2766	Homokbödöge	8563	0
2767	Borzavár	8428	0
2768	Porva	8429	0
2769	Bakonyoszlop	8418	0
2770	Sóly	8193	0
2771	Királyszentistván	8195	0
2772	Vilonya	8194	0
2773	Bakonynána	8422	0
2774	Tés	8109	0
2775	Jásd	8424	0
2776	Papkeszi	8183	0
2777	Nyáregyháza	2723	0
2778	Vasad	2211	0
2779	Csévharaszt	2212	0
2780	Bénye	2216	0
2781	Csemő	2713	0
2782	Tápiószentmárton	2711	0
2783	Tószeg	5091	0
2784	Rákóczifalva	5085	0
2785	Kengyel	5083	0
2786	Kétpó	5411	0
2787	Zagyvarékas	5051	0
2788	Tiszatenyő	5082	0
2789	Tiszapüspöki	5211	0
2790	Csataszög	5064	0
2791	Szászberek	5053	0
2792	Besenyszög	5071	0
2793	Hunyadfalva	5063	0
2794	Kuncsorba	5412	0
2795	Nagykörű	5065	0
2796	Örményes	5222	0
2797	Kőtelek	5062	0
2798	Tiszabő	5232	0
2799	Pilisszentiván	2084	0
2800	Simaság	9633	0
2801	Kemeneshőgyész	8516	0
2802	Nagyacsád	8521	0
2803	Magyargencs	8517	0
2804	Vanyola	8552	0
2805	Lovászpatona	8553	0
2806	Nagydém	8554	0
2807	Réde	2886	0
2808	Ácsteszér	2887	0
2809	Bakonybánk	2885	0
2810	Bársonyos	2883	0
2811	Bakonyszombathely	2884	0
2812	Kerékteleki	2882	0
2813	Ászár	2881	0
2814	Tárkány	2945	0
2815	Csép	2946	0
2816	Vaszar	8542	0
2817	Gecse	8543	0
2818	Súr	2889	0
2819	Csatka	2888	0
2820	Aka	2862	0
2821	Ete	2947	0
2822	Nagyigmánd	2942	0
2823	Kömlőd	2853	0
2824	Szákszend	2856	0
2825	Kocs	2898	0
2826	Kecskéd	2852	0
2827	Környe	2851	0
2828	Ecser	2233	0
2829	Mende	2235	0
2830	Gomba	2217	0
2831	Úri	2244	0
2832	Tápióság	2253	0
2833	Kóka	2243	0
2834	Dány	2118	0
2835	Zsámbok	2116	0
2836	Vácszentlászló	2115	0
2837	Hévízgyörk	2192	0
2838	Galgahévíz	2193	0
2839	Szentlőrinckáta	2255	0
2840	Jászfelsőszentgyörgy	5111	0
2841	Boldog	3016	0
2842	Pusztamonostor	5125	0
2843	Jászágó	5124	0
2844	Jászalsószentgyörgy	5054	0
2845	Jászladány	5055	0
2846	Alattyán	5142	0
2847	Jászkisér	5137	0
2848	Jásztelek	5141	0
2849	Visznek	3293	0
2850	Erk	3295	0
2851	Jászszentandrás	5136	0
2852	Jászivány	5135	0
2853	Pély	3381	0
2854	Tarnaszentmiklós	3382	0
2855	Hevesvezekény	3383	0
2856	Zaránk	3296	0
2857	Boconád	3368	0
2858	Tiszasüly	5061	0
2859	Tiszaroff	5234	0
2860	Tiszabura	5235	0
2861	Tiszagyenda	5233	0
2862	Kömlő	3372	0
2863	Tomajmonostora	5324	0
2864	Tiszaderzs	5243	0
2865	Tiszaszentimre	5322	0
2866	Tiszaörs	5362	0
2867	Naszály	2899	0
2868	Nagysáp	2524	0
2869	Bajót	2533	0
2870	Mogyorósbánya	2535	0
2871	Pári	7091	0
2872	Nőtincs	2610	0
2873	Ősagárd	2610	0
2874	Szécsénke	2692	0
2875	Kisecset	2655	0
2876	Kálló	2175	0
2877	Erdőkürt	2176	0
2878	Heréd	3011	0
2879	Erdőtarcsa	2177	0
2880	Nagykökényes	3012	0
2881	Palotás	3042	0
2882	Csány	3015	0
2883	Hort	3014	0
2884	Vanyarc	2688	0
2885	Bér	3045	0
2886	Szirák	3044	0
2887	Kisbágyon	3046	0
2888	Buják	3047	0
2889	Szarvasgede	3051	0
2890	Csécse	3052	0
2891	Gyöngyössolymos	3231	0
2892	Parádsasvár	3242	0
2893	Karácsond	3281	0
2894	Visonta	3271	0
2895	Nagyfüged	3282	0
2896	Tarnaméra	3284	0
2897	Tarnazsadány	3283	0
2898	Nagyút	3357	0
2899	Halmajugra	3273	0
2900	Ludas	3274	0
2901	Detk	3275	0
2902	Tarnabod	3369	0
2903	Kompolt	3356	0
2904	Kál	3350	0
2905	Egerfarmos	3379	0
2906	Parád	3240	0
2907	Kisnána	3264	0
2908	Tarnaszentmária	3331	0
2909	Sirok	3332	0
2910	Egerszólát	3328	0
2911	Demjén	3395	0
2912	Egerszalók	3394	0
2913	Novaj	3327	0
2914	Bököny	4231	0
2915	Geszteréd	4232	0
2916	Érpatak	4245	0
2917	Biri	4235	0
2918	Kálmánháza	4434	0
2919	Penészlek	4267	0
2920	Nyírgelse	4362	0
2921	Nyírbéltek	4372	0
2922	Encsencs	4374	0
2923	Ömböly	4373	0
2924	Piricse	4375	0
2925	Nyírpilis	4376	0
2926	Bátorliget	4343	0
2927	Terem	4342	0
2928	Vállaj	4351	0
2929	Kállósemjén	4324	0
2930	Pócspetri	4327	0
2931	Nyírvasvári	4341	0
2932	Nyírcsászári	4331	0
2933	Nyírkáta	4333	0
2934	Tiborszállás	4353	0
2935	Tereske	2652	0
2936	Pusztaberki	2658	0
2937	Csesztve	2678	0
2938	Herencsény	2677	0
2939	Cserhátszentiván	3066	0
2940	Kutasó	3066	0
2941	Iliny	2675	0
2942	Nógrádmegyer	3132	0
2943	Sóshartyán	3131	0
2944	Endrefalva	3165	0
2945	Piliny	3134	0
2946	Szécsényfelfalu	3135	0
2947	Magyargéc	3133	0
2948	Karancsság	3163	0
2949	Ságújfalu	3162	0
2950	Szalmatercs	3163	0
2951	Egyházasgerge	3185	0
2952	Mihálygerge	3184	0
2953	Mátraszőlős	3068	0
2954	Sámsonháza	3074	0
2955	Tar	3073	0
2956	Mátraverebély	3077	0
2957	Dorogháza	3153	0
2958	Szuha	3154	0
2959	Mátramindszent	3155	0
2960	Nagybárkány	3075	0
2961	Kisbárkány	3075	0
2962	Lucfalva	3129	0
2963	Márkháza	3075	0
2964	Nagykeresztúr	3129	0
2965	Vizslás	3128	0
2966	Kazár	3127	0
2967	Etes	3136	0
2968	Karancskeszi	3183	0
2969	Karancsalja	3181	0
2970	Karancslapujtő	3182	0
2971	Nemti	3152	0
2972	Mátraterenye	3145	0
2973	Mátraszele	3142	0
2974	Mátranovák	3143	0
2975	Bárna	3126	0
2976	Cered	3123	0
2977	Karancsberény	3137	0
2978	Bodony	3243	0
2979	Szilaspogony	3125	0
2980	Recsk	3245	0
2981	Mátraderecske	3246	0
2982	Szajla	3334	0
2983	Terpes	3334	0
2984	Egerbakta	3321	0
2985	Ivád	3248	0
2986	Erdőkövesd	3252	0
2987	Váraszó	3254	0
2988	Kisfüzes	3256	0
2989	Bükkszék	3335	0
2990	Fedémes	3255	0
2991	Tarnalelesz	3258	0
2992	Szentdomonkos	3259	0
2993	Istenmezeje	3253	0
2994	Zabar	3124	0
2995	Hevesaranyos	3322	0
2996	Egerbocs	3337	0
2997	Szúcs	3341	0
2998	Egercsehi	3341	0
2999	Mónosbél	3345	0
3000	Mikófalva	3344	0
3001	Bükkszentmárton	3346	0
3002	Felsőtárkány	3324	0
3003	Nagyvisnyó	3349	0
3004	Tiszadob	4456	0
3005	Tiszadada	4455	0
3006	Nagycserkesz	4445	0
3007	Tiszaeszlár	4464	0
3008	Tiszanagyfalu	4463	0
3009	Gávavencsellő	4471	0
3010	Tiszabercel	4474	0
3011	Paszab	4475	0
3012	Szabolcs	4467	0
3013	Balsa	4468	0
3014	Tiszatelek	4487	0
3015	Napkor	4552	0
3016	Nyírpazony	4531	0
3017	Nyírtura	4532	0
3018	Sényő	4533	0
3019	Nyírbogdány	4511	0
3020	Vasmegyer	4502	0
3021	Kék	4515	0
3022	Tiszarád	4503	0
3023	Beszterec	4488	0
3024	Apagy	4553	0
3025	Magy	4556	0
3026	Ófehértó	4558	0
3027	Levelek	4555	0
3028	Besenyőd	4557	0
3029	Nyírtét	4554	0
3030	Nyíribrony	4535	0
3031	Székely	4534	0
3032	Gégény	4517	0
3033	Nyírkércs	4537	0
3034	Ramocsaháza	4536	0
3035	Laskod	4543	0
3036	Nyírjákó	4541	0
3037	Petneháza	4542	0
3038	Berkesz	4521	0
3039	Nyírtass	4522	0
3040	Nyírkarász	4544	0
3041	Gyulaháza	4545	0
3042	Szabolcsbáka	4547	0
3043	Nyírderzs	4332	0
3044	Kántorjánosi	4335	0
3045	Hodász	4334	0
3046	Őr	4336	0
3047	Nyírmeggyes	4722	0
3048	Jármi	4337	0
3049	Papos	4338	0
3050	Vaja	4562	0
3051	Pusztadobos	4565	0
3052	Nyírparasznya	4822	0
3053	Ilk	4566	0
3054	Gemzse	4567	0
3055	Pátroha	4523	0
3056	Ajak	4524	0
3057	Anarcs	4546	0
3058	Rétközberencs	4525	0
3059	Pap	4631	0
3060	Szabolcsveresmart	4496	0
3061	Döge	4495	0
3062	Fényeslitke	4621	0
3063	Komoró	4622	0
3064	Nyírlövő	4632	0
3065	Lövőpetri	4633	0
3066	Tornyospálca	4642	0
3067	Győröcske	4625	0
3068	Annavölgy	2529	0
3069	Tolmács	2657	0
3070	Bokor	3066	0
3071	Rákóczibánya	3151	0
3072	Tákos	4845	0
3073	Kótaj	4482	0
3074	Újdombrád	4491	0
3075	Jéke	4611	0
3076	Darnó	4737	0
3077	Mátraszentimre	3235	0
3078	Pálosvörösmart	3261	0
3079	Kerekharaszt	3009	0
3080	Egeralja	8497	0
3081	Sáska	8308	0
3082	Hegyesd	8296	0
3083	Kisapáti	8284	0
3084	Ceglédbercel	2737	0
3085	Drávatamási	7979	0
3086	Sárszentmihály	8143	0
3087	Zalagyömörő	8349	0
3088	Városföld	6033	0
3089	Bakonyság	8557	0
3090	Ősi	8161	0
3091	Rigács	8348	0
3092	Uzsa	8321	0
3093	Gic	8435	0
3094	Nyársapát	2712	0
3095	Csénye	9611	0
3096	Chernelházadamonya	9624	0
3097	Rábatöttös	9766	0
3098	Mosonudvar	9246	0
3099	Ómassa	3517	0
3100	Márokföld	8976	0
3101	Vasalja	9921	0
3102	Kőröstetétlen	2745	0
3103	Abony	2740	0
3104	Nagytilaj	9832	0
3105	Zalaszentlőrinc	8921	0
3106	Zubogy	3723	0
3107	Püski	9235	0
3108	Regöly	7193	0
3109	Békéssámson	5946	0
3110	Becsehely	8866	0
3111	Tornakápolna	3761	0
3112	Kunfehértó	6413	0
3113	Tarnaörs	3294	0
3114	Gencsapáti	9721	0
3115	Szentpéterúr	8762	0
3116	Kübekháza	6755	0
3117	Kisigmánd	2948	0
3118	Kisújszállás	5310	0
3119	Szarvaskő	3323	0
3120	Péteri	2209	0
3121	Alacska	3779	0
3122	Dunaújváros	2400	0
3123	Monorierdő	2213	0
3124	Kéked	3899	0
3125	Máriahalom	2527	0
3126	Sárisáp	2523	0
3127	Úny	2528	0
3128	Döröske	9913	0
3129	Szombathely	9700	0
3130	Kurd	7226	0
3131	Söpte	9743	0
3132	Csokvaomány	3647	0
3133	Szolnok	5000	0
3134	Mánfa	7304	0
3135	Lesenceistvánd	8319	0
3136	Taliándörögd	8295	0
3137	Kapolcs	8294	0
3138	Szihalom	3377	0
3139	Tiszabezdéd	4624	0
3140	Dunaszentpál	9175	0
3141	Belegrád	0	0
3142	Galgamácsa	2183	0
3143	Mátraballa	3247	0
3144	Nagyszénás	5931	0
3145	Tunyogmatolcs	4731	0
3146	Csibrák	7225	0
3147	Maklár	3397	0
3148	Balatonszárszó	8624	0
3149	Nemesszentandrás	8925	0
3150	Tardona	3644	0
3151	Biharkeresztes	4110	0
3152	Téglás	4243	0
3153	Körmösdpuszta	4135	0
3154	Kecel	6237	0
3155	Zánka	8251	0
3156	Balogunyom	9771	0
3157	Kétújfalu	7975	0
3158	Selymes	0	0
3159	Kistiszahát	0	0
3160	Ozmánbük	8998	0
3161	Bakópuszta	2678	0
3162	Dobaipuszta	0	0
3163	Kocsér	2755	0
3164	Göbölyjárás	0	0
3165	Fischerbócsa	6235	0
3166	Ongaújfalu	0	0
3167	Kispáhi	0	0
3168	Kisvid	0	0
3169	Erdőszéplak	0	0
3170	Tölgyeszögtanya	0	0
3171	Tiszahát	0	0
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
8	Prémium egyenleg csomag	20 000 ft prémium egyenleg	PREMIUM-1	20000	balance	0	20000	t	2021-04-28 14:23:38.15174	t		
9	3 havi prémium csomag	3 havi prémium mester szolgáltatás csomag	PREMIUM-2	24990	time based subscription	2160	0	t	2021-04-28 14:23:38.152924	t		
7	12 havi alap csomag	12 havi mester szolgáltatás csomag	ALAP-3	29880	time based subscription	8760	0	t	2021-04-28 10:23:38.15	f		
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
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, email_verified, profile_pic, phone) FROM stdin;
2	Patrik Bajusz	bajusz.patrik@gmail.com	f	https://lh3.googleusercontent.com/a-/AOh14Giz6xvyfOUla8Sn3Q6P5eoT3zpKurB6Nns4ggY61Q	+36301741451
29	Akos Szelle	pelda@example.com	t	https://lh3.googleusercontent.com/a-/AOh14GiKPaS3VdFu8r9VvkXDRS7PhtMINf2wDdNetXfvyw	
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
61	78	Hornyák Balázs	+36204416868	rajeser880@onzmail.com		Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vel eros nec felis convallis sodales venenatis ut nibh....		10000		2021-01-19	f	f	99	0	f	hornyak-balazs-webfejleszto	104	t		123-456-78	t
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
8	8	Fekete Máté E.V.	+36123456789	pelda@example.com	Szolnok	Fekete Máté egészségügyi gázmester vagyok.  Ha meggyűlne a bajod a rágcsálókkal vagy a rovarokkal, akkor keress bizalommal!		0		2020-09-19	t	t	0	0	t	fekete-mate-e-v-rovarirtas-ragcsaloirtas	3133	t			t
56	1	Bajusz Máté ev.	+36309828187	bajszmate99@gmail.com		dasdasdl;kad;asdaskldl;asdklal;sd		0		2021-01-18	f	f	0	0	f	bajusz-mate-ev-acs	141	f			f
62	2	Angyal Ferenc	+36301741451	bajusz.patrik@gmail.com		SZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEGSZÖVEG 123 SZÖVEG11		0		2021-03-22	t	t	0	0	t	villanyszerelo-muszaki-ellenor	2311	t			t
51	72	Aszalos petike	+36306543221	asztipeti1215@gmail.com	Miskolc	Sziasziasziasziasziasziasziasziaaaa2		5000		2020-12-01	f	t	0	0	t	pothurszki-laszlo-ev-festo	104	f			f
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
41	56	Nincs aktív csomag	f	2022-05-05	4	f	2021-05-05	f	2021-05-05	5000	sub_JIMqgv9aiJw38D
46	61	Nincs aktív csomag	f	2022-05-22	3	t	2021-12-22	f	2021-11-22	0	
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

