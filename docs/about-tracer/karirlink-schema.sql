-- public.applicant_notes_old definition

-- Drop table

-- DROP TABLE public.applicant_notes_old;

CREATE TABLE public.applicant_notes_old (
	id int8 DEFAULT nextval('applicant_notes_id_seq'::regclass) NOT NULL,
	applicant_id uuid NOT NULL,
	recruiter_id uuid NOT NULL,
	post_id uuid NOT NULL,
	stage bpchar(1) NOT NULL,
	note text NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT applicant_notes_pkey PRIMARY KEY (id)
);
CREATE INDEX applicant_note_apply_on_post ON public.applicant_notes_old USING btree (post_id);
CREATE INDEX applicant_note_by_recruiter ON public.applicant_notes_old USING btree (recruiter_id);
CREATE INDEX applicant_note_for_applicant ON public.applicant_notes_old USING btree (applicant_id);
CREATE INDEX applicant_note_stage ON public.applicant_notes_old USING btree (stage);


-- public.article_categories definition

-- Drop table

-- DROP TABLE public.article_categories;

CREATE TABLE public.article_categories (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	parent_id int8 NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	slug varchar(255) NULL,
	CONSTRAINT article_categories_pkey PRIMARY KEY (id),
	CONSTRAINT article_categories_slug_unique UNIQUE (slug)
);


-- public.article_tag definition

-- Drop table

-- DROP TABLE public.article_tag;

CREATE TABLE public.article_tag (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT article_tag_name_unique UNIQUE (name),
	CONSTRAINT article_tag_pkey PRIMARY KEY (id)
);


-- public.benefits definition

-- Drop table

-- DROP TABLE public.benefits;

CREATE TABLE public.benefits (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	slug varchar(255) NOT NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT benefits_pkey PRIMARY KEY (id),
	CONSTRAINT benefits_slug_unique UNIQUE (slug)
);


-- public.cache_keys definition

-- Drop table

-- DROP TABLE public.cache_keys;

CREATE TABLE public.cache_keys (
	id bigserial NOT NULL,
	"key" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT cache_keys_key_unique UNIQUE (key),
	CONSTRAINT cache_keys_pkey PRIMARY KEY (id)
);


-- public.campaign_banners definition

-- Drop table

-- DROP TABLE public.campaign_banners;

CREATE TABLE public.campaign_banners (
	id bigserial NOT NULL,
	title varchar(255) NOT NULL,
	description text NULL,
	image_id uuid NOT NULL,
	start_date date NOT NULL,
	end_date date NOT NULL,
	link varchar(255) NULL,
	user_type int8 DEFAULT '1'::bigint NOT NULL,
	is_active bool DEFAULT true NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT campaign_banners_pkey PRIMARY KEY (id)
);


-- public.campaigns definition

-- Drop table

-- DROP TABLE public.campaigns;

CREATE TABLE public.campaigns (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	started_at timestamp(0) NOT NULL,
	ended_at timestamp(0) NOT NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	poster_image_id uuid NULL,
	description text NULL,
	slug varchar(255) NULL,
	flyers jsonb NULL,
	CONSTRAINT campaigns_pkey PRIMARY KEY (id),
	CONSTRAINT campaigns_slug_unique UNIQUE (slug)
);


-- public.collaboration_activities definition

-- Drop table

-- DROP TABLE public.collaboration_activities;

CREATE TABLE public.collaboration_activities (
	id bigserial NOT NULL,
	parent_id uuid NOT NULL,
	posted_by_user_id uuid NOT NULL,
	"type" varchar(255) NOT NULL,
	partner_id uuid NOT NULL,
	category varchar(255) NULL,
	started_at date NOT NULL,
	ended_at date NULL,
	description text NULL,
	proposal_file_id uuid NOT NULL,
	status bpchar(1) DEFAULT 'P'::bpchar NOT NULL,
	responded_by uuid NULL,
	pic_name varchar(255) NOT NULL,
	pic_email varchar(255) NOT NULL,
	pic_phone varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT collaboration_activities_pkey PRIMARY KEY (id)
);


-- public.collaboration_recommendations definition

-- Drop table

-- DROP TABLE public.collaboration_recommendations;

CREATE TABLE public.collaboration_recommendations (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	job_id int4 NOT NULL,
	status bpchar(1) DEFAULT 'W'::bpchar NOT NULL,
	review text NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	university_id uuid NULL,
	company_id uuid NULL,
	CONSTRAINT collaboration_recommendations_pkey PRIMARY KEY (id)
);


-- public.collaborations definition

-- Drop table

-- DROP TABLE public.collaborations;

CREATE TABLE public.collaborations (
	id bigserial NOT NULL,
	university_id uuid NOT NULL,
	company_id uuid NOT NULL,
	status bpchar(1) DEFAULT 'A'::bpchar NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	collaboration_id int4 NULL,
	CONSTRAINT collaborations_pkey PRIMARY KEY (id)
);


-- public.company_request_joins definition

-- Drop table

-- DROP TABLE public.company_request_joins;

CREATE TABLE public.company_request_joins (
	id uuid NOT NULL,
	user_id uuid NULL,
	user_name varchar(255) NOT NULL,
	user_email varchar(255) NOT NULL,
	user_password varchar(255) NOT NULL,
	pic_name varchar(255) NULL,
	pic_role varchar(255) NULL,
	pic_contact varchar(255) NULL,
	company_name varchar(255) NULL,
	company_address varchar(255) NULL,
	approved int4 NULL,
	verified_at timestamp(0) NULL,
	verified_by varchar(255) NULL,
	admin_notes text NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL
);


-- public.company_sizes definition

-- Drop table

-- DROP TABLE public.company_sizes;

CREATE TABLE public.company_sizes (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT company_sizes_name_unique UNIQUE (name),
	CONSTRAINT company_sizes_pkey PRIMARY KEY (id)
);


-- public.company_subscriptions definition

-- Drop table

-- DROP TABLE public.company_subscriptions;

CREATE TABLE public.company_subscriptions (
	id bigserial NOT NULL,
	company_id uuid NOT NULL,
	"level" int4 DEFAULT 1 NOT NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	started_at_whatsapp timestamp(0) NULL,
	expired_at_whatsapp timestamp(0) NULL,
	started_at_manage_applicant timestamp(0) NULL,
	expired_at_manage_applicant timestamp(0) NULL,
	talent_search_quota int4 DEFAULT 0 NOT NULL,
	talent_invitation_quota int4 DEFAULT 0 NOT NULL,
	job_preference_quota int4 DEFAULT 0 NOT NULL,
	CONSTRAINT company_subscriptions_pkey PRIMARY KEY (id)
);


-- public.company_types definition

-- Drop table

-- DROP TABLE public.company_types;

CREATE TABLE public.company_types (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT company_types_name_unique UNIQUE (name),
	CONSTRAINT company_types_pkey PRIMARY KEY (id)
);


-- public.confirmation_types definition

-- Drop table

-- DROP TABLE public.confirmation_types;

CREATE TABLE public.confirmation_types (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT confirmation_types_pkey PRIMARY KEY (id)
);


-- public.department_types definition

-- Drop table

-- DROP TABLE public.department_types;

CREATE TABLE public.department_types (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	slug varchar(255) NOT NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT department_types_pkey PRIMARY KEY (id),
	CONSTRAINT department_types_slug_unique UNIQUE (slug)
);


-- public.discounts definition

-- Drop table

-- DROP TABLE public.discounts;

CREATE TABLE public.discounts (
	id bigserial NOT NULL,
	code varchar(255) NOT NULL,
	description varchar(255) NULL,
	"type" bpchar(1) NOT NULL,
	value int4 NOT NULL,
	min_transaction int4 NULL,
	max_discount int4 NULL,
	started_at timestamp(0) NULL,
	expired_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	title varchar(255) NULL,
	status bpchar(1) DEFAULT 'A'::bpchar NOT NULL,
	CONSTRAINT discounts_pkey PRIMARY KEY (id)
);
CREATE INDEX discount_code ON public.discounts USING btree (code);
CREATE INDEX discount_type ON public.discounts USING btree (type);


-- public.error_logs definition

-- Drop table

-- DROP TABLE public.error_logs;

CREATE TABLE public.error_logs (
	id bigserial NOT NULL,
	message text NOT NULL,
	line varchar(255) NOT NULL,
	file varchar(255) NOT NULL,
	url text NOT NULL,
	"input" text NOT NULL,
	user_agent text NOT NULL,
	http_code int4 NOT NULL,
	code int4 NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT error_logs_pkey PRIMARY KEY (id)
);


-- public.failed_jobs definition

-- Drop table

-- DROP TABLE public.failed_jobs;

CREATE TABLE public.failed_jobs (
	id bigserial NOT NULL,
	"connection" text NOT NULL,
	queue text NOT NULL,
	payload text NOT NULL,
	"exception" text NOT NULL,
	failed_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"uuid" uuid NULL,
	CONSTRAINT failed_jobs_pkey PRIMARY KEY (id),
	CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid)
);


-- public.ftypes definition

-- Drop table

-- DROP TABLE public.ftypes;

CREATE TABLE public.ftypes (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT ftypes_name_unique UNIQUE (name),
	CONSTRAINT ftypes_pkey PRIMARY KEY (id)
);


-- public.gelar_akademiks definition

-- Drop table

-- DROP TABLE public.gelar_akademiks;

CREATE TABLE public.gelar_akademiks (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT gelar_akademiks_pkey PRIMARY KEY (id)
);


-- public.industry_types definition

-- Drop table

-- DROP TABLE public.industry_types;

CREATE TABLE public.industry_types (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT industry_types_name_unique UNIQUE (name),
	CONSTRAINT industry_types_pkey PRIMARY KEY (id)
);


-- public.job_categories definition

-- Drop table

-- DROP TABLE public.job_categories;

CREATE TABLE public.job_categories (
	id bigserial NOT NULL,
	slug varchar(255) NOT NULL,
	display_name varchar(255) NOT NULL,
	image_path varchar(255) NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT job_categories_pkey PRIMARY KEY (id)
);
CREATE INDEX job_category_slug ON public.job_categories USING btree (slug);


-- public.job_positions definition

-- Drop table

-- DROP TABLE public.job_positions;

CREATE TABLE public.job_positions (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	slug varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT job_positions_pkey PRIMARY KEY (id)
);
CREATE INDEX job_position_slug ON public.job_positions USING btree (slug);


-- public.job_preferences definition

-- Drop table

-- DROP TABLE public.job_preferences;

