--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5 (Debian 10.5-2.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: application_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.application_status AS ENUM (
    'Approve',
    'Decline',
    'Canceled'
);


ALTER TYPE public.application_status OWNER TO postgres;

--
-- Name: gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender AS ENUM (
    'M',
    'F'
);


ALTER TYPE public.gender OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: application; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    application_date date NOT NULL,
    product_id integer NOT NULL,
    appliaction_limit money NOT NULL,
    application_days integer NOT NULL,
    status public.application_status
);


ALTER TABLE public.application OWNER TO postgres;

--
-- Name: contract; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contract (
    application_id integer NOT NULL,
    contract_limit money NOT NULL,
    contract_date date,
    contract_finished_date date
);


ALTER TABLE public.contract OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    region_id integer NOT NULL,
    gender public.gender NOT NULL,
    birthdate date NOT NULL
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id integer NOT NULL,
    productname character varying(50) NOT NULL,
    max_limit money NOT NULL,
    max_days integer NOT NULL,
    percentage numeric(4,3) NOT NULL,
    penalty numeric(4,3) NOT NULL
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    id integer NOT NULL,
    region_name character varying(200) NOT NULL
);


ALTER TABLE public.region OWNER TO postgres;

--
-- Name: transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction (
    id integer NOT NULL,
    application_id integer NOT NULL,
    operation_date date NOT NULL,
    amount money NOT NULL,
    direction integer NOT NULL,
    payment_fv money NOT NULL,
    payment_iv money NOT NULL,
    payment_pv money NOT NULL
);


ALTER TABLE public.transaction OWNER TO postgres;

--
-- Data for Name: application; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application (id, customer_id, application_date, product_id, appliaction_limit, application_days, status) FROM stdin;
1	1	2017-01-01	1	$8,000.00	30	Decline
2	2	2017-01-01	1	$5,000.00	5	Canceled
3	3	2017-01-02	1	$8,000.00	20	Approve
4	4	2017-02-01	2	$15,000.00	20	Approve
5	5	2017-02-15	1	$8,000.00	24	Decline
6	6	2017-02-23	1	$6,000.00	14	Approve
7	7	2017-03-02	1	$6,000.00	20	Decline
8	7	2017-03-02	8	$3,000.00	5	Approve
9	8	2017-03-05	1	$8,000.00	20	Decline
10	9	2017-03-10	1	$3,000.00	5	Approve
11	10	2017-03-20	1	$6,000.00	30	Decline
12	11	2017-03-25	1	$8,000.00	30	Decline
13	6	2017-04-01	3	$10,000.00	7	Approve
14	12	2017-04-01	1	$8,000.00	30	Decline
15	12	2017-04-01	8	$3,000.00	5	Approve
16	13	2017-04-05	1	$8,000.00	7	Approve
17	14	2017-04-10	1	$5,000.00	10	Decline
18	15	2017-04-20	1	$7,000.00	30	Approve
19	16	2017-04-25	1	$5,000.00	20	Approve
20	17	2017-05-01	1	$7,000.00	14	Decline
21	18	2017-05-09	1	$8,000.00	17	Decline
22	19	2017-05-11	1	$7,000.00	25	Decline
23	6	2017-05-14	4	$12,000.00	12	Approve
24	20	2017-05-21	1	$8,000.00	22	Approve
25	3	2017-06-01	3	$12,000.00	25	Approve
26	15	2017-06-01	3	$11,000.00	30	Approve
27	21	2017-06-01	1	$8,000.00	30	Decline
28	22	2017-06-10	1	$5,000.00	20	Decline
29	23	2017-06-13	1	$6,000.00	25	Decline
30	6	2017-06-18	5	$18,000.00	20	Approve
31	24	2017-06-22	1	$7,000.00	20	Decline
32	25	2017-06-27	1	$8,000.00	30	Approve
33	16	2017-07-02	6	$30,000.00	180	Canceled
34	26	2017-07-07	1	$8,000.00	8	Approve
35	27	2017-08-01	1	$8,000.00	20	Decline
36	15	2017-08-02	3	$10,000.00	30	Approve
37	26	2017-08-05	3	$12,000.00	18	Canceled
38	13	2017-08-06	3	$12,000.00	16	Decline
39	25	2017-09-01	3	$12,000.00	30	Approve
40	28	2017-09-01	1	$7,000.00	25	Decline
41	3	2017-09-09	4	$15,000.00	15	Approve
42	29	2017-09-15	1	$7,000.00	24	Approve
43	6	2017-09-17	5	$20,000.00	30	Approve
44	6	2017-10-22	5	$20,000.00	30	Approve
45	30	2017-10-30	1	$8,000.00	20	Canceled
46	25	2017-11-02	4	$15,000.00	16	Approve
47	29	2017-11-03	3	$12,000.00	28	Approve
48	6	2017-11-23	7	$50,000.00	180	Canceled
\.


