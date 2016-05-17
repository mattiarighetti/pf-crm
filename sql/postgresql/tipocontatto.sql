DROP TABLE IF EXISTS "crm_tipocontatto";
CREATE TABLE "crm_tipocontatto" (
	"tipo_id" int4 NOT NULL,
	"descrizione" varchar(100)
)
WITH (OIDS=FALSE);
ALTER TABLE "crm_tipocontatto" OWNER TO "www-data";
ALTER TABLE "crm_tipocontatto" ADD CONSTRAINT "crm_tipocontatto_pkey" PRIMARY KEY ("tipo_id") NOT DEFERRABLE INITIALLY IMMEDIATE;