CREATE TABLE public.job_preferences (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	job_position_ids jsonb NULL,
	job_schemes jsonb NULL,
	city_ids jsonb NULL,
	salary_expected int4 NULL,
	readiness_to_work varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	industry_type_id jsonb NULL,
	reallocate bool NULL,
	current_salary int8 NULL,
	opportunity_status bpchar(1) NULL,
	CONSTRAINT job_preferences_pkey PRIMARY KEY (id)
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


-- public.mitra_universities definition

-- Drop table

-- DROP TABLE public.mitra_universities;

CREATE TABLE public.mitra_universities (
	id bigserial NOT NULL,
	company_id uuid NOT NULL,
	university_id uuid NOT NULL,
	user_company_id uuid NULL,
	user_university_id uuid NULL,
	status bpchar(1) DEFAULT '1'::bpchar NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT mitra_universities_pkey PRIMARY KEY (id)
);
CREATE INDEX company_mitra_from_univerisity ON public.mitra_universities USING btree (company_id);
CREATE INDEX university_mitra_from_company ON public.mitra_universities USING btree (university_id);
CREATE INDEX user_company_mitra_from_university ON public.mitra_universities USING btree (user_company_id);
CREATE INDEX user_university_mitra_from_company ON public.mitra_universities USING btree (user_university_id);


-- public.notifications definition

-- Drop table

-- DROP TABLE public.notifications;

CREATE TABLE public.notifications (
	id uuid NOT NULL,
	"type" varchar(255) NOT NULL,
	notifiable_type varchar(255) NOT NULL,
	notifiable_id uuid NOT NULL,
	"data" text NOT NULL,
	read_at timestamp(0) NULL,
	push_notification_result text NULL,
	push_notification_sent_at timestamp(0) NULL,
	sms_notification_result text NULL,
	sms_notification_sent_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT notifications_pkey PRIMARY KEY (id)
);
CREATE INDEX notifications_notifiable_type_notifiable_id_index ON public.notifications USING btree (notifiable_type, notifiable_id);


-- public.notifikasi_broadcast definition

-- Drop table

-- DROP TABLE public.notifikasi_broadcast;

CREATE TABLE public.notifikasi_broadcast (
	id bigserial NOT NULL,
	pengirim_id int4 NULL,
	penerima_id text NULL,
	judul varchar(255) NULL,
	pesan varchar(255) NULL,
	data_json text NULL,
	penerima_roles text NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT notifikasi_broadcast_pkey PRIMARY KEY (id)
);


-- public.oauth_access_tokens definition

-- Drop table

-- DROP TABLE public.oauth_access_tokens;

CREATE TABLE public.oauth_access_tokens (
	id varchar(100) NOT NULL,
	client_id int8 NOT NULL,
	"name" varchar(255) NULL,
	scopes text NULL,
	revoked bool NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	expires_at timestamp(0) NULL,
	user_id uuid NULL,
	CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id)
);
CREATE INDEX oauth_access_tokens_user_id_index ON public.oauth_access_tokens USING btree (user_id);


-- public.oauth_auth_codes definition

-- Drop table

-- DROP TABLE public.oauth_auth_codes;

CREATE TABLE public.oauth_auth_codes (
	id varchar(100) NOT NULL,
	user_id int8 NOT NULL,
	client_id int8 NOT NULL,
	scopes text NULL,
	revoked bool NOT NULL,
	expires_at timestamp(0) NULL,
	CONSTRAINT oauth_auth_codes_pkey PRIMARY KEY (id)
);
CREATE INDEX oauth_auth_codes_user_id_index ON public.oauth_auth_codes USING btree (user_id);


-- public.oauth_clients definition

-- Drop table

-- DROP TABLE public.oauth_clients;

CREATE TABLE public.oauth_clients (
	id bigserial NOT NULL,
	user_id int8 NULL,
	"name" varchar(255) NOT NULL,
	secret varchar(100) NULL,
	provider varchar(255) NULL,
	redirect text NOT NULL,
	personal_access_client bool NOT NULL,
	password_client bool NOT NULL,
	revoked bool NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT oauth_clients_pkey PRIMARY KEY (id)
);
CREATE INDEX oauth_clients_user_id_index ON public.oauth_clients USING btree (user_id);


-- public.oauth_personal_access_clients definition

-- Drop table

-- DROP TABLE public.oauth_personal_access_clients;

CREATE TABLE public.oauth_personal_access_clients (
	id bigserial NOT NULL,
	client_id int8 NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT oauth_personal_access_clients_pkey PRIMARY KEY (id)
);


-- public.oauth_refresh_tokens definition

-- Drop table

-- DROP TABLE public.oauth_refresh_tokens;

CREATE TABLE public.oauth_refresh_tokens (
	id varchar(100) NOT NULL,
	access_token_id varchar(100) NOT NULL,
	revoked bool NOT NULL,
	expires_at timestamp(0) NULL,
	CONSTRAINT oauth_refresh_tokens_pkey PRIMARY KEY (id)
);
CREATE INDEX oauth_refresh_tokens_access_token_id_index ON public.oauth_refresh_tokens USING btree (access_token_id);


-- public.organizations definition

-- Drop table

-- DROP TABLE public.organizations;

CREATE TABLE public.organizations (
	id serial4 NOT NULL,
	"name" varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT organizations_pkey PRIMARY KEY (id)
);


-- public.packages definition

-- Drop table

-- DROP TABLE public.packages;

CREATE TABLE public.packages (
	id bigserial NOT NULL,
	"name" varchar(255) NULL,
	subscription_price int4 NULL,
	total_user int4 NULL,
	limit_survey_sent int4 NULL,
	permission_ids jsonb NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT packages_pkey PRIMARY KEY (id)
);


-- public.password_resets definition

-- Drop table

-- DROP TABLE public.password_resets;

CREATE TABLE public.password_resets (
	email varchar(255) NOT NULL,
	"token" varchar(255) NOT NULL,
	created_at timestamp(0) NULL
);
CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);


-- public.permission_packages definition

-- Drop table

-- DROP TABLE public.permission_packages;

CREATE TABLE public.permission_packages (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	slug varchar(255) NOT NULL,
	"type" varchar(1) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT permission_packages_pkey PRIMARY KEY (id)
);


-- public.permissions definition

-- Drop table

-- DROP TABLE public.permissions;

CREATE TABLE public.permissions (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	description varchar(255) NULL,
	built_in bool DEFAULT false NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT permissions_name_unique UNIQUE (name),
	CONSTRAINT permissions_pkey PRIMARY KEY (id)
);


-- public.post_comment_types definition

-- Drop table

-- DROP TABLE public.post_comment_types;

CREATE TABLE public.post_comment_types (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT post_comment_types_name_unique UNIQUE (name),
	CONSTRAINT post_comment_types_pkey PRIMARY KEY (id)
);


-- public.post_statuses definition

-- Drop table

-- DROP TABLE public.post_statuses;

CREATE TABLE public.post_statuses (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT post_statuses_name_unique UNIQUE (name),
	CONSTRAINT post_statuses_pkey PRIMARY KEY (id)
);


-- public.post_tag_types definition

-- Drop table

-- DROP TABLE public.post_tag_types;

CREATE TABLE public.post_tag_types (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT post_tag_types_name_unique UNIQUE (name),
	CONSTRAINT post_tag_types_pkey PRIMARY KEY (id)
);


-- public.post_types definition

-- Drop table

-- DROP TABLE public.post_types;

CREATE TABLE public.post_types (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT post_types_name_unique UNIQUE (name),
	CONSTRAINT post_types_pkey PRIMARY KEY (id)
);


-- public.provinsis definition

-- Drop table

-- DROP TABLE public.provinsis;

CREATE TABLE public.provinsis (
	id varchar(255) NOT NULL,
	nama varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT provinsis_pkey PRIMARY KEY (id)
);


-- public.queue_jobs definition

-- Drop table

-- DROP TABLE public.queue_jobs;

CREATE TABLE public.queue_jobs (
	id int8 DEFAULT nextval('jobs_id_seq'::regclass) NOT NULL,
	queue varchar(255) NOT NULL,
	payload text NOT NULL,
	attempts int2 NOT NULL,
	reserved_at int4 NULL,
	available_at int4 NOT NULL,
	created_at int4 NOT NULL,
	CONSTRAINT jobs_pkey PRIMARY KEY (id)
);
CREATE INDEX jobs_queue_index ON public.queue_jobs USING btree (queue);


-- public.reports definition

-- Drop table

-- DROP TABLE public.reports;

CREATE TABLE public.reports (
	id bigserial NOT NULL,
	reporter_id uuid NOT NULL,
	post_id uuid NULL,
	description text NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	report_type varchar(255) NULL,
	user_id uuid NULL,
	user_type_id int4 NULL,
	CONSTRAINT reports_pkey PRIMARY KEY (id),
	CONSTRAINT reports_report_type_check CHECK (((report_type)::text = ANY (ARRAY[('P'::character varying)::text, ('U'::character varying)::text])))
);


-- public.roles definition

-- Drop table

-- DROP TABLE public.roles;

CREATE TABLE public.roles (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	description varchar(255) NULL,
	built_in bool DEFAULT false NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT roles_name_unique UNIQUE (name),
	CONSTRAINT roles_pkey PRIMARY KEY (id)
);


-- public.short_urls definition

-- Drop table

-- DROP TABLE public.short_urls;

CREATE TABLE public.short_urls (
	id bigserial NOT NULL,
	destination_url text NOT NULL,
	url_key varchar(255) NOT NULL,
	default_short_url varchar(255) NOT NULL,
	single_use bool NOT NULL,
	track_visits bool NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	redirect_status_code int4 DEFAULT 301 NOT NULL,
	track_ip_address bool DEFAULT false NOT NULL,
	track_operating_system bool DEFAULT false NOT NULL,
	track_operating_system_version bool DEFAULT false NOT NULL,
	track_browser bool DEFAULT false NOT NULL,
	track_browser_version bool DEFAULT false NOT NULL,
	track_referer_url bool DEFAULT false NOT NULL,
	track_device_type bool DEFAULT false NOT NULL,
	activated_at timestamp(0) DEFAULT '2026-04-13 13:43:21'::timestamp without time zone NULL,
	deactivated_at timestamp(0) NULL,
	forward_query_params bool DEFAULT false NOT NULL,
	CONSTRAINT short_urls_pkey PRIMARY KEY (id),
	CONSTRAINT short_urls_url_key_unique UNIQUE (url_key)
);


-- public.skills definition

-- Drop table

-- DROP TABLE public.skills;

CREATE TABLE public.skills (
	id bigserial NOT NULL,
	"name" text NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT skills_pkey PRIMARY KEY (id)
);


-- public.special_vacancies definition

-- Drop table

-- DROP TABLE public.special_vacancies;

CREATE TABLE public.special_vacancies (
	id uuid NOT NULL,
	post_id uuid NOT NULL,
	university_id uuid NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL
);


-- public.tags definition

-- Drop table

-- DROP TABLE public.tags;

CREATE TABLE public.tags (
	id bigserial NOT NULL,
	tag varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT tags_pkey PRIMARY KEY (id)
);


-- public.tracer_masters definition

-- Drop table

-- DROP TABLE public.tracer_masters;

CREATE TABLE public.tracer_masters (
	tracer_master_id uuid DEFAULT uuid_generate_v4() NOT NULL,
	ref_id uuid NOT NULL,
	tracer_name varchar(255) NOT NULL,
	tracer_formula varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT tracer_masters_pkey PRIMARY KEY (tracer_master_id)
);


