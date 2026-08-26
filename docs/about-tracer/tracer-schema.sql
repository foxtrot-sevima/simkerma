-- public.action_logs definition

-- Drop table

-- DROP TABLE public.action_logs;

CREATE TABLE public.action_logs (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	parent_id uuid NULL,
	"action" varchar(255) NOT NULL,
	payload jsonb NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT action_logs_pkey PRIMARY KEY (id)
);
CREATE INDEX action_logs_action_index ON public.action_logs USING btree (action);
CREATE INDEX action_logs_parent_id_index ON public.action_logs USING btree (parent_id);
CREATE INDEX action_logs_user_id_index ON public.action_logs USING btree (user_id);


-- public.cities definition

-- Drop table

-- DROP TABLE public.cities;

CREATE TABLE public.cities (
	id bigserial NOT NULL,
	province_code int4 NOT NULL,
	code int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT cities_pkey PRIMARY KEY (id)
);


-- public.debug_logs definition

-- Drop table

-- DROP TABLE public.debug_logs;

CREATE TABLE public.debug_logs (
	id bigserial NOT NULL,
	"action" varchar(255) NOT NULL,
	response json NULL,
	url varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT debug_logs_pkey PRIMARY KEY (id)
);


-- public.migrations definition

-- Drop table

-- DROP TABLE public.migrations;

CREATE TABLE public.migrations (
	id serial4 NOT NULL,
	migration varchar(255) NOT NULL,
	batch int4 NOT NULL,
	CONSTRAINT migrations_pkey PRIMARY KEY (id)
);


-- public.provinces definition

-- Drop table

-- DROP TABLE public.provinces;

CREATE TABLE public.provinces (
	id bigserial NOT NULL,
	code int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT provinces_pkey PRIMARY KEY (id)
);


-- public.quest_answer_types definition

-- Drop table

-- DROP TABLE public.quest_answer_types;

CREATE TABLE public.quest_answer_types (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT quest_answer_types_pkey PRIMARY KEY (id)
);


-- public.quest_publications definition

-- Drop table

-- DROP TABLE public.quest_publications;

CREATE TABLE public.quest_publications (
	id uuid NOT NULL,
	owner_type_id varchar(255) NOT NULL,
	owner_id uuid NOT NULL,
	"name" varchar(255) NULL,
	file varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	"domain" varchar(255) NULL,
	CONSTRAINT quest_publications_owner_type_id_check CHECK (((owner_type_id)::text = '3'::text)),
	CONSTRAINT quest_publications_pkey PRIMARY KEY (id)
);


-- public.quest_statuses definition

-- Drop table

-- DROP TABLE public.quest_statuses;

CREATE TABLE public.quest_statuses (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT quest_statuses_pkey PRIMARY KEY (id)
);


-- public.study_levels definition

-- Drop table

-- DROP TABLE public.study_levels;

CREATE TABLE public.study_levels (
	id bigserial NOT NULL,
	university_id uuid NULL,
	code varchar(255) NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT study_levels_pkey PRIMARY KEY (id)
);
CREATE INDEX study_levels_code_index ON public.study_levels USING btree (code);


-- public.ump definition

-- Drop table

-- DROP TABLE public.ump;

CREATE TABLE public.ump (
	id bigserial NOT NULL,
	"year" int4 NOT NULL,
	code varchar(255) NOT NULL,
	"name" varchar(255) NOT NULL,
	price int4 NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT ump_pkey PRIMARY KEY (id)
);


-- public.universities definition

-- Drop table

-- DROP TABLE public.universities;

CREATE TABLE public.universities (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	university_id uuid NOT NULL,
	dikticode varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT universities_pkey PRIMARY KEY (id)
);
CREATE INDEX universities_dikticode_index ON public.universities USING btree (dikticode);
CREATE INDEX universities_university_id_index ON public.universities USING btree (university_id);


-- public.quest_masters definition

-- Drop table

-- DROP TABLE public.quest_masters;

CREATE TABLE public.quest_masters (
	id uuid NOT NULL,
	owner_type_id varchar(255) NOT NULL,
	owner_id uuid NOT NULL,
	"name" varchar(255) NULL,
	formula varchar(255) NULL,
	is_published bool NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	period_id int4 NULL,
	firebase_dynamic_link varchar(255) NULL,
	open_to_all bool DEFAULT false NOT NULL,
	active bool DEFAULT true NOT NULL,
	status_id int8 DEFAULT '1'::bigint NOT NULL,
	"year" json NULL,
	program_study json NULL,
	total_graduate int4 NULL,
	"group" bool DEFAULT false NOT NULL,
	started_at timestamp(0) NULL,
	ended_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	hide_landing bool DEFAULT false NOT NULL,
	CONSTRAINT quest_masters_owner_type_id_check CHECK (((owner_type_id)::text = ANY (ARRAY[('1'::character varying)::text, ('2'::character varying)::text, ('3'::character varying)::text]))),
	CONSTRAINT quest_masters_pkey PRIMARY KEY (id),
	CONSTRAINT quest_masters_status_id_foreign FOREIGN KEY (status_id) REFERENCES public.quest_statuses(id) ON DELETE RESTRICT
);
CREATE INDEX quest_masters_formula_index ON public.quest_masters USING btree (formula);
CREATE INDEX quest_masters_name_index ON public.quest_masters USING btree (name);
CREATE INDEX quest_masters_owner_id_index ON public.quest_masters USING btree (owner_id);
CREATE INDEX quest_masters_period_id_index ON public.quest_masters USING btree (period_id);
CREATE INDEX quest_masters_status_id_index ON public.quest_masters USING btree (status_id);


