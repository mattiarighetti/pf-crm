DROP TABLE IF EXISTS "crm_cariche";
CREATE TABLE "crm_cariche" (
	"carica_id" int4 NOT NULL,
	"descrizione" varchar(100),
	"societa_id" int4
)
WITH (OIDS=FALSE);
ALTER TABLE "crm_cariche" OWNER TO "www-data";
ALTER TABLE "crm_cariche" ADD CONSTRAINT "crm_cariche_pkey" PRIMARY KEY ("carica_id") NOT DEFERRABLE INITIALLY IMMEDIATE;