--
-- Data for Name: contract; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contract (application_id, contract_limit, contract_date, contract_finished_date) FROM stdin;
3	$8,000.00	2017-01-07	2017-01-25
4	$12,000.00	2017-02-04	2017-02-21
6	$6,000.00	2017-02-23	\N
8	$3,000.00	2017-03-03	2017-03-08
10	$3,000.00	2017-03-12	2017-03-23
13	$8,000.00	2017-04-06	2017-05-02
15	$3,000.00	2017-04-02	\N
16	$8,000.00	2017-04-06	2017-04-14
18	$7,000.00	2017-04-20	\N
19	$5,000.00	2017-04-30	2017-05-20
23	$12,000.00	2017-05-19	2017-05-31
24	$8,000.00	2017-05-23	\N
25	$12,000.00	2017-06-05	2017-06-25
26	$10,000.00	2017-06-02	2017-07-08
30	$18,000.00	2017-06-18	2017-07-20
32	$8,000.00	2017-06-30	\N
34	$8,000.00	2017-07-07	\N
36	$10,000.00	2017-08-03	2017-08-31
39	$12,000.00	2017-09-02	\N
41	$15,000.00	2017-09-11	2017-09-26
42	$7,000.00	2017-09-17	2017-10-29
43	$20,000.00	2017-09-19	2017-11-03
44	$20,000.00	2017-10-27	\N
46	$11,000.00	2017-11-06	2017-12-12
47	$12,000.00	2017-11-05	\N
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, name, region_id, gender, birthdate) FROM stdin;
1	Иванов	1	M	1987-01-12
2	Петров	1	M	1976-08-15
3	Сидоров	2	M	1972-04-04
4	Кошкин	5	M	1972-12-25
5	Мышкин	7	M	1970-08-07
6	Васин	3	M	1985-07-11
7	Коржиков	8	M	1988-07-14
8	Успенская	7	F	1988-05-26
9	Петрова	3	F	1991-09-11
10	Гаврилова	4	F	1978-03-22
11	Самарская	6	F	1972-08-23
12	Рабинович	4	F	1999-01-01
13	Бенюмович	2	F	1983-05-09
14	Бобчинскиий	8	M	1978-08-25
15	Добчинский	5	M	1990-01-04
16	Чацкий	5	M	1974-06-18
17	Фамусов	3	M	1972-08-20
18	Антонова	7	F	1973-02-15
19	Красновская	6	F	1971-10-27
20	Глебова	8	F	1978-07-07
21	Калмыкова	9	F	1986-11-09
22	Кирсанов	10	F	1966-01-19
23	Петренко	6	M	1956-02-21
24	Сумская	8	F	1977-09-01
25	Поддубная	3	F	1981-09-13
26	Семенов	2	M	1982-04-10
27	Шишкин	5	M	1966-07-30
28	Родионов	4	M	1997-06-17
29	Соколов	7	M	1967-08-22
30	Чернышов	3	M	1993-11-17
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, productname, max_limit, max_days, percentage, penalty) FROM stdin;
1	Базовый продукт	$8,000.00	30	7.300	0.200
2	Акция	$15,000.00	30	1.830	0.000
3	Повторный продукт	$12,000.00	30	7.300	0.200
4	Премиальный продукт	$15,000.00	30	6.900	0.200
5	Спецпредложение	$20,000.00	30	3.650	0.000
6	VIP	$30,000.00	180	0.500	0.000
7	Бонус	$50,000.00	180	0.500	0.000
8	Контрпредложение	$3,000.00	30	7.300	0.200
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region (id, region_name) FROM stdin;
1	Москва
2	Санкт-Петербург
3	Московская область
4	Краснодарский край
5	Свердловская область
6	Приморский край
7	Ульяновская область
8	Ленинградская область
9	Тамбовская область
10	Тульская область
\.


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaction (id, application_id, operation_date, amount, direction, payment_fv, payment_iv, payment_pv) FROM stdin;
1	3	2017-01-07	$8,000.00	-1	-$8,000.00	$0.00	$0.00
2	3	2017-01-25	$10,880.00	1	$8,000.00	$2,880.00	$0.00
3	4	2017-02-04	$12,000.00	-1	-$12,000.00	$0.00	$0.00
4	4	2017-02-21	$13,100.00	1	$12,000.00	$1,022.80	$0.00
5	6	2017-02-23	$6,000.00	-1	-$6,000.00	$0.00	$0.00
6	8	2017-03-03	$3,000.00	-1	-$3,000.00	$0.00	$0.00
7	8	2017-03-08	$3,300.00	1	$3,000.00	$300.00	$0.00
8	10	2017-03-12	$3,000.00	-1	-$3,000.00	$0.00	$0.00
9	10	2017-03-23	$3,700.00	1	$3,000.00	$660.00	$9.87
10	15	2017-04-02	$3,000.00	-1	-$3,000.00	$0.00	$0.00
11	13	2017-04-06	$8,000.00	-1	-$8,000.00	$0.00	$0.00
12	16	2017-04-06	$8,000.00	-1	-$8,000.00	$0.00	$0.00
13	16	2017-04-14	$9,300.00	1	$8,000.00	$1,280.00	$4.39
14	18	2017-04-20	$7,000.00	-1	-$7,000.00	$0.00	$0.00
15	19	2017-04-30	$5,000.00	-1	-$5,000.00	$0.00	$0.00
16	13	2017-05-02	$12,300.00	1	$8,000.00	$4,160.00	$83.29
17	23	2017-05-19	$12,000.00	-1	-$12,000.00	$0.00	$0.00
18	19	2017-05-20	$7,000.00	1	$5,000.00	$2,000.00	$0.00
19	24	2017-05-23	$8,000.00	-1	-$8,000.00	$0.00	$0.00
20	23	2017-05-31	$14,800.00	1	$12,000.00	$2,722.20	$0.00
21	26	2017-06-02	$10,000.00	-1	-$10,000.00	$0.00	$0.00
22	25	2017-06-05	$12,000.00	-1	-$12,000.00	$0.00	$0.00
23	30	2017-06-18	$18,000.00	-1	-$18,000.00	$0.00	$0.00
24	25	2017-06-25	$16,800.00	1	$12,000.00	$4,800.00	$0.00
25	32	2017-06-30	$8,000.00	-1	-$8,000.00	$0.00	$0.00
26	34	2017-07-07	$8,000.00	-1	-$8,000.00	$0.00	$0.00
27	26	2017-07-08	$17,300.00	1	$10,000.00	$7,200.00	$32.88
28	30	2017-07-20	$23,900.00	1	$18,000.00	$5,760.00	$118.36
29	36	2017-08-03	$10,000.00	-1	-$10,000.00	$0.00	$0.00
30	36	2017-08-31	$15,600.00	1	$10,000.00	$5,600.00	$0.00
31	39	2017-09-02	$12,000.00	-1	-$12,000.00	$0.00	$0.00
32	41	2017-09-11	$15,000.00	-1	-$15,000.00	$0.00	$0.00
33	42	2017-09-17	$7,000.00	-1	-$7,000.00	$0.00	$0.00
34	43	2017-09-19	$20,000.00	-1	-$20,000.00	$0.00	$0.00
35	41	2017-09-26	$19,300.00	1	$15,000.00	$4,253.43	$0.00
36	44	2017-10-27	$20,000.00	-1	-$20,000.00	$0.00	$0.00
37	42	2017-10-29	$13,000.00	1	$7,000.00	$5,880.00	$69.05
38	43	2017-11-03	$29,200.00	1	$20,000.00	$9,000.00	$164.39
39	47	2017-11-05	$12,000.00	-1	-$12,000.00	$0.00	$0.00
40	46	2017-11-06	$11,000.00	-1	-$11,000.00	$0.00	$0.00
41	46	2017-12-12	$18,700.00	1	$11,000.00	$7,486.03	$120.55
\.


--
-- Name: application application_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_pkey PRIMARY KEY (id);


--
-- Name: contract contract_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (application_id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);


--
-- Name: application application_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: application application_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


--
-- Name: contract contract_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.application(id);


--
-- Name: customer customer_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.region(id);


--
-- Name: transaction transaction_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.contract(application_id);


--
-- PostgreSQL database dump complete
--