-- public.university_packages definition

-- Drop table

-- DROP TABLE public.university_packages;

CREATE TABLE public.university_packages (
	id bigserial NOT NULL,
	university_id varchar(255) NOT NULL,
	package_id int8 NOT NULL,
	status bpchar(1) DEFAULT 'A'::bpchar NOT NULL,
	permission_ids jsonb NULL,
	stated_at timestamp(0) NULL,
	ended_at timestamp(0) NULL,
	subscription_price int4 NULL,
	total_user int4 NULL,
	limit_survey_sent int4 NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT university_packages_pkey PRIMARY KEY (id)
);
CREATE INDEX package_from_university ON public.university_packages USING btree (package_id);
CREATE INDEX university_related_packages ON public.university_packages USING btree (university_id);


-- public.university_sizes definition

-- Drop table

-- DROP TABLE public.university_sizes;

CREATE TABLE public.university_sizes (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT university_sizes_name_unique UNIQUE (name),
	CONSTRAINT university_sizes_pkey PRIMARY KEY (id)
);


-- public.university_types definition

-- Drop table

-- DROP TABLE public.university_types;

CREATE TABLE public.university_types (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT university_types_name_unique UNIQUE (name),
	CONSTRAINT university_types_pkey PRIMARY KEY (id)
);


-- public.user_privacy_types definition

-- Drop table

-- DROP TABLE public.user_privacy_types;

CREATE TABLE public.user_privacy_types (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT user_privacy_types_name_unique UNIQUE (name),
	CONSTRAINT user_privacy_types_pkey PRIMARY KEY (id)
);


-- public.user_skills definition

-- Drop table

-- DROP TABLE public.user_skills;

CREATE TABLE public.user_skills (
	id bigserial NOT NULL,
	skill_id int8 NOT NULL,
	user_id uuid NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT user_skills_pkey PRIMARY KEY (id)
);


-- public.user_statuses definition

-- Drop table

-- DROP TABLE public.user_statuses;

CREATE TABLE public.user_statuses (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT user_statuses_name_unique UNIQUE (name),
	CONSTRAINT user_statuses_pkey PRIMARY KEY (id)
);


-- public.user_types definition

-- Drop table

-- DROP TABLE public.user_types;

CREATE TABLE public.user_types (
	id serial4 NOT NULL,
	"name" varchar(255) NOT NULL,
	display_name varchar(255) NULL,
	note varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT user_types_name_unique UNIQUE (name),
	CONSTRAINT user_types_pkey PRIMARY KEY (id)
);


-- public.vacancy_skills definition

-- Drop table

-- DROP TABLE public.vacancy_skills;

CREATE TABLE public.vacancy_skills (
	id bigserial NOT NULL,
	skill_id int8 NOT NULL,
	post_id uuid NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT vacancy_skills_pkey PRIMARY KEY (id)
);


-- public.vacancy_statuses definition

-- Drop table

-- DROP TABLE public.vacancy_statuses;

CREATE TABLE public.vacancy_statuses (
	id bigserial NOT NULL,
	post_id uuid NOT NULL,
	status bpchar(1) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	user_id uuid NOT NULL,
	CONSTRAINT vacancy_statuses_pkey PRIMARY KEY (id)
);


-- public.versions definition

-- Drop table

-- DROP TABLE public.versions;

CREATE TABLE public.versions (
	id bigserial NOT NULL,
	version_number varchar(255) NOT NULL,
	build_number varchar(255) NOT NULL,
	changelog text NOT NULL,
	platform varchar(255) NOT NULL,
	is_update_required bool DEFAULT false NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT versions_pkey PRIMARY KEY (id),
	CONSTRAINT versions_platform_check CHECK (((platform)::text = ANY (ARRAY[('1'::character varying)::text, ('2'::character varying)::text])))
);


-- public.fexts definition

-- Drop table

-- DROP TABLE public.fexts;

