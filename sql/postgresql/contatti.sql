DROP TABLE IF EXISTS "crm_contatti";
CREATE TABLE "crm_contatti" (
	"contatto_id" int4 NOT NULL,
	"tipo_id" int4,
	"persona_id" int4,
	"valore" varchar(250),
	"preferito" bool
)
WITH (OIDS=FALSE);
ALTER TABLE "crm_contatti" OWNER TO "www-data";
ALTER TABLE "crm_contatti" ADD CONSTRAINT "crm_contatti_pkey" PRIMARY KEY ("contatto_id") NOT DEFERRABLE INITIALLY IMMEDIATE;