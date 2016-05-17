DROP TABLE IF EXISTS "crm_persone";
CREATE TABLE "crm_persone" (
	"persona_id" int4 NOT NULL,
	"user_id" int4,
	"nome" varchar(100),
	"sec_nome" varchar(100),
	"cognome" varchar(100),
	"albo_pf" bool,
	"societa_id" int4,
	"sesso" char(1),
	"codicefiscale" char(16),
	"partitaiva" char(14),
	"last_update" timestamp(6) NULL,
	"note" text,
	"comune_id" int4,
	"carica_id" int4
)
WITH (OIDS=FALSE);
ALTER TABLE "crm_persone" OWNER TO "www-data";
ALTER TABLE "crm_persone" ADD CONSTRAINT "crm_persone_pkey" PRIMARY KEY ("persona_id") NOT DEFERRABLE INITIALLY IMMEDIATE;