CREATE TABLE public.fexts (
	id bigserial NOT NULL,
	"name" varchar(255) NOT NULL,
	ftype_id int8 NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT fexts_name_unique UNIQUE (name),
	CONSTRAINT fexts_pkey PRIMARY KEY (id),
	CONSTRAINT fexts_ftype_id_foreign FOREIGN KEY (ftype_id) REFERENCES public.ftypes(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.kotas definition

-- Drop table

-- DROP TABLE public.kotas;

CREATE TABLE public.kotas (
	id varchar(255) NOT NULL,
	provinsi_id varchar(255) NULL,
	nama varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT kotas_pkey PRIMARY KEY (id),
	CONSTRAINT kotas_provinsi_id_foreign FOREIGN KEY (provinsi_id) REFERENCES public.provinsis(id) ON DELETE CASCADE
);


-- public.permission_role definition

-- Drop table

-- DROP TABLE public.permission_role;

CREATE TABLE public.permission_role (
	permission_id int4 NOT NULL,
	role_id int4 NOT NULL,
	CONSTRAINT permission_role_pkey PRIMARY KEY (permission_id, role_id),
	CONSTRAINT permission_role_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT permission_role_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.permission_user definition

-- Drop table

-- DROP TABLE public.permission_user;

CREATE TABLE public.permission_user (
	permission_id int4 NOT NULL,
	user_id int4 NOT NULL,
	user_type varchar(255) NOT NULL,
	CONSTRAINT permission_user_pkey PRIMARY KEY (user_id, permission_id, user_type),
	CONSTRAINT permission_user_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.role_user definition

-- Drop table

-- DROP TABLE public.role_user;

CREATE TABLE public.role_user (
	role_id int4 NOT NULL,
	user_id int4 NOT NULL,
	user_type varchar(255) NOT NULL,
	CONSTRAINT role_user_pkey PRIMARY KEY (user_id, role_id, user_type),
	CONSTRAINT role_user_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- public.short_url_visits definition

-- Drop table

-- DROP TABLE public.short_url_visits;

CREATE TABLE public.short_url_visits (
	id bigserial NOT NULL,
	short_url_id int8 NOT NULL,
	ip_address varchar(255) NULL,
	operating_system varchar(255) NULL,
	operating_system_version varchar(255) NULL,
	browser varchar(255) NULL,
	browser_version varchar(255) NULL,
	visited_at timestamp(0) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	referer_url varchar(255) NULL,
	device_type varchar(255) NULL,
	CONSTRAINT short_url_visits_pkey PRIMARY KEY (id),
	CONSTRAINT short_url_visits_short_url_id_foreign FOREIGN KEY (short_url_id) REFERENCES public.short_urls(id) ON DELETE CASCADE
);


-- public.tracer_answer_types definition

-- Drop table

-- DROP TABLE public.tracer_answer_types;

CREATE TABLE public.tracer_answer_types (
	tracer_answer_type_id uuid DEFAULT uuid_generate_v4() NOT NULL,
	tracer_master_id uuid NOT NULL,
	tracer_answer_type_name varchar(255) NOT NULL,
	tracer_answer_type varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT tracer_answer_types_pkey PRIMARY KEY (tracer_answer_type_id),
	CONSTRAINT tracer_answer_types_tracer_master_id_foreign FOREIGN KEY (tracer_master_id) REFERENCES public.tracer_masters(tracer_master_id) ON DELETE RESTRICT
);


-- public.tracer_aspects definition

-- Drop table

-- DROP TABLE public.tracer_aspects;

CREATE TABLE public.tracer_aspects (
	tracer_aspect_id uuid DEFAULT uuid_generate_v4() NOT NULL,
	tracer_master_id uuid NOT NULL,
	tracer_aspect_number varchar(3) NOT NULL,
	tracer_aspect_name varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT tracer_aspects_pkey PRIMARY KEY (tracer_aspect_id),
	CONSTRAINT tracer_aspects_tracer_master_id_foreign FOREIGN KEY (tracer_master_id) REFERENCES public.tracer_masters(tracer_master_id) ON DELETE RESTRICT
);


-- public.tracer_questions definition

-- Drop table

-- DROP TABLE public.tracer_questions;

CREATE TABLE public.tracer_questions (
	tracer_question_id uuid DEFAULT uuid_generate_v4() NOT NULL,
	tracer_aspect_id uuid NOT NULL,
	tracer_answer_type_id uuid NOT NULL,
	tracer_question_number varchar(3) NOT NULL,
	tracer_question varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT tracer_questions_pkey PRIMARY KEY (tracer_question_id),
	CONSTRAINT tracer_questions_tracer_answer_type_id_foreign FOREIGN KEY (tracer_answer_type_id) REFERENCES public.tracer_answer_types(tracer_answer_type_id) ON DELETE RESTRICT,
	CONSTRAINT tracer_questions_tracer_aspect_id_foreign FOREIGN KEY (tracer_aspect_id) REFERENCES public.tracer_aspects(tracer_aspect_id) ON DELETE RESTRICT
);


-- public.collaboration_partners definition

-- Drop table

-- DROP TABLE public.collaboration_partners;

CREATE TABLE public.collaboration_partners (
	id bigserial NOT NULL,
	parent_id uuid NOT NULL,
	posted_by_user_id uuid NOT NULL,
	"type" varchar(255) NOT NULL,
	partner_id uuid NOT NULL,
	category varchar(255) NULL,
	city_id varchar(255) NOT NULL,
	website varchar(255) NULL,
	address text NULL,
	proposal_file_id uuid NOT NULL,
	status bpchar(1) DEFAULT 'P'::bpchar NOT NULL,
	responded_by uuid NULL,
	pic_name varchar(255) NOT NULL,
	pic_email varchar(255) NOT NULL,
	pic_phone varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	is_new_company bool DEFAULT false NOT NULL,
	CONSTRAINT collaboration_partners_pkey PRIMARY KEY (id),
	CONSTRAINT collaboration_partners_city_id_foreign FOREIGN KEY (city_id) REFERENCES public.kotas(id)
);


-- public.kecamatans definition

-- Drop table

-- DROP TABLE public.kecamatans;

CREATE TABLE public.kecamatans (
	id varchar(255) NOT NULL,
	kota_id varchar(255) NULL,
	nama varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT kecamatans_pkey PRIMARY KEY (id),
	CONSTRAINT kecamatans_kota_id_foreign FOREIGN KEY (kota_id) REFERENCES public.kotas(id) ON DELETE CASCADE
);


-- public.kelurahans definition

-- Drop table

-- DROP TABLE public.kelurahans;

CREATE TABLE public.kelurahans (
	id varchar(255) NOT NULL,
	kecamatan_id varchar(255) NULL,
	nama varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT kelurahans_pkey PRIMARY KEY (id),
	CONSTRAINT kelurahans_kecamatan_id_foreign FOREIGN KEY (kecamatan_id) REFERENCES public.kecamatans(id) ON DELETE CASCADE
);


-- public.tracer_answer_type_values definition

-- Drop table

-- DROP TABLE public.tracer_answer_type_values;

CREATE TABLE public.tracer_answer_type_values (
	tracer_answer_type_value_id uuid DEFAULT uuid_generate_v4() NOT NULL,
	tracer_answer_type_id uuid NOT NULL,
	tracer_answer_type_value_name varchar(255) NOT NULL,
	tracer_answer_type_value_point int4 NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT tracer_answer_type_values_pkey PRIMARY KEY (tracer_answer_type_value_id),
	CONSTRAINT tracer_answer_type_values_tracer_answer_type_id_foreign FOREIGN KEY (tracer_answer_type_id) REFERENCES public.tracer_answer_types(tracer_answer_type_id) ON DELETE RESTRICT
);


-- public.applicant_notes definition

-- Drop table

-- DROP TABLE public.applicant_notes;

CREATE TABLE public.applicant_notes (
	id bigserial NOT NULL,
	applicant_status_id int8 NULL,
	note text NOT NULL,
	note_giver_id uuid NOT NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT applicant_notes_pkey1 PRIMARY KEY (id)
);


-- public.applicant_statuses definition

-- Drop table

-- DROP TABLE public.applicant_statuses;

CREATE TABLE public.applicant_statuses (
	id bigserial NOT NULL,
	applicant_id int8 NOT NULL,
	status bpchar(1) NOT NULL,
	status_changer_by_id uuid NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT applicant_statuses_pkey PRIMARY KEY (id)
);
CREATE INDEX status_from_applicant ON public.applicant_statuses USING btree (status);


-- public.applicants definition

-- Drop table

-- DROP TABLE public.applicants;

CREATE TABLE public.applicants (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	job_id int8 NOT NULL,
	attachment_url text NULL,
	interview_at timestamp(0) NULL,
	hired_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	campaign_id int8 NULL,
	resume_file varchar(255) NULL,
	CONSTRAINT applicants_pkey PRIMARY KEY (id)
);


-- public.article_category definition

-- Drop table

-- DROP TABLE public.article_category;

CREATE TABLE public.article_category (
	id bigserial NOT NULL,
	article_id int8 NOT NULL,
	category_id int8 NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT article_category_pkey PRIMARY KEY (id)
);


-- public.article_meta definition

-- Drop table

-- DROP TABLE public.article_meta;

CREATE TABLE public.article_meta (
	id bigserial NOT NULL,
	article_id int8 NOT NULL,
	part text NOT NULL,
	title varchar(255) NOT NULL,
	description text NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT article_meta_pkey PRIMARY KEY (id)
);


-- public.article_tags definition

-- Drop table

-- DROP TABLE public.article_tags;

CREATE TABLE public.article_tags (
	id bigserial NOT NULL,
	article_id int8 NOT NULL,
	tag_id int8 NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT article_tags_pkey PRIMARY KEY (id)
);


-- public.articles definition

-- Drop table

-- DROP TABLE public.articles;

CREATE TABLE public.articles (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	status varchar(255) NOT NULL,
	title varchar(255) NOT NULL,
	slug varchar(255) NOT NULL,
	"content" text NOT NULL,
	thumbnail_id uuid NULL,
	published_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	priority bool NULL,
	CONSTRAINT articles_pkey PRIMARY KEY (id),
	CONSTRAINT articles_slug_unique UNIQUE (slug),
	CONSTRAINT articles_status_check CHECK (((status)::text = ANY (ARRAY[('publish'::character varying)::text, ('draft'::character varying)::text, ('trash'::character varying)::text, ('pending'::character varying)::text])))
);


-- public.bookmark_jobs definition

-- Drop table

-- DROP TABLE public.bookmark_jobs;

CREATE TABLE public.bookmark_jobs (
	id bigserial NOT NULL,
	job_id int8 NOT NULL,
	user_id uuid NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT bookmark_jobs_pkey PRIMARY KEY (id)
);


-- public.campaign_companies definition

-- Drop table

-- DROP TABLE public.campaign_companies;

CREATE TABLE public.campaign_companies (
	id bigserial NOT NULL,
	campaign_id int8 NOT NULL,
	company_id uuid NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT campaign_companies_pkey PRIMARY KEY (id)
);


-- public.campaign_jobs definition

-- Drop table

-- DROP TABLE public.campaign_jobs;

CREATE TABLE public.campaign_jobs (
	id bigserial NOT NULL,
	campaign_id int8 NOT NULL,
	job_id int8 NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT campaign_jobs_pkey PRIMARY KEY (id)
);


-- public.companies definition

-- Drop table

-- DROP TABLE public.companies;

CREATE TABLE public.companies (
	id uuid NOT NULL,
	"name" varchar(255) NULL,
	abbrev varchar(255) NULL,
	company_type_id int4 NULL,
	company_size_id int4 NULL,
	industry_type_id int4 NULL,
	head_line varchar(255) NULL,
	tag_line varchar(255) NULL,
	website varchar(255) NULL,
	phone varchar(255) NULL,
	whatsapp varchar(255) NULL,
	email varchar(255) NULL,
	facebook varchar(255) NULL,
	linkedin varchar(255) NULL,
	instagram varchar(255) NULL,
	npwp varchar(255) NULL,
	address varchar(255) NULL,
	city_id varchar(255) NULL,
	alternate_address varchar(255) NULL,
	alternate_city_id varchar(255) NULL,
	year_founded int4 NULL,
	profile_image_id uuid NULL,
	dashboard_image_id uuid NULL,
	last_update_by_id uuid NULL,
	last_update_by_iplocation varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	youtube varchar(100) NULL,
	description text NULL,
	why_join_us text NULL,
	operational_hour text NULL,
	"language" varchar(255) NULL,
	slug text NULL,
	status varchar(255) DEFAULT 'active'::character varying NOT NULL,
	suspend_ended_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	reason varchar(255) NULL,
	benefit jsonb NULL,
	"source" varchar(255) NULL,
	CONSTRAINT companies_email_unique UNIQUE (email),
	CONSTRAINT companies_id_unique UNIQUE (id),
	CONSTRAINT companies_status_check CHECK (((status)::text = ANY (ARRAY[('active'::character varying)::text, ('suspend'::character varying)::text, ('blocked'::character varying)::text, ('deleted'::character varying)::text]))),
	CONSTRAINT "slug-from-company" UNIQUE (slug)
);
CREATE INDEX company_source ON public.companies USING btree (source);
CREATE INDEX status_of_companies ON public.companies USING btree (status);


-- public.company_admins definition

-- Drop table

-- DROP TABLE public.company_admins;

CREATE TABLE public.company_admins (
	id bigserial NOT NULL,
	company_id uuid NULL,
	user_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT company_admins_pkey PRIMARY KEY (id)
);


-- public.company_followers definition

-- Drop table

-- DROP TABLE public.company_followers;

CREATE TABLE public.company_followers (
	id bigserial NOT NULL,
	company_id uuid NOT NULL,
	follower_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	company_follower_id uuid NULL,
	university_follower_id uuid NULL,
	CONSTRAINT company_followers_pkey PRIMARY KEY (id)
);


-- public.company_images definition

-- Drop table

-- DROP TABLE public.company_images;

CREATE TABLE public.company_images (
	id bigserial NOT NULL,
	company_id uuid NULL,
	file_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT company_images_pkey PRIMARY KEY (id)
);


-- public.company_invitations definition

-- Drop table

-- DROP TABLE public.company_invitations;

CREATE TABLE public.company_invitations (
	id uuid NOT NULL,
	company_name varchar(200) NULL,
	company_email varchar(200) NULL,
	company_phone varchar(200) NULL,
	inviter_name varchar(200) NULL,
	inviter_position varchar(200) NULL,
	used_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	inviter_organization_name varchar(200) NULL,
	inviter_user_id uuid NULL,
	company_id uuid NULL,
	inviter_organization_id uuid NULL,
	firebase_dynamic_link varchar(255) NULL,
	CONSTRAINT company_invitations_id_unique UNIQUE (id)
);


-- public.confirmation_users definition

-- Drop table

-- DROP TABLE public.confirmation_users;

CREATE TABLE public.confirmation_users (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	code varchar(255) NOT NULL,
	expired_at timestamp(0) NOT NULL,
	confirmation_type_id int8 NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT confirmation_users_code_unique UNIQUE (code),
	CONSTRAINT confirmation_users_pkey PRIMARY KEY (id)
);


-- public.device_logins definition

-- Drop table

-- DROP TABLE public.device_logins;

CREATE TABLE public.device_logins (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	ip varchar(255) NOT NULL,
	device varchar(255) NULL,
	platform varchar(255) NULL,
	platform_version varchar(255) NULL,
	browser varchar(255) NULL,
	browser_version varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	source_login_as uuid NULL,
	CONSTRAINT device_logins_pkey PRIMARY KEY (id)
);


-- public.files definition

-- Drop table

-- DROP TABLE public.files;

CREATE TABLE public.files (
	id uuid NOT NULL,
	ext varchar(255) NULL,
	ftype_id int8 NOT NULL,
	user_id uuid NOT NULL,
	caption varchar(255) NULL,
	"path" varchar(255) NULL,
	path_thumbnail varchar(255) NULL,
	full_path varchar(255) NULL,
	full_path_thumbnail varchar(255) NULL,
	folder varchar(255) NULL,
	size_in_bytes float8 NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT files_id_unique UNIQUE (id)
);


-- public.footers definition

-- Drop table

-- DROP TABLE public.footers;

CREATE TABLE public.footers (
	id bigserial NOT NULL,
	university_id uuid NOT NULL,
	"name" varchar(255) NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	is_active bool DEFAULT false NOT NULL,
	url varchar(255) NOT NULL,
	CONSTRAINT footers_pkey PRIMARY KEY (id)
);


-- public.invoices definition

-- Drop table

-- DROP TABLE public.invoices;

CREATE TABLE public.invoices (
	id bigserial NOT NULL,
	transaction_id int8 NOT NULL,
	virtual_account varchar(255) NOT NULL,
	email varchar(255) NOT NULL,
	phone varchar(255) NULL,
	amount int4 NOT NULL,
	direct_amount int4 NOT NULL,
	payment_method int4 NOT NULL,
	expired_at timestamp(0) NOT NULL,
	paid_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT invoices_pkey PRIMARY KEY (id)
);
CREATE INDEX invoice_payment_method ON public.invoices USING btree (payment_method);
CREATE INDEX virtual_account ON public.invoices USING btree (virtual_account);


-- public.job_benefits definition

-- Drop table

-- DROP TABLE public.job_benefits;

CREATE TABLE public.job_benefits (
	id bigserial NOT NULL,
	job_id int8 NOT NULL,
	benefit_id int8 NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT job_benefits_pkey PRIMARY KEY (id)
);


-- public.job_skills definition

-- Drop table

-- DROP TABLE public.job_skills;

CREATE TABLE public.job_skills (
	id bigserial NOT NULL,
	skill_id int8 NOT NULL,
	job_id int8 NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT job_skills_pkey PRIMARY KEY (id)
);


-- public.jobs definition

-- Drop table

-- DROP TABLE public.jobs;

CREATE TABLE public.jobs (
	id bigserial NOT NULL,
	title varchar(255) NOT NULL,
	parent_id uuid NOT NULL,
	"type" varchar(255) DEFAULT 'university'::character varying NOT NULL,
	workplace_type bpchar(1) NOT NULL,
	employment_type bpchar(1) NOT NULL,
	industry_type_id int8 NULL,
	department_type_id int8 NULL,
	city_id varchar(255) NULL,
	description text NULL,
	requirements text NULL,
	responsibilities text NULL,
	started_at timestamp(0) NULL,
	ended_at timestamp(0) NULL,
	salary_min int8 NULL,
	salary_max int8 NULL,
	poster_image_id uuid NULL,
	min_education bpchar(1) NULL,
	total_applycant int4 NULL,
	total_bookmark int4 NULL,
	posted_by_id uuid NOT NULL,
	salary_type bpchar(1) NULL,
	special_vacancies jsonb NULL,
	major_preferences jsonb NULL,
	permalink varchar(255) NULL,
	job_category_id int8 NULL,
	is_required_document bool DEFAULT false NOT NULL,
	is_restricted_city bool DEFAULT false NOT NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	status varchar(255) DEFAULT 'draft'::character varying NOT NULL,
	education_level bpchar(1) NULL,
	experience_level bpchar(1) NULL,
	status_reason text NULL,
	suspend_ended_at timestamp(0) NULL,
	is_priority bool DEFAULT false NOT NULL,
	is_share_to_ubaya bool DEFAULT false NOT NULL,
	assign_date timestamp(0) NULL,
	CONSTRAINT jobs_pkey1 PRIMARY KEY (id),
	CONSTRAINT jobs_type_check CHECK (((type)::text = ANY (ARRAY[('university'::character varying)::text, ('company'::character varying)::text]))),
	CONSTRAINT status_check CHECK (((status)::text = ANY (ARRAY[('draft'::character varying)::text, ('published'::character varying)::text, ('suspend'::character varying)::text, ('block'::character varying)::text])))
);
CREATE INDEX employment_type_of_job ON public.jobs USING btree (employment_type);
CREATE INDEX jobs_min_education_index ON public.jobs USING btree (min_education);
CREATE INDEX status_of_job ON public.jobs USING btree (status);
CREATE INDEX type_of_job ON public.jobs USING btree (type);
CREATE INDEX workplace_type_of_job ON public.jobs USING btree (workplace_type);


-- public.log_talent_searches definition

-- Drop table

-- DROP TABLE public.log_talent_searches;

CREATE TABLE public.log_talent_searches (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	company_id uuid NOT NULL,
	filter_data text NULL,
	result_data text NULL,
	expired_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT log_talent_searches_pkey PRIMARY KEY (id)
);
CREATE INDEX log_talent_searches_filter_data_token_index ON public.log_talent_searches USING btree (filter_data);


-- public.notifikasis definition

-- Drop table

-- DROP TABLE public.notifikasis;

CREATE TABLE public.notifikasis (
	id bigserial NOT NULL,
	title varchar(255) NOT NULL,
	subtitle text NULL,
	"action" varchar(255) NOT NULL,
	value varchar(255) NOT NULL,
	sender_id uuid NULL,
	receiver_id uuid NOT NULL,
	read_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT notifikasis_pkey PRIMARY KEY (id)
);


-- public.post_comment_files definition

-- Drop table

-- DROP TABLE public.post_comment_files;

CREATE TABLE public.post_comment_files (
	id bigserial NOT NULL,
	post_comment_id int8 NULL,
	file_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT post_comment_files_pkey PRIMARY KEY (id)
);


-- public.post_comment_likes definition

-- Drop table

-- DROP TABLE public.post_comment_likes;

CREATE TABLE public.post_comment_likes (
	id bigserial NOT NULL,
	post_comment_id int8 NULL,
	user_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT post_comment_likes_pkey PRIMARY KEY (id)
);


-- public.post_comments definition

-- Drop table

-- DROP TABLE public.post_comments;

CREATE TABLE public.post_comments (
	id bigserial NOT NULL,
	post_id uuid NULL,
	user_id uuid NULL,
	post_comment_type_id int8 NULL,
	"content" varchar(255) NULL,
	total_like int4 DEFAULT 0 NOT NULL,
	last_update_by_id uuid NULL,
	last_update_by_iplocation varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	read_at timestamp(0) NULL,
	post_reference_id uuid NULL,
	CONSTRAINT post_comments_pkey PRIMARY KEY (id)
);


-- public.post_files definition

-- Drop table

-- DROP TABLE public.post_files;

CREATE TABLE public.post_files (
	id bigserial NOT NULL,
	post_id uuid NULL,
	file_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT post_files_pkey PRIMARY KEY (id)
);


-- public.post_likes definition

-- Drop table

-- DROP TABLE public.post_likes;

CREATE TABLE public.post_likes (
	id bigserial NOT NULL,
	post_id uuid NULL,
	user_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT post_likes_pkey PRIMARY KEY (id)
);


-- public.post_tags definition

-- Drop table

-- DROP TABLE public.post_tags;

CREATE TABLE public.post_tags (
	id bigserial NOT NULL,
	post_id uuid NULL,
	tag_id int8 NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	post_tag_type_id int8 NULL,
	CONSTRAINT post_tags_pkey PRIMARY KEY (id)
);


-- public.post_views definition

-- Drop table

-- DROP TABLE public.post_views;

CREATE TABLE public.post_views (
	id bigserial NOT NULL,
	post_id uuid NULL,
	user_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT post_views_pkey PRIMARY KEY (id)
);


-- public.posts definition

-- Drop table

-- DROP TABLE public.posts;

CREATE TABLE public.posts (
	id uuid NOT NULL,
	user_id uuid NULL,
	head_line varchar(255) NULL,
	"content" text NULL,
	post_type_id int8 NULL,
	total_view int4 DEFAULT 0 NOT NULL,
	total_like int4 DEFAULT 0 NOT NULL,
	total_comment int4 DEFAULT 0 NOT NULL,
	company_id uuid NULL,
	university_id uuid NULL,
	op_date_start timestamp(0) NULL,
	op_date_end timestamp(0) NULL,
	op_title varchar(255) NULL,
	op_location varchar(255) NULL,
	op_description text NULL,
	op_field_1 text NULL,
	op_field_2 text NULL,
	op_field_3 text NULL,
	op_field_4 text NULL,
	op_field_5 text NULL,
	last_update_by_id uuid NULL,
	last_update_by_iplocation varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	recipient_id uuid NULL,
	post_status_id int8 NULL,
	op_value_min float8 NULL,
	op_value_max float8 NULL,
	last_comment_at timestamp(0) NULL,
	last_modified_at timestamp(0) NULL,
	recipient_company_id uuid NULL,
	recipient_university_id uuid NULL,
	is_source_sync bool DEFAULT false NOT NULL,
	special_vacancy bool DEFAULT false NOT NULL,
	firebase_dynamic_link varchar(255) NULL,
	permalink varchar(255) NULL,
	external_apply bool NULL,
	domisili_restrict bool NULL,
	is_required_document bool NULL,
	job_category_id int8 NULL,
	majors_preferences jsonb NULL,
	CONSTRAINT posts_id_unique UNIQUE (id),
	CONSTRAINT posts_permalink_unique UNIQUE (permalink)
);
CREATE INDEX category_from_job ON public.posts USING btree (job_category_id);


-- public.study_experiences definition

-- Drop table

-- DROP TABLE public.study_experiences;

CREATE TABLE public.study_experiences (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	university_id uuid NOT NULL,
	"degree" varchar(255) NOT NULL,
	study_program_id int8 NULL,
	study_program_title varchar(255) NULL,
	started_at timestamp(0) NULL,
	ended_at timestamp(0) NULL,
	gpa float8 NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT study_experiences_pkey PRIMARY KEY (id)
);
CREATE INDEX study_experiences_degree_index ON public.study_experiences USING btree (degree);


-- public.study_programs definition

-- Drop table

-- DROP TABLE public.study_programs;

CREATE TABLE public.study_programs (
	id bigserial NOT NULL,
	university_id uuid NOT NULL,
	code varchar(255) NOT NULL,
	"name" varchar(255) NOT NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT study_programs_pkey PRIMARY KEY (id)
);
CREATE INDEX study_programs_code_index ON public.study_programs USING btree (code);


-- public.talent_invitations definition

-- Drop table

-- DROP TABLE public.talent_invitations;

CREATE TABLE public.talent_invitations (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	job_id int8 NOT NULL,
	company_id uuid NOT NULL,
	status bpchar(1) DEFAULT '0'::bpchar NOT NULL,
	confirmed_at timestamp(0) NULL,
	rejected_at timestamp(0) NULL,
	expired_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	inviter_id uuid NULL,
	CONSTRAINT talent_invitations_pkey PRIMARY KEY (id)
);
CREATE INDEX talent_invitations_status_index ON public.talent_invitations USING btree (status);


-- public.testimonies definition

-- Drop table

-- DROP TABLE public.testimonies;

CREATE TABLE public.testimonies (
	id uuid NOT NULL,
	university_id uuid NOT NULL,
	graduate_name varchar(100) NOT NULL,
	photo_graduate_id uuid NOT NULL,
	company_name varchar(100) NOT NULL,
	logo_company_id uuid NOT NULL,
	"comment" text NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	is_active bool DEFAULT false NOT NULL,
	"position" varchar(100) NOT NULL,
	program_study varchar(255) NULL,
	graduate_year int4 NULL
);


-- public.tracer_publishes definition

-- Drop table

-- DROP TABLE public.tracer_publishes;

CREATE TABLE public.tracer_publishes (
	tracer_publish_id uuid DEFAULT uuid_generate_v4() NOT NULL,
	user_id uuid NULL,
	university_id uuid NULL,
	title varchar(255) NULL,
	file_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT tracer_publishes_pkey PRIMARY KEY (tracer_publish_id)
);


-- public.tracer_results definition

-- Drop table

-- DROP TABLE public.tracer_results;

CREATE TABLE public.tracer_results (
	tracer_result_id uuid DEFAULT uuid_generate_v4() NOT NULL,
	user_id uuid NOT NULL,
	tracer_master_id uuid NOT NULL,
	tracer_question_id uuid NOT NULL,
	tracer_answer_type_value_id uuid NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT tracer_results_pkey PRIMARY KEY (tracer_result_id)
);


-- public.transaction_details definition

-- Drop table

-- DROP TABLE public.transaction_details;

CREATE TABLE public.transaction_details (
	id bigserial NOT NULL,
	transaction_id int8 NOT NULL,
	"type" varchar(255) NOT NULL,
	value int4 NOT NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT transaction_details_pkey PRIMARY KEY (id)
);
CREATE INDEX transaction_detail_type ON public.transaction_details USING btree (type);


-- public.transactions definition

-- Drop table

-- DROP TABLE public.transactions;

CREATE TABLE public.transactions (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	company_id uuid NOT NULL,
	discount_id int8 NULL,
	sub_total int4 NOT NULL,
	payment_method varchar(255) NOT NULL,
	admin_fee int4 DEFAULT 0 NOT NULL,
	tax_fee int4 DEFAULT 0 NOT NULL,
	discount_amount int4 NULL,
	grand_total int4 NOT NULL,
	status bpchar(1) DEFAULT 'P'::bpchar NOT NULL,
	deleted_at timestamp(0) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	trx_id varchar(255) NULL,
	CONSTRAINT transactions_pkey PRIMARY KEY (id),
	CONSTRAINT transactions_trx_id_unique UNIQUE (trx_id)
);
CREATE INDEX transaction_payment_method ON public.transactions USING btree (payment_method);
CREATE INDEX transaction_status ON public.transactions USING btree (status);


-- public.universities definition

-- Drop table

-- DROP TABLE public.universities;

CREATE TABLE public.universities (
	id uuid NOT NULL,
	"name" varchar(255) NULL,
	dikticode varchar(255) NULL,
	abbrev varchar(255) NULL,
	university_type_id int4 NULL,
	industry_type_id int4 NULL,
	head_line varchar(255) NULL,
	tag_line varchar(255) NULL,
	website varchar(255) NULL,
	phone varchar(255) NULL,
	whatsapp varchar(255) NULL,
	email varchar(255) NULL,
	facebook varchar(255) NULL,
	linkedin varchar(255) NULL,
	instagram varchar(255) NULL,
	npwp varchar(255) NULL,
	address varchar(255) NULL,
	city_id varchar(255) NULL,
	alternate_address varchar(255) NULL,
	alternate_city_id varchar(255) NULL,
	year_founded int4 NULL,
	profile_image_id uuid NULL,
	dashboard_image_id uuid NULL,
	last_update_by_id uuid NULL,
	last_update_by_iplocation varchar(255) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	university_size_id int4 NULL,
	youtube varchar(150) NULL,
	description text NULL,
	jenis varchar(255) NULL,
	status_pengelolaan varchar(255) NULL,
	address_latitude float8 NULL,
	address_longitude float8 NULL,
	akreditasi varchar(255) NULL,
	client_id varchar(255) NULL,
	client_secret varchar(255) NULL,
	client_url varchar(255) NULL,
	siakad varchar(255) NULL,
	plan varchar(255) NULL,
	is_client bool DEFAULT false NULL,
	main_domain varchar(255) NULL,
	custom_domain varchar(255) NULL,
	subscription_price int4 NULL,
	total_user int4 NULL,
	personalize bool NULL,
	custom_survey bool NULL,
	satisfaction_survey bool NULL,
	dashboard bool NULL,
	career_preparation bool NULL,
	logo_personalize_id uuid NULL,
	bg_img_personalize_id uuid NULL,
	title_personalize varchar(255) NULL,
	description_personalize varchar(255) NULL,
	phone_personalize int8 NULL,
	email_personalize varchar(64) NULL,
	instagram_personalize varchar(64) NULL,
	facebook_personalize varchar(64) NULL,
	about_personalize text NULL,
	career_yt_url_personalize varchar(255) NULL,
	edlink_client_url varchar(255) NULL,
	edlink_secret_id varchar(255) NULL,
	custom_form bool DEFAULT false NOT NULL,
	tracer_logo_id uuid NULL,
	university_type varchar(255) NULL,
	CONSTRAINT universities_id_unique UNIQUE (id),
	CONSTRAINT universities_siakad_check CHECK (((siakad)::text = ANY (ARRAY[('1'::character varying)::text, ('2'::character varying)::text, ('3'::character varying)::text])))
);


-- public.university_admins definition

-- Drop table

-- DROP TABLE public.university_admins;

CREATE TABLE public.university_admins (
	id bigserial NOT NULL,
	university_id uuid NULL,
	user_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT university_admins_pkey PRIMARY KEY (id)
);


-- public.university_followers definition

-- Drop table

-- DROP TABLE public.university_followers;

CREATE TABLE public.university_followers (
	id bigserial NOT NULL,
	university_id uuid NOT NULL,
	follower_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	company_follower_id uuid NULL,
	university_follower_id uuid NULL,
	CONSTRAINT university_followers_pkey PRIMARY KEY (id)
);


-- public.university_images definition

-- Drop table

-- DROP TABLE public.university_images;

CREATE TABLE public.university_images (
	id bigserial NOT NULL,
	university_id uuid NULL,
	file_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT university_images_pkey PRIMARY KEY (id)
);


-- public.university_request_joins definition

-- Drop table

-- DROP TABLE public.university_request_joins;

CREATE TABLE public.university_request_joins (
	id uuid NOT NULL,
	user_id uuid NULL,
	user_name varchar(255) NOT NULL,
	user_email varchar(255) NOT NULL,
	user_position varchar(255) NULL,
	university_id uuid NULL,
	university_size_id int4 NULL,
	verified_at timestamp(0) NULL,
	verified_by varchar(255) NULL,
	admin_notes text NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL
);


-- public.user_followers definition

-- Drop table

-- DROP TABLE public.user_followers;

CREATE TABLE public.user_followers (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	follower_id uuid NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	is_approved int4 DEFAULT 1 NULL,
	company_follower_id uuid NULL,
	university_follower_id uuid NULL,
	CONSTRAINT user_followers_pkey PRIMARY KEY (id)
);


-- public.user_records definition

-- Drop table

-- DROP TABLE public.user_records;

CREATE TABLE public.user_records (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	activity varchar(255) NOT NULL,
	device varchar(255) NOT NULL,
	notes varchar(255) NULL,
	ip varchar(255) NULL,
	device_info varchar(255) NULL,
	app_version varchar(255) NULL,
	url varchar(255) NULL,
	latitude float8 NULL,
	longitude float8 NULL,
	execution_time int4 NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	CONSTRAINT user_records_device_check CHECK (((device)::text = ANY (ARRAY[('android'::character varying)::text, ('ios'::character varying)::text, ('web'::character varying)::text, ('postman'::character varying)::text, ('other'::character varying)::text]))),
	CONSTRAINT user_records_pkey PRIMARY KEY (id)
);
CREATE INDEX user_records_user_id_activity_url_ip_device_index ON public.user_records USING btree (user_id, activity, url, ip, device);


-- public.users definition

-- Drop table

-- DROP TABLE public.users;

CREATE TABLE public.users (
	id uuid NOT NULL,
	user_type_id int8 NULL,
	username varchar(255) NULL,
	email varchar(255) NULL,
	country_code varchar(255) NULL,
	phone varchar(255) NULL,
	"password" varchar(255) NULL,
	email_verified_at timestamp(0) NULL,
	phone_verified_at timestamp(0) NULL,
	first_name varchar(255) NULL,
	last_name varchar(255) NULL,
	sex varchar(255) NULL,
	address varchar(255) NULL,
	city_id varchar(255) NULL,
	birth_date timestamp(0) NULL,
	birth_place varchar(255) NULL,
	motto varchar(255) NULL,
	about_me text NULL,
	website varchar(255) NULL,
	facebook varchar(255) NULL,
	linkedin varchar(255) NULL,
	instagram varchar(255) NULL,
	twitter varchar(255) NULL,
	is_active bool DEFAULT false NOT NULL,
	built_in bool DEFAULT false NOT NULL,
	signin_provider varchar(255) NULL,
	firebase_uid varchar(700) NULL,
	firebase_token varchar(700) NULL,
	last_signedin timestamp(0) NULL,
	last_access timestamp(0) NULL,
	last_update_location timestamp(0) NULL,
	latitude float8 NULL,
	longitude float8 NULL,
	device_info varchar(255) NULL,
	app_version_name varchar(255) NULL,
	app_version_code varchar(255) NULL,
	remember_token varchar(100) NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	profile_image_id uuid NULL,
	dashboard_image_id uuid NULL,
	last_update_by_id uuid NULL,
	last_update_by_iplocation varchar(255) NULL,
	nim varchar(255) NULL,
	university_id uuid NULL,
	company_id uuid NULL,
	occupation varchar(255) NULL,
	"degree" varchar(255) NULL,
	signup_provider varchar(255) NULL,
	graduation_year int4 NULL,
	company_name varchar(255) NULL,
	user_privacy_type_id int8 NULL,
	user_status_id int8 NULL,
	login_sync_status bool DEFAULT false NOT NULL,
	sync_status bool DEFAULT false NOT NULL,
	is_deleted bool DEFAULT false NULL,
	cause_delete varchar(255) NULL,
	is_profile_public bool DEFAULT false NOT NULL,
	is_job_recommendation bool DEFAULT false NULL,
	height int4 NULL,
	weight int4 NULL,
	previous_user_type_id int8 NULL,
	CONSTRAINT users_email_unique UNIQUE (email),
	CONSTRAINT users_id_unique UNIQUE (id),
	CONSTRAINT users_nim_unique UNIQUE (nim),
	CONSTRAINT users_phone_unique UNIQUE (phone),
	CONSTRAINT users_sex_check CHECK (((sex)::text = ANY (ARRAY[('m'::character varying)::text, ('f'::character varying)::text]))),
	CONSTRAINT users_username_unique UNIQUE (username)
);
CREATE INDEX users_email_phone_username_first_name_last_name_index ON public.users USING btree (email, phone, username, first_name, last_name);


-- public.work_experiences definition

-- Drop table

-- DROP TABLE public.work_experiences;

CREATE TABLE public.work_experiences (
	id bigserial NOT NULL,
	user_id uuid NOT NULL,
	company_id uuid NOT NULL,
	city_id varchar(4) NOT NULL,
	"position" varchar(255) NOT NULL,
	employment_type bpchar(1) NOT NULL,
	start_date date NOT NULL,
	end_date date NULL,
	description text NULL,
	created_at timestamp(0) NULL,
	updated_at timestamp(0) NULL,
	deleted_at timestamp(0) NULL,
	CONSTRAINT work_experiences_pkey PRIMARY KEY (id)
);


-- public.applicant_notes foreign keys

ALTER TABLE public.applicant_notes ADD CONSTRAINT applicant_notes_applicant_status_id_foreign FOREIGN KEY (applicant_status_id) REFERENCES public.applicant_statuses(id);
ALTER TABLE public.applicant_notes ADD CONSTRAINT applicant_notes_note_giver_id_foreign FOREIGN KEY (note_giver_id) REFERENCES public.users(id);


-- public.applicant_statuses foreign keys

ALTER TABLE public.applicant_statuses ADD CONSTRAINT applicant_statuses_applicant_id_foreign FOREIGN KEY (applicant_id) REFERENCES public.applicants(id);
ALTER TABLE public.applicant_statuses ADD CONSTRAINT applicant_statuses_status_changer_by_id_foreign FOREIGN KEY (status_changer_by_id) REFERENCES public.users(id);


-- public.applicants foreign keys

ALTER TABLE public.applicants ADD CONSTRAINT applicants_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id);
ALTER TABLE public.applicants ADD CONSTRAINT applicants_job_id_foreign FOREIGN KEY (job_id) REFERENCES public.jobs(id);
ALTER TABLE public.applicants ADD CONSTRAINT applicants_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


-- public.article_category foreign keys

ALTER TABLE public.article_category ADD CONSTRAINT article_category_article_id_foreign FOREIGN KEY (article_id) REFERENCES public.articles(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE public.article_category ADD CONSTRAINT article_category_category_id_foreign FOREIGN KEY (category_id) REFERENCES public.article_categories(id) ON DELETE RESTRICT ON UPDATE CASCADE;


-- public.article_meta foreign keys

ALTER TABLE public.article_meta ADD CONSTRAINT article_meta_article_id_foreign FOREIGN KEY (article_id) REFERENCES public.articles(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- public.article_tags foreign keys

ALTER TABLE public.article_tags ADD CONSTRAINT article_tags_article_id_foreign FOREIGN KEY (article_id) REFERENCES public.articles(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE public.article_tags ADD CONSTRAINT article_tags_tag_id_foreign FOREIGN KEY (tag_id) REFERENCES public.article_tag(id) ON DELETE RESTRICT ON UPDATE CASCADE;


-- public.articles foreign keys

ALTER TABLE public.articles ADD CONSTRAINT articles_thumbnail_id_foreign FOREIGN KEY (thumbnail_id) REFERENCES public.files(id) ON DELETE SET NULL;
ALTER TABLE public.articles ADD CONSTRAINT articles_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE ON UPDATE CASCADE;


-- public.bookmark_jobs foreign keys

ALTER TABLE public.bookmark_jobs ADD CONSTRAINT bookmark_jobs_job_id_foreign FOREIGN KEY (job_id) REFERENCES public.jobs(id);
ALTER TABLE public.bookmark_jobs ADD CONSTRAINT bookmark_jobs_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


-- public.campaign_companies foreign keys

ALTER TABLE public.campaign_companies ADD CONSTRAINT campaign_companies_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id);
ALTER TABLE public.campaign_companies ADD CONSTRAINT campaign_companies_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.companies(id);


-- public.campaign_jobs foreign keys

ALTER TABLE public.campaign_jobs ADD CONSTRAINT campaign_jobs_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id);
ALTER TABLE public.campaign_jobs ADD CONSTRAINT campaign_jobs_job_id_foreign FOREIGN KEY (job_id) REFERENCES public.jobs(id);


-- public.companies foreign keys

ALTER TABLE public.companies ADD CONSTRAINT companies_alternate_city_id_foreign FOREIGN KEY (alternate_city_id) REFERENCES public.kotas(id) ON DELETE SET NULL;
ALTER TABLE public.companies ADD CONSTRAINT companies_city_id_foreign FOREIGN KEY (city_id) REFERENCES public.kotas(id) ON DELETE SET NULL;
ALTER TABLE public.companies ADD CONSTRAINT companies_company_size_id_foreign FOREIGN KEY (company_size_id) REFERENCES public.company_sizes(id) ON DELETE SET NULL;
ALTER TABLE public.companies ADD CONSTRAINT companies_company_type_id_foreign FOREIGN KEY (company_type_id) REFERENCES public.company_types(id) ON DELETE SET NULL;
ALTER TABLE public.companies ADD CONSTRAINT companies_dashboard_image_id_foreign FOREIGN KEY (dashboard_image_id) REFERENCES public.files(id) ON DELETE SET NULL;
ALTER TABLE public.companies ADD CONSTRAINT companies_industry_type_id_foreign FOREIGN KEY (industry_type_id) REFERENCES public.industry_types(id) ON DELETE SET NULL;
ALTER TABLE public.companies ADD CONSTRAINT companies_last_update_by_id_foreign FOREIGN KEY (last_update_by_id) REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.companies ADD CONSTRAINT companies_profile_image_id_foreign FOREIGN KEY (profile_image_id) REFERENCES public.files(id) ON DELETE SET NULL;


-- public.company_admins foreign keys

ALTER TABLE public.company_admins ADD CONSTRAINT company_admins_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE SET NULL;
ALTER TABLE public.company_admins ADD CONSTRAINT company_admins_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


-- public.company_followers foreign keys

ALTER TABLE public.company_followers ADD CONSTRAINT company_followers_company_follower_id_foreign FOREIGN KEY (company_follower_id) REFERENCES public.companies(id);
ALTER TABLE public.company_followers ADD CONSTRAINT company_followers_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;
ALTER TABLE public.company_followers ADD CONSTRAINT company_followers_follower_id_foreign FOREIGN KEY (follower_id) REFERENCES public.users(id) ON DELETE CASCADE;
ALTER TABLE public.company_followers ADD CONSTRAINT company_followers_university_follower_id_foreign FOREIGN KEY (university_follower_id) REFERENCES public.universities(id);


-- public.company_images foreign keys

ALTER TABLE public.company_images ADD CONSTRAINT company_images_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;
ALTER TABLE public.company_images ADD CONSTRAINT company_images_file_id_foreign FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;


-- public.company_invitations foreign keys

ALTER TABLE public.company_invitations ADD CONSTRAINT company_invitations_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE SET NULL;
ALTER TABLE public.company_invitations ADD CONSTRAINT company_invitations_inviter_user_id_foreign FOREIGN KEY (inviter_user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.confirmation_users foreign keys

ALTER TABLE public.confirmation_users ADD CONSTRAINT confirmation_users_confirmation_type_id_foreign FOREIGN KEY (confirmation_type_id) REFERENCES public.confirmation_types(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE public.confirmation_users ADD CONSTRAINT confirmation_users_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.device_logins foreign keys

ALTER TABLE public.device_logins ADD CONSTRAINT device_logins_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.files foreign keys

ALTER TABLE public.files ADD CONSTRAINT files_ftype_id_foreign FOREIGN KEY (ftype_id) REFERENCES public.ftypes(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE public.files ADD CONSTRAINT files_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


-- public.footers foreign keys

ALTER TABLE public.footers ADD CONSTRAINT footers_university_id_foreign FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE SET NULL;


-- public.invoices foreign keys

ALTER TABLE public.invoices ADD CONSTRAINT invoices_transaction_id_foreign FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE CASCADE;


-- public.job_benefits foreign keys

ALTER TABLE public.job_benefits ADD CONSTRAINT job_benefits_benefit_id_foreign FOREIGN KEY (benefit_id) REFERENCES public.benefits(id);
ALTER TABLE public.job_benefits ADD CONSTRAINT job_benefits_job_id_foreign FOREIGN KEY (job_id) REFERENCES public.jobs(id);


-- public.job_skills foreign keys

ALTER TABLE public.job_skills ADD CONSTRAINT job_skills_job_id_foreign FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON DELETE CASCADE;
ALTER TABLE public.job_skills ADD CONSTRAINT job_skills_skill_id_foreign FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


-- public.jobs foreign keys

ALTER TABLE public.jobs ADD CONSTRAINT jobs_city_id_foreign FOREIGN KEY (city_id) REFERENCES public.kotas(id);
ALTER TABLE public.jobs ADD CONSTRAINT jobs_department_type_id_foreign FOREIGN KEY (department_type_id) REFERENCES public.department_types(id);
ALTER TABLE public.jobs ADD CONSTRAINT jobs_industry_type_id_foreign FOREIGN KEY (industry_type_id) REFERENCES public.industry_types(id);
ALTER TABLE public.jobs ADD CONSTRAINT jobs_job_category_id_foreign FOREIGN KEY (job_category_id) REFERENCES public.job_categories(id);
ALTER TABLE public.jobs ADD CONSTRAINT jobs_posted_by_id_foreign FOREIGN KEY (posted_by_id) REFERENCES public.users(id);


-- public.log_talent_searches foreign keys

ALTER TABLE public.log_talent_searches ADD CONSTRAINT log_talent_searches_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.companies(id);
ALTER TABLE public.log_talent_searches ADD CONSTRAINT log_talent_searches_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


-- public.notifikasis foreign keys

ALTER TABLE public.notifikasis ADD CONSTRAINT notifikasis_receiver_id_foreign FOREIGN KEY (receiver_id) REFERENCES public.users(id) ON DELETE CASCADE;
ALTER TABLE public.notifikasis ADD CONSTRAINT notifikasis_sender_id_foreign FOREIGN KEY (sender_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.post_comment_files foreign keys

ALTER TABLE public.post_comment_files ADD CONSTRAINT post_comment_files_file_id_foreign FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;
ALTER TABLE public.post_comment_files ADD CONSTRAINT post_comment_files_post_comment_id_foreign FOREIGN KEY (post_comment_id) REFERENCES public.post_comments(id) ON DELETE CASCADE;


-- public.post_comment_likes foreign keys

ALTER TABLE public.post_comment_likes ADD CONSTRAINT post_comment_likes_post_comment_id_foreign FOREIGN KEY (post_comment_id) REFERENCES public.post_comments(id) ON DELETE CASCADE;
ALTER TABLE public.post_comment_likes ADD CONSTRAINT post_comment_likes_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.post_comments foreign keys

ALTER TABLE public.post_comments ADD CONSTRAINT post_comments_last_update_by_id_foreign FOREIGN KEY (last_update_by_id) REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.post_comments ADD CONSTRAINT post_comments_post_comment_type_id_foreign FOREIGN KEY (post_comment_type_id) REFERENCES public.post_comment_types(id) ON DELETE SET NULL;
ALTER TABLE public.post_comments ADD CONSTRAINT post_comments_post_id_foreign FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;
ALTER TABLE public.post_comments ADD CONSTRAINT post_comments_post_reference_id_foreign FOREIGN KEY (post_reference_id) REFERENCES public.posts(id);
ALTER TABLE public.post_comments ADD CONSTRAINT post_comments_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.post_files foreign keys

ALTER TABLE public.post_files ADD CONSTRAINT post_files_file_id_foreign FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;
ALTER TABLE public.post_files ADD CONSTRAINT post_files_post_id_foreign FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


-- public.post_likes foreign keys

ALTER TABLE public.post_likes ADD CONSTRAINT post_likes_post_id_foreign FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;
ALTER TABLE public.post_likes ADD CONSTRAINT post_likes_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.post_tags foreign keys

ALTER TABLE public.post_tags ADD CONSTRAINT post_tags_post_id_foreign FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;
ALTER TABLE public.post_tags ADD CONSTRAINT post_tags_post_tag_type_id_foreign FOREIGN KEY (post_tag_type_id) REFERENCES public.post_tag_types(id) ON DELETE CASCADE;
ALTER TABLE public.post_tags ADD CONSTRAINT post_tags_tag_id_foreign FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;


-- public.post_views foreign keys

ALTER TABLE public.post_views ADD CONSTRAINT post_views_post_id_foreign FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;
ALTER TABLE public.post_views ADD CONSTRAINT post_views_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.posts foreign keys

ALTER TABLE public.posts ADD CONSTRAINT posts_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE SET NULL;
ALTER TABLE public.posts ADD CONSTRAINT posts_last_update_by_id_foreign FOREIGN KEY (last_update_by_id) REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.posts ADD CONSTRAINT posts_post_status_id_foreign FOREIGN KEY (post_status_id) REFERENCES public.post_statuses(id);
ALTER TABLE public.posts ADD CONSTRAINT posts_post_type_id_foreign FOREIGN KEY (post_type_id) REFERENCES public.post_types(id) ON DELETE SET NULL;
ALTER TABLE public.posts ADD CONSTRAINT posts_recipient_company_id_foreign FOREIGN KEY (recipient_company_id) REFERENCES public.companies(id);
ALTER TABLE public.posts ADD CONSTRAINT posts_recipient_id_foreign FOREIGN KEY (recipient_id) REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.posts ADD CONSTRAINT posts_recipient_university_id_foreign FOREIGN KEY (recipient_university_id) REFERENCES public.universities(id);
ALTER TABLE public.posts ADD CONSTRAINT posts_university_id_foreign FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE SET NULL;


-- public.study_experiences foreign keys

ALTER TABLE public.study_experiences ADD CONSTRAINT study_experiences_study_program_id_foreign FOREIGN KEY (study_program_id) REFERENCES public.study_programs(id) ON DELETE CASCADE;
ALTER TABLE public.study_experiences ADD CONSTRAINT study_experiences_university_id_foreign FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE CASCADE;
ALTER TABLE public.study_experiences ADD CONSTRAINT study_experiences_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.study_programs foreign keys

ALTER TABLE public.study_programs ADD CONSTRAINT study_programs_university_id_foreign FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE CASCADE;


-- public.talent_invitations foreign keys

ALTER TABLE public.talent_invitations ADD CONSTRAINT talent_invitations_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.companies(id);
ALTER TABLE public.talent_invitations ADD CONSTRAINT talent_invitations_job_id_foreign FOREIGN KEY (job_id) REFERENCES public.jobs(id);
ALTER TABLE public.talent_invitations ADD CONSTRAINT talent_invitations_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id);


-- public.testimonies foreign keys

ALTER TABLE public.testimonies ADD CONSTRAINT testimonies_logo_company_id_foreign FOREIGN KEY (logo_company_id) REFERENCES public.files(id) ON DELETE SET NULL;
ALTER TABLE public.testimonies ADD CONSTRAINT testimonies_photo_graduate_id_foreign FOREIGN KEY (photo_graduate_id) REFERENCES public.files(id) ON DELETE SET NULL;
ALTER TABLE public.testimonies ADD CONSTRAINT testimonies_university_id_foreign FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE SET NULL;


-- public.tracer_publishes foreign keys

ALTER TABLE public.tracer_publishes ADD CONSTRAINT tracer_publishes_university_id_foreign FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE CASCADE;


-- public.tracer_results foreign keys

ALTER TABLE public.tracer_results ADD CONSTRAINT tracer_results_tracer_answer_type_value_id_foreign FOREIGN KEY (tracer_answer_type_value_id) REFERENCES public.tracer_answer_type_values(tracer_answer_type_value_id) ON DELETE RESTRICT;
ALTER TABLE public.tracer_results ADD CONSTRAINT tracer_results_tracer_master_id_foreign FOREIGN KEY (tracer_master_id) REFERENCES public.tracer_masters(tracer_master_id) ON DELETE RESTRICT;
ALTER TABLE public.tracer_results ADD CONSTRAINT tracer_results_tracer_question_id_foreign FOREIGN KEY (tracer_question_id) REFERENCES public.tracer_questions(tracer_question_id) ON DELETE RESTRICT;
ALTER TABLE public.tracer_results ADD CONSTRAINT tracer_results_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


-- public.transaction_details foreign keys

ALTER TABLE public.transaction_details ADD CONSTRAINT transaction_details_transaction_id_foreign FOREIGN KEY (transaction_id) REFERENCES public.transactions(id) ON DELETE CASCADE;


-- public.transactions foreign keys

ALTER TABLE public.transactions ADD CONSTRAINT transactions_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;
ALTER TABLE public.transactions ADD CONSTRAINT transactions_discount_id_foreign FOREIGN KEY (discount_id) REFERENCES public.discounts(id) ON DELETE CASCADE;
ALTER TABLE public.transactions ADD CONSTRAINT transactions_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.universities foreign keys

ALTER TABLE public.universities ADD CONSTRAINT universities_alternate_city_id_foreign FOREIGN KEY (alternate_city_id) REFERENCES public.kotas(id) ON DELETE SET NULL;
ALTER TABLE public.universities ADD CONSTRAINT universities_background_personalize_id_foreign FOREIGN KEY (bg_img_personalize_id) REFERENCES public.files(id) ON DELETE SET NULL;
ALTER TABLE public.universities ADD CONSTRAINT universities_city_id_foreign FOREIGN KEY (city_id) REFERENCES public.kotas(id) ON DELETE SET NULL;
ALTER TABLE public.universities ADD CONSTRAINT universities_dashboard_image_id_foreign FOREIGN KEY (dashboard_image_id) REFERENCES public.files(id) ON DELETE SET NULL;
ALTER TABLE public.universities ADD CONSTRAINT universities_industry_type_id_foreign FOREIGN KEY (industry_type_id) REFERENCES public.industry_types(id) ON DELETE SET NULL;
ALTER TABLE public.universities ADD CONSTRAINT universities_last_update_by_id_foreign FOREIGN KEY (last_update_by_id) REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.universities ADD CONSTRAINT universities_logo_personalize_id_foreign FOREIGN KEY (logo_personalize_id) REFERENCES public.files(id) ON DELETE SET NULL;
ALTER TABLE public.universities ADD CONSTRAINT universities_profile_image_id_foreign FOREIGN KEY (profile_image_id) REFERENCES public.files(id) ON DELETE SET NULL;
ALTER TABLE public.universities ADD CONSTRAINT universities_tracer_logo_id_foreign FOREIGN KEY (tracer_logo_id) REFERENCES public.files(id) ON DELETE SET NULL;
ALTER TABLE public.universities ADD CONSTRAINT universities_university_size_id_foreign FOREIGN KEY (university_size_id) REFERENCES public.university_sizes(id) ON DELETE SET NULL;
ALTER TABLE public.universities ADD CONSTRAINT universities_university_type_id_foreign FOREIGN KEY (university_type_id) REFERENCES public.company_types(id) ON DELETE SET NULL;


-- public.university_admins foreign keys

ALTER TABLE public.university_admins ADD CONSTRAINT university_admins_university_id_foreign FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE SET NULL;
ALTER TABLE public.university_admins ADD CONSTRAINT university_admins_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


-- public.university_followers foreign keys

ALTER TABLE public.university_followers ADD CONSTRAINT university_followers_company_follower_id_foreign FOREIGN KEY (company_follower_id) REFERENCES public.companies(id);
ALTER TABLE public.university_followers ADD CONSTRAINT university_followers_follower_id_foreign FOREIGN KEY (follower_id) REFERENCES public.users(id) ON DELETE CASCADE;
ALTER TABLE public.university_followers ADD CONSTRAINT university_followers_university_follower_id_foreign FOREIGN KEY (university_follower_id) REFERENCES public.universities(id);
ALTER TABLE public.university_followers ADD CONSTRAINT university_followers_university_id_foreign FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE CASCADE;


-- public.university_images foreign keys

ALTER TABLE public.university_images ADD CONSTRAINT university_images_file_id_foreign FOREIGN KEY (file_id) REFERENCES public.files(id) ON DELETE CASCADE;
ALTER TABLE public.university_images ADD CONSTRAINT university_images_university_id_foreign FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE CASCADE;


-- public.university_request_joins foreign keys

ALTER TABLE public.university_request_joins ADD CONSTRAINT university_request_joins_university_id_foreign FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE SET NULL;
ALTER TABLE public.university_request_joins ADD CONSTRAINT university_request_joins_university_size_id_foreign FOREIGN KEY (university_size_id) REFERENCES public.university_sizes(id) ON DELETE SET NULL;
ALTER TABLE public.university_request_joins ADD CONSTRAINT university_request_joins_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


-- public.user_followers foreign keys

ALTER TABLE public.user_followers ADD CONSTRAINT user_followers_company_follower_id_foreign FOREIGN KEY (company_follower_id) REFERENCES public.companies(id);
ALTER TABLE public.user_followers ADD CONSTRAINT user_followers_follower_id_foreign FOREIGN KEY (follower_id) REFERENCES public.users(id) ON DELETE CASCADE;
ALTER TABLE public.user_followers ADD CONSTRAINT user_followers_university_follower_id_foreign FOREIGN KEY (university_follower_id) REFERENCES public.universities(id);
ALTER TABLE public.user_followers ADD CONSTRAINT user_followers_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.user_records foreign keys

ALTER TABLE public.user_records ADD CONSTRAINT user_records_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- public.users foreign keys

ALTER TABLE public.users ADD CONSTRAINT users_city_id_foreign FOREIGN KEY (city_id) REFERENCES public.kotas(id);
ALTER TABLE public.users ADD CONSTRAINT users_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE SET NULL;
ALTER TABLE public.users ADD CONSTRAINT users_dashboard_image_id_foreign FOREIGN KEY (dashboard_image_id) REFERENCES public.files(id) ON DELETE SET NULL;
ALTER TABLE public.users ADD CONSTRAINT users_last_update_by_id_foreign FOREIGN KEY (last_update_by_id) REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.users ADD CONSTRAINT users_profile_image_id_foreign FOREIGN KEY (profile_image_id) REFERENCES public.files(id) ON DELETE SET NULL;
ALTER TABLE public.users ADD CONSTRAINT users_university_id_foreign FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE SET NULL;
ALTER TABLE public.users ADD CONSTRAINT users_user_privacy_type_id_foreign FOREIGN KEY (user_privacy_type_id) REFERENCES public.user_privacy_types(id) ON DELETE SET NULL;
ALTER TABLE public.users ADD CONSTRAINT users_user_status_id_foreign FOREIGN KEY (user_status_id) REFERENCES public.user_statuses(id) ON DELETE SET NULL;
ALTER TABLE public.users ADD CONSTRAINT users_user_type_id_foreign FOREIGN KEY (user_type_id) REFERENCES public.user_types(id);


-- public.work_experiences foreign keys

ALTER TABLE public.work_experiences ADD CONSTRAINT work_experiences_city_id_foreign FOREIGN KEY (city_id) REFERENCES public.kotas(id) ON DELETE RESTRICT;
ALTER TABLE public.work_experiences ADD CONSTRAINT work_experiences_company_id_foreign FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE RESTRICT;
ALTER TABLE public.work_experiences ADD CONSTRAINT work_experiences_parent_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;