-- public.quest_sections definition

-- Drop table

-- DROP TABLE public.quest_sections;

CREATE TABLE public.quest_sections (
	id bigserial NOT NULL,
	master_id uuid NOT NULL,
	"number" varchar(3) NOT NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	jump_to varchar(255) DEFAULT ''::character varying NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT quest_sections_pkey PRIMARY KEY (id),
	CONSTRAINT quest_sections_master_id_foreign FOREIGN KEY (master_id) REFERENCES public.quest_masters(id) ON DELETE RESTRICT
);
CREATE INDEX quest_sections_master_id_index ON public.quest_sections USING btree (master_id);


-- public.study_programs definition

-- Drop table

-- DROP TABLE public.study_programs;

CREATE TABLE public.study_programs (
	id bigserial NOT NULL,
	study_level_id int8 NOT NULL,
	university_id uuid NULL,
	code varchar(255) NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	status varchar(1) DEFAULT '1'::character varying NOT NULL,
	last_update_by varchar(255) NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT study_programs_pkey PRIMARY KEY (id),
	CONSTRAINT study_programs_study_level_id_foreign FOREIGN KEY (study_level_id) REFERENCES public.study_levels(id) ON DELETE RESTRICT
);
CREATE INDEX study_programs_code_index ON public.study_programs USING btree (code);
CREATE INDEX study_programs_last_update_by_index ON public.study_programs USING btree (last_update_by);
CREATE INDEX study_programs_status_index ON public.study_programs USING btree (status);
CREATE INDEX study_programs_university_id_index ON public.study_programs USING btree (university_id);


-- public.graduates definition

-- Drop table

-- DROP TABLE public.graduates;

CREATE TABLE public.graduates (
	id bigserial NOT NULL,
	study_program_id int8 NOT NULL,
	university_id uuid NULL,
	nim varchar(50) NOT NULL,
	"name" varchar(60) NOT NULL,
	entry_year int2 NULL,
	graduation_date date NOT NULL,
	gpa_passed float8 NULL,
	nik varchar(255) NULL,
	npwp varchar(50) NULL,
	email varchar(255) NULL,
	no_hp varchar(255) NULL,
	birthday date NULL,
	birthplace varchar(255) NULL,
	address text NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	graduate_year int2 DEFAULT '0'::smallint NOT NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT graduates_pkey PRIMARY KEY (id),
	CONSTRAINT graduates_study_program_id_foreign FOREIGN KEY (study_program_id) REFERENCES public.study_programs(id) ON DELETE RESTRICT
);
CREATE INDEX graduates_email_index ON public.graduates USING btree (email);
CREATE INDEX graduates_graduate_year_index ON public.graduates USING btree (graduate_year);
CREATE INDEX graduates_graduation_date_index ON public.graduates USING btree (graduation_date);
CREATE INDEX graduates_nim_index ON public.graduates USING btree (nim);
CREATE INDEX graduates_university_id_index ON public.graduates USING btree (university_id);


-- public.participants definition

-- Drop table

-- DROP TABLE public.participants;

CREATE TABLE public.participants (
	id bigserial NOT NULL,
	master_id uuid NOT NULL,
	owner_id uuid NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	nim varchar(255) NULL,
	kode_pt varchar(255) NULL,
	tahun_lulus varchar(255) NULL,
	kode_prodi varchar(255) NULL,
	"name" varchar(255) NULL,
	phone varchar(255) NULL,
	email varchar(255) NULL,
	nik varchar(255) NULL,
	npwp varchar(255) NULL,
	status varchar(255) NULL,
	deleted_at timestamp(0) NULL,
	latitude varchar(255) NULL,
	longitude varchar(255) NULL,
	CONSTRAINT participants_pkey PRIMARY KEY (id),
	CONSTRAINT participants_master_id_foreign FOREIGN KEY (master_id) REFERENCES public.quest_masters(id) ON DELETE RESTRICT
);
CREATE INDEX participants_kode_prodi_index ON public.participants USING btree (kode_prodi);
CREATE INDEX participants_kode_pt_index ON public.participants USING btree (kode_pt);
CREATE INDEX participants_master_id_index ON public.participants USING btree (master_id);
CREATE INDEX participants_name_index ON public.participants USING btree (name);
CREATE INDEX participants_nim_index ON public.participants USING btree (nim);
CREATE INDEX participants_owner_id_index ON public.participants USING btree (owner_id);


