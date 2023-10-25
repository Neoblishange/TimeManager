--
-- PostgreSQL database dump
--

-- Dumped from database version 12.16 (Ubuntu 12.16-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.16 (Ubuntu 12.16-0ubuntu0.20.04.1)

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
-- Name: clocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clocks (
    id uuid NOT NULL,
    "time" timestamp(0) without time zone,
    status boolean DEFAULT false NOT NULL,
    "user" uuid,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    username character varying(255),
    email character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: workingtimes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workingtimes (
    id uuid NOT NULL,
    start timestamp(0) without time zone,
    "end" timestamp(0) without time zone,
    "user" uuid,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: clocks clocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clocks
    ADD CONSTRAINT clocks_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workingtimes workingtimes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workingtimes
    ADD CONSTRAINT workingtimes_pkey PRIMARY KEY (id);


--
-- Name: clocks_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX clocks_user_index ON public.clocks USING btree ("user");


--
-- Name: workingtimes_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workingtimes_user_index ON public.workingtimes USING btree ("user");


--
-- Name: clocks clocks_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clocks
    ADD CONSTRAINT clocks_user_fkey FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- Name: workingtimes workingtimes_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workingtimes
    ADD CONSTRAINT workingtimes_user_fkey FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20231023150546);
INSERT INTO public."schema_migrations" (version) VALUES (20231023164035);
INSERT INTO public."schema_migrations" (version) VALUES (20231023164757);
