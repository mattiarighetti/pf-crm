DROP TABLE IF EXISTS "comuni";
CREATE TABLE "comuni" (
	"comune_id" int4 NOT NULL,
	"denominazione" varchar(100),
	"provincia_id" int4,
	"cap" char(5)
)
WITH (OIDS=FALSE);
ALTER TABLE "comuni" OWNER TO "www-data";
ALTER TABLE "comuni" ADD CONSTRAINT "comuni_pkey" PRIMARY KEY ("comune_id") NOT DEFERRABLE INITIALLY IMMEDIATE;