-- public.quest_master_groups definition

-- Drop table

-- DROP TABLE public.quest_master_groups;

CREATE TABLE public.quest_master_groups (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	owner_id uuid NOT NULL,
	quest_master_id_1 uuid NOT NULL,
	quest_master_id_2 uuid NOT NULL,
	status_id varchar(255) NULL,
	active bool DEFAULT true NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT quest_master_groups_pkey PRIMARY KEY (id),
	CONSTRAINT quest_master_groups_quest_master_id_1_foreign FOREIGN KEY (quest_master_id_1) REFERENCES public.quest_masters(id) ON DELETE RESTRICT,
	CONSTRAINT quest_master_groups_quest_master_id_2_foreign FOREIGN KEY (quest_master_id_2) REFERENCES public.quest_masters(id) ON DELETE RESTRICT
);


-- public.quest_questions definition

-- Drop table

-- DROP TABLE public.quest_questions;

CREATE TABLE public.quest_questions (
	id bigserial NOT NULL,
	section_id int8 NOT NULL,
	answer_type_id int8 NOT NULL,
	"number" varchar(5) NOT NULL,
	"content" text NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	description text NULL,
	is_other bool NULL,
	is_required bool NULL,
	code varchar(255) NULL,
	is_other_code varchar(255) NULL,
	is_other_value varchar(255) NULL,
	is_other_dikti_code varchar(255) NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT quest_questions_pkey PRIMARY KEY (id),
	CONSTRAINT quest_questions_answer_type_id_foreign FOREIGN KEY (answer_type_id) REFERENCES public.quest_answer_types(id) ON DELETE RESTRICT,
	CONSTRAINT quest_questions_section_id_foreign FOREIGN KEY (section_id) REFERENCES public.quest_sections(id) ON DELETE CASCADE
);
CREATE INDEX quest_questions_answer_type_id_index ON public.quest_questions USING btree (answer_type_id);
CREATE INDEX quest_questions_code_index ON public.quest_questions USING btree (code);
CREATE INDEX quest_questions_section_id_index ON public.quest_questions USING btree (section_id);


-- public.quest_sub_questions definition

-- Drop table

-- DROP TABLE public.quest_sub_questions;

CREATE TABLE public.quest_sub_questions (
	id bigserial NOT NULL,
	question_id int8 NOT NULL,
	"content" text NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	code varchar(255) NULL,
	value varchar(255) NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT quest_sub_questions_pkey PRIMARY KEY (id),
	CONSTRAINT quest_sub_questions_question_id_foreign FOREIGN KEY (question_id) REFERENCES public.quest_questions(id) ON DELETE CASCADE
);
CREATE INDEX quest_sub_questions_code_index ON public.quest_sub_questions USING btree (code);
CREATE INDEX quest_sub_questions_question_id_index ON public.quest_sub_questions USING btree (question_id);


-- public.participant_answers definition

-- Drop table

-- DROP TABLE public.participant_answers;

CREATE TABLE public.participant_answers (
	id bigserial NOT NULL,
	participant_id int8 NOT NULL,
	question_id int8 NOT NULL,
	subquestion_id int4 NULL,
	answer_question_id int4 NULL,
	"content" text NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT participant_answers_pkey PRIMARY KEY (id),
	CONSTRAINT participant_answers_participant_id_foreign FOREIGN KEY (participant_id) REFERENCES public.participants(id) ON DELETE RESTRICT,
	CONSTRAINT participant_answers_question_id_foreign FOREIGN KEY (question_id) REFERENCES public.quest_questions(id) ON DELETE RESTRICT
);
CREATE INDEX participant_answers_answer_question_id_index ON public.participant_answers USING btree (answer_question_id);
CREATE INDEX participant_answers_participant_id_index ON public.participant_answers USING btree (participant_id);
CREATE INDEX participant_answers_question_id_index ON public.participant_answers USING btree (question_id);
CREATE INDEX participant_answers_subquestion_id_index ON public.participant_answers USING btree (subquestion_id);


-- public.quest_answer_questions definition

-- Drop table

-- DROP TABLE public.quest_answer_questions;

CREATE TABLE public.quest_answer_questions (
	id bigserial NOT NULL,
	question_id int8 NOT NULL,
	"content" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	jump_to varchar(255) NULL,
	code varchar(255) NULL,
	value varchar(255) NULL,
	parent varchar(255) NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT quest_answer_questions_pkey PRIMARY KEY (id),
	CONSTRAINT quest_answer_questions_question_id_foreign FOREIGN KEY (question_id) REFERENCES public.quest_questions(id) ON DELETE CASCADE
);
CREATE INDEX quest_answer_questions_code_index ON public.quest_answer_questions USING btree (code);
CREATE INDEX quest_answer_questions_question_id_index ON public.quest_answer_questions USING btree (question_id);