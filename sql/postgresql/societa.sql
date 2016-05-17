DROP TABLE IF EXISTS "crm_societa";
CREATE TABLE "crm_societa" (
	"societa_id" int4 NOT NULL,
	"ragionesociale" varchar(150),
	"telefono" varchar(20),
	"website" varchar(100)
)
WITH (OIDS=FALSE);
ALTER TABLE "crm_societa" OWNER TO "www-data";
ALTER TABLE "crm_societa" ADD CONSTRAINT "crm_societa_pkey" PRIMARY KEY ("societa_id") NOT DEFERRABLE INITIALLY IMMEDIATE;