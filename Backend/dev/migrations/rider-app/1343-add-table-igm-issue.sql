CREATE TABLE atlas_app.igm_issue ();

ALTER TABLE atlas_app.igm_issue ADD COLUMN created_at timestamp with time zone NOT NULL default CURRENT_TIMESTAMP;
ALTER TABLE atlas_app.igm_issue ADD COLUMN id character varying(36) NOT NULL;
ALTER TABLE atlas_app.igm_issue ADD COLUMN booking_id text NOT NULL;
ALTER TABLE atlas_app.igm_issue ADD COLUMN merchant_operating_city_id character varying(36) NOT NULL;
ALTER TABLE atlas_app.igm_issue ADD COLUMN issue_status text NOT NULL;
ALTER TABLE atlas_app.igm_issue ADD COLUMN respondent_email text ;
ALTER TABLE atlas_app.igm_issue ADD COLUMN respondent_name text ;
ALTER TABLE atlas_app.igm_issue ADD COLUMN respondent_phone text ;
ALTER TABLE atlas_app.igm_issue ADD COLUMN responding_merchant_id text NOT NULL;
ALTER TABLE atlas_app.igm_issue ADD COLUMN issue_type text NOT NULL;
ALTER TABLE atlas_app.igm_issue ADD COLUMN respondent_action text ;
ALTER TABLE atlas_app.igm_issue ADD COLUMN rider_id character varying(36);
ALTER TABLE atlas_app.igm_issue ADD COLUMN respondent_entity_type text ;
ALTER TABLE atlas_app.igm_issue ADD COLUMN updated_at timestamp with time zone NOT NULL default CURRENT_TIMESTAMP;
ALTER TABLE atlas_app.igm_issue ADD COLUMN transaction_id text NOT NULL;
ALTER TABLE atlas_app.igm_issue ADD COLUMN customer_email character varying(36);
ALTER TABLE atlas_app.igm_issue ADD COLUMN customer_name character varying(36);
ALTER TABLE atlas_app.igm_issue ADD COLUMN customer_phone character varying(36);
ALTER TABLE atlas_app.igm_issue ADD COLUMN issue_raised_by_merchant character varying(36);
ALTER TABLE atlas_app.igm_issue ADD COLUMN merchant_id character varying(36);
ALTER TABLE atlas_app.igm_issue ADD COLUMN resolution_action character varying(36);
ALTER TABLE atlas_app.igm_issue ADD COLUMN domain character varying(36) not null;
ALTER TABLE atlas_app.igm_issue ADD PRIMARY KEY ( id);
