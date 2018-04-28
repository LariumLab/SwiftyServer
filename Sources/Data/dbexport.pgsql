--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3
-- Dumped by pg_dump version 10.3

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: appointment; Type: TABLE; Schema: public; Owner: glebvasyutin
--

CREATE TABLE public.appointment (
    salonid uuid NOT NULL,
    serviceid uuid NOT NULL,
    masterid uuid NOT NULL,
    clientid uuid NOT NULL,
    approved boolean NOT NULL,
    date timestamp with time zone NOT NULL
);


ALTER TABLE public.appointment OWNER TO glebvasyutin;

--
-- Name: client; Type: TABLE; Schema: public; Owner: glebvasyutin
--

CREATE TABLE public.client (
    clientid uuid NOT NULL,
    login text NOT NULL,
    token text NOT NULL,
    phonenumber text NOT NULL
);


ALTER TABLE public.client OWNER TO glebvasyutin;

--
-- Name: master; Type: TABLE; Schema: public; Owner: glebvasyutin
--

CREATE TABLE public.master (
    salonid uuid NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.master OWNER TO glebvasyutin;

--
-- Name: salon; Type: TABLE; Schema: public; Owner: glebvasyutin
--

CREATE TABLE public.salon (
    salonid uuid NOT NULL,
    nickname text NOT NULL,
    customname text NOT NULL,
    phonenumber text NOT NULL,
    description text NOT NULL,
    city text NOT NULL,
    address text NOT NULL,
    token text NOT NULL
);


ALTER TABLE public.salon OWNER TO glebvasyutin;

--
-- Name: service; Type: TABLE; Schema: public; Owner: glebvasyutin
--

CREATE TABLE public.service (
    salonid uuid NOT NULL,
    serviceid uuid NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    pricefrom text,
    priceto text NOT NULL
);


ALTER TABLE public.service OWNER TO glebvasyutin;

--
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: glebvasyutin
--

COPY public.appointment (salonid, serviceid, masterid, clientid, approved, date) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: glebvasyutin
--

COPY public.client (clientid, login, token, phonenumber) FROM stdin;
\.


--
-- Data for Name: master; Type: TABLE DATA; Schema: public; Owner: glebvasyutin
--

COPY public.master (salonid, name) FROM stdin;
\.


--
-- Data for Name: salon; Type: TABLE DATA; Schema: public; Owner: glebvasyutin
--

COPY public.salon (salonid, nickname, customname, phonenumber, description, city, address, token) FROM stdin;
4ad6b313-3026-43f8-99df-b969cdc1d95d	qwerty	Tatoo by Gleb	79104452059	The best choice	Moscow	Kremlin	5411aa4b553a4fd6331dbe9bb7f5abc6
5887a1ec-5977-415e-bff4-cf6e68e4e946	beautyworld	My dream salon	79105678968	Best prices	Los Angeles	Second road, 3	f613755c82c91c5bb0a81d923a948379
c69fbe76-ee7d-4832-8c60-28b4bb609f40	beautyfactory	Фабрика красоты	79101234441	Самые интересные предложения	Москва	Кутузовский, 12	da97ca6a2563cb9e30d69182896b2cf9
03b41ba6-8df4-45e8-8c85-975b82d62083	hairmaster	ilovetatoo	79161234657	Лучшие тату только у нас	Москва	Кастанаевская, 12	1da9f7a1ef5551fec6b23764b0db875c
95e51534-d8d6-41c9-856d-e63faec9aa16	nicenails	nails4ever	79165672343	Красим ногти	Самара	Ленина, 12	5eb094cd723d395b7b30d50739c1d6ae
\.


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: glebvasyutin
--

COPY public.service (salonid, serviceid, name, description, pricefrom, priceto) FROM stdin;
\.


--
-- Name: index_salonid; Type: INDEX; Schema: public; Owner: glebvasyutin
--

CREATE INDEX index_salonid ON public.service USING btree (salonid);


--
-- PostgreSQL database dump complete
--

